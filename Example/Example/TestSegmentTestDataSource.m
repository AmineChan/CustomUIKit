//
//  TestSegmentTestDataSource.m
//  CustomUIKit
//
//  Created by czm on 15/11/24.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "TestSegmentTestDataSource.h"
#import "ViewController.h"

@interface TestSegmentTestDataSource ()
@end
@implementation TestSegmentTestDataSource
- (void)dealloc
{

}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (void)cu_segmentedViewControllerDidLoad:(CUSegmentedViewController *)viewController
{
    viewController.navigationItem.title = @"TestSegment";
}

- (void)cu_segmentedViewController:(CUSegmentedViewController *)viewController didSelectAtIndex:(NSUInteger)index
{
    
}

- (NSArray *)cu_pagesInSegmentedViewController:(CUSegmentedViewController *)viewController
{
    NSMutableArray *pages = [NSMutableArray new];
    for (int i = 1; i < 4; i++)
    {
        ViewController *vc = (ViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.title = @(i).stringValue;
        [vc.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        
//        UIViewController *vc = [[UIViewController alloc] init];
//        [vc.view setBackgroundColor:[UIColor colorWithHue:((i/8)%20)/20.0+0.02 saturation:(i%8+3)/10.0 brightness:91/100.0 alpha:1]];
        [pages addObject:vc];
    }
    
    return pages;
}


@end
