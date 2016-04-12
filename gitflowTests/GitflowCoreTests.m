//
//  GitflowCoreTests.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 12.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GitflowCore.h"
#import "ShellCore.h"


@interface GitflowCoreTests : XCTestCase

@property (nonatomic, strong, readwrite) GitflowCore *testableGitflowCore;
@end


@implementation GitflowCoreTests

- (void)setUp {
    [super setUp];
    
    self.testableGitflowCore = [GitflowCore sharedInstance];
    self.testableGitflowCore.projectDirectoryPath = [[NSBundle bundleForClass:[self class]] resourcePath];
    
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    [shellCore executeCommand:@"git"
                withArguments:@[ @"init" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [shellCore executeCommand:@"touch"
                withArguments:@[ @"file.txt" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];

    [shellCore executeCommand:@"git"
                withArguments:@[ @"add", @"file.txt" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];

    [shellCore executeCommand:@"git"
                withArguments:@[ @"commit", @"-m \"Initial commit\"" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [self logBranches];
}

- (void)tearDown {
    [[ShellCore sharedInstance] executeCommand:@"rm"
                                 withArguments:@[ @"-rf", @".git" ]
                                   inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [super tearDown];
}

- (void)testGitflowInitialization {
    [self.testableGitflowCore gitFlowInit];
    
    [self logBranches];
    
    NSString *branchesOutput = [[ShellCore sharedInstance] executeCommand:@"git"
                                                            withArguments:@[ @"branch" ]
                                                              inDirectory:self.testableGitflowCore.projectDirectoryPath];
    XCTAssertTrue([branchesOutput containsString:@"master"]);
    XCTAssertTrue([branchesOutput containsString:@"develop"]);
}

- (void)testFeatureStarting {
    NSString *testFeature = @"test-feature";
    NSString *testBranch = [NSString stringWithFormat:@"feature/%@", testFeature];
    [self.testableGitflowCore gitFlowInit];
    [self.testableGitflowCore startFeature:testFeature];
    
    [self logBranches];
    
    NSString *branchesOutput = [[ShellCore sharedInstance] executeCommand:@"git"
                                                            withArguments:@[ @"branch" ]
                                                              inDirectory:self.testableGitflowCore.projectDirectoryPath];
    XCTAssertTrue([branchesOutput containsString:testBranch]);
    XCTAssertTrue([branchesOutput containsString:@"master"]);
    XCTAssertTrue([branchesOutput containsString:@"develop"]);
}

- (void)testFeatureListing {
    NSArray<NSString *> *testBranchList = @[ @"new-function", @"another-function" ];
    
    [self.testableGitflowCore gitFlowInit];
    [self.testableGitflowCore startFeature:testBranchList[0]];
    [self.testableGitflowCore startFeature:testBranchList[1]];
    
    [self logBranches];
    
    NSArray<NSString *> *branchList = [self.testableGitflowCore listFeatures];
    
    for (NSString *testBranch in testBranchList) {
        XCTAssertTrue([branchList containsObject:testBranch]);
    }
}

- (void)logBranches {
    NSString *branchList = [[ShellCore sharedInstance] executeCommand:@"git"
                                                        withArguments:@[ @"branch" ]
                                                          inDirectory:self.testableGitflowCore.projectDirectoryPath];
    NSLog(@"Testable branch list: %@", branchList);
}

@end
