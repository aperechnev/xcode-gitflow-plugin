//
//  gitflow.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import "gitflow.h"
#import "GitflowCore.h"


@interface gitflow()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end


@implementation gitflow

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSApplicationDidFinishLaunchingNotification
                                                  object:nil];
    [self configureMenuItems];
}

#pragma mark - Menu configuration

- (void)configureMenuItems {
    NSMenuItem *sourceControlMenuItem = [[NSApp mainMenu] itemWithTitle:@"Source Control"];
    if (sourceControlMenuItem) {
        [[sourceControlMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *gitflowMenuItem = [[NSMenuItem alloc] initWithTitle:@"Git Flow" action:nil keyEquivalent:@""];
        [[sourceControlMenuItem submenu] addItem:gitflowMenuItem];
        
        NSMenu *gitflowMenu = [[NSMenu alloc] init];
        
        NSMenuItem *startFeatureMenuItem = [[NSMenuItem alloc] initWithTitle:@"Start Feature"
                                                                      action:@selector(doStartFeature)
                                                               keyEquivalent:@""];
        startFeatureMenuItem.target = self;
        [gitflowMenu addItem:startFeatureMenuItem];
        
        for (NSString *feature in [GitflowCore sharedInstance].listFeatures) {
            [gitflowMenu addItemWithTitle:feature action:nil keyEquivalent:@""];
        }
        
        [gitflowMenu addItem:[NSMenuItem separatorItem]];
        [gitflowMenu addItemWithTitle:@"Start Release" action:nil keyEquivalent:@""];
        [gitflowMenu addItemWithTitle:@"Finish Release" action:nil keyEquivalent:@""];
        gitflowMenuItem.submenu = gitflowMenu;
    }
}

#pragma mark - Menu actions

- (void)doStartFeature {
    [[GitflowCore sharedInstance] startFeature:@"my feature"];
}

- (void)doMenuAction {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
