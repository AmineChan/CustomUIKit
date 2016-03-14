//
//  UIView+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UIView+CUAddtion.h"
#import <objc/runtime.h>

@interface UINavigationBar (CUAddtion)
@end
@implementation UINavigationBar(CUAddtion)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.cu_hiddenKeyboardWhenTouchBegin && self.delegate)
    {
        if ([self.delegate isKindOfClass:[UINavigationController class]])
        {
            UIViewController *topVC = [(UINavigationController *)self.delegate topViewController];
            if (topVC)
            {
                [topVC.view endEditing:YES];
            }
        }
    }
}
@end

@implementation UIView (CUAddtion)
@dynamic cu_hiddenKeyboardWhenTouchBegin;

- (void)cu_setHiddenKeyboardWhenTouchBegin:(BOOL)cu_hiddenKeyboardWhenTouchBegin
{
    objc_setAssociatedObject(self,
                             @selector(cu_hiddenKeyboardWhenTouchBegin),
                             @(cu_hiddenKeyboardWhenTouchBegin),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)cu_hiddenKeyboardWhenTouchBegin
{
    return [objc_getAssociatedObject(self, @selector(cu_hiddenKeyboardWhenTouchBegin)) boolValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.cu_hiddenKeyboardWhenTouchBegin)
    {
        [self endEditing:YES];
    }
}

@end
