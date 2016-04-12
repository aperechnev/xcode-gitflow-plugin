//
//  GitflowCore.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import "GitflowCore.h"
#import "ShellCore.h"


@implementation GitflowCore

+ (instancetype)sharedInstance {
    static GitflowCore * sGitflowCore = nil;
    @synchronized (self) {
        if (sGitflowCore == nil) {
            sGitflowCore = [[GitflowCore alloc] init];
        }
    }
    return sGitflowCore;
}

- (void)startFeature:(NSString *)featureName {
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSString *command = @"git";
    NSArray *arguments = @[ @"flow", @"feature", @"start", featureName ];
    [shellCore executeCommand:command
                withArguments:arguments
                  inDirectory:self.projectDirectoryPath];
}

- (NSArray<NSString *> *)listFeatures {
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSString *command = @"git";
    NSArray *arguments = @[ @"branch" ];
    NSString *shellOutput = [shellCore executeCommand:command
                                        withArguments:arguments
                                          inDirectory:self.projectDirectoryPath];
    NSArray *branchRawList = [shellOutput componentsSeparatedByString:@"\n"];
    
    NSMutableArray *branchList = [[NSMutableArray alloc] init];
    for (NSString *rawBranch in branchRawList) {
        NSString *branch = [rawBranch stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" *"]];
        if ([branch containsString:@"feature/"]) {
            branch = [branch stringByReplacingOccurrencesOfString:@"feature/" withString:@""];
            [branchList addObject:branch];
        }
    }
    
    return branchList.copy;
}

- (NSString *)projectDirectory {
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    id workSpace;
    
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:[NSApp keyWindow]]) {
            workSpace = [controller valueForKey:@"_workspace"];
        }
    }
    
    NSString *workspacePath = [[workSpace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    NSURL *url = [[NSURL alloc] initWithString:workspacePath];
    return url.URLByDeletingLastPathComponent.absoluteString;
}

@end
