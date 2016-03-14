//
//  CUTextField.m
//  CustomUIKit
//
//  Created by czm on 14-4-11.
//  Copyright (c) 2014年 czm. All rights reserved.
//

#import "CUTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation CUTextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __textFieldSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __textFieldSetup];
    }
    
    return self;
}

- (void)__textFieldSetup
{
    _padding = UIEdgeInsetsZero;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeNotify:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setText:(NSString *)text
{
    if (text && _maxLength > 0 && text.length > _maxLength)
    {
        [super setText:[text substringToIndex:_maxLength]];
    }
    else
    {
        [super setText:text];
    }
}

- (void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = maxLength;
    if (_maxLength == 0)
    {
        return;
    }
    
    if (self.text.length > _maxLength)
    {
        self.text = [self.text substringToIndex:_maxLength];
    }
}

- (void)didChangeNotify:(NSNotification*)notification
{
    if (_maxLength == 0)
    {
        return;
    }
    
    UITextField *sender = self;
    UITextRange *markRange = sender.markedTextRange;
    NSInteger pos = [sender offsetFromPosition:markRange.start toPosition:markRange.end];
    NSInteger nLength = sender.text.length - pos;
    if (nLength > _maxLength && pos==0)
    {
        sender.text = [sender.text substringToIndex:_maxLength];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + _padding.left,
                      bounds.origin.y + _padding.top,
                      bounds.size.width - _padding.left-_padding.right,
                      bounds.size.height - _padding.top-_padding.bottom);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + _padding.left,
                      bounds.origin.y + _padding.top,
                      bounds.size.width - _padding.left-_padding.right,
                      bounds.size.height - _padding.top-_padding.bottom);
}

@end
