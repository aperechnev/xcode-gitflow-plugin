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

#pragma mark - Entity Management

- (NSArray<NSString *> *)listEntity:(NSString *)entity {
    NSString *projectDirectoryPath = self.projectDirectoryPath;
    if (projectDirectoryPath == nil) {
        return @[];
    }
    
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSArray *arguments = @[ entity ];
    NSString *shellOutput = [shellCore executeCommand:kGitflowExecutablePath
                                        withArguments:arguments
                                          inDirectory:projectDirectoryPath];
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

- (void)doAction:(NSString *)action withEntity:(NSString *)entity withName:(NSString *)name additionalParameters:(NSArray<NSString *> *)parameters {
    ShellCore *shellCore = [ShellCore sharedInstance];
    
    NSArray *arguments = [self shellArgumentsForAction:action
                                             forEntity:entity
                                              withName:name
                              withAdditionalParameters:parameters];
    
    [shellCore executeCommand:kGitflowExecutablePath
                withArguments:arguments
                  inDirectory:self.projectDirectoryPath];
}

- (NSArray *)shellArgumentsForAction:(NSString *)action forEntity:(NSString *)entity withName:(NSString *)name withAdditionalParameters:(NSArray<NSString *> *)parameters {
    NSMutableArray *arguments = [[NSMutableArray alloc] initWithArray:@[ entity, action ]];
    if (parameters != nil) {
        [arguments addObjectsFromArray:parameters];
    }
    [arguments addObject:name];
    return arguments.copy;
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
    
    if (workSpace == nil) {
        return nil;
    }
    
    NSString *workspacePath = [[workSpace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    if (workspacePath == nil) {
        return nil;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:workspacePath];
    if (url == nil) {
        return nil;
    }
    
    return url.URLByDeletingLastPathComponent.absoluteString;
}

@end
