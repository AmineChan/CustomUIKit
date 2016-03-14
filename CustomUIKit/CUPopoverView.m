//
//  CUPopoverView.m
//  CustomUIKit
//
//  Created by czm on 15-9-2.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import "CUPopoverView.h"
#import <QuartzCore/QuartzCore.h>

@interface CUPopoverView ()

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end

@implementation CUPopoverView
@synthesize overlayView = _overlayView;

- (void)dealloc
{
    _dismissBlock = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __popoverViewsetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __popoverViewsetup];
    }
    
    return self;
}

- (void)__popoverViewsetup
{
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [keywindow endEditing:YES];

    self.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f-40);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

- (void)setOnDismissBlock:(void (^)(void))onDismissBlock
{
    _dismissBlock = onDismissBlock;
}

#pragma mark - animations
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0;
    self.overlayView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        _overlayView.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
        _overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
            
            if (_dismissBlock)
            {
                _dismissBlock();
            }
        }
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super pointInside:point withEvent:event];
}

@end
