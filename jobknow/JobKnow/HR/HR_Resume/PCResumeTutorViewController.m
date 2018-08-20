//
//  PCResumeTutorViewController.m
//  JobKnow
//
//  Created by Suny on 15/10/23.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "PCResumeTutorViewController.h"
#import "OLGhostAlertView.h"


@interface PCResumeTutorViewController ()<UIWebViewDelegate>{
    UIWebView *_webView;
    OLGhostAlertView *_ghostView;
    MBProgressHUD *_progressView;
//    WebViewJavascriptBridge* bridge;
}

@end

@implementation PCResumeTutorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:[NSString stringWithFormat:@"%@",_webTitle]];
    
    //清楚webview缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    _ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    _ghostView.position=OLGhostAlertViewPositionCenter;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
//    [self initJsBridge];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}

#pragma mark - 父类方法 如果自雷有新功能那么在子类中重写
- (void)backUp:(id)sender
{
//    if (_isFromNodataApplyList) {
//        for (UIViewController *item in self.navigationController.viewControllers) {
//            if ([item isKindOfClass:[ICSDrawerController class]]) {
//                [self.navigationController popToViewController:item animated:YES];
//                return ;
//            }
//        }
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化jsBridge
//- (void) initJsBridge{
//    
//    if (_bridge) {
//        return;
//    }
//    //    __block typeof(self) weakSelf = self;
//    [WebViewJavascriptBridge enableLogging];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(@"WebViewJavascriptBridge connect");
//    }];
//    
//    //申请入职奖金
//    [_bridge registerHandler:@"applyBonus" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"applyBonus %@", data);
//        
//        //        HRLogin *loginVC = [[HRLogin alloc]init];
//        //        [self.navigationController pushViewController:loginVC animated:YES];
//        
//        ApplyEntryBounsViewController *vc = [[ApplyEntryBounsViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    
//    //申请私信
//    [_bridge registerHandler:@"checkJobList" handler:^(id data, WVJBResponseCallback responseCallback) {
//        for (UIViewController *item in self.navigationController.viewControllers) {
//            if ([item isKindOfClass:[ICSDrawerController class]]) {
//                [(ICSDrawerController *)item close];
//                [self.navigationController popToViewController:item animated:YES];
//                return ;
//            }
//        }
//        //若从普通职位列表进入web跳转，需要重新创建
//        SeniorJobListViewController *main = [[SeniorJobListViewController alloc] init];
//        SeniorJobRightViewController *right = [[SeniorJobRightViewController alloc] init];
//        ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithRightViewController:right
//                                                                          centerViewController:main];
//        [self.navigationController pushViewController:drawer animated:YES];
//    }];
//    
//}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.absoluteString;
    if ([str rangeOfString:@"www.xzhiliao.com/c"].length > 0) {
        NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-zhi-le-qi-ye-ban/id921410120?mt=8"]];
            
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
