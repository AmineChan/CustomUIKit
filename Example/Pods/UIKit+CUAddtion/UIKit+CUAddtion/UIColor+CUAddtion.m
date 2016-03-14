//
//  UIColor+CUAddtion.m
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import "UIColor+CUAddtion.h"

@implementation UIColor (CUAddtion)

+ (UIColor *)cu_colorWithHex:(NSInteger)rgbHexValue
{
    return [UIColor colorWithRed:((rgbHexValue>>16)&0xFF)/255.0
                           green:((rgbHexValue>>8)&0xFF)/255.0
                            blue:(rgbHexValue&0xFF)/255.0
                           alpha:1.0];
}

+ (UIColor *)cu_colorWithHex:(NSInteger)rgbHexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((rgbHexValue>>16)&0xFF)/255.0
                           green:((rgbHexValue>>8)&0xFF)/255.0
                            blue:(rgbHexValue&0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)cu_colorWithHexString:(NSString *)hexStr
{
    NSMutableString *tempHex = [[NSMutableString alloc] init];
    [tempHex appendString:hexStr];
   
    unsigned colorInt = 0;
    [[NSScanner scannerWithString:tempHex] scanHexInt:&colorInt];
    
    return [UIColor cu_colorWithHex:colorInt];
}

@end
