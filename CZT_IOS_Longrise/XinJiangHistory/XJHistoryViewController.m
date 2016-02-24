//
//  XJHistoryViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 16/1/15.
//  Copyright (c) 2016年 程三. All rights reserved.
//

#import "XJHistoryViewController.h"
#import "XJHistoryTableViewCell.h"
#import "XJHistoryModel.h"
#import "XJDetailHistoryViewController.h"
#import "CZT_IOS_Longrise.pch"
#import "MuchViewController.h"
#import "SingleViewController.h"
#import "MakeAppointmentController.h"
#import "TakeResponsePhotoViewController.h"


@interface XJHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,XJHistoryTableViewCellDelegate,TakePhotoViewControllerDelegate>{
    NSMutableArray *dataListArray;   //历史记录数组
    FVCustomAlertView *alertView;
}

@end

@implementation XJHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.hidesBottomBarWhenPushed = YES;
        //self.isShowController = true;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    //添加监听
    NSString *name1 = NotificationNameForOneStepFinish;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishOneStep:) name:name1 object:nil];
    dataListArray = [NSMutableArray array];
    [_historyTableView registerNib:[UINib nibWithNibName:@"XJHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"XJHistory"];
    [self refreshData];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 下拉刷新
-(void)refreshData{
    _historyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //[blockSelf.htTableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_historyTableView.mj_header endRefreshing];
        });
    }];
}

#pragma mark - 通知回调刷新界面
-(void)finishOneStep:(NSNotification *)notify{
    NSDictionary *dic = [notify userInfo];
    if (nil != dic) {
        [dataListArray removeAllObjects];
        [_historyTableView reloadData];
        [self requestData];
    }
}

#pragma mark － 请求历史记录列表数据
-(void)requestData{
    if (alertView == nil) {
        alertView = [[FVCustomAlertView alloc] init];
    }
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView];
    
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
    NSString *token = bigDic[@"token"];
    NSDictionary *userDic = bigDic[@"userinfo"];
    NSString *userflag = userDic[@"userflag"];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:userflag forKey:@"username"];
    [bean setValue:token forKey:@"password"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/xjsearchhistorycase",kckpxjapprest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        NSDictionary *bigDic = result;
        if (nil != bigDic) {
            if ([bigDic[@"restate"]isEqualToString:@"0"]) {
                if ([bigDic[@"data"]isEqual:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未查询到历史记录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                }else{
                    NSArray *dataArray = bigDic[@"data"];
                    for (NSDictionary *dic in dataArray) {
                        XJHistoryModel *historyModel = [[XJHistoryModel alloc]initWithDictionary:dic];
                        [dataListArray addObject:historyModel];
                    }
                    [_historyTableView reloadData];
                }
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证信息不通过!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请检查网络是否连接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
        [alertView dismiss];
        
    }];
    
    
}

#pragma mark - tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataListArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJHistory" forIndexPath:indexPath];
    if (dataListArray.count > indexPath.row) {
        cell.delegate = self;
        XJHistoryModel *model = dataListArray[indexPath.row];
        if ([model.acctype isEqualToString:@"1"]) {
            cell.acctypeLabel.text = @"单车";
            
        }else if([model.acctype isEqualToString:@"2"]){
            cell.acctypeLabel.text = @"双车";
        }
        
        if ([model.type isEqualToString:@"1"]) {
            
            cell.caseStateLabel.text = @"取证未完成";
            cell.caseStateLabel.textColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
        }else if ([model.type isEqualToString:@"2"]){

            cell.caseStateLabel.text = @"未预约";
            cell.caseStateLabel.textColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
        }else if ([model.type isEqualToString:@"3"]){
            
            cell.caseStateLabel.text = @"预约成功";
            cell.caseStateLabel.textColor = [UIColor colorWithRed:107/255.0 green:220/255.0 blue:91/255.0 alpha:1.0];
        }
        
        if ([model.dampicoverd isEqualToString:@"1"]) {
            cell.responseLabel.text = @"(已完成)";
            [cell.responseTakePhotoBtn setTitle:@"补拍照片" forState:UIControlStateNormal];
        }else{
            cell.responseLabel.text = @"(未完成)";
        }
        cell.dampicoverd = model.dampicoverd;
        
        if ([model.scepicoverd isEqualToString:@"1"]) {
            cell.currentLabel.text = @"(已完成)";
            [cell.currentTakePhotoBtn setTitle:@"补拍照片" forState:UIControlStateNormal];
        }else{
            cell.currentLabel.text = @"(未完成)";
        }
        cell.scepicoverd = model.scepicoverd;
        
        if ([model.isbespeak isEqualToString:@"1"]) {
            cell.appointmentLabel.text = @"(已完成)";
            [cell.goToAppointmentBtn setTitle:@"已预约" forState:UIControlStateNormal];
        }else{
            cell.appointmentLabel.text = @"(未完成)";
        }
        cell.isbespeak = model.isbespeak;
        
        cell.accidentTimeLabel.text = model.scebegintime;
        cell.appcaseno = model.appcaseno;
        cell.acctype = model.acctype;
        cell.type = model.type;
        
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataListArray.count > indexPath.row) {
    
        NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
        NSString *token = bigDic[@"token"];
        NSDictionary *userDic = bigDic[@"userinfo"];
        NSString *userflag = userDic[@"userflag"];
        
        alertView = [[FVCustomAlertView alloc] init];
        [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        [self.view addSubview:alertView];
        
        XJHistoryModel *historyModel = dataListArray[indexPath.row];
        NSString *appcaseno = historyModel.appcaseno;
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:appcaseno forKey:@"appcaseno"];
        [bean setValue:userflag forKey:@"username"];
        [bean setValue:token forKey:@"password"];
        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/xjsearchCaseDetailInfo",kckpxjapprest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            NSDictionary *bigDic = result;
            if (nil != bigDic) {
                if ([bigDic[@"restate"]isEqualToString:@"0"]) {
                    if ([bigDic[@"data"]isEqual:@""]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未查询到数据!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                        
                    }else{
                        NSDictionary *dic = bigDic[@"data"];
                        XJDetailHistoryViewController *DVC = [XJDetailHistoryViewController new];
                        DVC.dataDic = dic;
                        [self.navigationController pushViewController:DVC animated:YES];
                    }
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证信息不通过!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请检查网络是否连接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            [alertView dismiss];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

#pragma mark - cell代理方法
-(void)pushNextViewControllerWith:(NSString *)state and:(NSString *)appcaseno and:(NSString *)isbespeak and:(NSString *)scepicoverd and:(NSString *)dampicoverd and:(NSString *)acctype{
    
    self.appcaseno = appcaseno; //选中的案件号
    self.acctype = acctype;
    //现场拍照未完成时
    if (![scepicoverd isEqualToString:@"1"]) {
        if ([state isEqualToString:@"2"]||[state isEqualToString:@"3"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先完成现场拍照!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    //已预约状态下点击预约
    if ([state isEqualToString:@"3"]) {
        if ([isbespeak isEqualToString:@"1"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您当前已经预约过了,请勿重复预约" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MakeAppointment" bundle:nil];
            MakeAppointmentController *MAVC = [storyBoard instantiateViewControllerWithIdentifier:@"MakeAppointmentID"];
            MAVC.appcaseno = appcaseno;
            MAVC.currentMark = @"1";
            [self.navigationController pushViewController:MAVC animated:YES];
        }
        return;
    }
    
//    //现场拍照取证完成
//    if ([state isEqualToString:@"1"]&&[scepicoverd isEqualToString:@"1"]) {
//        TakePhotoViewController *TPVC = [TakePhotoViewController new];
//        TPVC.stringFromLast = @"其它";
//        TPVC.delegate = self;
//        TPVC.imageFromLast = [UIImage imageNamed:@"other_photo"];
//        shoottype = 15;
//        _photoType = @"1";
//        [self presentViewController:TPVC animated:YES completion:nil];
//        return;
//    }
//    
//    //定损拍照取证完成
//    if ([state isEqualToString:@"2"]&&[dampicoverd isEqualToString:@"1"]) {
//        TakePhotoViewController *TPVC = [TakePhotoViewController new];
//        TPVC.stringFromLast = @"其它";
//        TPVC.delegate = self;
//        TPVC.imageFromLast = [UIImage imageNamed:@"other_photo"];
//        shoottype = 16;
//        _photoType = @"2";
//        [self presentViewController:TPVC animated:YES completion:nil];
//        return;
//    }
    
    //照片未完成续拍
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
    NSString *token = bigDic[@"token"];
    NSDictionary *userDic = bigDic[@"userinfo"];
    NSString *userflag = userDic[@"userflag"];
    
    alertView = [[FVCustomAlertView alloc] init];
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:appcaseno forKey:@"appcaseno"];
    [bean setValue:userflag forKey:@"username"];
    [bean setValue:token forKey:@"password"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/xjsearchCaseDetailInfo",kckpxjapprest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        NSDictionary *bigDic = result;
        if (nil != bigDic) {
            if ([bigDic[@"restate"]isEqualToString:@"0"]) {
                if ([bigDic[@"data"]isEqual:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未查询到数据!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                }else{
                    NSDictionary *dic = bigDic[@"data"];
                    if ([state isEqualToString:@"1"]) {
                        
                        NSArray *dataArray = dic[@"scenedata"];
                        if ([dic[@"acctype"]isEqualToString:@"1"]) {
                            
                            SingleViewController *SVC = [SingleViewController new];
                            SVC.currentPhotoArray = dataArray;
                            SVC.appcaseno = appcaseno;
                            
                            //拍照完成的时候
                            if ([scepicoverd isEqualToString:@"1"]) {
                                SVC.scepicoverd = scepicoverd;
                            }
                            [self.navigationController pushViewController:SVC animated:YES];
                            
                        }else if ([dic[@"acctype"]isEqualToString:@"2"]){
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MuchViewStoryBoard" bundle:nil];
                            MuchViewController *MVC = [storyboard instantiateViewControllerWithIdentifier:@"MuchControrllerID"];
                            MVC.appcaseno = appcaseno;
                            MVC.currentPhotoArray = dataArray;
                            
                            //拍照完成的时候
                            if ([scepicoverd isEqualToString:@"1"]) {
                                MVC.scepicoverd = scepicoverd;
                            }
                            [self.navigationController pushViewController:MVC animated:YES];
                            
                        }
                        
                    }else if ([state isEqualToString:@"2"]){
                        
                        NSArray *dataArray = dic[@"assessdata"];
                        NSString *type = dic[@"acctype"];
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"ResponsePhotoSB" bundle:nil];
                        TakeResponsePhotoViewController *TVC = [storyBoard instantiateViewControllerWithIdentifier:@"TakeResponsePhotoID"];
                        TVC.currentMark = @"1";
                        TVC.type = type;
                        TVC.appcaseno = appcaseno;
                        TVC.responsePhotoArray = dataArray;
                        
                        //定损拍照完成的时候
                        if ([dampicoverd isEqualToString:@"1"]) {
                            TVC.dampicoverd = dampicoverd;
                        }
                        [self.navigationController pushViewController:TVC animated:YES];
                        
                    }
                }
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证信息不通过!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请检查网络是否连接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [alertView dismiss];
    }];
}

#pragma mark 自定义相机回调方法
-(void)takeTheCamera:(UIImage *)image
{
    if(image == nil)
    {
        return;
    }
    
    //进行缩放图片
    //    CGSize imgSize = image.size;
    //    float height = imgSize.width*(640/imgSize.height);
    
    tempImage = [Util originImage:image scaleToSize:CGSizeMake(640,480)];
    
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
    NSDictionary *userinfo = [[Globle getInstance].loginInfoDic objectForKey:@"userinfo"];
    //报案手机号
    [dic setValue:[userinfo objectForKey:@"mobilephone"] forKey:@"casetelephoe"];
    //拍摄类型	String		1,定责图片 2定损图片
    [dic setValue:_photoType forKey:@"shoottype"];
  
    [dic setValue:[[NSNumber alloc] initWithInt:shoottype] forKey:@"imagetype"];
    //拍照时间	String	19	格式：YYYY-MM-DD HH:MM:SS(24小时)
    [dic setValue:[Util getCurrentTimeByFormal:@"yyyy-MM-dd HH:mm:ss"] forKey:@"imagedate"];
    //区域	String	18	报案所在的区域精确到区级
    [dic setValue:[Globle getInstance].areaid forKey:@"areaid"];
    //事故类型
    [dic setValue:_acctype forKey:@"acctype"];
    //用户名
    [dic setValue:userFlag forKey:@"username"];
    //密码
    [dic setValue:token forKey:@"password"];
    
    [self sendPhoneInfo:dic];
    
}

#pragma mark 发送数据
-(void)sendPhoneInfo:(NSMutableDictionary *)dic
{
    if(nil == dic)
    {
        return;
    }
    
    NSString *tempStr = kckpxjapprest;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[tempStr stringByAppendingString:@"/xjsubmitcaseimageinfor"] params:dic httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        NSDictionary *bigDic = result;
        if (nil != bigDic) {
            if ([bigDic[@"restate"]isEqualToString:@"1"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上传图片失败" message:@"验证信息不通过!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上传图片失败" message:@"上传图片失败,请检查网络是否连接!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
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
