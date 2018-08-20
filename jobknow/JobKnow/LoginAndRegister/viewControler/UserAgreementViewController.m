//
//  UserAgreementViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()<UIWebViewDelegate>
{
    UIWebView *_WebView;
}


@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"用户协议"];
    _WebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, iPhone_width, iPhone_height-64)];
    _WebView.delegate = self;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"xzlxieyi" ofType:@"html"];
    NSString *htmlStr = @"http://test.appapi.xzhiliao.com/xzlxieyi.html";
    NSURL *url = [NSURL URLWithString:htmlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_WebView loadRequest:request];
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
