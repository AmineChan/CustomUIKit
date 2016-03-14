//
//  CUTextView.h
//  CustomUIKit
//
//  Created by czm on 14-4-11.
//  Copyright (c) 2014年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUTextView : UITextView

@property (nonatomic, strong, nullable) NSString *placeholder;      //default is nil.
@property (nonatomic, strong) UIColor *placeholderColor;            // default [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1].
@property (nonatomic, strong, nullable) UIColor *borderColor;       //normal border color, default is nil.
@property (nonatomic, strong, nullable) UIColor *editingBorderColor;//edit border color, default is nil.
@property (nonatomic) NSUInteger maxLength;                         //Maximum input length, default is 0.

@end

NS_ASSUME_NONNULL_END