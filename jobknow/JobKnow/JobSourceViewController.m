//
//  JobSourceViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "JobSourceViewController.h"
//#import "AttributedLabel.h"
//#import "ReportViewController.h"
//#import "MJSecondDetailViewController.h"
//#import "UIViewController+MJPopupViewController.h"
//#import "SaveCount.h"
//#import "cnvUILabel.h"
//#import "CityInfo.h"
//#import <CoreText/CoreText.h>
//#import <QuartzCore/QuartzCore.h>
//#import "TipView.h"
//@interface JobSourceViewController () <MJSecondPopupDelegate>{
//    MJSecondDetailViewController *secondDetailViewController;
//}
@interface JobSourceViewController ()
@end
@implementation JobSourceViewController

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位来源"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位来源"];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CityInfo *ci = [CityInfo standerDefault];
    NSString *citya = [[NSString alloc]initWithFormat:@"职位来源"];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, iPhone_height-44)];
    webView.delegate= self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [self addBackBtn];
    [self addTitleLabel:citya];
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, @"from_source?");
    
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:ci.cityCode,LocaCity, nil];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:dic urlString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled = NO;
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
