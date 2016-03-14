//
//  UINavigationController+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/17.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UINavigationController+CUAddtion.h"

@implementation UINavigationController (CUAddtion)

- (void)cu_popToDestViewController:(UIViewController *)vc withAnimated:(BOOL)animated
{
    if (!vc)
    {
        return;
    }
    
    NSArray *viewControllers = [self viewControllers];
    if (![viewControllers containsObject:vc])
    {
        return;
    }

    [self popToViewController:vc animated:animated];
}

@end
