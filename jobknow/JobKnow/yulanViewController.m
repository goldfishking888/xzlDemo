//
//  yulanViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "yulanViewController.h"

@interface yulanViewController ()

@end

@implementation yulanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"简历预览"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"简历预览"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, iPhone_height-44)];
    webView.delegate= self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [self addBackBtn];
    [self addTitleLabel:@"简历预览"];
    
    ResumeOperation *st = [ResumeOperation defaultResume];
    NSString *urlString = [st.resumeDictionary valueForKey:@"userjlUrl"];
    NSLog(@"urlString is %@",urlString);
    
    if (urlString) {
        NSURL *url = [NetWorkConnection dictionaryBecomeUrl:nil urlString:urlString];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else
    {
        ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
        ghostView.position=OLGhostAlertViewPositionCenter;
        ghostView.message=@"网络异常，请检查您的网络";
        [ghostView show];
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad.........");
    [loadView hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError........");
    
    ghostView.message=@"网络异常，请检查您的网络";
    
    [ghostView show];
    
    [loadView hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end