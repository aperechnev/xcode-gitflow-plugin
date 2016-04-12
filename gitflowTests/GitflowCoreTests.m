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
    
    [shellCore executeCommand:@"git"
                withArguments:@[ @"branch", @"develop" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [shellCore executeCommand:@"git"
                withArguments:@[ @"branch", @"feature/new-function" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [shellCore executeCommand:@"git"
                withArguments:@[ @"branch", @"feature/another-function" ]
                  inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    NSString *branchList = [shellCore executeCommand:@"git"
                                       withArguments:@[ @"branch" ]
                                         inDirectory:self.testableGitflowCore.projectDirectoryPath];
    NSLog(@"Testable branch list: %@", branchList);
}

- (void)tearDown {
    [[ShellCore sharedInstance] executeCommand:@"rm"
                                 withArguments:@[ @"-rf", @".git" ]
                                   inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [super tearDown];
}

- (void)testFeatureStarting {
    
}

- (void)testFeatureListing {
    NSArray<NSString *> *testBranchList = @[ @"new-function", @"another-function" ];
    NSArray<NSString *> *branchList = [self.testableGitflowCore listFeatures];
    
    for (NSString *branch in branchList) {
        NSLog(@"Found branch named %@", branch);
    }
    
    for (NSString *testBranch in testBranchList) {
        XCTAssertTrue([branchList containsObject:testBranch]);
    }
}

@end
