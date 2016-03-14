//
//  CUSegmentedViewController.h
//  CustomUIKit
//
//  Created by czm on 15/11/23.
//  Copyright © 2015年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@class CUSegmentedViewController;
@protocol CUSegmentedViewControllerDelegate <NSObject>

@required
- (void)cu_segmentedViewControllerDidLoad:(CUSegmentedViewController *)viewController;
- (void)cu_segmentedViewController:(CUSegmentedViewController *)viewController didSelectAtIndex:(NSUInteger)index;

@end

@protocol CUSegmentedViewControllerDataSource <NSObject>

@required
- (NSArray<UIViewController *> *)cu_pagesInSegmentedViewController:(CUSegmentedViewController *)viewController;

@end

@interface CUSegmentedViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, readonly) UIPageViewController *pageViewController;
@property (nonatomic, readonly) HMSegmentedControl *segmentedControl;
@property (nonatomic, readonly) UIView *containerView;

@property (nonatomic, strong, nullable) id<CUSegmentedViewControllerDelegate> delegate;
@property (nonatomic, strong, nullable) id<CUSegmentedViewControllerDataSource> dataSource;

@property (nonatomic) CGFloat segmentedControlHeight;//default is 40.0f

- (void)setSegmentedControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END