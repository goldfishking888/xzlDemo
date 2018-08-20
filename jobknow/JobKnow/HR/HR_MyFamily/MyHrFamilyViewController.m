//
//  MyHrFamilyViewController.m
//  JobKnow
//
//  Created by admin on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "MyHrFamilyViewController.h"
#import "WebViewJavascriptBridge.h"
#import "MyHrFamilyJumpViewController.h"
#import "MessageDetailViewController.h"
#import "MessageListViewController.h"
#import "HrApplyCashViewController.h"
#import "MBProgressHUD.h"
#import "HR_MyCardViewController.h"
#import "AgentBonusIntroViewController.h"
#import "HR_ApplyCashWebViewController.h"

@interface MyHrFamilyViewController ()

@property WebViewJavascriptBridge* bridge;
@property MBProgressHUD *progressView;

@end

@implementation MyHrFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightBarBtnItem:@"bonus_job_message" WithXtoRight:40.0f WithWidth:30.0f WithHeight:30.0f];
    [self addCenterTitle:@"人才经纪人家族"];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    [self initJsBridge];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@&version=%@",KXZhiLiaoAPI,HRInvite,kUserTokenStr,IMEI,kAppVersion];
    NSLog(@"邀请家族URL=%@",urlStr);
    [self loadWebPageWithString:urlStr];
    
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCashSuccess:) name:@"applyCashSuccess" object:nil];

    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mUserDefaults valueForKey:@"HRFamilyWindow"]];
//    if (!dic) {
//        dic = [[NSMutableDictionary alloc] init];
//    }
//    if (![dic valueForKey:[mUserDefaults valueForKey:@"userUid"]]) {
//        [self addAgentBonusWindow];
//        [dic setValue:@"1" forKey:[mUserDefaults valueForKey:@"userUid"]];
//        [mUserDefaults setValue:(NSDictionary *)dic forKey:@"HRFamilyWindow"];
//    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Notif ApplyCashSuccess
-(void)applyCashSuccess:(NSNotification *)notif{
    [_webView reload];
}

-(void)addAgentBonusWindow{
    _introView_back = [[UIView alloc] initWithFrame:self.view.frame];
    _introView_back.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.75];
    //    introView_back.backgroundColor = [UIColor blackColor];
    UIView *introView_imageback = [[UIView alloc] initWithFrame:CGRectMake(160-92, 100, 185, 240)];
    [introView_imageback.layer setCornerRadius:4];
    [introView_imageback.layer setMasksToBounds:YES];
    introView_imageback.backgroundColor = [UIColor whiteColor];
    [_introView_back addSubview:introView_imageback];
    
    
    UIImageView *introView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 155, 180)];
    [introView setImage:[UIImage imageNamed:@"hr_proxybonus_content"]];
    [introView.layer setCornerRadius:4];
    [introView.layer setMasksToBounds:YES];
    introView.backgroundColor = [UIColor whiteColor];
    [introView_imageback addSubview:introView];
    
    UIButton *imagePointB = [[UIButton alloc] initWithFrame:CGRectMake(introView_imageback.frame.size.width -24, 0, 24, 24)];
    [imagePointB setImage:[UIImage imageNamed:@"resume_manage_delete"] forState:UIControlStateNormal];
    [imagePointB addTarget:self action:@selector(closebutton_Click) forControlEvents:UIControlEventTouchUpInside];
    [introView addSubview:imagePointB];
    [_introView_back setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introView_backClick)];
    [_introView_back addGestureRecognizer:tap];
    [introView_imageback addSubview:imagePointB];
    
    UIButton *goSeeSeeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, introView.frame.origin.y+introView.frame.size.height, 145, 30)];
    [goSeeSeeBtn.layer setCornerRadius:4];
    [goSeeSeeBtn.layer setMasksToBounds:YES];
    goSeeSeeBtn.backgroundColor = [UIColor colorWithHex:0xff7204 alpha:1];
    [goSeeSeeBtn setTitle:@"去看看怎么玩" forState:UIControlStateNormal];
    [goSeeSeeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goSeeSeeBtn addTarget:self action:@selector(clickAgentBonusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [introView_imageback addSubview:goSeeSeeBtn];
    
    [self.view addSubview:_introView_back];

    _introView_back.center = self.view.center;
    introView_imageback.center = _introView_back.center;
}

-(void)introView_backClick{
    _introView_back.hidden = YES;
}

-(void)closebutton_Click{
    _introView_back.hidden = YES;
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
//    }];
    
//    //成为企业会员
    [_bridge registerHandler:@"toVip" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"toVip %@", data);

        NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            
            [weakSelf gotoNewWebViewWithJumpRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xzhiliao.com/wap/download.html"]]];
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    //申请私信
    [_bridge registerHandler:@"applyAuthorize" handler:^(id data, WVJBResponseCallback responseCallback) {

        NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"666666",@"companyId",nil];
        NSString *urlStr = kCombineURL(KXZhiLiaoAPI,kGetPlidWithCompanyId);
        NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
        [request setCompletionBlock:^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *responseStr = [NSString stringWithFormat:@"%@",request.responseString];
            MessageDetailViewController *messageVC = [[MessageDetailViewController alloc] init];
            MessageListModel *info = [MessageListModel new];
            info.soureId = @"666666";//小职了团队id
            info.plid = responseStr;
            info.name = @"小职了团队";
            messageVC.message = info;
            messageVC.isFromHr = YES;
            messageVC.defautText = @"我申请建立人才经纪人家族的权限";
            [self.navigationController pushViewController:messageVC animated:YES];
            
        }];
        [request setFailedBlock:^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [request startAsynchronous];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];
    
    //   申请HR认证
    [_bridge registerHandler:@"toHRRenZheng" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"toHRRenZheng %@", data);
        HR_MyCardViewController *vc = [[HR_MyCardViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}

#pragma mark - 右按钮点击事件
-(void)onClickRightBtn:(id)sender
{
    MessageListViewController *jobCollectVC = [[MessageListViewController alloc] init];
    [self.navigationController pushViewController:jobCollectVC animated:YES];
}

#pragma mark - 右按钮点击事件
-(void)clickAgentBonusBtn:(id)sender
{
    AgentBonusIntroViewController *agentBonusIntroViewController = [[AgentBonusIntroViewController alloc] init];
    [self.navigationController pushViewController:agentBonusIntroViewController animated:YES];
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
    //发展我的家族
    if ([request.URL.absoluteString rangeOfString:@"hr_api/invite/invite_page?"].length > 0){
        [self gotoNewWebViewWithJumpRequest:request];
        return NO;
    }
    //规则详情页面
    if ([request.URL.absoluteString rangeOfString:@"hr_api/invite/invite_rule?"].length > 0){
        [self gotoNewWebViewWithJumpRequest:request];
        return NO;
    }
    //电话
    if ([request.URL.absoluteString rangeOfString:@"family/web_call?"].length > 0){
        NSRange range = [request.URL.absoluteString rangeOfString:@"mobile="];
        NSString *mobile = [request.URL.absoluteString substringFromIndex:(range.location+range.length)];
        NSString * str = [NSString stringWithFormat:@"tel:%@",mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        return NO;
    }
    //消息
    if ([request.URL.absoluteString rangeOfString:@"family/web_chat?"].length > 0){
        NSRange range01 = [request.URL.absoluteString rangeOfString:@"destName="];
        NSRange range02 = [request.URL.absoluteString rangeOfString:@"&destId="];
        NSRange range03 = [request.URL.absoluteString rangeOfString:@"&text="];
        NSString *destName = [request.URL.absoluteString substringWithRange:NSMakeRange(range01.location+range01.length, range02.location-range01.location-range01.length)];
        NSString *destId = [request.URL.absoluteString substringWithRange:NSMakeRange(range02.location+range02.length, range03.location-range02.location-range02.length)];
        NSString *text = [request.URL.absoluteString substringFromIndex:range03.location+range03.length];
        destName = [destName stringByRemovingPercentEncoding];
        text = [text stringByRemovingPercentEncoding];
        
        
        NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",destId,@"companyId",nil];
        NSString *urlStr = kCombineURL(KXZhiLiaoAPI,kGetPlidWithCompanyId);
        NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
        [request setCompletionBlock:^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *responseStr = [NSString stringWithFormat:@"%@",request.responseString];
            MessageDetailViewController *messageVC = [[MessageDetailViewController alloc] init];
            MessageListModel *info = [MessageListModel new];
            info.name = destName;
            info.soureId = destId;
            info.plid = responseStr;
            messageVC.message = info;
            messageVC.isFromHr = YES;
            messageVC.defautText = text;
            [self.navigationController pushViewController:messageVC animated:YES];

        }];
        [request setFailedBlock:^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [request startAsynchronous];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        return NO;
    }
    //立即提现
    if ([request.URL.absoluteString rangeOfString:@"family/web_cash?"].length > 0){
//        NSRange range = [request.URL.absoluteString rangeOfString:@"money="];
//        NSString *money = [request.URL.absoluteString substringFromIndex:(range.location+range.length)];
//        HrApplyCashViewController *vc = [[HrApplyCashViewController alloc] init];
//        vc.appleType = HrApplyCashTypeOfInvite;
//        vc.money = money;
//        [self.navigationController pushViewController:vc animated:YES];
        HR_ApplyCashWebViewController *acVC = [[HR_ApplyCashWebViewController alloc] init];
        NSString *urlstr = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@",KXZhiLiaoAPI,@"common/page_secret/apply_cash?",kUserTokenStr,IMEI];
        acVC.jumpRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
        [self.navigationController pushViewController:acVC animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_progressView) {
        [_progressView hide:YES];
    }
//    //代理奖金弹窗，从未看过显示，之后不显示
    //已废弃 存活于2.8.8
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString * userUidStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"userUid"]];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"IsSeenDelegateWindow"]];
//    if (!dic) {
//        dic = [[NSMutableDictionary alloc] init];
//    }
//    if([[dic valueForKey:userUidStr] isKindOfClass:[NSNull class]]||![dic valueForKey:userUidStr]){
//        [self addAgentBonusWindow];
//        [dic setValue:@"1" forKey:userUidStr];
//        [defaults setObject:dic forKey:@"IsSeenDelegateWindow"];
//    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (_progressView) {
        [_progressView hide:YES];
    }
}
@end
