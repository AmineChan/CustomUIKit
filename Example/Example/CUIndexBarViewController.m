//
//  CUIndexBarViewController.m
//  Example
//
//  Created by czm on 16/3/11.
//  Copyright © 2016年 gaodesoft. All rights reserved.
//

#import "CUIndexBarViewController.h"

@interface CUIndexBarViewController ()<CUIndexBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet CUIndexBar *indexBar;
@property (nonatomic, strong) NSArray *indexs;

@end

@implementation CUIndexBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CUIndexBar";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _indexs = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
    _indexBar.delegate = self;
    _indexBar.backgroundColor = [UIColor clearColor];
    [_indexBar setIndexes:_indexs];
    _indexBar.tableView = _tableView;
    _indexBar.textFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];// HelveticaNeue Bold 11pt is a font of native table index
    
    //    id topGuide = self.topLayoutGuide;
    //    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (_indexBar, topGuide);
    //    NSString *vfl = @"V:[topGuide]-20-[_indexBar]-20-|";
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: vfl
    //                                                                      options: 0
    //                                                                      metrics: nil
    //                                                                        views: viewsDictionary]];
    //
    //    vfl = @"H:[_indexBar(28)]-10-|";
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: vfl
    //                                                                      options: 0
    //                                                                      metrics: nil
    //                                                                        views: viewsDictionary]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexs[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    return cell;
}

#pragma mark -
#pragma mark CMIndexBarDelegate
#pragma mark
- (void)indexSelectionDidChange:(CUIndexBar *)indexBar index:(NSInteger)index title:(NSString*)title
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:NO];
}

@end
