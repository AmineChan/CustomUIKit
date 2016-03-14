//
//  CUIndexBar.m
//  CustomUIKit
//
//  Created by czm on 15/11/30.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "CUIndexBar.h"
#import <QuartzCore/QuartzCore.h>

static NSUInteger kBigIndexLabelTag = (NSUInteger)&kBigIndexLabelTag;

@interface CUIndexBar ()
@property (nonatomic, strong) UILabel *bigIndexTitle;
@property (nonatomic, strong) UILabel *curSelectedLabel;
@property (nonatomic, strong) UIView *backgroundview;

@property (nonatomic, assign) BOOL dragging;
@end

@implementation CUIndexBar
- (void)dealloc
{
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __indexBarSetup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self __indexBarSetup];
    }
    
    return self;
}

- (void)__indexBarSetup
{
    self.backgroundColor = [UIColor clearColor];
    _textColor = [UIColor blackColor];
    _selectedTextColor = [UIColor orangeColor];
    _textFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    _highlightedBackgroundColor = [UIColor lightGrayColor];

    _backgroundview = [[UIView alloc] init];
    _backgroundview.alpha = 0.5;
    _backgroundview.backgroundColor = _highlightedBackgroundColor;
    _backgroundview.layer.cornerRadius = self.bounds.size.width/2;
    _backgroundview.layer.masksToBounds = YES;
    [_backgroundview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_backgroundview];
    _backgroundview.hidden = YES;

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (_backgroundview);
    NSString *vfl = @"V:|-0-[_backgroundview]-0-|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: vfl
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: viewsDictionary]];
    
    vfl = @"H:|-0-[_backgroundview]-0-|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: vfl
                                                                 options: 0
                                                                 metrics: nil
                                                                   views: viewsDictionary]];

    _bigIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _bigIndexLabel.tag = kBigIndexLabelTag;
    _bigIndexLabel.font = [UIFont boldSystemFontOfSize:38];
    _bigIndexLabel.backgroundColor = [UIColor clearColor];
    _bigIndexLabel.textAlignment = NSTextAlignmentCenter;
    _bigIndexLabel.textColor = [UIColor darkGrayColor];
}

- (void)layoutSubviews 
{
	[super layoutSubviews];	

    UIView *superView = self.superview;
    CGPoint bigIndexCenter = CGPointMake(superView.bounds.size.width/2.0, superView.bounds.size.height/2.0);
    [superView addSubview:_bigIndexLabel];
    [superView bringSubviewToFront:_bigIndexLabel];
    [_bigIndexLabel setCenter:bigIndexCenter];

	NSInteger subCount = 0;
	for (UIView *subview in self.subviews)
	{
        if ([self isIndexLabel:subview])
		{
            UILabel *label = (UILabel *)subview;
            label.font = _textFont;
            label.textColor = _textColor;

			subCount++;
		}
	}
	
    CGFloat ypos = 10.0;
    CGFloat sectionheight = (self.frame.size.height - 20.0)/subCount;
    if (sectionheight > 32.0)
    {
        sectionheight = 32.0;
        ypos = floorf((self.bounds.size.height - sectionheight*subCount)/2.0);
    }
    
	for (UIView *subview in self.subviews) 
	{
        if ([self isIndexLabel:subview])
		{
			[subview setFrame:CGRectMake(0, ypos, self.frame.size.width, sectionheight)];
            ypos += sectionheight;
		}
	}
}

- (void)setIndexes:(NSArray*)indexes
{	
	[self clearIndex];
    
	for (NSInteger i = 0; i < [indexes count]; i ++)
	{
		UILabel *indexLabel = [[UILabel alloc] init];
		indexLabel.textAlignment = NSTextAlignmentCenter;
		indexLabel.text = [indexes objectAtIndex:i];
		indexLabel.backgroundColor = [UIColor clearColor];
        
		[self addSubview:indexLabel];
	}
    
    [self setNeedsLayout];
}

- (void)clearIndex
{
	for (UIView *subview in self.subviews) 
	{
        if ([self isIndexLabel:subview])
        {
            [subview removeFromSuperview];
        }
	}
}


- (BOOL)isIndexLabel:(UIView *)view
{
    if (![view isKindOfClass:[UILabel class]])
        return NO;
    
    if (view.tag == kBigIndexLabelTag)
    {
        return NO;
    }
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void)touchesEndedOrCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _backgroundview.hidden = YES;
    
    [UIView animateWithDuration:.5 animations:^{
        _bigIndexLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _bigIndexLabel.text = @"";
    }];
    
    if ([_delegate respondsToSelector:@selector(indexSelectionDidEndDragging:)])
        [_delegate indexSelectionDidEndDragging:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
    _backgroundview.hidden = NO;
    _backgroundview.backgroundColor = _highlightedBackgroundColor;
    _backgroundview.layer.cornerRadius = self.bounds.size.width/2;
    _backgroundview.layer.masksToBounds = YES;
	[self sendSubviewToBack:_backgroundview];
	
    if (!_delegate)
        return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	if(touchPoint.x < 0)
	{
		return;
	}
	
	NSString *title = nil;
	NSInteger count = 0;
    for (UILabel *subview in self.subviews)
	{
		if ([self isIndexLabel:subview])
		{
			if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height)
			{
				count++;
				title = subview.text;
                if (_selectedTextColor)
                {
                    subview.textColor = _selectedTextColor;
                }
                
                if (_selectedTextFont)
                {
                    subview.font = _selectedTextFont;
                }
                
                if (_curSelectedLabel != subview)
                {
                    _curSelectedLabel.textColor = _textColor;
                    _curSelectedLabel.font = _textFont;
                    _curSelectedLabel = subview;
                }
                
				break;
			}
			
			count++;
			title = subview.text;
		}
	}

    _bigIndexLabel.alpha = 1;
    _bigIndexLabel.text = title;
    if ([_delegate respondsToSelector:@selector(indexSelectionDidChange:index:title:)])
        [_delegate indexSelectionDidChange:self index:count - 1 title:title];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

	if (!_delegate)
        return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	if(touchPoint.x < 0)
	{
		return;
	}
	
	NSString *title = nil;
	NSInteger count = 0;
	for (UILabel *subview in self.subviews)
	{
        if ([self isIndexLabel:subview])
		{
			if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height)
			{
				count++;
				title = subview.text;
                if (_selectedTextColor)
                {
                    subview.textColor = _selectedTextColor;
                }
                
                if (_selectedTextFont)
                {
                    subview.font = _selectedTextFont;
                }
                
                if (_curSelectedLabel != subview)
                {
                    _curSelectedLabel.textColor = _textColor;
                    _curSelectedLabel.font = _textFont;
                    _curSelectedLabel = subview;
                }
                
				break;
			}
			
			count++;
			title = subview.text;
		}
	}
    
    _bigIndexLabel.alpha = 1;
    _bigIndexLabel.text = title;
    if ([_delegate respondsToSelector:@selector(indexSelectionDidChange:index:title:)])
        [_delegate indexSelectionDidChange:self index:count - 1 title:title];
}

- (void)setTableView:(UITableView *)tableView
{
    if (_tableView != nil)
    {
        @try
        {
            [_tableView removeObserver:self forKeyPath:@"contentInset" context:@"CUIndexBar"];
        }
        @catch(id anException)
        {
        }
    }
    
    _tableView = tableView;
    if (!_tableView)
    {
        return;
    }
    
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"CUIndexBar"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        NSArray *indexPathArray = [_tableView indexPathsForVisibleRows];
        if (indexPathArray && indexPathArray.count != 0)
        {
            NSIndexPath *indexPath = indexPathArray[0];
            NSInteger index = 0;
            for (UILabel *subview in self.subviews)
            {
                if ([self isIndexLabel:subview])
                {
                    if (index == indexPath.section)
                    {
                        subview.textColor = _selectedTextColor;
                        if (_curSelectedLabel != subview)
                        {
                            _curSelectedLabel.textColor = self.textColor;
                            _curSelectedLabel = subview;
                        }
                        break;
                    }
                    index ++;
                }
            }
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        if (_tableView != nil)
        {
            @try
            {
                [_tableView removeObserver:self forKeyPath:@"contentInset" context:@"CUIndexBar"];
            }
            @catch(id anException)
            {
                NSLog(@"warning:%s, %d, removeOberver error!!!", __FILE__, __LINE__);
            }
        }
    }
}

@end
