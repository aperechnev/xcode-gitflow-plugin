//
//  ShellCore.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 12.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import "ShellCore.h"


static NSString * const kShellPath = @"/bin/sh";
static NSString * const kShellConsoleArgument = @"-c";


@implementation ShellCore

+ (instancetype)sharedInstance {
    static ShellCore *sShellCore = nil;
    @synchronized (self) {
        if (sShellCore == nil) {
            sShellCore = [[ShellCore alloc] init];
        }
    }
    return sShellCore;
}

- (NSString *)executeCommand:(NSString *)command withArguments:(NSArray<NSString *> *)arguments inDirectory:(NSString *)directoryPath {
    NSString *shellCommand = [self stringFromShellCommand:command
                                            withArguments:arguments];
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = kShellPath;
    task.currentDirectoryPath = directoryPath;
    task.arguments = @[ kShellConsoleArgument, shellCommand ];
    task.standardOutput = [NSPipe pipe];
    
    NSFileHandle *file = [task.standardOutput fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return output;
}

- (NSString *)stringFromShellCommand:(NSString *)command withArguments:(NSArray<NSString *> *)arguments {
    NSMutableArray *commandComponents = [[NSMutableArray alloc] init];
    [commandComponents addObject:command];
    [commandComponents addObjectsFromArray:arguments];
    return [self stringFromCommandComponents:commandComponents];
}

- (NSString *)stringFromCommandComponents:(NSArray<NSString *> *)components {
    NSMutableString *argumentsString = [[NSMutableString alloc] init];
    
    for (NSString *i_component in components) {
        NSString *argString = [NSString stringWithFormat:@" %@", i_component];
        [argumentsString appendString:argString];
    }
    
    return argumentsString.copy;
}

@end
