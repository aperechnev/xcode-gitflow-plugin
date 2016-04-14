//
//  GitflowCore.h
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


static NSString * const kGitflowEntityFeature = @"feature";
static NSString * const kGitflowEntityRelease = @"release";
static NSString * const kGitflowEntityHotfix = @"hotfix";

static NSString * const kGitflowActionStart = @"start";
static NSString * const kGitflowActionFinish = @"finish";
static NSString * const kGitflowActionPublish = @"publish";
static NSString * const kGitflowActionPull = @"pull";


@interface GitflowCore : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readwrite) NSString *projectDirectoryPath;

- (void)gitFlowInit;

- (NSArray<NSString *> *)listEntity:(NSString *)entity;

- (void)doAction:(NSString *)action
      withEntity:(NSString *)entity
        withName:(NSString *)name
additionalParameters:(NSArray<NSString *>*)parameters;

- (NSArray *)shellArgumentsForAction:(NSString *)action
                           forEntity:(NSString *)entity
                            withName:(NSString *)name
            withAdditionalParameters:(NSArray<NSString *> *)parameters;

@end
