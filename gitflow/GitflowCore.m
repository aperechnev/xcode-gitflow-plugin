//
//  GitflowCore.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import "GitflowCore.h"
#import "ShellCore.h"


static NSString * const kGitflowExecutablePath = @"/usr/local/bin/git-flow";


@implementation GitflowCore

@synthesize projectDirectoryPath = _projectDirectoryPath;

+ (instancetype)sharedInstance {
    static GitflowCore * sGitflowCore = nil;
    @synchronized (self) {
        if (sGitflowCore == nil) {
            sGitflowCore = [[GitflowCore alloc] init];
        }
    }
    return sGitflowCore;
}

- (void)gitFlowInit {
    NSArray *arguments = @[ @"init", @"-fd" ];
    [[ShellCore sharedInstance] executeCommand:kGitflowExecutablePath
                                 withArguments:arguments
                                   inDirectory:self.projectDirectoryPath];
}

- (void)startFeature:(NSString *)featureName {
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSArray *arguments = @[ @"feature", @"start", featureName ];
    [shellCore executeCommand:kGitflowExecutablePath
                withArguments:arguments
                  inDirectory:self.projectDirectoryPath];
}

- (NSArray<NSString *> *)listFeatures {
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSArray *arguments = @[ @"feature" ];
    NSString *shellOutput = [shellCore executeCommand:kGitflowExecutablePath
                                        withArguments:arguments
                                          inDirectory:self.projectDirectoryPath];
    NSArray *branchRawList = [shellOutput componentsSeparatedByString:@"\n"];
    
    NSMutableArray *branchList = [[NSMutableArray alloc] init];
    NSCharacterSet *charactersToTrim = [NSCharacterSet characterSetWithCharactersInString:@" *"];
    for (NSString *rawBranch in branchRawList) {
        NSString *branch = [rawBranch stringByTrimmingCharactersInSet:charactersToTrim];
        if (branch == nil || branch.length == 0) {
            continue;
        }
        [branchList addObject:branch];
    }
    
    return branchList.copy;
}

- (void)finishFeature:(NSString *)featureName {
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSArray *arguments = @[ @"feature", @"finish", featureName ];
    [shellCore executeCommand:kGitflowExecutablePath
                withArguments:arguments
                  inDirectory:self.projectDirectoryPath];
}

- (void)publishFeature:(NSString *)featureName {
    // TODO: Feature publishing
}

- (void)pullFeature:(NSString *)featureName {
    // TODO: Feature pulling
}

#pragma mark - Setters & Getters

- (NSString *)projectDirectoryPath {
    if (_projectDirectoryPath != nil) {
        return _projectDirectoryPath;
    }
    
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
