//
//  UIPageControl+CUAddtion.h
//  Pods
//
//  Created by czm on 16/3/14.
//
//

#import <UIKit/UIKit.h>

@interface UIPageControl (CUAddtion)

@property (nonatomic, setter=cu_setPageIndicatorRadius:) CGFloat cu_pageIndicatorRadius;//dot radius， default is 0, if <=0 do nothing

@end
