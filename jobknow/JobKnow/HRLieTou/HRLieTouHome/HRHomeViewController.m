//
//  HRHomeViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRHomeViewController.h"
#import "WebViewJavascriptBridge.h"
#import "XZLPMListModel.h"
#import "MJRefresh.h"

@interface HRHomeViewController ()<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;

@end

@implementation HRHomeViewController{
    UIWebView *_webView;
    UIButton *_backBtn;
    MBProgressHUD *loadView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //    [WebConsole enable];
    
    [self configHeadViewGR];
    [self addTitleLabelGR:@"首页"];
    self.view.backgroundColor = XZHILBJ_colour;
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,50,30);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_gray"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    _backBtn.hidden = YES;
    
    _urlStr = kCombineURL(kTestAPPAPIGR, @"/api/freehr")
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 64,kMainScreenWidth,kMainScreenHeight-64-50);
    // 设置可以支持缩放
    [_webView setScalesPageToFit:YES];
    
    [_webView.scrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _webView.scrollView.headerPullToRefreshText= @"下拉刷新";
    _webView.scrollView.headerReleaseToRefreshText = @"松开马上刷新";
    _webView.scrollView.headerRefreshingText = @"努力加载中……";

    [self.view addSubview:_webView];
    
    [self initJSBridge];
    
    [self setCookies];
    
    [self requestDataWithToward];
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    [self setCookies];
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


- (void)backUp:(id)sender
{
    [_webView goBack];
}

#pragma mark - 根据DB时间戳，获取服务器的列表数据
- (void)requestDataWithToward{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/get/conversation/member/list"];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    NSString *sqlCriteria = nil;
    
    XZLPMListModel *pmTempModel = [XZLPMListModel findFirstByCriteria:sqlCriteria];
    NSString *lastDateline = pmTempModel ? pmTempModel.created_time : @"0";
    [paramDic setValue:@"0" forKey:@"createdTime"];
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            //            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *array = data[@"memberList"];
            if (error.integerValue == 0) {
                if ([array count] > 0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in array) {
                        
                        [tempArray addObject:[XZLPMListModel getPMListModelWithDic:dataDic isHistory:NO]];
                    }
                    int count = 0;
                    for (XZLPMListModel *model in tempArray) {
                        if ([model.unRead isEqualToString:@"1"]) {
                            count++;
                        }
                    }
                    if (count>0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnread object:[NSNumber numberWithInt:count]];
                    }
                }
                
            }else{
                
            }
        }
    } failure:^(NSError *error) {
        //        [loadView hide:YES];
        mAlertView(@"提示", @"获取数据失败，请检查网络");
        NSLog(@"failed block%@",error);
    }];
    
}

@end
