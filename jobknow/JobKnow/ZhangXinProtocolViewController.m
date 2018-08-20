//
//  ZhangXinProtocolViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ZhangXinProtocolViewController.h"

@interface ZhangXinProtocolViewController ()

@end

@implementation ZhangXinProtocolViewController

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
    [self addTitleLabel:@"涨薪宝协议"];
    
    num=ios7jj;
    
	_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num)];
    
    _webView.delegate=self;
    
    [self.view addSubview:_webView];
    
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"zhangxinbao" ofType:@"html"];
    
    NSString *htmlString=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    loadView =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadView hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadView hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end