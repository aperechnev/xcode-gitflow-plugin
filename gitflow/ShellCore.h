//
//  ShellCore.h
//  gitflow
//
//  Created by Alex Krzyżanowski on 12.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShellCore : NSObject

+ (instancetype)sharedInstance;

- (NSString *)executeCommand:(NSString *)command
               withArguments:(NSArray<NSString *> *)arguments
                 inDirectory:(NSString *)directoryPath;

- (NSString *)stringFromShellCommand:(NSString *)command
                       withArguments:(NSArray<NSString *> *)arguments;

- (NSString *)stringFromCommandComponents:(NSArray<NSString *> *)components;
@end
