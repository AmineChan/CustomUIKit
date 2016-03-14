//
//  CUTextView.m
//  CustomUIKit
//
//  Created by czm on 14-4-11.
//  Copyright (c) 2014年 czm. All rights reserved.
//

#import "CUTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface CUTextView()

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) BOOL isEditing;

@end

@implementation CUTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __textViewSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __textViewSetup];
    }
    
    return self;
}

- (void)__textViewSetup
{
    _placeholderColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(beginEditingNotify:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEditingNotify:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeEditingNotify:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updatePlaceholder];
    [self updateBorder];
}

#pragma mark -
#pragma mark  inner
#pragma mark
- (void)updatePlaceholder
{
    if (!_placeholderLabel)
    {
        return;
    }
    
    _placeholderLabel.text = _placeholder;
    _placeholderLabel.font = self.font;
    
    if (!self.text || self.text.length < 1)
    {
        CGFloat height = self.font.lineHeight;
        _placeholderLabel.font = self.font;
        _placeholderLabel.frame = CGRectMake(5, 8, self.bounds.size.width-10, height);
        _placeholderLabel.hidden = NO;
    }
    else
    {
        _placeholderLabel.hidden = YES;
    }
}

- (void)updateBorder
{
    if (_isEditing)
    {
        if (_editingBorderColor)
        {
            self.layer.borderColor = _editingBorderColor.CGColor;
        }
    }
    else
    {
        if (_borderColor)
        {
            self.layer.borderColor = _borderColor.CGColor;
        }
    }
}

#pragma mark -
#pragma mark  property
#pragma mark
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder)
    {
        if (!_placeholderLabel)
        {
            CGFloat height = self.font.lineHeight;
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, self.bounds.size.width-10, height)];
            _placeholderLabel.backgroundColor = self.backgroundColor;
            _placeholderLabel.textAlignment= NSTextAlignmentLeft;
            _placeholderLabel.textColor = _placeholderColor;
            [self addSubview:_placeholderLabel];
        }
    }
    
    _placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    assert(placeholderColor);
    
    _placeholderColor = placeholderColor;
    if (_placeholderLabel)
    {
        _placeholderLabel.textColor = _placeholderColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    if (_borderColor)
    {
        [self updateBorder];
    }
}

- (void)setEditingBorderColor:(UIColor *)editingBorderColor
{
    _editingBorderColor = editingBorderColor;
    if (editingBorderColor)
    {
        [self updateBorder];
    }
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

- (NSString *)suitText:(NSString *)text toMaxLength:(NSUInteger)maxLength
{
    if (text && text.length > _maxLength)
    {
        return [text substringToIndex:_maxLength];
    }
    
    return text;
}

#pragma mark -
#pragma mark  notify
#pragma mark
- (void)beginEditingNotify:(NSNotification*) notification
{
    _isEditing = YES;
    [self setNeedsLayout];
}

- (void)endEditingNotify:(NSNotification*) notification
{
    _isEditing = NO;
    [self setNeedsLayout];
}

- (void)changeEditingNotify:(NSNotification*) notification
{
    [self updatePlaceholder];
    if (_maxLength < 1)
    {
        [self setNeedsLayout];
        return;
    }
    
    UITextView *sender = self;
    UITextRange *markRange = sender.markedTextRange;
    NSInteger pos = [sender offsetFromPosition:markRange.start toPosition:markRange.end];
    NSInteger nLength = sender.text.length - pos;
    if (nLength > _maxLength && pos==0)
    {
        sender.text = [sender.text substringToIndex:_maxLength];
    }
}


@end
