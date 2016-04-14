//
//  gitflow.h
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <AppKit/AppKit.h>


@class gitflow;


static gitflow *sharedPlugin;


@interface gitflow : NSObject <NSMenuDelegate>

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle *bundle;

- (void)menuWillOpen:(NSMenu *)menu;
@end