//
//  UserProtocolVC.m
//  JobKnow
//
//  Created by ralbatr on 15/7/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "UserProtocolVC.h"

@interface UserProtocolVC ()<UIWebViewDelegate>
{
    UIWebView *_WebView;
}

@end

@implementation UserProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"用户协议"];
    _WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, iPhone_width, iPhone_height-64)];
    _WebView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xzlxieyi" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   [_WebView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:path]];
    
    [self.view addSubview:_WebView];
    // Do any additional setup after loading the view.
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
