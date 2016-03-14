//
//  UITableViewCell+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UITableViewCell+CUAddtion.h"

@implementation UITableViewCell (CUAddtion)

- (void)cu_setSeperatorToLeft
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)cu_setSeperatorInset:(UIEdgeInsets)seperatorInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self setSeparatorInset:seperatorInset];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self setLayoutMargins:seperatorInset];
    }
    
    if([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [self setPreservesSuperviewLayoutMargins:NO];
    }
}

@end
