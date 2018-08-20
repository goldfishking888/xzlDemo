//
//  HR_ApplyCashWebViewController.m
//  JobKnow
//
//  Created by Suny on 15/12/9.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "HR_ApplyCashWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "OLGhostAlertView.h"
#import "HrApplyCashHistoryListViewController.h"


@interface HR_ApplyCashWebViewController (){
    
    OLGhostAlertView *_ghostView;
}

@property WebViewJavascriptBridge* bridge;
@property MBProgressHUD *progressView;

@end

@implementation HR_ApplyCashWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightButtonWithTitle:@"提现记录"];
    [self addCenterTitle:@"申请提现"];
    
    _ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    _ghostView.position=OLGhostAlertViewPositionCenter;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    //    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    [self initJsBridge];
    
    [_webView loadRequest:_jumpRequest];
    NSLog(@"_jumpRequest= %@",_jumpRequest);
    
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写父类返回方法
- (void)backUp:(id)sender
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 初始化jsBridge
- (void) initJsBridge{
    
    if (_bridge) {
        return;
    }
    __block typeof(self) weakSelf = self;
    [WebViewJavascriptBridge enableLogging];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(@"WebViewJavascriptBridge connect");
//        NSLog(@"test--bridge");
//    }];
    
    //点击复制
    [_bridge registerHandler:@"copyCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *code = [(NSDictionary *)data objectForKey:@"code"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",code];
        _ghostView.message = @"邀请码复制成功";
        [_ghostView show];
    }];
    
    //点击复制
    [_bridge registerHandler:@"appCash" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *code = [(NSDictionary *)data objectForKey:@"code"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",code];
        _ghostView.message = @"邀请码复制成功";
        [_ghostView show];
    }];
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.absoluteString;
    if ([str hasSuffix:@"/common/applyCashSuccess"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applyCashSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - NavigationBarRightButton 提现记录

- (void)onClickRightBtn:(id)sender
{
    HrApplyCashHistoryListViewController *listVC = [[HrApplyCashHistoryListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
    
}

@end
