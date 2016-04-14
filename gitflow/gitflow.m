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
    [self reloadEntitiesToMenu:menu];
}

#pragma mark - Internal methods

- (void)reloadEntitiesToMenu:(NSMenu *)menu {
    [menu removeAllItems];
    
    [self configureMenuItemsForEntity:kGitflowEntityFeature
                              forMenu:menu
                            withStart:@selector(startFeatureItemClicked)
                            andFinish:@selector(finishFeatureItemClicked:)];
    
    [self configureMenuItemsForEntity:kGitflowEntityRelease
                              forMenu:menu
                            withStart:@selector(startReleaseItemClicked)
                            andFinish:@selector(finishReleaseItemClicked:)];
    
    [self configureMenuItemsForEntity:kGitflowEntityHotfix
                              forMenu:menu
                            withStart:@selector(startHotfixItemClicked)
                            andFinish:@selector(finishHotfixItemClicked:)];
}

- (void)configureMenuItemsForEntity:(NSString *)entity forMenu:(NSMenu *)menu withStart:(SEL)start andFinish:(SEL)finish {
    [menu addItem:[NSMenuItem separatorItem]];
    
    NSString *startEntityMenuItemTitle = [NSString stringWithFormat:@"Start %@", entity.capitalizedString];
    
    NSMenuItem *startEntityMenuItem = [[NSMenuItem alloc] initWithTitle:startEntityMenuItemTitle
                                                                 action:start
                                                          keyEquivalent:@""];
    startEntityMenuItem.target = self;
    [menu addItem:startEntityMenuItem];
    
    for (NSString *i_entity in [[GitflowCore sharedInstance] listEntity:entity]) {
        NSMenuItem *entityMenuItem = [[NSMenuItem alloc] initWithTitle:i_entity
                                                                action:nil
                                                         keyEquivalent:@""];
        
        NSMenu *entitySubmenu = [[NSMenu alloc] init];
        NSMenuItem *finishEntityMenuItem = [[NSMenuItem alloc] initWithTitle:@"Finish"
                                                                      action:finish
                                                               keyEquivalent:@""];
        finishEntityMenuItem.target = self;
        [entitySubmenu addItem:finishEntityMenuItem];
        entityMenuItem.submenu = entitySubmenu;
        
        [menu addItem:entityMenuItem];
    }
}

- (NSString *)askInputStringWithMessage:(NSString *)message {
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    
    alert.messageText = message;
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [input setStringValue:@""];
    [alert setAccessoryView:input];
    
    NSInteger button = [alert runModal];
    if (button == NSAlertFirstButtonReturn) {
        [input validateEditing];
        return [input stringValue];
    }
    
    return nil;
}

#pragma mark - Menu actions

- (void)startFeatureItemClicked {
    NSString *featureName = [self askInputStringWithMessage:@"Please enter a name for new feature"];
    if (featureName != nil) {
        [[GitflowCore sharedInstance] doAction:kGitflowActionStart
                                    withEntity:kGitflowEntityFeature
                                      withName:featureName
                          additionalParameters:nil];
    }
}

- (void)finishFeatureItemClicked:(NSMenuItem *)sender {
    NSString *featureName = sender.parentItem.title;
    if (featureName != nil) {
        [[GitflowCore sharedInstance] doAction:kGitflowActionFinish
                                    withEntity:kGitflowEntityFeature
                                      withName:featureName
                          additionalParameters:nil];
    }
}

- (void)startReleaseItemClicked {
    NSString *releaseName = [self askInputStringWithMessage:@"Please enter a name for new release"];
    if (releaseName != nil) {
        [[GitflowCore sharedInstance] doAction:kGitflowActionStart
                                    withEntity:kGitflowEntityRelease
                                      withName:releaseName
                          additionalParameters:nil];
    }
}

- (void)finishReleaseItemClicked:(NSMenuItem *)sender {
    NSString *releaseName = sender.parentItem.title;
    if (releaseName == nil) {
        return;
    }
    
    NSString *tagMessage = [self askInputStringWithMessage:@"Please enter message for the new tag"];
    if (tagMessage == nil) {
        return;
    }
    
    NSArray *additionalParameters = @[ @"-m", tagMessage ];
    
    [[GitflowCore sharedInstance] doAction:kGitflowActionFinish
                                withEntity:kGitflowEntityRelease
                                  withName:releaseName
                      additionalParameters:additionalParameters];
}

- (void)startHotfixItemClicked {
    NSString *hotfixName = [self askInputStringWithMessage:@"Please enter a name for new hotfix"];
    if (hotfixName != nil) {
        [[GitflowCore sharedInstance] doAction:kGitflowActionStart
                                    withEntity:kGitflowEntityHotfix
                                      withName:hotfixName
                          additionalParameters:nil];
    }
}

- (void)finishHotfixItemClicked:(NSMenuItem *)sender {
    NSString *hotifxName = sender.parentItem.title;
    if (hotifxName == nil) {
        return;
    }
    
    NSString *tagMessage = [self askInputStringWithMessage:@"Please enter message for the new tag"];
    if (tagMessage == nil) {
        return;
    }
    
    NSArray *additionalParameters = @[ @"-m", tagMessage ];
    
    [[GitflowCore sharedInstance] doAction:kGitflowActionFinish
                                withEntity:kGitflowEntityHotfix
                                  withName:hotifxName
                      additionalParameters:additionalParameters];
}

@end
