//
//  HR_ToBecomeVipViewController.m
//  JobKnow
//
//  Created by Suny on 15/8/22.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ToBecomeVipViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MyHrFamilyJumpViewController.h"
#import "HrApplyCashViewController.h"
#import "MBProgressHUD.h"
#import "MessageListViewController.h"

@interface HR_ToBecomeVipViewController ()

@property WebViewJavascriptBridge* bridge;
@property MBProgressHUD *progressView;

@end

@implementation HR_ToBecomeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
//    [self addRightBarBtnItem:@"bonus_job_message" WithXtoRight:40.0f WithWidth:30.0f WithHeight:30.0f];
    [self addCenterTitle:@"成为会员"];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
//    _webView.delegate = self;
    [self.view addSubview:_webView];
    [self initJsBridge];
//    http://api.xzhiliao.com/hr_api/job/job_bonus_des?userToken=5798eb6ee4839dc6c57f234b1c968441&userImei=351554054729885&vip=0&salary=4000-5999&rate=50
    
    NSString *urlStr = [NSString stringWithFormat:@"%@hr_api/job/job_bonus_des?userToken=%@&userImei=%@&vip=%@&salary=%@&rate=%@",KXZhiLiaoAPI,kUserTokenStr,IMEI,@"0",_salary,@"50"];
    [self loadWebPageWithString:urlStr];
    
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化jsBridge
- (void) initJsBridge{
    
    if (_bridge) {
        return;
    }
    __block typeof(self) weakSelf = self;
    [WebViewJavascriptBridge enableLogging];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(@"WebViewJavascriptBridge connect");
//    }];
    
    //下载客户端
    [_bridge registerHandler:@"postInfoToVip" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"postInfoToVip %@", data);
        NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            
            [weakSelf gotoNewWebViewWithJumpRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xzhiliao.com/wap/download.html"]]];
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }

            }];
    
        
}

#pragma mark - 右按钮点击事件
-(void)onClickRightBtn:(id)sender
{
    MessageListViewController *jobCollectVC = [[MessageListViewController alloc] init];
    [self.navigationController pushViewController:jobCollectVC animated:YES];
}

#pragma mark - 跳转一个新的网页
-(void)gotoNewWebViewWithJumpRequest:(NSURLRequest *)request
{
    MyHrFamilyJumpViewController *jumpViewController = [[MyHrFamilyJumpViewController alloc] init];
    [jumpViewController setJumpRequest:request];
    [self.navigationController pushViewController:jumpViewController animated:YES];
}

#pragma mark - 加载一个链接
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //发展我的家族
    if ([request.URL.absoluteString rangeOfString:@"hr_api/invite/invite_page?"].length > 0){
        [self gotoNewWebViewWithJumpRequest:request];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_progressView) {
        [_progressView hide:YES];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (_progressView) {
        [_progressView hide:YES];
    }
}

@end
