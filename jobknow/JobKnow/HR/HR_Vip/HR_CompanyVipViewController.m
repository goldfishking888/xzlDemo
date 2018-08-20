//
//  HR_CompanyVipViewController.m
//  JobKnow
//
//  Created by Jiang on 15/8/16.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_CompanyVipViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MBProgressHUD.h"
#import "MyHrFamilyJumpViewController.h"

@interface HR_CompanyVipViewController ()

@property WebViewJavascriptBridge* bridge;
@property MBProgressHUD *progressView;

@end

@implementation HR_CompanyVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightBarBtnItem:@"hr_circle_share" WithXtoRight:40.0f WithWidth:30.0f WithHeight:30.0f];
    [self addCenterTitle:@"企业会员"];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    [self initJsBridge];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@",KXZhiLiaoAPI,@"hr_api/buy/company_v?",kUserTokenStr,IMEI];
//    NSString *urlStr = @"http://api.xzhiliao.com/hr_api/invite/invite_page?userToken=2529e45bbd8ecd12e4013bf8ee401bda&userImei=f4a39eff0b657ede6cbf249379a6550f6469949a";
    [self loadWebPageWithString:urlStr];
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化jsBridge
- (void) initJsBridge{
    
    if (_bridge) {
        return;
    }
    __block typeof(self) weakSelf = self;
    [WebViewJavascriptBridge enableLogging];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        responseCallback(@"WebViewJavascriptBridge connect");
//        
//    }];
    
    
    //成为企业会员
    [_bridge registerHandler:@"toEnterpriseVip" handler:^(id data, WVJBResponseCallback responseCallback) {

        NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            
            [weakSelf gotoNewWebViewWithJumpRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xzhiliao.com/wap/download.html"]]];
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }];
}

#pragma mark - 右按钮点击事件
-(void)onClickRightBtn:(id)sender
{
//    NSString *shareTitle = @"招聘难？看过来！";
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.tencentData.title = shareTitle;
//    
//    NSString *shareLink = [NSString stringWithFormat:@"http://xj.xzhiliao.com/hr/company_v?code=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"inviteId"]];
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareLink;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareLink;
//    [UMSocialData defaultData].extConfig.qqData.url = shareLink;
//    [UMSocialData defaultData].extConfig.qzoneData.url = shareLink;
//    
//    NSString *shareText = [NSString stringWithFormat:@"小职了HR圈让你快速、准确地抓到需要的人才！招聘不痛，夏日轻松~%@",shareLink];
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"招聘难？看过来！加入小职了企业会员，让你快速、准确地抓到需要的人才！招聘不痛，夏日轻松~%@",shareLink];
//    [UMSocialData defaultData].extConfig.tencentData.shareText = [NSString stringWithFormat:@"招聘难？看过来！加入小职了企业会员，让你快速、准确地抓到需要的人才！招聘不痛，夏日轻松~%@",shareLink];
//    if ([XZLUtil isShareAppInstalled] == NO) {
//        mAlertView(nil, @"未发现分享所需的客户端");
//        return;
//    }
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToTencent,nil] delegate:nil];
}

#pragma mark - 跳转一个新的网页
-(void)gotoNewWebViewWithJumpRequest:(NSURLRequest *)request
{
    MyHrFamilyJumpViewController *jumpViewController = [[MyHrFamilyJumpViewController alloc] init];
    [jumpViewController setJumpRequest:request];
    [self.navigationController pushViewController:jumpViewController animated:YES];
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

@end
