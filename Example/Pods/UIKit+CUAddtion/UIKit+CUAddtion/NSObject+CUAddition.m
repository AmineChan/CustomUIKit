//
//  NSObject+CUAddition.m
//  CustomUIKit
//
//  Created by czm on 15/11/17.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "NSObject+CUAddition.h"

@implementation NSObject (CUAddition)

- (UIViewController *)cu_getCurrentViewController
{
    if ([self isKindOfClass:[UIViewController class]])
    {
        return (UIViewController *)self;
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootViewController = keywindow.rootViewController;
    if (rootViewController)
    {
        return rootViewController;
    }
    
    return nil;
}

@end
