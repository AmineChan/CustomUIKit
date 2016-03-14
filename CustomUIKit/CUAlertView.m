//
//  CUAlertView.m
//  CustomUIKit
//
//  Created by czm on 14-4-13.
//  Copyright (c) 2014年 czm. All rights reserved.
//

#import "CUAlertView.h"

#define CUAlertViewHeaderHeight         48
#define CUAlertViewBtnHeight            48
#define CUAlertViewSeparateLineWidth    0.5

#define CUAlertViewTitleFont    [UIFont boldSystemFontOfSize:17.0f]
#define CUAlertViewMsgFont      [UIFont systemFontOfSize:13.0f]

static inline UIImage *CUAlertViewCreateImageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@interface CUAlertAction ()

@property (nonatomic, copy) void(^handler)(CUAlertAction * action);
@property (nonatomic, strong) UIButton *actionButton;

- (UIButton *)createActionButton;

@end

@implementation CUAlertAction

#pragma mark - Initializers
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(CUAlertActionStyle)style handler:(void (^ __nullable)(CUAlertAction *action))handler
{
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(nullable NSString *)title style:(CUAlertActionStyle)style handler:(void (^ __nullable)(CUAlertAction *action))handler
{
    self = [super init];
    if (self)
    {
        _title = title;
        _style = style;
        _handler = handler;
        _enabled = YES;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _enabled = YES;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    if (!_actionButton)
    {
        return;
    }
    
    _actionButton.enabled = enabled;
}

#pragma mark - NSCopying
- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[CUAlertAction allocWithZone:zone] initWithTitle:_title.copy style:_style handler:_handler];
}

- (UIButton *)createActionButton
{
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton setBackgroundImage:CUAlertViewCreateImageWithColor([UIColor whiteColor])forState:UIControlStateNormal];
    [_actionButton setBackgroundImage:CUAlertViewCreateImageWithColor([UIColor colorWithRed:239.0/255.0 green:240.0/255.0 blue:244.0/255.0 alpha:1]) forState:UIControlStateHighlighted];
    
    switch (_style) {
        case CUAlertActionStyleDefault:
            [_actionButton setTitleColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1] forState:UIControlStateNormal];
            break;
        case CUAlertActionStyleCancel:
            [_actionButton setTitleColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1] forState:UIControlStateNormal];
            break;
        case CUAlertActionStyleDestructive:
            [_actionButton setTitleColor:[UIColor colorWithRed:204.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    _actionButton.enabled = _enabled;
    [_actionButton setTitle:_title forState:UIControlStateNormal];
    
    return _actionButton;
}

@end

@interface CUAlertView ()
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *titleView;//title container
@property (nonatomic, strong) UILabel *titleLabel;//title label

@property (nonatomic, strong) UIView *contentView;//message container
@property (nonatomic, strong) UILabel *msgLabel;//message label

@property (nonatomic, strong) UIView *actionView;//action container
@property (nonatomic, strong) NSMutableArray *mutableActions;//actions
@property (nonatomic) BOOL isDismissing;// Whether or not in dismiss animtion
@end

@implementation CUAlertView
- (void)dealloc
{
    _overlayView = nil;
    _title = nil;
    _message = nil;
}

- (void)addAction:(CUAlertAction *)action
{
    [_mutableActions addObject:action];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = screen.size.width - 48.0;
    self = [super initWithFrame:CGRectMake(0, 0, width, CUAlertViewHeaderHeight+CUAlertViewBtnHeight)];
    if (self)
    {
        [self __alertViewSetup];
    }
    
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[CUAlertView alloc] initWithTitle:title message:message];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
    }
    
    return self;
}

- (void)__alertViewSetup
{
    CGRect bounds = self.bounds;
    self.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;

    _mutableActions = [NSMutableArray new];
    
    _titleTextColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    _messageTextColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    
    _messageTextAlignment = NSTextAlignmentCenter;
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self action:@selector(onOverlayViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    //title
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, CUAlertViewHeaderHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:_titleView.bounds];
    _titleLabel.font = CUAlertViewTitleFont;
    _titleLabel.textColor = _titleTextColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = _title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_titleView addSubview:_titleLabel];
    
    //message
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 40)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _msgLabel = [[UILabel alloc] initWithFrame:_contentView.bounds];
    _msgLabel.font = CUAlertViewMsgFont;
    _msgLabel.textColor = _messageTextColor;
    _msgLabel.backgroundColor = [UIColor whiteColor];
    _msgLabel.numberOfLines = 0;
    _msgLabel.text = _message;
    _msgLabel.textAlignment = _messageTextAlignment;
    [_contentView addSubview:_msgLabel];
    
    //action
    _actionView = [[UIView alloc] init];
    [self addSubview:_actionView];
}

- (void)setupActions
{
    for (UIView *view in _actionView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSInteger actionCount = _mutableActions.count;
    CGFloat actionViewWidth = self.bounds.size.width;
    
    if (actionCount == 0)
    {
        return;
    }
    else if (actionCount == 2)
    {
        CGFloat halfActionViewWidth = actionViewWidth/2;
        
        UIButton *leftBtn = [_mutableActions[0] createActionButton];
        leftBtn.frame = CGRectMake(0, CUAlertViewSeparateLineWidth, halfActionViewWidth, CUAlertViewBtnHeight);
        leftBtn.tag = 0;
        [_actionView addSubview:leftBtn];
        
        UIButton *rightBtn = [_mutableActions[1] createActionButton];
        rightBtn.frame = CGRectMake(halfActionViewWidth+CUAlertViewSeparateLineWidth, CUAlertViewSeparateLineWidth, halfActionViewWidth, CUAlertViewBtnHeight);
        rightBtn.tag = 1;
        [_actionView addSubview:rightBtn];
    }
    else
    {
        CGFloat rowHeight = CUAlertViewBtnHeight + CUAlertViewSeparateLineWidth;
        NSInteger index = 0;
        for (CUAlertAction *action in _mutableActions)
        {
            UIButton *btn = [action createActionButton];
            btn.frame = CGRectMake(0, index*rowHeight+CUAlertViewSeparateLineWidth, actionViewWidth, CUAlertViewBtnHeight);
            btn.tag = index ++;
            [_actionView addSubview:btn];
        }
    }
    
    for (UIButton *actionButton in _actionView.subviews)
    {
        [actionButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)preShow
{
    [self setupActions];
    CGRect bounds = self.bounds;
    CGFloat marginLeftRight = 12;
    CGFloat contentWidth = bounds.size.width - 2*marginLeftRight;
    
    CGFloat height = 0;
    CGRect frame;
    
    //title
    if (!_title && !_attributedTitle)
    {
        //when title is nil, use the message as title,
        if (_attributedMessage)
        {
            _attributedTitle = _attributedMessage;
            _attributedMessage = nil;
        }
        else
        {
            _title = _message;
            _message = nil;
        }
    }
    
    if (_attributedTitle)
    {
        _titleLabel.attributedText = _attributedTitle;
    }
    else
    {
        _titleLabel.text = _title;
    }
    
    CGFloat fontHeight = [_msgLabel.font pointSize];
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(contentWidth, FLT_MAX)];
    if (size.height > 2*fontHeight)
    {
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    size.height += 16;
    if (size.height < CUAlertViewHeaderHeight)
    {
        size.height = CUAlertViewHeaderHeight;
    }
    
    frame = _titleView.frame;
    frame.size.height = size.height;
    _titleView.frame = frame;
    
    frame = _titleLabel.frame;
    frame.origin.x = marginLeftRight;
    frame.size.height = size.height;
    frame.size.width = contentWidth;
    _titleLabel.frame = frame;
    
    height += _titleView.frame.size.height;
    
    //message
    if (_attributedMessage)
    {
        _msgLabel.attributedText = _attributedMessage;
    }
    else
    {
        _msgLabel.text = _message;
    }
    
    fontHeight = [_msgLabel.font pointSize];
    size = [_msgLabel sizeThatFits:CGSizeMake(contentWidth, FLT_MAX)];
    if (size.height > 0)
    {
        if (size.height > 2*fontHeight)
        {
            _msgLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        if (size.height < 21)
        {
            size.height = 21;
        }
        
        size.height += 12;
        _contentView.frame = CGRectMake(0, height, bounds.size.width, size.height);
        _msgLabel.frame = CGRectMake(marginLeftRight, 0, contentWidth, size.height-12);
        _contentView.hidden = NO;
    }
    else
    {
        _contentView.hidden = YES;
    }
    
    height += size.height;
    
    NSInteger actionCount = _mutableActions.count;
    CGFloat actionViewHeight = 0;
    if (actionCount == 0)
    {
        actionViewHeight = 0;
    }
    else if (actionCount == 2)
    {
        actionViewHeight = CUAlertViewBtnHeight + CUAlertViewSeparateLineWidth;
    }
    else
    {
        CGFloat rowHeight = CUAlertViewBtnHeight + CUAlertViewSeparateLineWidth;
        actionViewHeight = actionCount * rowHeight;
    }
    
    _actionView.frame = CGRectMake(0, height, bounds.size.width, actionViewHeight);
    height += actionViewHeight;
    
    frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CUAlertView *)show
{
    [self preShow];
    [CUAlertView cancelAll];
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [keywindow endEditing:YES];
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f-40);
    
    [self fadeIn];
    
    return self;
}

- (void)dismiss
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)useAnimation
{
    if (useAnimation)
    {
        if (!_isDismissing)
        {
            [self fadeOut];
        }
    }
    else
    {
        _isDismissing = NO;
        [_overlayView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)btnClicked:(UIButton *)sender
{
    NSInteger index = 0;
    CUAlertAction *currentAction = nil;
    for (CUAlertAction *action in _mutableActions)
    {
        if (sender.tag == index && action.handler)
        {
            currentAction = action;
            action.handler(action);
            break;
        }
        index ++;
    }
    
    if (currentAction && !currentAction.enabled)
    {
        return;
    }
    
    [self dismiss];
}

- (void)onOverlayViewClick
{
    if (_mutableActions.count == 0)
    {
        [self dismiss];
    }
}

#pragma mark - animations
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.alpha = 0;
    _overlayView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        _overlayView.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut
{
    _isDismissing = YES;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0.0;
        _overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        _isDismissing = NO;
        [_overlayView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

+ (void)cancelAll
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    for (UIView *view in keywindow.subviews)
    {
        if ([view isKindOfClass:[CUAlertView class]])
        {
            CUAlertView *alertView = (CUAlertView *)view;
            if (!alertView.isDismissing)
            {
                [alertView dismiss:NO];
            }
        }
    }
}
@end

@implementation NSObject (CUAlertView)

- (CUAlertView *)cu_showAlertWithTitle:(NSString *)title
{
    return [self cu_showAlertWithTitle:title msg:nil buttonTitle:NSLocalizedString(@"kConfirmButtonTitile", @"confirm buttom title")];
}

- (CUAlertView *)cu_showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{
    return [self cu_showAlertWithTitle:title msg:msg buttonTitle:NSLocalizedString(@"kConfirmButtonTitile", @"confirm buttom title")];
}

- (CUAlertView *)cu_showAlertWithTitle:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle
{
    CUAlertView *alert = [[CUAlertView alloc] initWithTitle:title message:msg];
    if (btnTitle)
    {
        CUAlertAction *cancelAction = [CUAlertAction actionWithTitle:btnTitle style:CUAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
    }
    
    return [alert show];
}

- (CUAlertView *)cu_showAlertWithTitle:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle clickBlock:(void (^)(NSInteger index))clickBlock
{
    CUAlertView *alert = [[CUAlertView alloc] initWithTitle:title message:msg];
    
    if (cancelButtonTitle)
    {
        CUAlertAction *cancelAction = [CUAlertAction actionWithTitle:cancelButtonTitle style:CUAlertActionStyleCancel handler:^(CUAlertAction *action) {
            if (clickBlock)
            {
                clickBlock(0);
            }
        }];
        [alert addAction:cancelAction];
    }
    
    if (confirmButtonTitle)
    {
        CUAlertAction *confirmAction = [CUAlertAction actionWithTitle:confirmButtonTitle style:CUAlertActionStyleDestructive handler:^(CUAlertAction *action) {
            if (clickBlock)
            {
                clickBlock(1);
            }
        }];
        [alert addAction:confirmAction];
    }
    
    return [alert show];
}

@end