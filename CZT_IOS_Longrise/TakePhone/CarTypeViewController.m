//
//  CarTypeViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/19.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "CarTypeViewController.h"

@interface CarTypeViewController ()

@end

@implementation CarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"现场拍照"];
    // Do any additional setup after loading the view.
}

//=================将通用的方法全部放在父类中实现======================
#pragma mark 发送数据
-(void)sendPhoneInfo:(NSMutableDictionary *)dic
{
    if(nil == dic)
    {
        return;
    }
    
    //临时变量，发送失败时重写发送用到
    tempDic = dic;
    _type = dic[@"acctype"]; //事故类型
    hud = [[FVCustomAlertView alloc] init];
    [hud showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
    [self.view addSubview:hud];
    NSString *tempStr = kckpxjapprest;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[tempStr stringByAppendingString:@"/xjsubmitcaseimageinfor"] params:tempDic httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        [self loadFinish:result];
        if(nil != hud)
        {
            [hud dismiss];
        }
    }];
}

#pragma mark 数据加载完成
-(void)loadFinish:(id)result
{
    NSString *string = nil;
    if(nil == result)
    {
        string = @"数据加载失败,请检查网络。";
    }
    else
    {
        NSDictionary *dic = result;
        
        NSString *restate = [dic objectForKey:@"restate"];
        if([@"0" isEqualToString:restate])
        {
            //成功
            return;
        }
        else
        {
            //失败
            string = (NSString *)[dic objectForKey:@"redes"];
        }
    }
    
    alert1 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alert1 show];
}

#pragma mark 调用拍照
-(id)takePhone:(NSString *)mark
{
    return nil;
}

#pragma mark 对话框回调方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alert1 == alertView)
    {
        if(buttonIndex == 1)
        {
            [self sendPhoneInfo:tempDic];
        }
    }
}

#pragma mark 取证完成
-(void)zdsubmitcaseimageisover:(NSMutableDictionary *)dic
{
    if(nil == hud)
    {
        hud = [[FVCustomAlertView alloc] init];
    }
    [hud showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
    
    NSString *tempStr = kckpxjapprest;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[tempStr stringByAppendingString:@"/xjsubmitcaseimageisover"] params:dic httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        [self finishGetPhone:result];
        if(nil != hud)
        {
            [hud dismiss];
        }
    }];
    
}

#pragma mark 提交完成
-(void)finishGetPhone:(NSDictionary *)result
{
    NSString *string = nil;
    BOOL sucess = NO;
    if(nil == result)
    {
        string = @"数据加载失败,请检查网络。";
    }
    else
    {
        NSDictionary *dic = result;
        
        NSString *restate = [dic objectForKey:@"restate"];
        if([@"0" isEqualToString:restate])
        {
            //成功
            sucess = YES;
        }
        else
        {
            //失败
            string = (NSString *)[dic objectForKey:@"redes"];
        }
    }
    
    if(sucess)
    {
        FinishTakePhotoViewController *finishController = [[FinishTakePhotoViewController alloc] init];
        finishController.appcaseno = _appcaseno;
        finishController.type = _type;
        [self.navigationController pushViewController:finishController animated:YES];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
    [alert show];
    
    
}

#pragma mark 照片没有拍摄完整提示
-(void)showNoticeAboutImage
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"照片没有拍摄完整" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
    [alert show];
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
