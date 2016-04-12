//
//  GitflowCore.h
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@interface GitflowCore : NSObject

+ (instancetype)sharedInstance;

- (NSArray<NSString *> *)listFeatures;
- (NSArray<NSString *> *)listReleases;

- (void)startFeature:(NSString *)featureName;
@end
