//
//  CUNotifyView.h
//  CustomUIKit
//
//  Created by czm on 15-8-24.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CUNotifyStyle) {
    CUNotifyStyleTop = 0,
    CUNotifyStyleCenter,
    CUNotifyStyleBottom,
};

@interface CUNotifyView : UIView

- (void)showWithMessage:(nullable NSString *)msg style:(CUNotifyStyle)style duration:(NSTimeInterval)duration;
- (void)dismiss;// defalut use animation
- (void)dismiss:(BOOL)useAnimation;

@end

@interface NSObject (CUNotifyView)

- (void)cu_showNotifyOnTop:(nullable NSString *)msg;
- (void)cu_showNotifyOnCenter:(nullable NSString *)msg;
- (void)cu_showNotifyOnBottom:(nullable NSString *)msg;
- (void)cu_showNotify:(nullable NSString *)msg style:(CUNotifyStyle)style duration:(NSTimeInterval)duration;
- (void)cu_dismissNotify;//defalut use animation
- (void)cu_dismissNotify:(BOOL)useAnimation;

@end

NS_ASSUME_NONNULL_END