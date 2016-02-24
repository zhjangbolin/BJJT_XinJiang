//
//  UserGuideViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/12/7.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "UserGuideViewController.h"
#import <BJJT_Lib/FVCustomAlertView.h>

@interface UserGuideViewController ()<UIWebViewDelegate>{
    FVCustomAlertView *alertView;
}

@end

@implementation UserGuideViewController

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
    alertView = [[FVCustomAlertView alloc] init];
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView];
    [self createWebView];
    // Do any additional setup after loading the view from its nib.
}

-(void)createWebView{
    
    self.title = @"使用指南";
    NSURL *url = [NSURL URLWithString:@"http://h.eqxiu.com/s/56xKT596"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView.delegate = self;
    [_webView setScalesPageToFit:NO];
    //    _webView.scrollView.contentSize = CGSizeMake(450, 667);
    _webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    //    _webView.scrollView.pagingEnabled = NO;
    [self setWebViewStatus];
    // [_webView sizeToFit];
    [_webView loadRequest:request];
}

-(void)setWebViewStatus
{
    for (UIView *_aView in [_webView subviews]) {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [alertView dismiss];
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
