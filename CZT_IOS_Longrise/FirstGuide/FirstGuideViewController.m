//
//  FirstGuideViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/12/28.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "FirstGuideViewController.h"
#import "AppDelegate.h"
@interface FirstGuideViewController ()

@end

@implementation FirstGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
