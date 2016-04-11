//
//  gitflow.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import "gitflow.h"


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
        
        NSMenuItem *featureStartMenuItem = [[NSMenuItem alloc] initWithTitle:@"Start Feature" action:nil keyEquivalent:@""];
        featureStartMenuItem.submenu = [[NSMenu alloc] initWithTitle:@"Feature"];
        [[gitflowMenuItem submenu] addItem:featureStartMenuItem];
    }
}

#pragma mark - Menu actions

- (void)doMenuAction {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, World"];
    [alert runModal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
