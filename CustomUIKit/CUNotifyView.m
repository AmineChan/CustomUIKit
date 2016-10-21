//
//  CUNotifyView.m
//  CustomUIKit
//
//  Created by czm on 15-8-24.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import "CUNotifyView.h"

@interface CUNotifyView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) CUNotifyStyle style;//default CUNotifyStyleCenter
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) BOOL isShowing;

@end

@implementation CUNotifyView

- (void)dealloc
{
    [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __notifyViewSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __notifyViewSetup];
    }
    
    return self;
}

- (void)__notifyViewSetup
{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.alpha = 0;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.7;
    _bgView.layer.opacity = 0.7;
    _bgView.layer.shadowOffset = CGSizeMake(0, 2);
    _bgView.layer.shadowColor = [UIColor whiteColor].CGColor;
    _bgView.layer.shadowOpacity = 0.5;
    _bgView.layer.frame = self.bounds;
    _bgView.layer.cornerRadius = 5.0;
    [_bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_bgView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.numberOfLines = 3;
    _contentLabel.adjustsFontSizeToFitWidth = YES;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor=[UIColor whiteColor];
    _contentLabel.backgroundColor = [UIColor clearColor];
    [_contentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_contentLabel];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (_contentLabel, _bgView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bgView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_contentLabel]-10-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_contentLabel]-4-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
}

- (void)layoutUI
{
    CGFloat maxLabelW = 280.0;
    CGFloat maxLabelH = 300.0;
    CGFloat minLabelW = 130.0;
    CGFloat minLabelH = 50.0;
    NSString *content = _contentLabel.text;
    CGSize contentSize = CGSizeZero;
    if (content)
    {
        contentSize = [_contentLabel sizeThatFits:CGSizeMake(maxLabelW, maxLabelH)];
        
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        contentSize.height += 24.0;
    }
    
    contentSize.width += 20.0;
    if (contentSize.height < minLabelH)
    {
        contentSize.height = minLabelH;
    }
    
    if (contentSize.width < minLabelW)
    {
        contentSize.width = minLabelW;
    }
    
    self.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
}

- (void)showWithMessage:(nullable NSString *)msg style:(CUNotifyStyle)style duration:(NSTimeInterval)duration;
{
    _duration = duration;
    _contentLabel.text = msg;
    _style = style;
    
    [self layoutUI];
    [self show];
}

- (void)show
{
    [self startTimer];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    switch (_style) {
        case CUNotifyStyleTop:
            self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                                      keywindow.bounds.size.height/4.0f);
            break;
        case CUNotifyStyleCenter:
            self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                                      keywindow.bounds.size.height/2.0f);
            break;
        case CUNotifyStyleBottom:
            self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                                      keywindow.bounds.size.height/4.0f*3);
            break;
        default:
            break;
    }
    
    if (_isShowing)
    {
        return;
    }
    
    _isShowing = YES;
    self.hidden = NO;
    
    [UIView beginAnimations:@"show"context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    self.alpha = 1;
    [UIView commitAnimations];
}

-(void)dismiss
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)useAnimation
{
    _isShowing = NO;
    [self stopTimer];
    
    if (useAnimation)
    {
        [UIView beginAnimations:@"hidden" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.alpha = 0;
        [UIView commitAnimations];
    }
    else
    {
        self.alpha = 0;
    }
}

- (void)startTimer
{
    if (_timer)
    {
        [self stopTimer];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)onTimer:(NSTimer *)timer
{
    [self dismiss];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end

static CUNotifyView *g_notifyView = nil;
static const NSTimeInterval kNotifyViewDefaultDuration = 2;

@implementation NSObject (CUNotifyView)
- (void)cu_showNotifyOnTop:(nullable NSString *)msg
{
    [self cu_showNotify:msg style:CUNotifyStyleTop duration:kNotifyViewDefaultDuration];
}

- (void)cu_showNotifyOnCenter:(nullable NSString *)msg
{
    [self cu_showNotify:msg style:CUNotifyStyleCenter duration:kNotifyViewDefaultDuration];
}

- (void)cu_showNotifyOnBottom:(nullable NSString *)msg
{
    [self cu_showNotify:msg style:CUNotifyStyleBottom duration:kNotifyViewDefaultDuration];
}

- (void)cu_showNotify:(NSString *)msg style:(CUNotifyStyle)style duration:(NSTimeInterval)duration
{
    if (nil == msg)
    {
        return;
    }
    
    if (nil == g_notifyView)
    {
        g_notifyView = [[CUNotifyView alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    }
    
    [g_notifyView showWithMessage:msg style:style duration:duration];
}

- (void)cu_dismissNotify
{
    [self cu_dismissNotify:YES];
}

- (void)cu_dismissNotify:(BOOL)useAnimation
{
    if (nil == g_notifyView)
    {
        return;
    }
    
    [g_notifyView dismiss:useAnimation];
}

@end
