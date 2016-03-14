//
//  CUControl.m
//  CustomUIKit
//
//  Created by czm on 15/11/17.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "CUControl.h"

@interface CUControl ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *cu_backgroundColors;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *cu_borderColors;
@property (nonatomic) UIControlState cu_state;

@end

@implementation CUControl

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
    return _cu_borderColors[@(state)];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsLayout];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsLayout];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsLayout];
}

@end
