//
//  CUButton.m
//  Example
//
//  Created by czm on 15/12/7.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "CUButton.h"

@interface CUButton ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *cu_backgroundColors;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *cu_borderColors;

@end

@implementation CUButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self cu_updateBackgroundColor];
    [self cu_updateBorderColor];
}

- (void)cu_setBackgroundColor:(UIColor *)color forUIControlState:(UIControlState)state
{
    assert(color);
    
    if (!_cu_backgroundColors)
    {
        _cu_backgroundColors = [NSMutableDictionary<NSNumber *, UIColor *> new];
        _cu_backgroundColors[@(UIControlStateNormal)] = self.backgroundColor;
    }
    
    _cu_backgroundColors[@(state)] = color;
    [self cu_updateBackgroundColor];
}

- (void)cu_setBorderColor:(UIColor *)color forUIControlState:(UIControlState)state;
{
    assert(color);
    
    if (!_cu_borderColors)
    {
        _cu_borderColors = [NSMutableDictionary<NSNumber *, UIColor *> new];
    }
    
    _cu_borderColors[@(state)] = color;
    [self cu_updateBorderColor];
}

- (UIColor*)cu_backgroundColorForState:(UIControlState)state
{
    if(_cu_backgroundColors[@(state)])
        return _cu_backgroundColors[@(state)];
    else
        return self.backgroundColor;
}

- (UIColor*)cu_borderColorForState:(UIControlState)state
{
    return self.cu_borderColors[@(state)];
}

- (void)cu_updateBackgroundColor
{
    UIColor *color = [self cu_backgroundColorForState:self.state];
    if (color)
    {
        [self setBackgroundColor:color];
    }
}

- (void)cu_updateBorderColor
{
    UIColor *color = [self cu_borderColorForState:self.state];
    if (color)
    {
        self.layer.borderColor = color.CGColor;
    }
}

@end
