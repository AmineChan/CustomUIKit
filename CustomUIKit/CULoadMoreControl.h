//
//  CULoadMoreControl.h
//  CustomUIKit
//
//  Created by apple on 15-08-04.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//#define CULoadMoreControlAutoLoad //默认不使用自动加载

typedef NS_ENUM(NSInteger, CULoadMoreControlState) {
    CULoadMoreControlStateNormal = 0,
    CULoadMoreControlStateLoading,
    CULoadMoreControlStateDone,// all data has been loaded
    CULoadMoreControlStateNoResult,//no data
    CULoadMoreControlStateFailed,
};

@protocol CULoadMoreControlDelegate;
@interface CULoadMoreControl : UIControl
{
    CULoadMoreControlState _loadMoreState;
    UILabel *_statusLabel;
    UIActivityIndicatorView *_activityView;
    __weak UITableView *_tableView;
}

@property(nonatomic, weak) id<CULoadMoreControlDelegate> delegate;
@property(nonatomic) BOOL enableLoadMore;//default is YES
@property(nonatomic, readonly) CULoadMoreControlState loadMoreState;//the initial is CULoadMoreControlStateNormal

- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView andHeight:(CGFloat)height;

- (void)setTitle:(nullable NSString *)title forState:(CULoadMoreControlState)state;

- (void)startLoading;
- (void)finishedLoading;//finish current load
- (void)loadFailed;
- (void)loadDone;//all data has been loaded
- (void)noResult;//no data

- (void)resetLoadMore;
@end

@protocol CULoadMoreControlDelegate <NSObject>

@required
- (void)cu_loadMoreControlBeginLoading;

@end

NS_ASSUME_NONNULL_END
