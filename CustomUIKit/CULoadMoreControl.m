//
//  CULoadMoreControl.m
//  CustomUIKit
//
//  Created by apple on 15-08-04.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import "CULoadMoreControl.h"

static CGFloat kCULoadMoreControlHeight = 40.0f;

@interface CULoadMoreControl ()
{
    NSMutableDictionary *_titleStateDic;
    BOOL _dragging;
}

@end

@implementation CULoadMoreControl
@synthesize loadMoreState = _loadMoreState;

- (void)dealloc
{
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    return [self initWithTableView:tableView andHeight:kCULoadMoreControlHeight];
}

- (instancetype)initWithTableView:(UITableView *)tableView andHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)];
    if (self)
    {
        _tableView = tableView;
        self.backgroundColor = tableView.backgroundColor;
        [self __loadMoreControlSetup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self __loadMoreControlSetup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __loadMoreControlSetup];
    }
    
    return self;
}

- (void)__loadMoreControlSetup
{
    [self setEnableLoadMore:YES];

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:label];
    _statusLabel=label;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view startAnimating];
    [self addSubview:view];
    _activityView = view;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (_statusLabel, _activityView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_statusLabel]|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_statusLabel(>=60)]"
                                                                 options:NSLayoutFormatAlignAllCenterX
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_activityView]-|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_activityView]-8-[_statusLabel]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    _titleStateDic = [NSMutableDictionary dictionary];
    _titleStateDic[@(CULoadMoreControlStateNormal)] = @"点击加载更多";
    _titleStateDic[@(CULoadMoreControlStateLoading)] = @"正在加载";
    _titleStateDic[@(CULoadMoreControlStateDone)] = @"没有更多了";
    _titleStateDic[@(CULoadMoreControlStateNoResult)] = @"没有数据";
    _titleStateDic[@(CULoadMoreControlStateFailed)] = @"加载失败，点击重试";
    
    [self setLoadMoreState:CULoadMoreControlStateNormal];
}

- (void)setTitle:(nullable NSString *)title forState:(CULoadMoreControlState)state
{
    _titleStateDic[@(state)] = title;
}

- (NSString *)titleForState:(CULoadMoreControlState)state
{
    return _titleStateDic[@(state)];
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore
{
    _enableLoadMore = enableLoadMore;
    if (!_tableView)
    {
        return;
    }
    
    if (enableLoadMore)
    {
        _tableView.tableFooterView = self;
    }
    else
    {
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (void)setLoadMoreState:(CULoadMoreControlState)loadMoreState
{
    switch (loadMoreState)
    {
        case CULoadMoreControlStateNormal:
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
            _statusLabel.text = _titleStateDic[@(CULoadMoreControlStateNormal)];
            [_activityView stopAnimating];
            break;
        case CULoadMoreControlStateLoading:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
            _statusLabel.text = _titleStateDic[@(CULoadMoreControlStateLoading)];
            [_activityView startAnimating];
            break;
        case CULoadMoreControlStateDone:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
            _statusLabel.text = _titleStateDic[@(CULoadMoreControlStateDone)];
            [_activityView stopAnimating];
            break;
        case CULoadMoreControlStateNoResult:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
            _statusLabel.text = _titleStateDic[@(CULoadMoreControlStateNoResult)];
            [_activityView stopAnimating];
            break;
        case CULoadMoreControlStateFailed:
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
            _statusLabel.text = _titleStateDic[@(CULoadMoreControlStateFailed)];
            [_activityView stopAnimating];
            break;
        default:
            break;
    }
    
    _loadMoreState = loadMoreState;
}

#pragma mark -
#pragma mark public
#pragma mark
- (void)startLoading
{
    [self setLoadMoreState:CULoadMoreControlStateLoading];
}

- (void)finishedLoading
{
    [self setLoadMoreState:CULoadMoreControlStateNormal];
}

- (void)loadFailed
{
    [self setLoadMoreState:CULoadMoreControlStateFailed];
}

- (void)loadDone
{
    [self setLoadMoreState:CULoadMoreControlStateDone];
}

- (void)noResult
{
    [self setLoadMoreState:CULoadMoreControlStateNoResult];
}

- (void)resetLoadMore
{
    [self setLoadMoreState:CULoadMoreControlStateNormal];
}

#pragma mark -
#pragma mark inner
#pragma mark
- (void)realCallDelegateToLoadMore
{
    if ([_delegate respondsToSelector:@selector(cu_loadMoreControlBeginLoading)])
    {
        [self setLoadMoreState:CULoadMoreControlStateLoading];
        [_delegate cu_loadMoreControlBeginLoading];
    }
}

- (void)callDelegateToLoadMore
{
    if (_loadMoreState != CULoadMoreControlStateNormal
        && _loadMoreState != CULoadMoreControlStateFailed)
    {
        return;
    }
    
    if (_delegate)
    {
        [self realCallDelegateToLoadMore];
    }
}

#ifdef CULoadMoreControlAutoLoad
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window)
    {
        if (_tableView && [_tableView isKindOfClass:[UIScrollView class]])
        {
            [_tableView addObserver:self
                         forKeyPath:@"contentOffset"
                            options:NSKeyValueObservingOptionNew
                            context:@"CULoadMoreControl"];
        }
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (!newWindow)
    {
        if (_tableView)
        {
            @try
            {
                [_tableView removeObserver:self forKeyPath:@"contentInset" context:@"CULoadMoreControl"];
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
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        UIScrollView *scrollView = (UIScrollView *)object;
        if (_dragging != scrollView.dragging)
        {
            if (!scrollView.dragging)
            {
                [self scrollViewDidEndDragging:scrollView willDecelerate:NO];
            }
            else
            {
                [self scrollViewWillBeginDragging:scrollView];
            }
            
            _dragging = scrollView.dragging;
        }
        
        [self scrollViewDidScroll:scrollView];
    }
}

- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView
{
    CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
    
    CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
    CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight;
    CGFloat normalizedOffset = scrollAreaContenHeight -scrolledDistance;
    
    return normalizedOffset;
}

- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView
{
    return (scrollView.bounds.size.height - MIN(scrollView.bounds.size.height, scrollView.contentSize.height));
}

static CGFloat kCULoadMoreControlStartY = 0;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
    if (_loadMoreState == CULoadMoreControlStateNormal)
    {
        if (kCULoadMoreControlStartY < scrollView.contentOffset.y //只有上拉时才请求
            && [self visibleTableHeightDiffWithBoundsHeight:scrollView] <= 0
            && bottomOffset < kCULoadMoreControlHeight+10)
        {
            [self callDelegateToLoadMore];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    kCULoadMoreControlStartY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

#endif

@end
