//
//  CUSegmentedViewController.m
//  CustomUIKit
//
//  Created by czm on 15/11/23.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "CUSegmentedViewController.h"

@interface CUSegmentedViewController ()
{
    UIPageViewController *_pageViewController;
    HMSegmentedControl *_segmentedControl;
    UIView *_containerView;
    NSLayoutConstraint *_segmentedControlHeightConstraint;
    NSArray<UIViewController *> *_pages;
}
@end

@implementation CUSegmentedViewController
@synthesize pageViewController = _pageViewController;
@synthesize segmentedControl = _segmentedControl;
@synthesize containerView = containerView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
    _dataSource = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self __segmentedViewControllerDefaultInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self __segmentedViewControllerDefaultInit];
    }
    
    return self;
}

- (void)__segmentedViewControllerDefaultInit
{
    _segmentedControlHeight = 40.0f;
    
    _segmentedControl = [[HMSegmentedControl alloc] init];
    _segmentedControl.backgroundColor = [UIColor redColor];
    [_segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0],
                                              NSFontAttributeName: [UIFont systemFontOfSize:16]};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]};
    _segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:185.0/255.0 green:0.0 blue:1.0/255.0 alpha:1.0];
    
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.verticalDividerEnabled = YES;
    _segmentedControl.verticalDividerColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [_segmentedControl setSelectionIndicatorHeight:2.0f];
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    
    _containerView = [[UIView alloc] init];
    [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewController setDataSource:self];
    [_pageViewController setDelegate:self];
    [_pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self __segmentedViewControllerSetupInitUI];
    [self reloadData];
    
    if (_delegate)
    {
        [_delegate cu_segmentedViewControllerDidLoad:self];
    }
}

- (void)__segmentedViewControllerSetupInitUI
{
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_segmentedControl];
    [self.view addSubview:_containerView];
    
    _pageViewController.view.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    _pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:_pageViewController];
    [_containerView addSubview:_pageViewController.view];
    
    id topGuide = self.topLayoutGuide;
    id bottomGuide = self.bottomLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_segmentedControl, _containerView, topGuide, bottomGuide);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-0-[_segmentedControl]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_segmentedControl]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    _segmentedControlHeightConstraint = [NSLayoutConstraint constraintWithItem:_segmentedControl
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:_segmentedControlHeight];
    [self.view addConstraint:_segmentedControlHeightConstraint];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_segmentedControl]-0-[_containerView]-0-[bottomGuide]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_containerView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    //底部横线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor grayColor];
    bottomLine.alpha = .4;
    [bottomLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_segmentedControl addSubview:bottomLine];
    
    NSDictionary *bottomLineViewsDictionary = NSDictionaryOfVariableBindings(bottomLine);
    [_segmentedControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:bottomLineViewsDictionary]];
    [_segmentedControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(0.75)]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:bottomLineViewsDictionary]];
    
    [_segmentedControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_pages count] > 0)
    {
        [self setSelectedPageIndex:[_segmentedControl selectedSegmentIndex] animated:animated];
    }
}

- (void)setupPages
{
    if (_dataSource)
    {
        _pages = [_dataSource cu_pagesInSegmentedViewController:self];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (!parent)
    {
        //must be set to nil, because this property is strong
        _delegate = nil;
        _dataSource = nil;
    }
}

#pragma mark - Setup
- (void)updateTitleLabels
{
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in _pages)
    {
        [titles addObject:vc.title ? vc.title : @""];
    }
    
    [_segmentedControl setSectionTitles:[titles copy]];
}

- (void)setSegmentedControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    _segmentedControlHeightConstraint.constant = hidden? 0:_segmentedControlHeight;
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        _segmentedControl.alpha = hidden ? 0.0f : 1.0f;
    }];
    
    [_segmentedControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    return _pages[[_segmentedControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index < [_pages count])
    {
        [_segmentedControl setSelectedSegmentIndex:index animated:YES];
        [_pageViewController setViewControllers:@[_pages[index]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:animated
                                     completion:NULL];
    }
}

- (void)reloadData
{
    [self setupPages];
    [self updateTitleLabels];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [_pages indexOfObject:viewController];
    if ((index == NSNotFound) || (index == 0))
    {
        return nil;
    }
    
    return _pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [_pages indexOfObject:viewController];
    if ((index == NSNotFound)||(index+1 >= [_pages count]))
    {
        return nil;
    }
    
    return _pages[++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    
    NSUInteger index = [_pages indexOfObject:[pageViewController.viewControllers lastObject]];
    [_segmentedControl setSelectedSegmentIndex:index animated:YES];
    if (_delegate)
    {
        [_delegate cu_segmentedViewController:self didSelectAtIndex:index];
    }
}

#pragma mark - Callback
- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [_segmentedControl selectedSegmentIndex] > [_pages indexOfObject:[_pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    if (_delegate)
    {
        [_delegate cu_segmentedViewController:self didSelectAtIndex:[_segmentedControl selectedSegmentIndex]];
    }
    
    [_pageViewController setViewControllers:@[[self selectedController]]
                                  direction:direction
                                   animated:YES
                                 completion:^(BOOL finished){
                                     
                                 }];
}

@end
