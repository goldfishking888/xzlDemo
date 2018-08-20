//
//  HRLieTouIncomeViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRLieTouIncomeViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SDWebImageManager.h"
#import "MJRefresh.h"

@interface HRLieTouIncomeViewController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;

@end

@implementation HRLieTouIncomeViewController{
    UIWebView *_webView;
    UIButton *_backBtn;
    MBProgressHUD *loadView;
    NSString *url_current;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //    [WebConsole enable];
    
    [self configHeadViewGR];
    [self addTitleLabelGR:@"收入"];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,50,30);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_gray"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    _backBtn.hidden = YES;
    
    _urlStr = kCombineURL(kTestAPPAPIGR, @"/api/freehr/income")
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 64,kMainScreenWidth,kMainScreenHeight-64-50);
    // 设置可以支持缩放
    [_webView setScalesPageToFit:YES];
    
    [_webView.scrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _webView.scrollView.headerPullToRefreshText= @"下拉刷新";
    _webView.scrollView.headerReleaseToRefreshText = @"松开马上刷新";
    _webView.scrollView.headerRefreshingText = @"努力加载中……";
    
//    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    
    [self.view addSubview:_webView];
    
    [self initJSBridge];
    
    [self setCookies];
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    [_webView reload];
}

-(void)initJSBridge{
    if (_bridge) {
        return;
    }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    
    [_bridge registerHandler:@"invite_code_str_copy" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        NSString *inviteCode = [data valueForKey:@"v"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = inviteCode;
        mGhostView(nil, @"已复制到剪贴板")
        
    }];
    
    [_bridge registerHandler:@"img_save" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        NSString *imgUrl = [data valueForKey:@"v"];
        [self downLoadImageAndSave:imgUrl];
    }];
    
    [_bridge registerHandler:@"invite_code_str_copy" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        NSString *inviteCode = [data valueForKey:@"v"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = inviteCode;
        mGhostView(nil, @"已复制到剪贴板")
        
    }];
}

-(void)setCookies{
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    url_current = urlStr;
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
    
    if (![_webView canGoBack]) {
        _backBtn.hidden = YES;
    }else{
        _backBtn.hidden = NO;
    }
    
    if ([url_current hasSuffix:@"/income"]||[url_current containsString:@"join/status"]) {
        _backBtn.hidden = YES;
    }
    
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


- (void)backUp:(id)sender
{
    [_webView goBack];
}

-(void)downLoadImageAndSave:(NSString *)urlImageStr{
    NSURL *urlImage = [NSURL URLWithString:urlImageStr];
    //    UIImage *image;
    NSLog(@"shareImage is downloading~");
    [[SDWebImageManager sharedManager] downloadImageWithURL:urlImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self saveImageToPhotos:image];
    }];
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存失败" ;
    }else{
        msg = @"保存成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
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
