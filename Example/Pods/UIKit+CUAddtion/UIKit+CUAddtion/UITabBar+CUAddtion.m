//
//  UITabBar+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UITabBar+CUAddtion.h"

@implementation UITabBar (CUAddtion)
- (void)cu_showBadgeOnTabIndex:(NSInteger)tabIndex
{
    //remove old badge
    [self cu_removeBadgeOnItemIndex:tabIndex];
    
    //create new badge
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + tabIndex;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    NSInteger tabCount = self.items.count;

    //set badge frame
    CGFloat percentX = (tabIndex +0.6) / tabCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    
    [self addSubview:badgeView];
}

- (void)cu_hideBadgeOnTabIndex:(NSInteger)tabIndex
{
    [self cu_removeBadgeOnItemIndex:tabIndex];
}

- (void)cu_removeBadgeOnItemIndex:(NSInteger)tabIndex
{
    for (UIView *subView in self.subviews)
    {
        if (subView.tag == 888+tabIndex)
        {
            [subView removeFromSuperview];
        }
    }
}

@end
