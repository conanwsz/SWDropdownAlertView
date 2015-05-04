//
//  ViewController.m
//  SWDropdownAlertView
//
//  Created by 汪顺舟 on 3/11/15.
//  Copyright (c) 2015 HXQC. All rights reserved.
//

#import "ViewController.h"
#import "SWDropdownAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showAlertView:(id)sender{
    SWDropdownAlertView *alertView = [SWDropdownAlertView alertViewWithMessage:@"这是测试" withType:SWDropdownAlertViewTypeDone];
    [alertView showWithDuration:2];
}

- (IBAction)showWarning:(id)sender{
    SWDropdownAlertView *alertView = [SWDropdownAlertView alertViewWithMessage:@"这是警告" withType:SWDropdownAlertViewTypeWarning];
    [alertView show];
}

- (IBAction)showError:(id)sender{
    SWDropdownAlertView *alertView = [SWDropdownAlertView alertViewWithMessage:@"这是错误" withType:SWDropdownAlertViewTypeError];
    [alertView show];
}
@end
