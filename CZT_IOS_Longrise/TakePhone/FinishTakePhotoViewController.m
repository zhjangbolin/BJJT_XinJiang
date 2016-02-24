//
//  FinishTakePhotoViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/19.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "FinishTakePhotoViewController.h"
#import "GoResponseViewController.h"
#import "AppDelegate.h"

@interface FinishTakePhotoViewController ()

@end

@implementation FinishTakePhotoViewController

- (void)viewDidLoad
{
    self.title = @"温馨提示";
    [super viewDidLoad];
    //设置navigationBar的背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:61/255.0 green:166/255.0 blue:244/255.0 alpha:1];
    
    NSArray *array = self.navigationController.viewControllers;
    if(array.count > 1)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 45, 30);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //图标
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_back"]];
        imageView.frame = CGRectMake(10, 0, 30, 30);
        [button addSubview:imageView];
        
        // 调整 leftBarButtonItem 在 iOS7 下面的位置
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0))
            
        {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil action:nil];
            negativeSpacer.width = -20;//这个数值可以根据情况自由变化
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
        }
        else
        {
            self.navigationItem.leftBarButtonItem = backItem;
        }
    }
    
    
    [self.okBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.layer.cornerRadius = 3;
    self.okBtn.layer.masksToBounds = YES;
    [AppDelegate storyBoradAutoLay:self.view];
}

#pragma mark 点击回调函数
-(void)onClick:(UIButton *)btn
{
    //取证完成通知
    NSString *name = NotificationNameForOneStepFinish;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"1" forKey:@"dealCaseStep"];
    [center postNotificationName:name object:nil userInfo:dic];
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [self.navigationController popToViewController:[navigationArray objectAtIndex:1] animated:YES];
}

-(void)btnClicked:(UIButton *)sender{
    GoResponseViewController *GRVC = [[GoResponseViewController alloc]init];
    GRVC.appcaseno = _appcaseno;
    GRVC.type = _type;
    [self.navigationController pushViewController:GRVC animated:YES];
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
