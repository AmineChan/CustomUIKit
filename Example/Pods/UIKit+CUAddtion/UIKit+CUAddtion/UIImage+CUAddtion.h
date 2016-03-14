//
//  UIImage+CUAddtion.h
//  CustomUIKit
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CUAddtion)

/**
 *  create image from UIColor
 */
+ (UIImage *)cu_createImageWithColor:(UIColor *)color;

/**
 *  create RoundedRect image from image
 */
+ (UIImage *)cu_createRoundedRectImage:(UIImage *)image size:(CGSize)imageNewSize radius:(NSInteger)radius;

/**
 * gray image
 */
- (UIImage *)cu_grayImage;

/**
 *  transform size to newSize
 */
- (UIImage *)cu_transformToSize:(CGSize)newSize;

/**
 *  fix device orientation
 */
- (UIImage *)cu_fixOrientation;

@end
