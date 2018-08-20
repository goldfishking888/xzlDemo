//
//  getRedEnvelopeViewController.m
//  JobKnow
//
//  Created by Apple on 14-8-5.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "getRedEnvelopeViewController.h"
#import "WXApi.h"

@interface getRedEnvelopeViewController ()

@property (nonatomic,strong)NSString *redEnvelopeStr;

@end

@implementation getRedEnvelopeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:_getString];
    
    num=ios7jj;

    if ([_getString isEqualToString:@"抢红包"]) {
        
        _redEnvelopeStr=@"http://xj.xzhiliao.com/xzhiliao_hongbao/robRed?ios=1";
        
    }else
    {
        _redEnvelopeStr=@"http://xj.xzhiliao.com/xzhiliao_hongbao/sendRed?ios=1";
    }
    
    NSURL *URL=[NSURL URLWithString:_redEnvelopeStr];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:URL];
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num)];
    
    _webView.delegate=self;
    
    [_webView stringByEvaluatingJavaScriptFromString:@""];
    
    [self.view addSubview:_webView];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    loadView.userInteractionEnabled=NO;
    
    [_webView loadRequest:request];
}

#pragma mark UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadView hide:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadView hide:YES];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString isEqualToString:@"objc://requestFromJs"]) {
        [self shareBtnClick:nil];
    }
    
    return YES;
}

#pragma mark  功能函数

- (void)shareBtnClick:(id)sender
{
   
}

- (void)backUp:(id)sender
{
    if ([_webView canGoBack]) {
        
        [_webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
