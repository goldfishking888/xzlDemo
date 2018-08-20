//
//  ProtocolViewController.m
//  JobKnow
//
//  Created by Zuo on 14-1-23.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        num=ios7jj;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"用户协议"];
    
	_webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44)];
    _webView.delegate=self;
    [self.view addSubview:_webView];
    
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"xzlxieyi" ofType:@"html"];
    NSString *htmlString=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
