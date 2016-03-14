//
//  CUIndexBar.h
//  CustomUIKit
//
//  Created by czm on 15/11/30.
//  Copyright © 2015年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CUIndexBarDelegate;

@interface CUIndexBar : UIControl

@property (nonatomic, weak) id<CUIndexBarDelegate> delegate;
@property (nonatomic, strong, nullable) UIColor *highlightedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) UIColor *selectedTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong, nullable) UIFont *selectedTextFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, readonly) UILabel *bigIndexLabel;

@property (nonatomic, weak, nullable) UITableView *tableView;

- (void)setIndexes:(nullable NSArray *)indexes;
- (void)clearIndex;

@end

@protocol CUIndexBarDelegate<NSObject>
@optional
- (void)indexSelectionDidChange:(CUIndexBar *)indexBar index:(NSInteger)index title:(NSString*)title;
- (void)indexSelectionDidEndDragging:(CUIndexBar *)indexBar;

@end

NS_ASSUME_NONNULL_END