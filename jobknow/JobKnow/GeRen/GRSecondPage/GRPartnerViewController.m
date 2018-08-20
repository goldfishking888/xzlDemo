//
//  GRPartnerViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/22.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRPartnerViewController.h"
#import "WebConsole.h"
#import "GRResumeCenterViewController.h"
#import "SDWebImageManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayModel.h"
#import "MJRefresh.h"

@interface GRPartnerViewController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation GRPartnerViewController{
    UIWebView *_webView;
    UIButton *_backBtn;
    MBProgressHUD *loadView;
}
- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle
{
    self.noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
    self.noDateView.frame = CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight -50-64);
    self.noDateView.hidden = YES;
    [self.view addSubview:_noDateView];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([XZLUtil isUnderCheck]) {
        _noDateView.hidden = NO;
        return;
    }
    if (_bridge) {
        return;
    }
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 44+20,kMainScreenWidth,kMainScreenHeight-44-20-(_isFullHeight?0:50));
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
    
    [_bridge registerHandler:@"editResume" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        GRResumeCenterViewController *vc = [GRResumeCenterViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        //        responseCallback(@"Response from testObjcCallback");
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
    
    [_bridge registerHandler:@"showPay" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *fee = [data valueForKey:@"fee"];
        [self createOrderWithFee:fee];
    }];
    
    _urlStr  = kCombineURL(kTestAPPAPIGR, @"/api/partner");
    
    [self setCookies];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [WebConsole enable];
    
    [self configHeadViewGR];
    if (_isFullHeight) {
        [self addBackBtnGR];
    }else{
        self.view.backgroundColor = XZHILBJ_colour;
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(10,5+self.num,50,30);
        [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
        [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_gray"] forState:UIControlStateNormal];
        [self.view addSubview:_backBtn];
        _backBtn.hidden = YES;
    }
    [self addTitleLabelGR:@"人才合伙人"];
    
    [self initDidLoadWithNoDataTitle:@"暂无信息，请先上传简历"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"PayResult" object:nil];
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    [_webView reload];
}

-(void)setCookies{
    //    NSURL *cookieHost = [NSURL URLWithString:@"http://"];
    //    NSDictionary *propertiesDict = [NSDictionary dictionaryWithObjectsAndKeys:[cookieHost host],NSHTTPCookieDomain,[cookieHost path],NSHTTPCookiePath,@"token",NSHTTPCookieName,kTestToken,NSHTTPCookieValue,nil];
    //    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:propertiesDict];
    //    NSArray* cookieArray = [NSArray arrayWithObject:cookie];
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:cookieHost mainDocumentURL:nil];
    
//    NSArray *arrayCookieD = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kTestAPPAPIGR]];
//    for (NSHTTPCookie *item in arrayCookieD) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:item];
//    }
//    
//    NSArray *arrayCookieDD = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://test.appapi.xzhiliao.com/api"]];
//    for (NSHTTPCookie *item in arrayCookieDD) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:item];
//    }
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
    if (_isFullHeight) {
        NSString *str  = kCombineURL(kTestAPPAPIGR, @"/api/partner/choicePay");
        str = [str stringByAppendingString:[NSString stringWithFormat:@"?token=%@",kTestToken]];
        url = [NSURL URLWithString:str];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:YES];
    [request setAllHTTPHeaderFields:headers];
    [_webView loadRequest:request];
    
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)myWebViewRequestNetWithUrlStr:(NSString *)urlStr
{
    
    NSString *url;
    if (![urlStr hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"http://%@",urlStr];
    } else {
        url = urlStr;
    }
    NSURL *urll = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urll];
    
    NSString* secretAgent = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"url is %@",url);
    NSLog(@"useragent is %@",secretAgent);
    
    [_webView loadRequest:request];
    
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
    if (![_webView canGoBack]) {
        _backBtn.hidden = YES;
    }else{
        _backBtn.hidden = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (error.code ==-3310) {
            msg =@"请前往设置-小职了-照片,开启访问权限";
        }
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

- (void)backUp:(id)sender
{
    if (_isFullHeight) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    
}


-(void)createOrderWithFee:(NSString *)fee{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:fee forKey:@"fee"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/create_order"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSString *payString = responseObject[@"data"];
                [self doAlipayWithOrderString:payString];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
//        NSLog(error);
    }];

}

-(void)doAlipayWithOrderString:(NSString *)orderString{
    NSString *appScheme = @"XZHiLiao";
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];

}

-(void)payResult:(NSNotification *)noti{
    NSDictionary *resultDic = noti.object;
    NSNumber *resultStatus = resultDic[@"resultStatus"];
    if (resultStatus.intValue == 9000) {
        mGhostView(nil, @"支付成功");
//
        //刷新用户信息操作
        if (!_isFullHeight) {
            [self setCookies];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedUserInfoAction" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if(resultStatus.intValue == 6001) {
        mGhostView(nil, @"支付取消");
        
    }else{
        mGhostView(nil, @"支付失败");
        
    }

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
