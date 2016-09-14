//
//  CUPopoverView.h
//  CustomUIKit
//
//  Created by czm on 15-9-2.
//  Copyright (c) 2015年 czm. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CUPopoverView : UIView
- (void)setOnDismissBlock:(void (^)(void))onDismissBlock;

- (void)show;
- (void)dismiss;

@end
