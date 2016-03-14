//
//  CUButton.h
//  Example
//
//  Created by czm on 15/12/7.
//  Copyright © 2015年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUButton : UIButton

- (void)cu_setBackgroundColor:(UIColor *)color forUIControlState:(UIControlState)state;
- (void)cu_setBorderColor:(UIColor *)color forUIControlState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
