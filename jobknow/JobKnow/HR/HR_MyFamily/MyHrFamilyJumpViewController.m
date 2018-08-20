//
//  MyHrFamilyJumpViewController.m
//  JobKnow
//
//  Created by admin on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "MyHrFamilyJumpViewController.h"
#import "WebViewJavascriptBridge.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "OLGhostAlertView.h"

@interface MyHrFamilyJumpViewController (){
    
    OLGhostAlertView *_ghostView;
}

@property WebViewJavascriptBridge* bridge;
@property MBProgressHUD *progressView;

@end

@implementation MyHrFamilyJumpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"人才经纪人家族"];
    
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
    
    //保存图片
    [_bridge registerHandler:@"save" handler:^(id data, WVJBResponseCallback responseCallback) {

        NSString *link = [(NSDictionary *)data objectForKey:@"link"];
        [weakSelf saveImageToAlbumWithUrl:[NSString stringWithFormat:@"%@",link]];
    }];
    //点击复制
    [_bridge registerHandler:@"copyCode" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *code = [(NSDictionary *)data objectForKey:@"code"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",code];
        _ghostView.message = @"邀请码复制成功";
        [_ghostView show];
    }];
    
}

#pragma mark - 保存图片
-(void)saveImageToAlbumWithUrl:(NSString *)imgUrl{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:nil completed:^(UIImage *image,NSData *data,NSError *error, BOOL finished){
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
    }];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"保存成功";
    }else
    {
        message = @"保存失败";
    }
    _ghostView.message = message;
    [_ghostView show];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
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
