//
//  UITableView+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UITableView+CUAddtion.h"

@implementation UITableView (CUAddtion)

- (void)cu_hiddenSeperatorLineForNoContentCell
{
    UIView *view = [ [UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

@end
