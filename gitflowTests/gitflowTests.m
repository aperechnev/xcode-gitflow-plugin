//
//  gitflowTests.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 14.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "gitflow.h"
#import "ShellCore.h"
#import "GitflowCore.h"


@interface gitflowTests : XCTestCase

@property (nonatomic, strong, readwrite) GitflowCore *testableGitflowCore;
@end


@implementation gitflowTests

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
}

- (void)tearDown {
    [[ShellCore sharedInstance] executeCommand:@"rm"
                                 withArguments:@[ @"-rf", @".git" ]
                                   inDirectory:self.testableGitflowCore.projectDirectoryPath];
    
    [super tearDown];
}

- (void)testMenuItemsConstruction {
    [self.testableGitflowCore gitFlowInit];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Git Flow"];
    
    gitflow *gitflowObject = [[gitflow alloc] init];
    
    [gitflowObject menuWillOpen:menu];
    
    NSMenuItem *menuItem;
    
    menuItem = [menu itemAtIndex:0];
    XCTAssertTrue([menuItem isKindOfClass:[[NSMenuItem separatorItem] class]]);
    
    menuItem = [menu itemAtIndex:1];
    XCTAssertEqualObjects(@"Start Feature", menuItem.title);
    
    menuItem = [menu itemAtIndex:2];
    XCTAssertTrue([menuItem isKindOfClass:[[NSMenuItem separatorItem] class]]);
    
    menuItem = [menu itemAtIndex:3];
    XCTAssertEqualObjects(@"Start Release", menuItem.title);
    
    menuItem = [menu itemAtIndex:4];
    XCTAssertTrue([menuItem isKindOfClass:[[NSMenuItem separatorItem] class]]);
    
    menuItem = [menu itemAtIndex:5];
    XCTAssertEqualObjects(@"Start Hotfix", menuItem.title);
    
    [self.testableGitflowCore doAction:kGitflowActionStart
                            withEntity:kGitflowEntityFeature
                              withName:@"test-feature"
                  additionalParameters:nil];
    
    [gitflowObject menuWillOpen:menu];
    
    menuItem = [menu itemAtIndex:2];
    XCTAssertEqualObjects(@"test-feature", menuItem.title);
}

@end
