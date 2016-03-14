//
//  TestViewController.m
//  Example
//
//  Created by czm on 16/3/11.
//  Copyright © 2016年 gaodesoft. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, weak) IBOutlet CUTextField *textField;
@property (nonatomic, weak) IBOutlet CUTextView *textView;
@property (nonatomic, weak) IBOutlet CUControl *control;
@property (nonatomic, weak) IBOutlet CUButton *button;
@property (nonatomic, weak) IBOutlet CUButton *notifyShowTopButton;
@property (nonatomic, weak) IBOutlet CUButton *notifyShowCenterButton;
@property (nonatomic, weak) IBOutlet CUButton *notifyShowBottomButton;
@property (nonatomic, weak) IBOutlet CUButton *alertShowButton;
@property (nonatomic, weak) IBOutlet CUButton *indicatorShowButton;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.cu_hiddenKeyboardWhenTouchBegin = YES;
    self.view.cu_hiddenKeyboardWhenTouchBegin = YES;//hidden keyboard when touch
    
    _textField.text = @"1234567890";
    _textField.placeholder = @"this is placeholder";
//    _textField.placeholderColor = [UIColor redColor];
    _textField.padding = UIEdgeInsetsMake(0, 16, 0, 16);
    _textField.maxLength = 8;
    
    _textView.text = @"CUTextViewAAAA";
    _textView.placeholder = @"this is placeholder";
//    _textView.placeholderColor = [UIColor redColor];
    _textView.borderColor = [UIColor grayColor];
    _textView.editingBorderColor = [UIColor redColor];
    _textView.layer.borderWidth = 1;
    _textView.maxLength = 10;
    
    _control.layer.borderWidth = 2;
    [_control cu_setBackgroundColor:[UIColor grayColor] forUIControlState:UIControlStateNormal];
    [_control cu_setBackgroundColor:[UIColor orangeColor] forUIControlState:UIControlStateHighlighted];
    [_control cu_setBorderColor:[UIColor orangeColor] forUIControlState:UIControlStateNormal];
    [_control cu_setBorderColor:[UIColor grayColor] forUIControlState:UIControlStateHighlighted];
    
    _button.layer.borderWidth = 2;
    [_button cu_setBackgroundColor:[UIColor grayColor] forUIControlState:UIControlStateNormal];
    [_button cu_setBackgroundColor:[UIColor orangeColor] forUIControlState:UIControlStateHighlighted];
    
    [_button cu_setBorderColor:[UIColor orangeColor] forUIControlState:UIControlStateNormal];
    [_button cu_setBorderColor:[UIColor grayColor] forUIControlState:UIControlStateHighlighted];
    
    _notifyShowTopButton.tag = 0;
    _notifyShowCenterButton.tag = 1;
    _notifyShowBottomButton.tag = 2;
    
    [_notifyShowTopButton addTarget:self action:@selector(onNotifyShow:) forControlEvents:UIControlEventTouchUpInside];
    [_notifyShowCenterButton addTarget:self action:@selector(onNotifyShow:) forControlEvents:UIControlEventTouchUpInside];
    [_notifyShowBottomButton addTarget:self action:@selector(onNotifyShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [_alertShowButton addTarget:self action:@selector(onAlertViewShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [_indicatorShowButton addTarget:self action:@selector(onIndicatorShow:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onNotifyShow:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            [self cu_showNotifyOnTop:@"notify top"];
            break;
        case 1:
            [self cu_showNotifyOnCenter:@"notify center"];
            break;
        case 2:
            [self cu_showNotifyOnBottom:@"notify bottom"];
            break;
        default:
            break;
    }
}

- (void)onAlertViewShow:(UIButton *)button
{
//    [self cu_showAlertWithTitle:@"CUAlertView"];
    [self cu_showAlertWithTitle:@"title" msg:@"message" cancelButtonTitle:@"cancel" confirmButtonTitle:@"ok" clickBlock:^(NSInteger index) {
        
    }];
}

- (void)onIndicatorShow:(UIButton *)button
{
    [self.view cu_showWaitingInicator];
     //show on keywindow
//    [UIView cu_showWaitingInicator];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view cu_dismissWaitingInicator];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
