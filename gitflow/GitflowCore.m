//
//  GitflowCore.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import "GitflowCore.h"


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

- (NSArray<NSString *> *)listFeatures {
    return @[ @"my-feature", @"another-feature" ];
}

- (void)startFeature:(NSString *)featureName {
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
