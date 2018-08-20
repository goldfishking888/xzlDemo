//
//  ZhiFuBaoViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-29.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ZhiFuBaoViewController.h"
#import "ZhangXinBaoViewController.h"
@interface ZhiFuBaoViewController ()

@end

@implementation ZhiFuBaoViewController

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
    
    [self addTitleLabel:@"支付宝"];
    
    num=ios7jj;
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num)];
    
    _webView.delegate=self;
    
    [self.view addSubview:_webView];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:_URL];
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_webView loadRequest:request];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor=[UIColor clearColor];
    backBtn.frame = CGRectMake(iPhone_width-85,-3+num,65,50);
    backBtn.showsTouchWhenHighlighted=YES;
    backBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [backBtn  setTitle:@"返回首页" forState:UIControlStateNormal];
    [backBtn  setTitle:@"返回首页" forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backBtnClick:(id)sender
{
    ZhangXinBaoViewController *zvc=[[ZhangXinBaoViewController alloc]init];
    [self.navigationController pushViewController:zvc animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadView hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadView hide:YES];
    
    ghostView.message=@"网页加载失败";

    [ghostView show];
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