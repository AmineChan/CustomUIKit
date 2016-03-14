//
//  CUActivityIndicatorView.m
//  CustomUIKit
//
//  Created by czm on 15-8-5.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import "CUActivityIndicatorView.h"

@interface CUActivityIndicatorView ()
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIImageView *indicator;
@property (nonatomic) BOOL startWhenMoveToWindow;
@property (nonatomic) BOOL superViewOriginUserInteractionEnabled;
@end

@implementation CUActivityIndicatorView
- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __indicatorViewSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __indicatorViewSetup];
    }
    
    return self;
}

- (void)__indicatorViewSetup
{
    _overlayView = [[UIControl alloc] init];
    [self addSubview:_overlayView];
    
    _indicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _indicator.image = [UIImage imageNamed:@"indicator_loading"];
    [self addSubview:_indicator];
    
    self.backgroundColor = [UIColor clearColor];
}

- (UIViewController *)activityIndicatorViewController
{
    id target = self;
    while (target)
    {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]])
        {
            if ([target isKindOfClass:[UINavigationController class]])
            {
                UIViewController *vc = [(UINavigationController *)target topViewController];
                if (vc)
                {
                    target = vc;
                    break;
                }
            }
            break;
        }
    }
    
    return target;
}

- (BOOL)isTabBarShowing:(UITabBarController *)tabBarController
{
    BOOL isTabBarShowing = YES;
    if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navi = (UINavigationController *)tabBarController.selectedViewController;
        if (navi.topViewController.hidesBottomBarWhenPushed || navi.viewControllers[0].hidesBottomBarWhenPushed)
        {
            isTabBarShowing =  NO;
        }
        else
        {
            //UINavigationController的viewControllers中，当出现第一个隐藏了tabBar的ViewController，之后所有的ViewController都会隐藏tabBar，和后面hidesBottomBarWhenPushed值无关
            NSInteger count = navi.viewControllers.count;
            for (NSInteger idx = 0; idx < count-1; idx ++)
            {
                UIViewController *obj = navi.viewControllers[idx];
                if (obj.hidesBottomBarWhenPushed)
                {
                    isTabBarShowing = NO;
                    break;
                }
            }
        }
    }
    else
    {
        isTabBarShowing = !tabBarController.selectedViewController.hidesBottomBarWhenPushed;
    }
    
    return isTabBarShowing;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *superView = self.superview;
    if (!superView)
    {
        return;
    }
    
    CGRect bounds = superView.bounds;
    //UIScrollView need reset bounds
    if ([superView isKindOfClass:[UIScrollView class]])
    {
        UIEdgeInsets edgeInsets = [(UIScrollView *)superView contentInset];
        bounds.size.height -= edgeInsets.bottom;
    }
    else
    {
        UIViewController *vc = [self activityIndicatorViewController];
        if (vc && vc.tabBarController)
        {
            //if vc is base on UITabBarController and tabBar is showing
            if ([self isTabBarShowing:vc.tabBarController])
            {
                bounds.size.height -= vc.tabBarController.tabBar.frame.size.height;
            }
        }
    }
    
    self.frame = bounds;
    _overlayView.frame = self.bounds;
    _indicator.center = CGPointMake(bounds.size.width/2, bounds.size.height/2-10);
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)setLoadingImage:(UIImage *)loadingImage
{
    if (!loadingImage)
    {
        return;
    }
    
    _indicator.image = loadingImage;
}

- (void)setLoadingImageArray:(NSArray *)loadingImageArray
{
    if (!loadingImageArray)
    {
        return;
    }
    
    _indicator.animationImages = loadingImageArray;
    _indicator.animationDuration = loadingImageArray.count * 0.05;
}

- (void)showOnKeywindow
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [self showOnView:keywindow];
}

- (void)showOnView:(UIView *)onView;
{
    assert(onView);
    
    switch (_style) {
        case CUActivityIndicatorStyleOverlay:
            _overlayView.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.35];
            break;
        case CUActivityIndicatorStyleEmbed:
            _overlayView.backgroundColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    _superViewOriginUserInteractionEnabled = onView.userInteractionEnabled;
    onView.userInteractionEnabled = NO;

    _startWhenMoveToWindow = YES;
    [onView addSubview:self];
    [onView bringSubviewToFront:self];
}

- (void)dismiss
{
    if ([self superview])
    {
        [self superview].userInteractionEnabled = _superViewOriginUserInteractionEnabled;
        [self endAnimation];
        [self removeFromSuperview];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window && _startWhenMoveToWindow)
    {
        if ([self.superview isKindOfClass:[UIScrollView class]])
        {
            [self.superview addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"CUActivityIndicatorView"];
        }

        [self superview].userInteractionEnabled = NO;
        [self startAnimation];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (!newWindow)
    {
        [self superview].userInteractionEnabled = _superViewOriginUserInteractionEnabled;
        if ([self.superview isKindOfClass:[UIScrollView class]])
        {
            @try
            {
                [self.superview removeObserver:self forKeyPath:@"contentInset" context:@"CUActivityIndicatorView"];
            }
            @catch(id anException)
            {
                NSLog(@"warning:%s, %d, removeOberver error!!!", __FILE__, __LINE__);
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentInset"])
    {
        [self setNeedsLayout];
    }
}

- (void)startAnimation
{
    if (!self.window)
    {
        return;
    }
    
    if (_indicator.animationImages)
    {
        [_indicator startAnimating];
        return;
    }
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [_indicator.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endAnimation
{
    if (_indicator.animationImages)
    {
        [_indicator stopAnimating];
        return;
    }
    
    [_indicator.layer removeAnimationForKey:@"rotationAnimation"];
}

@end

static const NSInteger CUViewTagWaitingIndicator = (NSInteger)&CUViewTagWaitingIndicator;

@implementation UIView (CUActivityIndicatorView)

+ (CUActivityIndicatorView *)cu_showWaitingInicator
{
    return [[UIApplication sharedApplication].keyWindow cu_showWaitingInicator];
}

+ (void)cu_dismissWaitingInicator
{
    [[UIApplication sharedApplication].keyWindow cu_dismissWaitingInicator];
}

- (CUActivityIndicatorView *)cu_showWaitingInicator
{
    return [self cu_showWaitingInicatorWithStyle:CUActivityIndicatorStyleOverlay];
}

- (CUActivityIndicatorView *)cu_showWaitingInicatorWithStyle:(CUActivityIndicatorStyle)style
{
    CUActivityIndicatorView *indicatorView = (CUActivityIndicatorView *)[self viewWithTag:CUViewTagWaitingIndicator];
    if (indicatorView)
    {
        [indicatorView removeFromSuperview];
    }
    
    indicatorView = [[CUActivityIndicatorView alloc] init];
    indicatorView.tag = CUViewTagWaitingIndicator;
    indicatorView.style = style;
    [indicatorView showOnView:self];
    
    return indicatorView;
}

- (void)cu_dismissWaitingInicator
{
    CUActivityIndicatorView *waitingIndicatorView = (CUActivityIndicatorView *)[self viewWithTag:CUViewTagWaitingIndicator];
    if (waitingIndicatorView && [waitingIndicatorView isKindOfClass:[CUActivityIndicatorView class]])
    {
        [waitingIndicatorView dismiss];
    }
}

@end
