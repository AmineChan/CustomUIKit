//
//  CUControl.h
//  CustomUIKit
//
//  Created by czm on 15/11/17.
//  Copyright © 2015年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUControl : UIControl

- (void)cu_setBackgroundColor:(UIColor *)color forUIControlState:(UIControlState)state;
- (void)cu_setBorderColor:(UIColor *)color forUIControlState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END