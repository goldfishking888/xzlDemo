//
//  GRUploadResumeWebViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/6.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRUploadResumeWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "GRResumeCenterViewController.h"
#import "MJRefresh.h"

@interface GRUploadResumeWebViewController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation GRUploadResumeWebViewController{
    UIWebView *_webView;
    MBProgressHUD *loadView;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

-(void)jumpToResumeCenter{
    GRResumeCenterViewController *vc = [GRResumeCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [WebConsole enable];
    
    [self addBackBtnGR];
    [self addTitleLabelGR:@"上传简历"];
    
    if (_bridge) {
        return;
    }
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 44+20,kMainScreenWidth,kMainScreenHeight-44-20);
    // 设置可以支持缩放
    [_webView setScalesPageToFit:YES];
    [_webView.scrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _webView.scrollView.headerPullToRefreshText= @"下拉刷新";
    _webView.scrollView.headerReleaseToRefreshText = @"松开马上刷新";
    _webView.scrollView.headerRefreshingText = @"努力加载中……";
    
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"refreshResume" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedUserInfoAction" object:nil];
        
        NSArray *array = self.navigationController.viewControllers;
        for (int i =0; i<array.count; i++) {
            if (i==array.count-1) {
                ;
                UIViewController *v = array[i];
                if (![v isKindOfClass:[GRResumeCenterViewController class]]) {
                    GRResumeCenterViewController *vc = [GRResumeCenterViewController new];
                    vc.isFromUpload = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
            }
        }
    }];
    
    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"editResume" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        
        
        //        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge registerHandler:@"finish" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        
        [self.navigationController popViewControllerAnimated:YES];
        
        //        responseCallback(@"Response from testObjcCallback");
    }];
    
    _urlStr  = kCombineURL(kTestAPPAPIGR, @"/web/resumeupload");
    NSString *uid = [mUserDefaults valueForKey:@"id"];
    if (uid) {
        _urlStr = [_urlStr stringByAppendingString:[NSString stringWithFormat:@"?uid=%@",uid]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToResumeCenter) name:@"UpLoadJumpResume" object:nil];
    
    [self setCookies];
}

-(void)setCookies{
    //    NSURL *cookieHost = [NSURL URLWithString:@"http://"];
    //    NSDictionary *propertiesDict = [NSDictionary dictionaryWithObjectsAndKeys:[cookieHost host],NSHTTPCookieDomain,[cookieHost path],NSHTTPCookiePath,@"token",NSHTTPCookieName,kTestToken,NSHTTPCookieValue,nil];
    //    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:propertiesDict];
    //    NSArray* cookieArray = [NSArray arrayWithObject:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:cookieHost mainDocumentURL:nil];
    
    NSString *hostString = [kTestAPPAPIGR substringFromIndex:8];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"token" forKey:NSHTTPCookieName];
    [cookieProperties setObject:kTestToken forKey:NSHTTPCookieValue];
    [cookieProperties setObject:hostString forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:hostString forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    // set expiration to one month from now or any NSDate of your choosing
    // this makes the cookie sessionless and it will persist across web sessions and app launches
    /// if you want the cookie to be destroyed when your app exits, don't set this
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:YES];
    [request setAllHTTPHeaderFields:headers];
    [_webView loadRequest:request];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    [_webView reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    //    if ([urlStr isEqualToString:_urlStr]) {
    //
    //    }
    NSLog(@"%@",urlStr);
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    loadView.hidden = YES;
    if ([_webView.scrollView isHeaderRefreshing]) {
        [_webView.scrollView headerEndRefreshing];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    loadView.hidden = YES;
    if ([_webView.scrollView isHeaderRefreshing]) {
        [_webView.scrollView headerEndRefreshing];
    }
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
