//
//  CULoadMoreControlViewController.m
//  Example
//
//  Created by czm on 16/3/11.
//  Copyright © 2016年 gaodesoft. All rights reserved.
//

#import "CULoadMoreControlViewController.h"

@interface CULoadMoreControlViewController ()<CULoadMoreControlDelegate>

@property (nonatomic, strong) CULoadMoreControl *loadMoreControl;

@end

@implementation CULoadMoreControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loadMoreControl = [[CULoadMoreControl alloc] initWithTableView:self.tableView];
    _loadMoreControl.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cu_loadMoreControlBeginLoading
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_loadMoreControl finishedLoading];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_loadMoreControl loadFailed];
//    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

@end
