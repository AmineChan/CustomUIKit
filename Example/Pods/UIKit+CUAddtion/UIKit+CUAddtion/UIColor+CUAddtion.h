//
//  UIColor+CUAddtion.h
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define HEXCOLOR(c)             [UIColor cu_colorWithHex:(c)]
#define HEXACOLOR(c, a)         [UIColor cu_colorWithHex:(c) alpha:(a)]

@interface UIColor (CUAddtion)

/**
 *  example:
        [UIColor cu_colorWithHex:0xff0000]
 */
+ (UIColor *)cu_colorWithHex:(NSInteger)rgbHexValue;

/**
 *  example:
        [UIColor cu_colorWithHex:0xff0000 alpha:1]
 */
+ (UIColor *)cu_colorWithHex:(NSInteger)rgbHexValue alpha:(CGFloat)alpha;

/**
 * example:
        [UIColor cu_colorWithHexString:@"0xffffff"]
 */
+ (UIColor *)cu_colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END