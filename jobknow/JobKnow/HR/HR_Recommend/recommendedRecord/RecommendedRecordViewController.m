//
//  RecommendedRecordViewController.m
//  FreeChat
//
//  Created by WangJinyu on 5/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
// 推荐记录

#import "RecommendedRecordViewController.h"
#import "RecommendedRecordCell.h"
#import "PositionRecommandViewController.h"
#import "MJRefresh.h"
//#import "MJRefreshHeaderView.h"
//#import "MJRefreshFooterView.h"
#import "MBProgressHUD.h"
//重新登录
#import "AppDelegate.h"
@interface RecommendedRecordViewController ()
{
    UITableView *mainTableView;
    
    UILabel *noRecommendLabel;
    UIImageView *nilImageView;
    UILabel *promptLabel;
    int pageIndex;
    int pageIndex_resume;
    MBProgressHUD *loadView;
//    MJRefreshHeaderView * header;
//    MJRefreshFooterView * footer;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArray_resume;
@property (nonatomic,strong) NSMutableDictionary * dataDicAll;
@end

@implementation RecommendedRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 1;
    pageIndex_resume = 1;
    isResumeRec = NO;
     self.view.backgroundColor=RGBA(241, 239, 240, 1);
    self.dataArray = [[NSMutableArray alloc] init];
    self.dataArray_resume = [[NSMutableArray alloc] init];
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    [self addBackBtn];
    [self addCenterTitle:@"推荐记录"];
    [self createWebView];

//    [self createMenuButtons];
//    [self createTableView];
//    [self requestDataWithPage:pageIndex];
}
-(void)createWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44+ self.num, kMainScreenWidth,kMainScreenHeight - 44- self.num)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    //    [self initJsBridge];
    
    //http://www.xzhiliao.com/api/job/recommend/show?version=3.2.1&userToken=3db65c2a66e0255aafe1f38e5d66a356&userImei=868433027181654
    
    NSString *str = kCombineURL(KWWWXZhiLiaoAPI, HRMyRecommendedRecordWeb);
    //     NSString *urlStr = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@&version=%@",KXZhiLiaoAPI,HRInvite,kUserTokenStr,IMEI,kAppVersion];
    //@"page":[NSNumber numberWithInt:page],
    //@"count":@"20",

    _jumpRequest = [NSString stringWithFormat:@"%@userToken=%@&userImei=%@&version=%@&count=%@",str,kUserTokenStr,IMEI,kAppVersion,@"500"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_jumpRequest]]];
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    //发展我的家族
//    if ([request.URL.absoluteString rangeOfString:@"hr_api/invite/invite_page?"].length > 0){
//        [self gotoNewWebViewWithJumpRequest:request];
//        return NO;
//    }
//    //规则详情页面
//    if ([request.URL.absoluteString rangeOfString:@"hr_api/invite/invite_rule?"].length > 0){
//        [self gotoNewWebViewWithJumpRequest:request];
//        return NO;
//    }
//    //电话
//    if ([request.URL.absoluteString rangeOfString:@"family/web_call?"].length > 0){
//        NSRange range = [request.URL.absoluteString rangeOfString:@"mobile="];
//        NSString *mobile = [request.URL.absoluteString substringFromIndex:(range.location+range.length)];
//        NSString * str = [NSString stringWithFormat:@"tel:%@",mobile];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
//        return NO;
//    }
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
//    MyHrFamilyJumpViewController *jumpViewController = [[MyHrFamilyJumpViewController alloc] init];
//    [jumpViewController setJumpRequest:request];
//    [self.navigationController pushViewController:jumpViewController animated:YES];
}
-(void)createMenuButtons{
    NSArray *arr = @[@"人才推荐",@"简历推荐"];
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
            btn_menu_left = btn;
            btn_menu_left.selected = YES;
           
            [self.view addSubview:btn_menu_left];
        }else if(i == 1){
            btn_menu_right = btn;
            btn_menu_right.selected = NO;
            [self.view addSubview:btn_menu_right];
        }
    }
}

- (void)requestDataWithPage:(int)page
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url = kCombineURL(KWWWXZhiLiaoAPI, HRRecommendList);
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
//    kAppVersion&version=%@
    NSString * tokenStr = GRBToken;
    
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    paramDic = @{
                 @"userToken":GRBToken,
                 @"userImei":IMEI,
                 @"page":[NSNumber numberWithInt:page],
                 @"count":@"20",
                 @"list_type":@"0",
                 @"version":kAppVersion//新添加version字段
                 };
    
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        if([mainTableView isFooterRefreshing] == YES){
            [mainTableView footerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDics=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDics valueForKey:@"error"];
        

        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            NSDictionary * resultDic = resultDics[@"data"];
            self.dataDicAll = [resultDic mutableCopy];
            //本地存储 把所有的对象保存在 HRRecommendedDic里
//            NSUserDefaults * HR_recommendedDefault = [NSUserDefaults standardUserDefaults];
//            [HR_recommendedDefault setValue:self.dataDicAll forKey:@"HRRecommendedDic"];
//            [HR_recommendedDefault synchronize];
            
            NSLog(@"self.dataDicAll是-----***%@",self.dataDicAll);
            //self.dataArray = [[resultDic objectForKey:@"data"] mutableCopy];
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
                if ([[resultDic objectForKey:@"list"] count] > 0)
                {
                    self.dataArray = [[resultDic objectForKey:@"list"] mutableCopy];
//                    if (!mainTableView)
//                    {
//                        [noRecommendLabel removeFromSuperview];
//                        [nilImageView removeFromSuperview];
//                        [promptLabel removeFromSuperview];
//                        [self createTableView];
//                    }
                    if(!mainTableView){
                        [self createTableView];
                    }
                    [mainTableView reloadData];
                }
                else
                {
                    ghostView.message=@"暂无推荐记录";
                    [ghostView show];
                    if (self.dataArray.count == 0)
                    {
                        [mainTableView removeFromSuperview];
                        mainTableView=nil;
                        [self createNil];
                    }
                }
                
            }
            else//refresh == footer
            {
                if ([[resultDic objectForKey:@"list"] count] > 0)
                {
                    [self.dataArray addObjectsFromArray:[resultDic objectForKey:@"list"]];
//                    if (!mainTableView)
//                    {
//                        [noRecommendLabel removeFromSuperview];
//                        [nilImageView removeFromSuperview];
//                        [promptLabel removeFromSuperview];
//                        [self createTableView];
//                    }
                    [mainTableView reloadData];
                }
                else
                {
                    ghostView.message=@"暂无更多数据";
                    [ghostView show];
                    if (self.dataArray.count == 0)
                    {
//                        [mainTableView removeFromSuperview];
                        [self createNil];
                    }
                }
            }
        }
        [loadView hide:YES];
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message=@"请求失败";
        [ghostView show];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        if([mainTableView isFooterRefreshing] == YES){
            [mainTableView footerEndRefreshing];
        }
        NSLog(@"请求失败");
    }];

    [request startAsynchronous];
}

- (void)requestesumeRecDataWithPager:(int)page
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url = kCombineURL(KXZhiLiaoAPI, HRRecommendList);
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    NSString * tokenStr = GRBToken;
    
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    paramDic = @{
                 @"userToken":GRBToken,
                 @"userImei":IMEI,
                 @"page":[NSNumber numberWithInt:page],
                 @"count":@"20",
                 @"list_type":@"1"
                 };

    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        if([mainTableView isFooterRefreshing] == YES){
            [mainTableView footerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];

        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            self.dataDicAll = [resultDic mutableCopy];
            //本地存储 把所有的对象保存在 HRRecommendedDic里
//            NSUserDefaults * HR_recommendedDefault = [NSUserDefaults standardUserDefaults];
//            [HR_recommendedDefault setValue:self.dataDicAll forKey:@"HRRecommendedDic"];
//            [HR_recommendedDefault synchronize];
            
            //self.dataArray = [[resultDic objectForKey:@"data"] mutableCopy];
            if (page == 1) {
                self.dataArray_resume = [NSMutableArray arrayWithCapacity:0];
                if ([[resultDic objectForKey:@"list"] count] > 0)
                {
                    self.dataArray_resume = [[resultDic objectForKey:@"list"] mutableCopy];
//                    if (!mainTableView)
//                    {
//                        [noRecommendLabel removeFromSuperview];
//                        [nilImageView removeFromSuperview];
//                        [promptLabel removeFromSuperview];
//                        [self createTableView];
//                    }
                    if (!mainTableView) {
                        [self createTableView];
                    }
                    
                    [mainTableView reloadData];
                }
                else
                {
                    ghostView.message=@"暂无推荐记录";
                    [ghostView show];
                    if (self.dataArray.count == 0)
                    {
                        [mainTableView removeFromSuperview];
                        mainTableView=nil;
                        [self createNil];
                    }
                }
                
            }
            else//refresh == footer
            {
                if ([[resultDic objectForKey:@"list"] count] > 0)
                {
                    [self.dataArray_resume addObjectsFromArray:[resultDic objectForKey:@"list"]];
//                    if (!mainTableView)
//                    {
//                        [noRecommendLabel removeFromSuperview];
//                        [nilImageView removeFromSuperview];
//                        [promptLabel removeFromSuperview];
//                        [self createTableView];
//                    }
                    [mainTableView reloadData];
                }
                else
                {
                    ghostView.message=@"暂无更多数据";
                    [ghostView show];
                    if (self.dataArray_resume.count == 0)
                    {
//                        [mainTableView removeFromSuperview];
                        [self createNil];
                    }
                }
            }
        }
        [loadView hide:YES];
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message=@"请求失败";
        [ghostView show];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        if([mainTableView isFooterRefreshing] == YES){
            [mainTableView footerEndRefreshing];
        }
        NSLog(@"请求失败");
    }];

    [request startAsynchronous];
}


- (void)createNil
{
    noRecommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + 44 + (ios7jj), self.view.frame.size.width, 12)];
    noRecommendLabel.text = @"您还没有推荐记录哦~";
    noRecommendLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    noRecommendLabel.textAlignment = NSTextAlignmentCenter;
    noRecommendLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noRecommendLabel];
    
    nilImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 130, 190, 207)];
    nilImageView.image = [UIImage imageNamed:@"hr_no_bonus.png"];
    [self.view addSubview:nilImageView];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 388, self.view.frame.size.width, 30)];
    promptLabel.text = @"快到职位列表页或职位详情页点击“推荐”按钮,\n推荐人才吧~~";
    promptLabel.numberOfLines = 2;
    promptLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:promptLabel];
}

-(void)removeNil{
    noRecommendLabel.hidden = YES;
    nilImageView.hidden = YES;
    promptLabel.hidden = YES;
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    if (!isResumeRec) {
        pageIndex =1;
        [self requestDataWithPage:pageIndex];
    }else{
        pageIndex_resume =1;
        [self requestesumeRecDataWithPager:pageIndex_resume];

    }
    
}
- (void)footerRefresh{
    if (!isResumeRec) {
        pageIndex ++;
        [self requestDataWithPage:pageIndex];
    }else{
        pageIndex_resume ++;
        [self requestesumeRecDataWithPager:pageIndex_resume];
        
    }
    
}

#pragma mark - 创建tableView
- (void)createTableView
{
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + (ios7jj)+48, self.view.frame.size.width, self.view.frame.size.height - (44 + (ios7jj)+48))];
    mainTableView.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    // 下拉刷新
    [mainTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    mainTableView.headerPullToRefreshText= @"下拉刷新";
    mainTableView.headerReleaseToRefreshText = @"松开马上刷新";
    mainTableView.headerRefreshingText = @"努力加载中……";
    // 上拉刷新
    [mainTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    mainTableView.footerPullToRefreshText= @"上拉刷新";
    mainTableView.footerReleaseToRefreshText = @"松开马上刷新";
    mainTableView.footerRefreshingText = @"努力加载中……";
}

#pragma mark tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    if (!isResumeRec) {
        NSString *cellIdentifier = @"Cell";
        RecommendedRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[RecommendedRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = self.dataArray[indexPath.row];
        cell.viewTag = indexPath.row *10;
        
        return cell;
    }
        NSString *cellIdentifier = @"Cell_resume";
        RecommendedRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[RecommendedRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = self.dataArray_resume[indexPath.row];
        cell.viewTag = indexPath.row *10;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //15 43 65 346
    if (isResumeRec) {
        return 58 + 65 * [self.dataArray_resume[indexPath.row][@"jobInfo"] count];
    }
    return 58 + 65 * [self.dataArray[indexPath.row][@"jobInfo"] count];//230 + 65 * peopleNum
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isResumeRec) {
        return _dataArray_resume.count;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    bgView.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255. blue:243 / 255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    if (self.dataDicAll)
    {
        label.text = [NSString stringWithFormat:@"    累计推荐%@人，成功推荐%@人，奖金%@元", self.dataDicAll[@"countRecommend"], self.dataDicAll[@"successJoin"], self.dataDicAll[@"moneyCount"]];
    }
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:label];
    
    return bgView;
}

#pragma mark buttonClick
- (void)recommendCellButtonClick:(UIButton *)sender
{
    PositionRecommandViewController *positionVc = [[PositionRecommandViewController alloc] init];
    int row = (int)sender.tag / 10;
    int col = (int)sender.tag - row * 10;
    if (!isResumeRec) {
        positionVc.dataDic = self.dataArray[row][@"jobInfo"][col];
        positionVc.comNameStr = self.dataArray[row][@"companyName"];
    }else{
        positionVc.dataDic = self.dataArray_resume[row][@"jobInfo"][col];
        positionVc.comNameStr = self.dataArray_resume[row][@"companyName"];
    }
    [self.navigationController pushViewController:positionVc animated:YES];
}

#pragma mark- MenuButtonClick

-(void)menuBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {

        btn_menu_left.selected = YES;
        btn_menu_right.selected = NO;
        isResumeRec = NO;
        pageIndex = 1;
        [self removeNil];
        if (_dataArray.count ==0) {
            [self requestDataWithPage:1];
        }else{
            [mainTableView reloadData];
            [self requestDataWithPage:1];
        }
    }else if(btn.tag == 1){
        btn_menu_left.selected = NO;
        btn_menu_right.selected = YES;
        isResumeRec = YES;
        pageIndex_resume = 1;
        [self removeNil];
        if (_dataArray_resume.count ==0) {
            [self requestesumeRecDataWithPager:1];
        }else{
            [mainTableView reloadData];
            [self requestesumeRecDataWithPager:1];
        }
    }
}


#pragma mark - 创建Nav
//-(void)createNav
//{
//    self.view.backgroundColor = XZHILBJ_colour;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBarHidden = NO;
//    if (IOS7) {
//        
//        [self.navigationController.navigationBar setBarTintColor:RGBA(255, 115, 4, 1)];
//        
//    }else
//    {
//        [self.navigationController.navigationBar setTintColor:RGBA(255, 115, 4, 1)];
//    }
//    UIButton * leftItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
//    [leftItem addTarget:self action:@selector(back:) forControlEvents:
//     UIControlEventTouchUpInside];
//    leftItem.tag = 1;
//    
//    UIImageView* backItem = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5.5f, 50.0f, 30.0f)];
//    [leftItem addSubview:backItem];
//    backItem.image = [UIImage imageNamed:@"btnnew.png"];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
//    
//    UILabel * TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//    TitleLabel.text = @"推荐记录";
//    TitleLabel.font = [UIFont systemFontOfSize:17];
//    TitleLabel.textColor = [UIColor whiteColor];
//    TitleLabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = TitleLabel;
//}
-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
