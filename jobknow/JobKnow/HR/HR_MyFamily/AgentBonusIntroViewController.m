//
//  AgentBonusIntroViewController.m
//  JobKnow
//
//  Created by Suny on 15/11/10.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "AgentBonusIntroViewController.h"
#import "MBProgressHUD.h"

@interface AgentBonusIntroViewController ()

@property MBProgressHUD *progressView;

@end

@implementation AgentBonusIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"代理奖金"];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,HRAgentBonus];
    NSLog(@"代理奖金介绍页URL=%@",urlStr);
    [self loadWebPageWithString:urlStr];
    
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}

#pragma mark - 加载一个链接
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
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
