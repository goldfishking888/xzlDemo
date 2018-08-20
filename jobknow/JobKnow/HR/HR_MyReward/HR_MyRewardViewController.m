//
//  HR_MyRewardViewController.m
//  JobKnow
//
//  Created by Wangjinyu on 10/08/2015.
//  Copyright (c) 2015 Wangjinyu. All rights reserved.
// 奖金金额界面

#import "HR_MyRewardViewController.h"
#import "HR_MyRewardViewCell.h"
#import "MJRefresh.h"
//重新登录
#import "HrApplyCashViewController.h"
#import "AppDelegate.h"
#import "MyHrFamilyJumpViewController.h"
#import "MessageListModel.h"
#import "MessageDetailViewController.h"

#import "HR_ApplyCashWebViewController.h"

@interface HR_MyRewardViewController ()
{
    UILabel *noRewardLabel;
    UILabel *promptLabel;
    UIImageView *nilImageView;
    
    UILabel *tipsLabel;//目前处于哪个档位
    UIView *whiteView;//header 白背景
    
    UITableView *mainTableView;
    int sectionHeight;
    UIView *bottomBgView;
    UILabel *cashLabel;
    UILabel *cashLabel_all;
    UIButton *appCashButton;
    
//    MJRefreshHeaderView * header1;
   // MJRefreshFooterView * footer1;
    int pageIndex;
    MBProgressHUD *loadView;
    int refreshTime;
    NSUserDefaults *userDefaults;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * dataArray_resume;
@property (nonatomic,strong)NSMutableDictionary * dataDicAll;
//@property (nonatomic,strong)NSMutableDictionary * dataDicOfHRInfo;
@end

@implementation HR_MyRewardViewController

-(void)viewWillAppear:(BOOL)animated
{
    refreshTime ++;
    NSLog(@"refreshTime = %d",refreshTime);
    if (refreshTime > 1) {
        if(isPersonRecList){
            [self requestDataWithPage:1];
        }else if(!isPersonRecList&&!isWeb){
            [self requestResumeRecRewardWithPage:1];
        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    refreshTime = 0;
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    NSString *isFamily = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"is_family"]];
    isHRFamily = [isFamily isEqualToString:@"1"];
    pageIndex = 1;
    _dataArray_resume = [[NSMutableArray alloc] init];
    [self addBackBtn];
    [self addCenterTitle:@"奖金"];
    [self createWebView];
//    [self createMenuButtons];
//    [self createTableView];
//    [self requestBonusBarData];
//    [self createWebView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCashSuccess:) name:@"applyCashSuccess" object:nil];
//    [self requestDataWithPage:1];
//    NSUserDefaults * HRHomeDefault = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary * dicHuanCun = [HRHomeDefault valueForKey:@"HRReward"];
//    if (dicHuanCun != nil) {
//        self.dataDicAll = dicHuanCun;
//        [mainTableView reloadData];
//        [header1 beginRefreshing];
//        
//    }
//    else
//    {
//        [header1 beginRefreshing];
//        
//    }
    //[self createNil];
}

#pragma mark- Notif ApplyCashSuccess
-(void)applyCashSuccess:(NSNotification *)notif{
    [_webView reload];
}

-(void)createWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+ self.num, kMainScreenWidth,kMainScreenHeight - 44- self.num)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
//    [self initJsBridge];
//    if (!isHRFamily) {
//        [self createNoHRFamilyView];
//        return;
//    }
    //http://www.xzhiliao.com/ api/bonus/list/show? version=3.2.1&userToken=3db65c2a66e0255aafe1f38e5d66a356&userImei=868433027181654

    NSString *str = kCombineURL(KWWWXZhiLiaoAPI, HRMyRewardWeb);
//     NSString *urlStr = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@&version=%@",KXZhiLiaoAPI,HRInvite,kUserTokenStr,IMEI,kAppVersion];
    _jumpRequest = [NSString stringWithFormat:@"%@userToken=%@&userImei=%@&version=%@",str,kUserTokenStr,IMEI,kAppVersion];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_jumpRequest]]];
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}

-(void)createNoHRFamilyView{
    view_NoHrFamily = [[UIView alloc] initWithFrame:_webView.frame];
    UIImageView *image_nodata = [[UIImageView alloc] initWithFrame:CGRectMake(iPhone_width/2-68/2, 50, 68, 68)];
    [image_nodata setImage:[UIImage imageNamed:@"nodata1"]];
    [view_NoHrFamily addSubview:image_nodata];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image_nodata.frame.origin.y+image_nodata.frame.size.height +30, iPhone_width, 20)];
    [label setText:@"您目前还没有自己的人才经纪人家族~"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:color_lightgray];
    [view_NoHrFamily addSubview:label];
    
    //登录
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(30, label.frame.origin.y+label.frame.size.height +20, ([[UIScreen mainScreen] bounds].size.width)-60, 40);
    
    [button setTitle:@"去建立人才经纪人家族" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button.layer setCornerRadius:4];
    [button.layer setMasksToBounds:YES];
    [button addTarget:self action:@selector(clickCreateFamily) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [view_NoHrFamily addSubview:button];
    
    [self.view addSubview:view_NoHrFamily];

}

-(void)requestBonusBarData
{
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRBonusBarData);
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:GRBToken,@"userToken",
                             IMEI,@"userImei",nil];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"请求成功");
        
        NSString *count_bonus=[NSString stringWithFormat:@"%@",[resultDic valueForKey:@"count_bonus"]];
        allow_money=[NSString stringWithFormat:@"%@",[resultDic valueForKey:@"allow_money"]];
        [cashLabel setText:[NSString stringWithFormat:@"￥%@",allow_money]];
        [cashLabel_all setText:[NSString stringWithFormat:@"￥%@",count_bonus]];
   
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
    
}
#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    int pageIndex1 =1;
    // 取新
    if (isPersonRecList&&!isWeb ) {
        [self requestDataWithPage:pageIndex1];
    }else if(!isPersonRecList&&!isWeb){
        [self requestResumeRecRewardWithPage:pageIndex1];
    }
}

-(void)requestDataWithPage:(int)page
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    //http://api.xzhiliao.com/ hr_api/money/getMoneyList?
    NSString * url = kCombineURL(KXZhiLiaoAPI, HRRewardList);
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    
    paramDic = @{
                 @"userToken":GRBToken,
                 @"userImei":IMEI
//                 @"page":[NSNumber numberWithInt:pageIndex],
//                 @"count":@"20"
                 };
    
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            [loadView hide:YES];

        }

        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            self.dataDicAll = [resultDic mutableCopy];
            NSString *money = [NSString stringWithFormat:@"%@", self.dataDicAll[@"moneyCount"]];
//            if ([money isEqualToString:@""]||[money isEqualToString:@"0"]) {
//                bottomBgView.hidden = YES;
//                appCashButton.hidden = YES;
//            }else{
//                bottomBgView.hidden = NO;
//                appCashButton.hidden = NO;
//                cashLabel.text = [NSString stringWithFormat:@"%@", self.dataDicAll[@"moneyCount"]];
//
//            }
            if ([resultDic[@"moneyList"] count] == 0) {
                //没数据
                [loadView hide:YES];
                mainTableView.hidden = YES;
                whiteView.hidden = YES;
                [self createNil];
            }
            else
            {
                [self removeNil];
                [loadView hide:YES];
                mainTableView.hidden = NO;
                whiteView.hidden = NO;
                
//                //本地存储
//                NSUserDefaults * HRRewardDefault = [NSUserDefaults standardUserDefaults];
//                [HRRewardDefault setValue:self.dataDicAll forKey:@"HRReward"];
//                [HRRewardDefault synchronize];
                
                if (page == 1) {
                    [loadView hide:YES];
                    self.dataArray = [NSMutableArray arrayWithCapacity:0];
                    self.dataArray = [resultDic[@"moneyList"] mutableCopy];
                    [mainTableView reloadData];
                }
                else//返回的viewwillappear里面写的刷新.
                {
                    [loadView hide:YES];
                    self.dataArray = [NSMutableArray arrayWithCapacity:0];
                    self.dataArray = [resultDic[@"moneyList"] mutableCopy];
                    [mainTableView reloadData];
                }
            }
        }
    }];
    [request setFailedBlock:^{
        ghostView.message=@"请求失败";
        [ghostView show];
        [loadView hide:YES];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
    }];
    [request startAsynchronous];
}

-(void)requestResumeRecRewardWithPage:(int)page
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString * url = kCombineURL(KXZhiLiaoAPI, HRResumeRecRewardList);
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    
    paramDic = @{
                 @"userToken":GRBToken,
                 @"userImei":IMEI
                 };
    
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            [loadView hide:YES];

        }
        
        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            self.dataDicAll = [resultDic mutableCopy];
//            NSString *money = [NSString stringWithFormat:@"%@", self.dataDicAll[@"moneyCount"]];
//            if ([money isEqualToString:@""]||[money isEqualToString:@"0"]) {
//                bottomBgView.hidden = YES;
//                appCashButton.hidden = YES;
//            }else{
//                bottomBgView.hidden = NO;
//                appCashButton.hidden = NO;
//                cashLabel.text = [NSString stringWithFormat:@"%@", self.dataDicAll[@"moneyCount"]];
//                
//            }
            if ([resultDic[@"moneyList"] count] == 0) {
                //没数据
                [loadView hide:YES];
                mainTableView.hidden = YES;
                whiteView.hidden = YES;
//                bottomBgView.hidden = YES;
//                appCashButton.hidden = YES;
                [self createNil];
            }
            else
            {
                [self removeNil];
                [loadView hide:YES];
                mainTableView.hidden = NO;
                whiteView.hidden = NO;
//                bottomBgView.hidden = NO;
//                appCashButton.hidden = NO;
//                cashLabel.text = [NSString stringWithFormat:@"%@", self.dataDicAll[@"moneyCount"]];
                
                if (page == 1) {
                    [loadView hide:YES];
                    self.dataArray_resume = [NSMutableArray arrayWithCapacity:0];
                    self.dataArray_resume = [resultDic[@"moneyList"] mutableCopy];
                    [mainTableView reloadData];
                }
                else//返回的viewwillappear里面写的刷新.
                {
                    [loadView hide:YES];
                    self.dataArray_resume = [NSMutableArray arrayWithCapacity:0];
                    self.dataArray_resume = [resultDic[@"moneyList"] mutableCopy];
                    [mainTableView reloadData];
                }
            }
        }
    }];
    [request setFailedBlock:^{
        ghostView.message=@"请求失败";
        [ghostView show];
        [loadView hide:YES];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
    }];
    
    [request startAsynchronous];
}


-(void)createMenuButtons{
    NSArray *arr = @[@"人才经纪人家族",@"简历奖金",@"入职奖金"];
    float btn_width =iPhone_width/ arr.count;
    for (int i = 0; i<arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btn_width*i, 44 + (ios7jj), btn_width, 48)];
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setBackgroundImage:[UIImage imageNamed:@"my_reward_back"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"my_reward_back_press"] forState:UIControlStateSelected];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn_menu_web = btn;
            btn_menu_web.selected = YES;
            isWeb = btn_menu_web.selected;
            [self.view addSubview:btn_menu_web];
        }else if (i==1) {
            btn_menu_left = btn;
            btn_menu_left.selected = NO;
            isPersonRecList = btn_menu_left.selected;
            [self.view addSubview:btn_menu_left];
        }else if(i == 2){
            btn_menu_right = btn;
            btn_menu_right.selected = NO;
            [self.view addSubview:btn_menu_right];
        }
    }
}

-(void)createTableView
{
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + (ios7jj)+48, self.view.frame.size.width, self.view.frame.size.height - 44 - (ios7jj) - 42 -48)];
    mainTableView.backgroundColor = RGBA(243, 243, 243, 1);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 42, self.view.frame.size.width, 42)];
    bottomBgView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
    bottomBgView.layer.borderWidth = 1;
    [self.view addSubview:bottomBgView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 42)];
    priceLabel.text = @"待提现金额";
//    priceLabel.backgroundColor = [UIColor redColor];
    priceLabel.textColor = RGBA(92, 92, 92, 1);
    priceLabel.font = [UIFont systemFontOfSize:14];
    [bottomBgView addSubview:priceLabel];
    
    cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0,70, 42)];
    cashLabel.textColor = RGBA(255, 146, 4, 1);
//    [cashLabel setBackgroundColor:[UIColor greenColor]];
    cashLabel.font = [UIFont systemFontOfSize:12];
    [bottomBgView addSubview:cashLabel];
    
    UILabel *priceLabel_all = [[UILabel alloc] initWithFrame:CGRectMake(150, 0,40 , 42)];
    priceLabel_all.text = @"奖金总额";
//    priceLabel_all.backgroundColor = [UIColor redColor];
    priceLabel_all.textColor = RGBA(92, 92, 92, 1);
    priceLabel_all.font = [UIFont systemFontOfSize:10];
    [bottomBgView addSubview:priceLabel_all];
    
    cashLabel_all = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 80, 42)];
    cashLabel_all.textColor = RGBA(255, 146, 4, 1);
//    [cashLabel_all setBackgroundColor:[UIColor greenColor]];
    cashLabel_all.font = [UIFont systemFontOfSize:10];
    [bottomBgView addSubview:cashLabel_all];
    
    appCashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    appCashButton.frame = CGRectMake(bottomBgView.frame.size.width - 80,0, 80, 42);
    appCashButton.backgroundColor = [UIColor orangeColor];
    [appCashButton setTitle:@"申请提现" forState:UIControlStateNormal];
    [appCashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appCashButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [appCashButton addTarget:self action:@selector(appCashButtonCLick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:appCashButton];
    
}
- (void)createNil
{
    if (noRewardLabel) {
        if(isPersonRecList&&!isWeb){
            noRewardLabel.text = @"您还没有入职奖金";
        }else if (!isPersonRecList&&!isWeb){
            noRewardLabel.text = @"您还没有简历奖金";
        }
        noRewardLabel.hidden = NO;
    }else{
        noRewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + 44 + (ios7jj), self.view.frame.size.width, 12)];
        if(isPersonRecList&&!isWeb){
            noRewardLabel.text = @"您还没有入职奖金";
        }else if (!isPersonRecList&&!isWeb){
            noRewardLabel.text = @"您还没有简历奖金";
        }
        noRewardLabel.textColor = RGBA(143, 143, 143, 1);
        noRewardLabel.textAlignment = NSTextAlignmentCenter;
        noRewardLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:noRewardLabel];
    }
    
    
    if (nilImageView) {
        nilImageView.hidden = NO;
    }else{
        nilImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 130 + 44 + (ios7jj), 190, 207)];
        nilImageView.image = [UIImage imageNamed:@"hr_no_bonus.png"];
        [self.view addSubview:nilImageView];
    }
    
    
    if (promptLabel) {
        if(isPersonRecList&&!isWeb){
            promptLabel.text = @"去首页选职位推荐简历,推荐成功就可获得入职奖金";
        }else if (!isPersonRecList&&!isWeb){
            promptLabel.text = @"去首页选职位推荐简历,推荐成功就可获得简历奖金";
        }
        promptLabel.hidden = NO;
    }else{
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 388 + 44 + (ios7jj), self.view.frame.size.width, 30)];
        if(isPersonRecList&&!isWeb){
            promptLabel.text = @"去首页选职位推荐简历,推荐成功就可获得入职奖金";
        }else if (!isPersonRecList&&!isWeb){
            promptLabel.text = @"去首页选职位推荐简历,推荐成功就可获得简历奖金";
        }

        
        promptLabel.numberOfLines = 2;
        promptLabel.textColor = RGBA(143, 143, 143, 1);
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:promptLabel];
    }
    
}

- (void)removeNil
{
    noRewardLabel.hidden = YES;
    
    nilImageView.hidden = YES;
    
    promptLabel.hidden = YES;
}

#pragma mark- ButtonClicked
-(void)clickCreateFamily{
    MyHrFamilyViewController *vc = [[MyHrFamilyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isPersonRecList) {
        NSString *cellIdentifier = @"CellRec";
        HR_MyResumeRecRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[HR_MyResumeRecRewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = self.dataArray_resume[indexPath.row];
        return cell;

    }
    NSString *cellIdentifier = @"CellIdentifier";
    HR_MyRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HR_MyRewardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = self.dataArray[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isPersonRecList) {
        return self.dataArray.count;
    }
    return self.dataArray_resume.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isPersonRecList) {
        return 140;
    }
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (isPersonRecList) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (isPersonRecList) {
//        return sectionHeight;
//    }
    return 0;
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
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (_progressView) {
        [_progressView hide:YES];
    }
}

#pragma mark - 跳转一个新的网页
-(void)gotoNewWebViewWithJumpRequest:(NSURLRequest *)request
{
    MyHrFamilyJumpViewController *jumpViewController = [[MyHrFamilyJumpViewController alloc] init];
    [jumpViewController setJumpRequest:request];
    [self.navigationController pushViewController:jumpViewController animated:YES];
}

#pragma mark- buttonClick

-(void)menuBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        btn_menu_web.selected = YES;
        btn_menu_left.selected = NO;
        btn_menu_right.selected = NO;
        isPersonRecList = NO;
        isWeb = YES;
        [self removeNil];
        mainTableView.hidden = YES;
        if (!isHRFamily) {
            view_NoHrFamily.hidden = NO;
            return;
        }else{
            _webView.hidden = NO;
            [_webView reload];
            
        }
        
//        if (_dataArray.count ==0) {
//            [self loadDataOfHRReward:nil];
//        }else{
//            [mainTableView reloadData];
//            [self loadDataOfHRReward:nil];
//        }
    }else if (btn.tag == 1) {
        btn_menu_web.selected = NO;
        btn_menu_left.selected = YES;
        btn_menu_right.selected = NO;
        isPersonRecList = NO;
        isWeb = NO;
        _webView.hidden = YES;
        view_NoHrFamily.hidden = YES;
        mainTableView.hidden = NO;
        if (_dataArray_resume.count ==0) {
            [self requestResumeRecRewardWithPage:1];
        }else{
            [mainTableView reloadData];
            [self requestResumeRecRewardWithPage:1];
        }
    }else if(btn.tag == 2){
        btn_menu_web.selected = NO;
        btn_menu_left.selected = NO;
        btn_menu_right.selected = YES;
        isPersonRecList = YES;
        isWeb = NO;
        _webView.hidden = YES;
        view_NoHrFamily.hidden = YES;
        mainTableView.hidden = NO;
        if (_dataArray.count ==0) {
            [self requestDataWithPage:1];
        }else{
            [mainTableView reloadData];
            [self requestDataWithPage:1];
        }
    }
}



- (void)appCashButtonCLick
{
    NSLog(@"appCashButtonClick");
//    HrApplyCashViewController *hrApplyCashVc = [[HrApplyCashViewController alloc] init];
//    hrApplyCashVc.appleType = HrApplyCashTypeOfInvite;
//    //最低为100，且为100的倍数
//    hrApplyCashVc.money = [NSString stringWithFormat:@"%d",[allow_money intValue]/100*100];
//    [self.navigationController pushViewController:hrApplyCashVc animated:YES];
    
    HR_ApplyCashWebViewController *acVC = [[HR_ApplyCashWebViewController alloc] init];
    NSString *urlstr = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@",KXZhiLiaoAPI,@"common/page_secret/apply_cash?",kUserTokenStr,IMEI];
    acVC.jumpRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    [self.navigationController pushViewController:acVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
