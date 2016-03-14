//
//  CUActivityIndicatorView.h
//  CustomUIKit
//
//  Created by czm on 15-8-5.
//  Copyright (c) 2015年 czm. All rights reserved.
////

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CUActivityIndicatorStyle) {
    CUActivityIndicatorStyleOverlay,
    CUActivityIndicatorStyleEmbed,
};

@interface CUActivityIndicatorView : UIView
@property (nonatomic) CUActivityIndicatorStyle style;//default is CUActivityIndicatorStyleOverlay
@property (nonatomic, strong, nullable) UIImage *loadingImage UI_APPEARANCE_SELECTOR;//defalut is nil
@property (nonatomic, strong, nullable) NSArray *loadingImageArray UI_APPEARANCE_SELECTOR;//defalut is nil

- (void)showOnKeywindow;
- (void)showOnView:(UIView *)onView;

- (void)dismiss;

@end

@interface UIView (CUActivityIndicatorView)

+ (CUActivityIndicatorView *)cu_showWaitingInicator;//show on keywindow
+ (void)cu_dismissWaitingInicator;//dismiss on keywindow

- (CUActivityIndicatorView *)cu_showWaitingInicator;
- (CUActivityIndicatorView *)cu_showWaitingInicatorWithStyle:(CUActivityIndicatorStyle)style;
- (void)cu_dismissWaitingInicator;

@end

NS_ASSUME_NONNULL_END
