//
//  UINavigationController+CUAddtion.h
//  CustomUIKit
//
//  Created by czm on 15/11/17.
//  Copyright © 2015年 gaodesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CUAddtion)

/**
 *  退回到的目的viewController，如果viewController为空或者不在导航栈中则没有效果
 *
 *  @param vc       目的viewController
 *  @param animated 使用使用动画
 */
- (void)cu_popToDestViewController:(UIViewController *)vc withAnimated:(BOOL)animated;

@end
