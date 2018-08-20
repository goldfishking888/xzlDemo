//
//  XZLCommonWebViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/29.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "XZLCommonWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SDWebImageManager.h"

@interface XZLCommonWebViewController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation XZLCommonWebViewController{
    UIWebView *_webView;
    MBProgressHUD *loadView;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [WebConsole enable];
    
    [self addBackBtnGR];
    [self addTitleLabelGR:_titleStr];
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 44+20,kMainScreenWidth,kMainScreenHeight-44-20);
    // 设置可以支持缩放
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    [self initJSBridge];
    
    [self setCookies];
}

- (void)backUp:(id)sender
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)initJSBridge{
    if (_bridge) {
        return;
    }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    
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
    
    [_bridge registerHandler:@"finish" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![_webView canGoBack]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

-(void)setCookies{
    NSString *hostString = kTestAPPAPIGR;
    if ([hostString hasPrefix:@"http://"]) {
        hostString = [hostString substringFromIndex:8];
    }
    
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
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    loadView.hidden = YES;
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
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
