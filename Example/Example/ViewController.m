//
//  ViewController.m
//  CustomUIKit
//
//  Created by czm on 15/11/15.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "ViewController.h"
#import "TestSegmentTestDataSource.h"
#import "CUIndexBarViewController.h"
#import "TestViewController.h"
#import "CULoadMoreControlViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.cu_hiddenKeyboardWhenTouchBegin = YES;
    _dataArray = @[@"CUTextField/CUTextView/CUTextView/CUControl/CUButton/CUNotifyView/CUAlertView/CUPopoverListView/CUActivityIndicatorView",
                   @"CULoadMoreControl",
                   @"CUSegmentedViewController",
                   @"CUIndexBar",];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIndenditify"];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UITableView Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndenditify = @"cellIndenditify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenditify forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenditify];
    }
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *data = _dataArray[indexPath.row];
    if ([data containsString:@"CUTextField"])
    {
        TestViewController *vc = (TestViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isEqualToString:@"CULoadMoreControl"])
    {
        CULoadMoreControlViewController *vc = [CULoadMoreControlViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isEqualToString:@"CUSegmentedViewController"])
    {
        TestSegmentTestDataSource *ds = [[TestSegmentTestDataSource alloc] init];
        CUSegmentedViewController *segmentedViewController = [[CUSegmentedViewController alloc] init];
        segmentedViewController.dataSource = ds;
        segmentedViewController.delegate = ds;
        segmentedViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:segmentedViewController animated:YES];
    }
    else if ([data isEqualToString:@"CUIndexBar"])
    {
        CUIndexBarViewController *vc = (CUIndexBarViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CUIndexBarViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
