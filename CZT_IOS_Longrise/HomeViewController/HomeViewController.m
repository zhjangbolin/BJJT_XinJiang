//
//  HomeViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/11/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "HomeViewController.h"
#import "CZT_IOS_Longrise.pch"
#import "LoginViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    //=====================自定义navigationBar=====================
    //设置navigationBar的背景颜色
    UIView *customNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, [Util getStatusBarAndnavigationBarHeight:self.navigationController])];
    customNavigationBar.backgroundColor = [UIColor colorWithRed:61/255.0 green:166/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:customNavigationBar];
    
    //Logo
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectZero];
    logoView.left = 5;
    logoView.width = 34;
    logoView.height = logoView.width;
    logoView.top = [Util getStatusBarHeight] + ([Util getnavigationBarHeight:self.navigationController] - logoView.width)/2;
    logoView.image = [UIImage imageNamed:@"logo"];
    [customNavigationBar addSubview:logoView];
    
    //城市
    citySelectView = [[UISelectListView alloc] initWithFrame:CGRectMake(logoView.right + 4, logoView.top, 100, 40)];
    //设置当前的View
    citySelectView.currentView =self.view;
    [citySelectView setCanEdit:NO];
    //设置图标
    [citySelectView setIcon:[UIImage imageNamed:@"select"]];
    //设置下拉的宽度
    [citySelectView setDropWidth:100];
    //设置代理
    citySelectView.delegate = self;
    [citySelectView setSelectIndex:0];
    [citySelectView setShowLabelColor:[UIColor whiteColor]];
    [citySelectView setShowLabelSize:[UIFont systemFontOfSize:13]];
    [customNavigationBar addSubview:citySelectView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [Util getStatusBarHeight], customNavigationBar.width, [Util getnavigationBarHeight:self.navigationController])];
    titleLabel.text = @"事故处理";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [customNavigationBar addSubview:titleLabel];
    
    //天气
    weatherAndtemp = [UIButton buttonWithType:UIButtonTypeCustom];
    weatherAndtemp.frame = CGRectZero;
    weatherAndtemp.width = 80;
    weatherAndtemp.height = [Util getnavigationBarHeight:self.navigationController];
    weatherAndtemp.top = [Util getStatusBarHeight];
    weatherAndtemp.left = customNavigationBar.width - weatherAndtemp.width;
    weatherAndtemp.titleLabel.font = [UIFont systemFontOfSize:12];
    [weatherAndtemp setTitle:@"未知" forState:UIControlStateNormal];
    weatherAndtemp.titleLabel.textAlignment = NSTextAlignmentRight;
    weatherAndtemp.titleLabel.numberOfLines = 0;
    [customNavigationBar addSubview:weatherAndtemp];
    
    //初始化Global
    [self initGlobal];
    
    self.hometabView = [[UITableView alloc]initWithFrame:CGRectMake(0, [Util getStatusBarAndnavigationBarHeight:self.navigationController], self.view.frame.size.width, self.view.frame.size.height)];
    self.hometabView.backgroundColor = BackColor;
    self.hometabView.delegate = self;
    self.hometabView.dataSource = self;
    self.hometabView.tableFooterView = [[UIView alloc]init];
    self.hometabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    [self.view addSubview:self.hometabView];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
    hud = [[FVCustomAlertView alloc] init];
    
    //添加通知
    NSString *name = NotificationNameForLoadMenu;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMenu:) name:name object:nil];
    
}

#pragma mark 加载菜单
-(void)loadMenu:(NSNotification *)notice
{
    if(nil == notice)
    {
        return;
    }
    
    NSString *str = (NSString *)[notice object];
    if([@"0" isEqualToString:str])
    {
        //加载
        [UserDefaultsUtil saveNSUserDefaultsForObject:@"0" forKey:@"DidBecomeActive"];
        if(hud != nil)
        {
            [hud showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
        }
        //开始定位
        [_locService startUserLocationService];
    }
    else
    {
        //停止
        if(nil != hud)
        {
            [hud dismiss];
        }
        
        if(nil != _locService)
        {
            //开始定位
            [_locService stopUserLocationService];

        }
    }
    
}

#pragma mark 初始化Global类
-(void)initGlobal
{
    [Globle getInstance].serviceURL = ServiceURL;
    [Globle getInstance].wxSericeURL = WXServiceURL;
    [Globle getInstance].updateURL = UpdateURL;
    [Globle getInstance].wxBaseServiceURL = WXBaseServiceURL;
    [Globle getInstance].loadDataName = @"650100001000";
    [Globle getInstance].loadDataPass = @"F11351A8B0D7483AEBCE6CBD7679F33A";
}

#pragma mark 获取本地菜单信息
-(void)getLocalMenuInfo
{
    NSString *dicPath = MenuInfoDic;
//    NSString *fileName = MenuFileName;
//    //读取本地菜单信息
//    localMenuInfo = [NSDictionary dictionaryWithContentsOfFile:[dicPath stringByAppendingPathComponent:fileName]];
    
    //获取登陆信息
    NSString *loginFileName = LoginFileName;
    [Globle getInstance].loginInfoDic = [NSDictionary dictionaryWithContentsOfFile:[dicPath stringByAppendingPathComponent:loginFileName]];
}

#pragma mark 设置菜单信息到本地
-(void)setMenuInfo2Local:(NSDictionary *)dic
{
    NSString *dicPath = MenuInfoDic;
    NSString *fileName = MenuFileName;
    //将菜单数据设置到本地
    [Util DicWrite2File:dicPath fileName:fileName Dic:dic];
}

#pragma mark 刷新数据
-(void)refresh
{
    if(_locService != nil)
    {
        [_locService startUserLocationService];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    self.navigationController.navigationBar.hidden = YES;
    _locService.delegate = self;
    if(nil != _geocodesearch)
    {
        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    self.navigationController.navigationBar.hidden = NO;
    _locService.delegate = nil;
    if(nil != _geocodesearch)
    {
        _geocodesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
}

-(void)viewDidAppear:(BOOL)animated
{

    NSLog(@"viewDidAppear");

    //判断是否加载菜单
    NSString *str = [UserDefaultsUtil getDataForKey:@"isLoadMenu"];
    if([@"1" isEqualToString:str])
    {
        //添加标记值，用来标记是否加载菜单
        //[UserDefaultsUtil saveNSUserDefaultsForBOOL:NO forKey:@"isLoadMenu"];
        [UserDefaultsUtil saveNSUserDefaultsForObject:@"0" forKey:@"isLoadMenu"];
        if(hud != nil)
        {
            [hud showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
        }
        //开始定位
        [_locService startUserLocationService];
    }
}

#pragma mark 加载数据
-(void)loadData
{
    [self loadDataByLat:[Globle getInstance].imagelat AndLon:[Globle getInstance].imagelon];
}

#pragma mark 第一次使用APP提交数据
-(void)firstUseAPPSendData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //操作系统版本类型
    [params setObject:@"1" forKey:@"lciposversiontype"];
    //设备型号(苹果6、小米.....)
    [params setObject:[Util getCurrentDeviceName] forKey:@"deviceversion"];
    //设备编码(设备唯一编码)
    [params setObject:[Util getIdentifierForVendor] forKey:@"devicenumber"];
    //是否wifi打开
    [params setObject:[[NSNumber alloc] initWithBool:([Util getNetState] == 1 ? YES:NO)] forKey:@"iswifi"];
    //登录名
    [params setObject:@"" forKey:@"userflag"];
    //手机物理网卡
    [params setObject:@"" forKey:@"clientmac"];
    
    NSString *tempStr = appbase;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[tempStr stringByAppendingString:@"/appwelcome"] params:params httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result)
     {
         NSDictionary *dic = result;
         if(nil != dic)
         {
             NSString *restate = [dic objectForKey:@"restate"];
             //成功
             if([@"1" isEqualToString:restate])
             {
                 //[UserDefaultsUtil saveNSUserDefaultsForBOOL:YES forKey:@"isFirst"];
             }
         }
     }];
}


#pragma mark 根据经纬度加载数据
-(void)loadDataByLat:(CGFloat)lat AndLon:(CGFloat)lon
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //经纬度
    [params setObject:[[NSNumber alloc] initWithFloat:lon] forKey:@"maplon"];
    [params setObject:[[NSNumber alloc] initWithFloat:lat] forKey:@"maplat"];
    //设备类型，0:android 1:IOS
    [params setObject:[[NSNumber alloc] initWithInt:1] forKey:@"device"];
    //菜单类型，0:出行 1:维修
    [params setObject:[[NSNumber alloc] initWithInt:0] forKey:@"menutype"];
    
    NSString *tempStr = appbase;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[tempStr stringByAppendingString:@"/appgetareaweather"] params:params httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result)
     {
         
         if(nil == result)
         {
             if(nil != hud)
             {
                 [hud dismiss];
             }
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请确认网络是否开启" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
             [alert show];
         }
         else
         {
             NSDictionary *dic = result;
             NSString *restate = [dic objectForKey:@"restate"];
             if([@"1" isEqualToString:restate])
             {
                 //刷新UI
                 [self setData2UI:[dic objectForKey:@"data"]];
             }
             else
             {
                 NSString *redes = [dic objectForKey:@"redes"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:redes delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
                 [alert show];
             }
             
             //将菜单存放在本地
             //[self setMenuInfo2Local:result];
             //获取本地的登录信息
             [Globle getInstance].loginInfoDic = [UserDefaultsUtil getDataForKey:LoginFileName];
             if(nil == [Globle getInstance].loginInfoDic)
             {
                 if(nil != hud)
                 {
                     [hud dismiss];
                 }
             }
             else
             {
                 NSString *token = [[Globle getInstance].loginInfoDic objectForKey:@"token"];
                 NSString *userflag= nil;
                 NSDictionary *userInfo = [[Globle getInstance].loginInfoDic objectForKey:@"userinfo"];
                 if(userInfo != nil)
                 {
                     userflag = [userInfo objectForKey:@"userflag"];
                 }
                 
                 //判断token的有效性
                 [self appValidateTokenUserFlag:userflag token:token];
             }
         }
         
         [self.hometabView.mj_header endRefreshing];
     }];
}

#pragma mark 验证token的有效性
-(void)appValidateTokenUserFlag:(NSString *)userFlag token:(NSString *)token
{
    if(nil == userFlag || token == nil || [@"" isEqualToString:userFlag] || [@"" isEqualToString:token])
    {
        if(nil != hud)
        {
            [hud dismiss];
        }
        [Globle getInstance].loginInfoDic = nil;
        [Globle getInstance].token = nil;
        
        return;
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userFlag forKey:@"userflag"];
    [params setObject:token forKey:@"token"];
    
    NSString *tempStr = appbase;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL  ServiceName:[tempStr stringByAppendingString:@"/appvalidatetoken"] params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result) {
        
        if(nil != hud)
        {
            [hud dismiss];
        }
        
        if(nil != result)
        {
            NSDictionary *dic = result;
            if(nil != dic)
            {
                NSString *restate = [dic objectForKey:@"restate"];
                if([@"1" isEqualToString:restate])
                {
                    return;
                }
            }
        }
        
        [Globle getInstance].loginInfoDic = nil;
        [Globle getInstance].token = nil;
    }];

}

#pragma mark 数据绑定到UI
-(void)setData2UI:(NSDictionary *)dataInfo
{
    //设置城市
    NSDictionary *area = [dataInfo objectForKey:@"area"];
    if(nil != area)
    {
        [citySelectView addItem:area forKey:@"city"];
        [citySelectView setSelectIndex:0];
        
        [Globle getInstance].areaid = [area objectForKey:@"areaid"];
        //为了调试，暂时写成北京的
//        [Globle getInstance].areaid = @"110101000000000000";650108000000000000
        [Globle getInstance].areaid = @"650108000000000000";
    }
    
    //设置天气和温度
    NSDictionary *weahther = [dataInfo objectForKey:@"weahther"];
    if(nil != weahther)
    {
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        NSString *weatherStr = [weahther objectForKey:@"weather"];
        if(nil != weatherStr)
        {
            [tempStr appendString:weatherStr];
        }
        NSString *temperature = [weahther objectForKey:@"temperature"];
        if(nil != temperature)
        {
            [tempStr appendString:[NSString stringWithFormat:@"\n%@",temperature]];
        }
        
        if(nil != weatherAndtemp)
        {
            [weatherAndtemp setTitle:tempStr forState:UIControlStateNormal];
            NSLog(@"tempStr = %@",tempStr);
        }
        
    }
    
    //设置菜单
    NSDictionary *dataDic = [dataInfo objectForKey:@"menu"];
    if(dataDic != nil)
    {
        //快处快赔路径
        NSString *areaurl = [dataDic objectForKey:@"kckpareaurl"];
        if(nil != areaurl && ![@"" isEqualToString:areaurl])
        {
            [Globle getInstance].serviceURL = areaurl;
        }
        
        //维修的路径
        NSString *lcipareaurl = [dataDic objectForKey:@"lcipareaurl"];
        if(nil != lcipareaurl && ![@"" isEqualToString:lcipareaurl])
        {
            [Globle getInstance].wxSericeURL = lcipareaurl;
        }
        
        menuFirstArray = [dataDic objectForKey:@"data"];
    }
    if(nil != menuFirstArray && menuFirstArray.count > 0)
    {
        [self.hometabView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前城市赞不支持出行业务。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
    
    //检查版本
    [self checkVersion];
}


#pragma mark ==================>UITableView 代理回调方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(nil != menuFirstArray)
    {
        return menuFirstArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil != menuFirstArray)
    {
        NSDictionary *dic = [menuFirstArray objectAtIndex:section];
        if(nil != dic)
        {
            NSArray *secondArray = [dic objectForKey:@"second"];
            if(nil != secondArray)
            {
                return secondArray.count;
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"homeCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil]lastObject];
    }
    
    NSDictionary *secondDic = nil;
    if(nil != menuFirstArray)
    {
        NSDictionary *dic = [menuFirstArray objectAtIndex:indexPath.section];
        if(nil != dic)
        {
            NSArray *secondArray = [dic objectForKey:@"second"];
            if(nil != secondArray)
            {
                secondDic = [secondArray objectAtIndex:indexPath.row];
            }
        }
    }
    
    if(nil != secondDic && cell.iconView != nil && nil != cell.titleLabel)
    {
        cell.iconView.image = [UIImage imageNamed:(NSString *)[secondDic objectForKey:@"picture"]];
        cell.titleLabel.text = (NSString *)[secondDic objectForKey:@"name"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(nil != menuFirstArray)
    {
        NSDictionary *dic = [menuFirstArray objectAtIndex:section];
        return (NSString *)[dic objectForKey:@"first"];
    }
    return nil;
}
//补全分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell  respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nil != menuFirstArray)
    {
        NSDictionary *dic = [menuFirstArray objectAtIndex:indexPath.section];
        if(nil != dic)
        {
            NSArray *secondArray = [dic objectForKey:@"second"];
            if(nil != secondArray)
            {
                NSDictionary *secondDic = [secondArray objectAtIndex:indexPath.row];
                [self onClickCell:[secondDic objectForKey:@"classorpath"] isLogin:[secondDic objectForKey:@"islogin"]];
            }
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark ================>单击事件回调方法
-(void)onClickCell:(NSString *)pathName isLogin:(NSString *)isLogin
{
    if(nil == pathName || [@"" isEqualToString:pathName])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"菜单数据异常，请重试。" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //判断是否需要登录 0:需要 1:不需要
    if([@"0" isEqualToString:isLogin])
    {
        //通过Global来判断是否登陆过
        if([Globle getInstance].loginInfoDic == nil)
        {
            //先登陆
            LoginViewController *loginController = [[LoginViewController alloc] init];
            loginController.loginControllerClose = self;
            loginController.isShowController = true;
            loginController.controllerName = pathName;
            [self.navigationController pushViewController:loginController animated:YES];
            return;
        }
    }
    
    Class someClass = NSClassFromString(pathName);
    if(nil == someClass)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"模块正在开发中" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    id obj = [[someClass alloc] init];
    if(obj == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"模块正在开发中" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
        [alert show];
    }
    BaseViewController *baseController = (BaseViewController *)obj;
    [self.navigationController pushViewController:baseController animated:YES];
}


#pragma mark ============>登陆页面关闭回调方法
-(void)LoginControllerClose:(UIViewController *)viewController success:(BOOL)b
{
    if(b)
    {
        //移除登陆控制器
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        [navigationArray removeObjectAtIndex: 1];
        self.navigationController.viewControllers = navigationArray;
    }
}

#pragma mark ============>定位
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if(nil != hud)
    {
        [hud dismiss];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查网络是否连接或者定位是否打开" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
    [alert show];
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [Globle getInstance].imagelon = userLocation.location.coordinate.longitude;
    [Globle getInstance].imagelat = userLocation.location.coordinate.latitude;
    
    //保存经纬度
    [UserDefaultsUtil saveNSUserDefaultsForFloat:userLocation.location.coordinate.latitude forKey:@"lat"];
    [UserDefaultsUtil saveNSUserDefaultsForFloat:userLocation.location.coordinate.longitude forKey:@"lon"];
    
    //停止定位服务
    if(nil != _locService)
    {
        [_locService stopUserLocationService];
    }
    
    //将经纬度换算成具体地址
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
        if(nil != hud)
        {
            [hud dismiss];
        }
        [self.hometabView.mj_header endRefreshing];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查网络是否连接" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles: nil];
        [alert show];
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        NSString *cityName = result.addressDetail.city;
        NSLog(@"城市名称：%@",cityName);
        if([@"新疆" isEqualToString:cityName])
//        if([@"上海市" isEqualToString:cityName])
        {
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = result.location;
            item.title = result.address;
            NSString* titleStr;
            NSString* showmeg;
            titleStr = @"反向地理编码";
            showmeg = [NSString stringWithFormat:@"%@",item.title];
            //保存地址
            [UserDefaultsUtil saveNSUserDefaultsForObject:showmeg forKey:@"imageaddress"];
            [Globle getInstance].imageaddress = showmeg;
        }
        else
        {
            //北京：保存地址
            [UserDefaultsUtil saveNSUserDefaultsForObject:@"新疆乌鲁木齐市米东区" forKey:@"imageaddress"];
            [Globle getInstance].imageaddress = @"新疆乌鲁木齐市米东区";
            [Globle getInstance].imagelat = 43.97;
            [Globle getInstance].imagelon = 87.68;
            
            //650108000000000000
            //上海
//            [UserDefaultsUtil saveNSUserDefaultsForObject:@"上海市黄浦区" forKey:@"imageaddress"];
//            [Globle getInstance].imageaddress = @"上海市黄浦区";
//            [Globle getInstance].imagelat = 31.23;
//            [Globle getInstance].imagelon = 121.48;
            
            //保存经纬度
            [UserDefaultsUtil saveNSUserDefaultsForFloat:[Globle getInstance].imagelat forKey:@"lat"];
            [UserDefaultsUtil saveNSUserDefaultsForFloat:[Globle getInstance].imagelon forKey:@"lon"];

        }
        
        
        //开始加载菜单
        [self loadData];
    }
    else
    {
        //反向失败
        if(nil != hud)
        {
            [hud dismiss];
        }
        [self.hometabView.mj_header endRefreshing];
    }
    
}

#pragma mark ============>UISelectListView 代理
-(void)selectListView:(UISelectListView *)selectListView index:(NSUInteger)index content:(NSDictionary *)dic
{
    
}

#pragma mark - 检测版本更新
-(void)checkVersion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"BJJT_XinJiang_IOS" forKey:@"arg1"];
    
    NSString *tempStr = kckpdecanrest;
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[tempStr stringByAppendingString:@"/lbcp_getAppVersion"] params:params httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        
        if (nil != result)
        {
            NSString *jsonStr = [Util objectToJson:result];
            NSLog(@"版本检测%@",jsonStr);
            verModel = [[AppVerModel alloc]initWithString:jsonStr error:nil];
            //            verModel.appversion;
            //            verModel.upgrade
            //            verModel.remarks
            remark = verModel.remarks;
            
            localVersion = VersionCode;
            NSLog(@"当前版本号%@",verModel.appversion);
            int localVersionNUm = (localVersion == nil ? -1 : [localVersion intValue]);
            
            //获取服务器版本
            serverVersion = verModel.appversion;
            int serverVersionNum = (serverVersion == nil ? -1 : [serverVersion intValue]);
            //判断是非升级
            if(localVersionNUm < serverVersionNum)
            {
                NSString *upgrade = verModel.upgrade;
                if([@"1" isEqualToString:upgrade])    //   强制升级
                {
                    self.versionAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                }
                else     //  自选升级
                {
                    self.versionAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"有新的版本，请及时更新。" delegate:self cancelButtonTitle: nil otherButtonTitles:@"确定",@"取消",nil];
                }
                [self.versionAlertView show];
                
            }
        }
        
    }];
    
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.versionAlertView)
    {
        if(buttonIndex == 0)
        {
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:remark]];
            
        }
    }
}

@end
