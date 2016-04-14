//
//  NSObject_Extension.m
//  gitflow
//
//  Created by Alex Krzyżanowski on 11.04.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//


#import "NSObject_Extension.h"
#import "gitflow.h"


@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[gitflow alloc] initWithBundle:plugin];
        });
    }
}
@end
