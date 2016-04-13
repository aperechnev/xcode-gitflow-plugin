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
    if (sourceControlMenuItem != nil) {
        [[sourceControlMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *gitflowMenuItem = [[NSMenuItem alloc] initWithTitle:@"Git Flow" action:nil keyEquivalent:@""];
        [[sourceControlMenuItem submenu] addItem:gitflowMenuItem];
        
        NSMenu *gitflowMenu = [[NSMenu alloc] init];
        gitflowMenu.delegate = self;
        gitflowMenuItem.submenu = gitflowMenu;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
    [self reloadFeatureListToMenu:menu];
}

#pragma mark - Internal methods

- (void)reloadFeatureListToMenu:(NSMenu *)menu {
    [menu removeAllItems];
    
    NSMenuItem *startFeatureMenuItem = [[NSMenuItem alloc] initWithTitle:@"Start feature"
                                                                  action:@selector(startFeatureItemClicked)
                                                           keyEquivalent:@""];
    startFeatureMenuItem.target = self;
    [menu addItem:startFeatureMenuItem];
    [menu addItem:[NSMenuItem separatorItem]];
    
    for (NSString *feature in [GitflowCore sharedInstance].listFeatures) {
        NSMenuItem *featureMenuItem = [[NSMenuItem alloc] initWithTitle:feature
                                                                 action:nil
                                                          keyEquivalent:@""];
        
        NSMenu *featureSubmenu = [[NSMenu alloc] init];
        NSMenuItem *finishFeatureMenuItem = [[NSMenuItem alloc] initWithTitle:@"Finish"
                                                                       action:@selector(finishFeatureItemClicked:)
                                                                keyEquivalent:@""];
        finishFeatureMenuItem.target = self;
        [featureSubmenu addItem:finishFeatureMenuItem];
        featureMenuItem.submenu = featureSubmenu;
        
        [menu addItem:featureMenuItem];
    }
}

#pragma mark - Menu actions

- (void)startFeatureItemClicked {
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    
    alert.messageText = @"Please enter a name for new feature";
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setStringValue:@""];
    [alert setAccessoryView:input];
    
    NSInteger button = [alert runModal];
    if (button == NSAlertFirstButtonReturn) {
        [input validateEditing];
        NSString *featureName = [input stringValue];
        [[GitflowCore sharedInstance] startFeature:featureName];
    }
}

- (void)finishFeatureItemClicked:(NSMenuItem *)sender {
    NSString *featureName = sender.parentItem.title;
    if (featureName != nil) {
        [[GitflowCore sharedInstance] finishFeature:featureName];
    }
}

@end
