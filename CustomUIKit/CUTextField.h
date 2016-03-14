//
//  CUTextField.h
//  CustomUIKit
//
//  Created by czm on 14-4-11.
//  Copyright (c) 2014年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUTextField : UITextField

@property (nonatomic) UIEdgeInsets padding;                 // default is UIEdgeInsetsZero.
@property (nonatomic) NSUInteger maxLength;                 // Maximum input length, default is 0.

@end

NS_ASSUME_NONNULL_END