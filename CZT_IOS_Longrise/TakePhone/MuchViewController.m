//
//  MuchViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/19.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "MuchViewController.h"
#import <BJJT_Lib/UIImageView+WebCache.h>

@interface MuchViewController ()

@end

@implementation MuchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadXIB];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)loadXIB{
    self.bacScrollView.contentSize = CGSizeMake(0, 850);
    NSArray *itemsView = [[NSBundle mainBundle]loadNibNamed:@"MuchViewXib" owner:self options:nil];
    UIView *views = [itemsView lastObject];
    views.frame = CGRectMake(0, 0, self.bacScrollView.frame.size.width, 850);
    [self.bacScrollView addSubview:views];
     [self _initView];
}

#pragma mark 初始化UI
-(void)_initView
{
    
    if (![_currentPhotoArray isEqual:@""] && _currentPhotoArray != nil) {
        //如果拍照已完成则隐藏finishBtn
        if ([_scepicoverd isEqualToString:@"1"]) {
            _finishBtn.hidden = YES;
        }
        
        for (NSDictionary *dic in _currentPhotoArray) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 30)/2, _imageBtn1.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:@"loadingPhoto"]];
            
            if ([dic[@"imagetype"]isEqualToString:@"1"]) {
                [_imageBtn1 addSubview:imageView];
                _imageBtn1.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"2"]){
                [_imageBtn2 addSubview:imageView];
                _imageBtn2.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"4"]){
                [_imageBtn3 addSubview:imageView];
                _imageBtn3.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"5"]){
                [_imageBtn4 addSubview:imageView];
                _imageBtn4.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"3"]){
                [_imageBtn5 addSubview:imageView];
                _imageBtn5.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"15"]){
                [_imageBtn6 addSubview:imageView];
                _imageBtn6.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"6"]){
                [_imageBtn7 addSubview:imageView];
                _imageBtn7.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"7"]){
                [_imageBtn8 addSubview:imageView];
                _imageBtn8.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"8"]){
                [_imageBtn9 addSubview:imageView];
                _imageBtn9.tag = 1;
            }else if ([dic[@"imagetype"]isEqualToString:@"9"]){
                [_imageBtn10 addSubview:imageView];
                _imageBtn10.tag = 1;
            }
        }
    }
    //添加监听
    [self.imageBtn1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn3 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn4 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn5 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn6 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn7 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn8 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn9 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBtn10 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    self.finishBtn.layer.cornerRadius = 5;
    [self.finishBtn setBackgroundColor:[UIColor colorWithRed:61/255.0 green:166/255.0 blue:244/255.0 alpha:1]];
    [self.finishBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
   
}

#pragma mark 单击回调函数
-(void)onClick:(UIButton *)btn
{
    if(btn == self.finishBtn)
    {
        //判断照片是否拍摄完成(0:未完成，1:完成)
        long tag = 0;
        tag = self.imageBtn1.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn2.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn3.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn4.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn5.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn7.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn8.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn9.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        tag = self.imageBtn10.tag;
        if(tag != 1)
        {
            [self showNoticeAboutImage];
            return;
        }
        tag = 0;
        
        NSMutableDictionary *finishDic = [[NSMutableDictionary alloc] init];
        [finishDic setObject:self.appcaseno forKey:@"appcaseno"];
        NSDictionary *userinfo = [[Globle getInstance].loginInfoDic objectForKey:@"userinfo"];
        NSDictionary *logininfo = [Globle getInstance].loginInfoDic;
        NSString *token = logininfo[@"token"];
        
        [finishDic setObject:[userinfo objectForKey:@"mobilephone"] forKey:@"appphone"];
        [finishDic setObject:@"1" forKey:@"shoottype"];
        [finishDic setObject:userinfo[@"userflag"] forKey:@"username"];
        [finishDic setObject:token forKey:@"password"];
        
        [self zdsubmitcaseimageisover:finishDic];
        return;
    }
    tempBtn = btn;
    tempBtn.tag =1;
    
    
    /*照片类型	Int	4	1、正前方
     2、正后方
     3、碰撞部位
     4、车辆近景
     5、本方车辆全景
     6、本方车辆碰撞部位
     7、对方车辆全景
     8、对方车辆碰撞部位
     9、其它；
     1				1				侧前方事故全景
     2				2				侧后方事故全景
     3				3				碰撞部位
     4				4				本方车辆损失全景
     5				5		 		对方车辆损失全景
     6				6				本方车辆行驶证
     7				7		 		本方车辆驾驶证
     8				8				对方车辆行驶证
     9				9				对方车辆驾驶证
     */
    if(btn == self.imageBtn1)
    {
        shoottype = 1;
    }
    else if(btn == self.imageBtn2)
    {
        shoottype = 2;
    }
    else if(btn == self.imageBtn3)
    {
        shoottype = 4;
    }
    else if(btn == self.imageBtn4)
    {
        shoottype = 5;
    }
    else if(btn == self.imageBtn5)
    {
        shoottype = 3;
    }
    else if(btn == self.imageBtn6)
    {
        shoottype = 15;
    }
    else if (btn == self.imageBtn7)
    {
        shoottype = 6;
    }
    else if (btn == self.imageBtn8)
    {
        shoottype = 7;
    }
    else if (btn == self.imageBtn9)
    {
        shoottype = 8;
    }
    else if (btn == self.imageBtn10)
    {
        shoottype = 9;
    }
    
    [self takePhone2:shoottype];
}

- (void)takePhone2:(int)photoType
{
    //遵守协议
    TakePhotoViewController *cameraVc = [[TakePhotoViewController alloc]initWithNibName:@"BJJT_Lib.framework/TakePhotoViewController" bundle:nil];
    cameraVc.delegate = self;
    
    if(photoType == 1)
    {
        cameraVc.stringFromLast = @"侧前方全景";
        cameraVc.hidesWarnLabel2 = @"1";
        cameraVc.imageFromLast = [UIImage imageNamed:@"car_double_font"];
    }
    else if(photoType == 2)
    {
        cameraVc.stringFromLast = @"侧后方全景";
        cameraVc.hidesWarnLabel2 = @"1";
        cameraVc.imageFromLast = [UIImage imageNamed:@"car_double_behind"];
    }
    else if(photoType == 3)
    {
        cameraVc.stringFromLast = @"擦碰部位";
        cameraVc.hidesWarnLabel2 = @"1";
        cameraVc.imageFromLast = [UIImage imageNamed:@"car_double_zhuang"];
    }
    else if(photoType == 4)
    {
        cameraVc.stringFromLast = @"本方车辆损失全景";
        cameraVc.hidesWarnLabel2 = @"1";
        cameraVc.imageFromLast = [UIImage imageNamed:@"car_double_me"];
    }
    else if(photoType == 5)
    {
        cameraVc.stringFromLast = @"对方车辆损失全景";
        cameraVc.hidesWarnLabel2 = @"1";
        cameraVc.imageFromLast = [UIImage imageNamed:@"car_double_other"];
    }
    else if(photoType == 15)
    {
        cameraVc.stringFromLast = @"其它";
        cameraVc.imageFromLast = [UIImage imageNamed:@"other_photo"];
    }
    else if (photoType == 6)
    {
        cameraVc.stringFromLast = @"本方车辆行驶证";
        cameraVc.imageFromLast = [UIImage imageNamed:@"me_drive_license"];
    }
    else if (photoType == 7)
    {
        cameraVc.stringFromLast = @"本方车辆驾驶证";
        cameraVc.imageFromLast = [UIImage imageNamed:@"me_drive_photo"];
        
    }
    else if (photoType == 8)
    {
        cameraVc.stringFromLast = @"对方车辆行驶证";
        cameraVc.imageFromLast = [UIImage imageNamed:@"other_drive_license"];
    }
    else if (photoType == 9)
    {
        cameraVc.stringFromLast = @"对方车辆驾驶证";
        cameraVc.imageFromLast = [UIImage imageNamed:@"other_drive_photo"];
    }
    
    UINavigationController *cameraNavigationController = [[UINavigationController alloc] initWithRootViewController:cameraVc];
    cameraNavigationController.navigationBarHidden = YES;
    [self presentViewController:cameraNavigationController animated:YES completion:nil];
}


#pragma mark 自定义相机回调方法
-(void)takeTheCamera:(UIImage *)image
{
    if(nil == tempBtn || image == nil)
    {
        return;
    }
    
    //进行缩放图片
    //    CGSize imgSize = image.size;
    //    imgSize.width = 640;
    //  float height = imgSize.width * (640/imgSize.height);
    tempImage = [Util originImage:image scaleToSize:CGSizeMake(640, 480)];
    //   NSLog(@"----------%lf%lf",tempImage.size.width,tempImage.size.height);
    [tempBtn setBackgroundImage:tempImage forState:UIControlStateNormal                                                                                                                                      ];
    
    //提交照片
    [self zdsubmitcaseimageinfor];
}


#pragma mark 上传图片
-(void)zdsubmitcaseimageinfor
{
    if(nil == tempImage)
    {
        return;
    }
    
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
    NSString *token = bigDic[@"token"];
    NSDictionary *userInfo = bigDic[@"userinfo"];
    NSString *userFlag = userInfo[@"userflag"];
    
    NSData *_data = UIImageJPEGRepresentation(tempImage, 0.9);
    NSString * encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    encodedImageStr = [encodedImageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    encodedImageStr = [NSString stringWithFormat:@"\"%@\"",encodedImageStr];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //移动报案号
    [dic setValue:self.appcaseno forKey:@"appcaseno"];
    //经度
    [dic setValue:[[NSNumber alloc] initWithFloat:[Globle getInstance].imagelon] forKey:@"imagelon"];
    //纬度
    [dic setValue:[[NSNumber alloc] initWithFloat:[Globle getInstance].imagelat] forKey:@"imagelat"];
    //地址描述	String
    [dic setValue:[Globle getInstance].imageaddress forKey:@"imageaddress"];
    //经过序列化的字节数组字符串
    [dic setValue:encodedImageStr forKey:@"imagedata"];
    //图片大小(单位是K)	String
    [dic setValue:[Util getImageBig:tempImage] forKey:@"imagebig"];
    //图片的宽
    [dic setValue:[[NSNumber alloc] initWithInt:tempImage.size.width] forKey:@"imagewide"];
    //图片的高
    [dic setValue:[[NSNumber alloc] initWithInt:tempImage.size.height] forKey:@"imageheigth"];
    //报案手机号
    //    [dic setValue:[[Globle getInstance].loginInfoDic[@"userinfo"] objectForKey:@"phonenumber"] forKey:@"casetelephoe"];
    NSDictionary *userinfo = [[Globle getInstance].loginInfoDic objectForKey:@"userinfo"];
    if(nil != userinfo)
    {
        [dic setValue:[userinfo objectForKey:@"mobilephone"] forKey:@"casetelephoe"];
    }
    //拍摄类型	String		1,定责图片 2定损图片
    [dic setValue:[[NSNumber alloc] initWithInt:1] forKey:@"shoottype"];
    /*照片类型	Int	4	1、正前方
     2、正后方
     3、碰撞部位
     4、车辆近景
     5、本方车辆全景
     6、本方车辆碰撞部位
     7、对方车辆全景
     8、对方车辆碰撞部位
     9、其它；
     */
    [dic setValue:[[NSNumber alloc] initWithInt:shoottype] forKey:@"imagetype"];
    //拍照时间	String	19	格式：YYYY-MM-DD HH:MM:SS(24小时)
    [dic setValue:[Util getCurrentTimeByFormal:@"yyyy-MM-dd HH:mm:ss"] forKey:@"imagedate"];
    //区域	String	18	报案所在的区域精确到区级
    [dic setValue:[Globle getInstance].areaid forKey:@"areaid"];
    //事故类型
    [dic setValue:@"2" forKey:@"acctype"];
    //用户名
    [dic setValue:userFlag forKey:@"username"];
    //密码
    [dic setValue:token forKey:@"password"];
    
    [self sendPhoneInfo:dic];
    
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
