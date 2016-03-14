//
//  CUAlertView.h
//  CustomUIKit
//
//  Created by czm on 14-4-13.
//  Copyright (c) 2014年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CUAlertActionStyle) {
    CUAlertActionStyleDefault = 0,
    CUAlertActionStyleCancel,
    CUAlertActionStyleDestructive
};

@interface CUAlertAction : NSObject<NSCopying>

@property (nonatomic, readonly, nullable) NSString *title;
@property (nonatomic, readonly) CUAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;// default is YES
@property (nonatomic, readonly) UIButton *actionButton;

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(CUAlertActionStyle)style handler:(void (^ __nullable)( CUAlertAction *action))handler;

@end

@interface CUAlertView : UIView
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *message;

@property (nonatomic, copy, nullable) NSAttributedString *attributedTitle;
@property (nonatomic, copy, nullable) NSAttributedString *attributedMessage;

@property (nonatomic, strong) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSTextAlignment messageTextAlignment;//default is NSTextAlignmentCenter

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (id)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(CUAlertAction *)action;

- (CUAlertView *)show;
- (void)dismiss;

+ (void)cancelAll;

@end

@interface NSObject (CUAlertView)

- (CUAlertView *)cu_showAlertWithTitle:(nullable NSString *)title;
- (CUAlertView *)cu_showAlertWithTitle:(nullable NSString *)title msg:(nullable NSString *)msg;
- (CUAlertView *)cu_showAlertWithTitle:(nullable NSString *)title msg:(nullable NSString *)msg buttonTitle:(nullable NSString *)btnTitle;
- (CUAlertView *)cu_showAlertWithTitle:(nullable NSString *)title msg:(nullable NSString *)msg cancelButtonTitle:(nullable NSString *)cancelButtonTitle confirmButtonTitle:(nullable NSString *)confirmButtonTitle clickBlock:(void (^__nullable)(NSInteger index))clickBlock;

@end

NS_ASSUME_NONNULL_END