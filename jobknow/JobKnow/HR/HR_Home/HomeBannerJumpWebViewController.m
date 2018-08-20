//
//  HomeBannerJumpWebViewController.m
//  JobKnow
//
//  Created by Suny on 15/12/25.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "HomeBannerJumpWebViewController.h"
#import "OLGhostAlertView.h"
#import "SeeFileVC.h"
#import "VoiceConverter.h"

@implementation HomeBannerJumpWebViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    
    num=ios7jj;
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:self.floog];
    
    Net *n=[Net standerDefault];
    if (n.status ==NotReachable) {
        ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:@"" timeout:2 dismissible:NO];
        ghostView.position = OLGhostAlertViewPositionCenter;
        ghostView.message=@"无网络连接,请检查您的网络";
        [ghostView show];
        return;
    }
    self.myWebView = [[UIWebView alloc]init];
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
    
    int num=ios7jj;
    self.myWebView.frame = CGRectMake(0, 44+num,iPhone_width,iPhone_height-44-num);
    isFirst = YES;
    
    // 设置可以支持缩放
    [self.myWebView setScalesPageToFit:YES];
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled = NO;
    
    [self myWebViewRequestNetWithUrlStr:_urlStr];
}

-(void)viewWillAppear:(BOOL)animated{
    if (isFirst) {
        isFirst = NO;
        return;
    }else{
        [_myWebView reload];
    }
    
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
    [self.myWebView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    NSString *newUrl = [[NSString alloc] initWithFormat:@"%@",webView.request.URL];
    textField.text = newUrl;
    [loadView hide:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"--------------fail");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
   
    return YES;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
