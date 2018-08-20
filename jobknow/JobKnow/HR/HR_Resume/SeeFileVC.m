//
//  SeeFileVCViewController.m
//  XzlEE
//
//  Created by Jiang on 15/10/10.
//  Copyright © 2015年 xzhiliao. All rights reserved.
//

#import "SeeFileVC.h"

@interface SeeFileVC ()<UIWebViewDelegate>{
    UIWebView *_webView;
}

@end

@implementation SeeFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:_fileTitle];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, iPhone_width, iPhone_height-64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_requestUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{

//}

@end
