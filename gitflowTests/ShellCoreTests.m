//
//  ShellCoreTests.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 12.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShellCore.h"


@interface ShellCoreTests : XCTestCase

@end


@implementation ShellCoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGettingStringFromCommandComponents {
    NSArray *components = @[ @"-c", @"-v", @"parameter" ];
    NSString *testString = @" -c -v parameter";
    
    ShellCore *shellCore = [ShellCore sharedInstance];
    NSString *formattedArgumentsString = [shellCore stringFromCommandComponents:components];
    
    XCTAssertEqualObjects(testString, formattedArgumentsString);
}

- (void)testGettingStringFromShellCommand {
    NSString *command = @"ls";
    NSArray *arguments = @[ @"-l", @"-a" ];
    
    NSString *testCommandString = @" ls -l -a";
    
    NSString *commandString = [[ShellCore sharedInstance] stringFromShellCommand:command
                                                                   withArguments:arguments];
    
    XCTAssertEqualObjects(testCommandString, commandString);
}

- (void)testShellCommandExecution {
    NSString * const kTestOutput = @".\n\
..\n\
file001.txt\n\
file002.txt\n";
    NSString * const kTestCommand = @"ls";
    NSString * const kTestArgument = @"-a";
    NSString * const kExecutionDirectory = @"/Users/aperechnev/Projects/xcode-gitflow-plugin/test_content";
    
    NSArray<NSString *> *arguments = @[ kTestArgument ];
    
    ShellCore *shellCore = [ShellCore sharedInstance];
    NSString *output = [shellCore executeCommand:kTestCommand
                                   withArguments:arguments
                                     inDirectory:kExecutionDirectory];
    
    XCTAssertEqualObjects(kTestOutput, output);
}

@end
