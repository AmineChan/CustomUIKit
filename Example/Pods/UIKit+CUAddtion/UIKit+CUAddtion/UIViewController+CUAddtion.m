//
//  UIViewController+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/17.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UIViewController+CUAddtion.h"

@implementation UIViewController (CUAddtion)

- (UIViewController *)cu_fromViewController
{
    UINavigationController *navi = self.navigationController;
    if ([self isKindOfClass:[UINavigationController class]])
    {
        navi = (UINavigationController *)self;
    }
    
    NSArray *viewControllers = [navi viewControllers];
    NSInteger index = [viewControllers indexOfObject:self];
    if (index > 0)
    {
        NSInteger index = [viewControllers indexOfObject:self];
        return viewControllers[index-1];
    }
    
    return self;
}

@end
