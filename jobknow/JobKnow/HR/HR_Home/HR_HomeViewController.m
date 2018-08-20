//
//  HR_HomeViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/7/31.
//  Copyright (c) 2015年 lxw. All rights reserved.
//
#import "HR_HomeViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"

//#import "CompanyinfoVC.h"
#import "SDDataCache.h"//缓存使用的第三方库
#import "ASIDownloadCache.h"
#import "MBProgressHUD.h"

#import "GTMBase64.h"//图片转为base64
#import "CommonFunc.h"
#import "JSONKit.h"

//重新登录
#import "MJRefresh.h"
#import "HRHomeCell.h"//xin cell
#import "HRHomeIntroduceModel.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"//btn缓存图片
#import "UIImageView+WebCache.h"
//#import "HR_HomeAddView.h"//头部点击图层
#import "MessageListViewController.h"//私信
#import "RecommendedRecordViewController.h"//推荐列表
#import "HR_searchResultViewController.h"//搜索结果
#import "HR_MyRewardViewController.h"//我的奖金页面

#import "HR_MyCardViewController.h"//我的名片页面

#import "RecommendDynamicList.h"
#import "PCResumeTutorViewController.h"

#import "DCPicScrollView.h"
#import "HomeBannerJumpWebViewController.h"



@interface HR_HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendRequest,UIAlertViewDelegate>
{
    UITableView * hrTableView;
    UIImage * imageSuccess;
    
    UIImageView * searchBgImageV;
    UIButton * searchBtn;
    UITextField * textField_Search;
    UIImageView * headerView;//头部
    
    UIButton * cardAplhaBtn;//点击认证我的名片
    UIButton * chooseIconBtn;//选择头像
    UILabel * nameLabel;
    UILabel * companmyNameLabel;
    UILabel * jobTypeLabel;
    UIImageView * HRImageV;
    UIImageView * VCompanyImageV;
    
    UILabel * recommendLabel;//推荐人数
    UILabel * rewardLabel;//奖金数目
    UILabel * resumeLabel;//简历份数
    UILabel * titleContentLabel;//全青岛共有 职位,奖金
    NSString * cityNameStr;//地名
    NSString * cityCodeStr;//城市code名
    NSString * tradeCodeStr;//我的HR圈用到的行业名code
    //    MJRefreshHeaderView * header1;
    //    MJRefreshFooterView * footer1;
    int pageIndex1;
    
    MBProgressHUD *loadView;
    //nav专用
    UIButton* leftItem;
    UIButton* rightItem;
    UIButton* rightItemUnread;
    UIButton * titleBtn;
    UIView* BgView;
    UIImageView * btnbgImageV;
    UIButton * chooseBtnAll;
    UIButton * chooseBtnMyHR;
    UIImageView * arrowImageV;
    int loadType;
    int collectType;
    
    //UIView * bgAlphaV 引导层
    UIView * bgAlphaV;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * dataDicAll;
@property (nonatomic,strong)NSMutableDictionary * dataDicOfHRInfo;
@end

@implementation HR_HomeViewController

-(void)viewWillDisappear:(BOOL)animated
{
    arrowImageV.image = [UIImage imageNamed:@"icon_down"];
    BgView.hidden = YES;
    btnbgImageV.hidden = YES;
    [textField_Search resignFirstResponder];
}
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
    [nc addObserver:self
           selector:@selector(refreshHeaderImage)
               name:HeaderImageRefresh
             object:nil];
    headerHeight = 190 -84;
    self.view.backgroundColor = RGBA(241, 239, 240, 1);
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataDicAll = [NSMutableDictionary dictionaryWithCapacity:0];
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    [self createNav];
    pageIndex1 = 1;
    loadType = 1;//1 hr青岛 2我的hr圈职位
    [self createTableView];
    [self makeUI];
    [self requestBannerData];
    [self valueDataOfheader];
    [self requestDataWithPage:pageIndex1];
    NSUserDefaults * HRHomeDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dicHuanCun = [HRHomeDefault valueForKey:@"HRHomeDic"];
    
    //轮播相关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRecommendDynamicView) name:reloadRecommendDynamicListSuccess object:nil];
    [self.view addSubview:[RecommendDynamicList shareInstance].dynamicView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetHeaderWhenNoticed:) name:@"resetHeader1WhenAddedNewResume" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataFromWeb) name:@"reloadDataWhenRecommendResume" object:nil];
    
    //添加重设私信未读数响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetSiXinCount:) name:@"ResetSiXinCount" object:nil];
    
    
}
#pragma mark - 创建引导界面
-(void)makeUIOfLeading
{
    NSArray *array = [mUserDefaults valueForKey:@"BonusVersionAndImageUrl"];
    bgAlphaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, iPhone_height)];
    bgAlphaV.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self.view addSubview:bgAlphaV];
    
    UIImageView * headerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, iPhone_width, 230)];
    [headerImageV setContentMode:UIViewContentModeScaleAspectFit];

    if (array.count>0) {
        NSString *strURL = [[array objectAtIndex:0] valueForKey:@"author_file"];
        [headerImageV sd_setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"hr_approve_content"]];
    }else{
        headerImageV.image = [UIImage imageNamed:@"hr_approve_content"];
    }
    [bgAlphaV addSubview:headerImageV];
    
    UIImageView * IKnowImageV = [[UIImageView alloc]initWithFrame:CGRectMake((iPhone_width - 90) / 2, headerImageV.frame.origin.y + headerImageV.frame.size.height + 40, 90, 40)];
    IKnowImageV.image = [UIImage imageNamed:@"hr_approve_know"];
    [bgAlphaV addSubview:IKnowImageV];
    
    //hr_approve_know 我知道了图片
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    //给self.view添加一个手势监测
    [bgAlphaV addGestureRecognizer:singleRecognizer];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //获取审核更新状态
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AppStoreCheck" object:@1];
    
    [self showRecommendDynamicView];
}

#pragma mark- 引导认证的我知道了点击事件
-(void)SingleTap:(UITapGestureRecognizer *)gesture
{
    [bgAlphaV removeFromSuperview];
}

#pragma mark - createTableView
-(void)createTableView
{
    if (IOS7) {
        hrTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 + 64, iPhone_width, iPhone_height - [MyControl isIOS7]) style:UITableViewStylePlain];
    }
    else
    {
        hrTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40 + 44, iPhone_width, iPhone_height - [MyControl isIOS7]) style:UITableViewStylePlain];
    }
    hrTableView.delegate = self;
    hrTableView.dataSource = self;
    hrTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:hrTableView];
    
    headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, iPhone_width, headerHeight)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = RGBA(240, 240, 240, 1);

    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, headerView.frame.size.height - 40)];
    //image.image = [UIImage imageNamed:@"hr_main_bg"];
    image.backgroundColor = RGBA(241, 239, 240, 1);
    image.userInteractionEnabled = YES;
    [headerView addSubview:image];
    hrTableView.tableHeaderView = headerView;
    
    // 下拉刷新
    [hrTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    hrTableView.headerPullToRefreshText= @"下拉刷新";
    hrTableView.headerReleaseToRefreshText = @"松开马上刷新";
    hrTableView.headerRefreshingText = @"努力加载中……";
    // 上拉刷新
    [hrTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    hrTableView.footerPullToRefreshText= @"上拉刷新";
    hrTableView.footerReleaseToRefreshText = @"松开马上刷新";
    hrTableView.footerRefreshingText = @"努力加载中……";
    
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    pageIndex1 =1;
    [self requestBannerData];
    [self requestDataWithPage:pageIndex1];
    
}
- (void)footerRefresh{
    pageIndex1 ++;
    [self requestDataWithPage:pageIndex1];
    
}

#pragma mark- 获取HR圈广告图片
-(void)requestBannerData
{
    
    NSString *url = kCombineURL(KXZhiLiaoAPI,HRGetBannerData);
    NSDictionary *paramDic = @{
                               @"userToken":kUserTokenStr,
                               @"userImei":IMEI
                               };
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            headerHeight = 190 - 84;
            [bgView setFrame:CGRectMake(0, 4, iPhone_width, 70)];
            [headerView setFrame:CGRectMake(0, 40, iPhone_width, headerHeight)];
            
            [titleContentLabel setFrame:CGRectMake(0, bgView.frame.size.height + bgView.frame.origin.y + 3, iPhone_width, 30)];
            hrTableView.tableHeaderView = headerView;
            [hrTableView reloadData];
            return;
        }
        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            NSArray *list = [resultDic objectForKey:@"list"];
            NSString *bannerSwitch = [resultDic objectForKey:@"switch"];
            NSMutableArray *arrayPicUrl = [[NSMutableArray alloc] init];
            NSMutableArray *arrayPicJumpUrl = [[NSMutableArray alloc] init];
            
            for (NSDictionary *item in list) {
                [arrayPicUrl addObject:[item objectForKey:@"pic"]];
                [arrayPicJumpUrl addObject:[item objectForKey:@"url"]];
            }
            if ([bannerSwitch isEqualToString:@"on"]) {
                headerHeight = 190 - 84 +84;
                [bannerView removeFromSuperview];
                bannerView = [[DCPicScrollView alloc] initWithFrame:CGRectMake(0,0, iPhone_width, 84) WithImageNames:arrayPicUrl];
                bannerView.placeImage = [UIImage imageNamed:@"place.png"];
                __block typeof(self) weakSelf = self;
                [bannerView setImageViewDidTapAtIndex:^(NSInteger index) {
                    printf("你点到我了😳index:%zd\n",index);
                    [weakSelf clickBannerImageWithUrl:[arrayPicJumpUrl objectAtIndex:index]];
                }];
                bannerView.AutoScrollDelay = 5.0f;
                [bannerView resetScorll];
                [headerView addSubview:bannerView];
                
                [bgView setFrame:CGRectMake(0,bannerView.frame.origin.y+ bannerView.frame.size.height+ 4, iPhone_width, 70)];
            }else{
                headerHeight = 190 - 84;
                [bgView setFrame:CGRectMake(0, 4, iPhone_width, 70)];
                
            }
        
            [headerView setFrame:CGRectMake(0, 40, iPhone_width, headerHeight)];
        
            [titleContentLabel setFrame:CGRectMake(0, bgView.frame.size.height + bgView.frame.origin.y + 3, iPhone_width, 30)];
            hrTableView.tableHeaderView = headerView;
            [hrTableView reloadData];
 
        }
    }];
    [request setFailedBlock:^{
        headerHeight = 190 - 84;
        [bgView setFrame:CGRectMake(0, 4, iPhone_width, 70)];
        [headerView setFrame:CGRectMake(0, 40, iPhone_width, headerHeight)];
        
        [titleContentLabel setFrame:CGRectMake(0, bgView.frame.size.height + bgView.frame.origin.y + 3, iPhone_width, 30)];
        hrTableView.tableHeaderView = headerView;
        [hrTableView reloadData];
        
    }];
    [request startAsynchronous];
}

#pragma mark- 点击广告图片跳转webview
-(void)clickBannerImageWithUrl:(NSString *)urlStr{
    HomeBannerJumpWebViewController *homeweb =  [[HomeBannerJumpWebViewController alloc] init];
    homeweb.urlStr = urlStr;
    homeweb.floog = @"功能介绍";
    AppDelegate * del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([del.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)del.window.rootViewController) pushViewController:homeweb animated:YES];
    }
}

#pragma mark 私信数修改响应方法

-(void)resetSiXinCount:(NSNotification *)noti{
    [self setSiXinCount];
}

#pragma mark - 判断轮播界面是否需要显示
-(void)showRecommendDynamicView{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:RecommendDynamicPlayStatus] isEqualToString:@"on"] && [[RecommendDynamicList shareInstance].dynamicArray count]>0){//动态开关打开并且有动态数据
        
        [[RecommendDynamicList shareInstance].dynamicView setHidden:NO];
        [[RecommendDynamicList shareInstance] startPlay];
        hrTableView.frame = CGRectMake(0, 40 + 44+ios7jj, kMainScreenWidth, iPhone_height-44-ios7jj-40-40);
        
    }else{
        
        [[RecommendDynamicList shareInstance].dynamicView setHidden:YES];
        [[RecommendDynamicList shareInstance] stopPlay];
        hrTableView.frame = CGRectMake(0, 40 + 44+ios7jj, kMainScreenWidth, iPhone_height-44-ios7jj-40);
    }
    
}

#pragma mark- 添加简历成功后修改简历数
-(void)resetHeaderWhenNoticed:(NSNotification *)noti{
    int  num = ((NSString *)self.dataDicAll[@"resumeNum"]).integerValue;
    num += 1;
    [self.dataDicAll setValue:[NSNumber numberWithInt:num] forKey:@"resumeNum"];
    [self refreshDataOfHeaderWithDic:self.dataDicOfHRInfo];
}

#pragma mark- 推荐成功后修改推荐数
-(void)reloadDataFromWeb{
    pageIndex1 = 1;
    [self requestDataWithPage:pageIndex1];
}

#pragma mark- 获取HR圈职位列表及HR信息
-(void)requestDataWithPage:(int)page
{
    //http://www.xzhiliao.com/api/hr_api/job/senior_job_list?version=3.2.1&userToken=c593b643ade242f632259405de1b34d2&userImei=868433027181654
    

    NSString *url = kCombineURL(KWWWXZhiLiaoAPI,HRPositonList);
    NSString * strUsertoken = @"";
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    if ([GRBToken length] != 0) {
        strUsertoken = GRBToken;
    }
    else if ([GRBToken length]== 0 && [kAUTHSTRING length]!= 0) {
        strUsertoken = kAUTHSTRING;
    }
    else
    {
        strUsertoken = @"noUserTokenoooooooooooooooooooo";
    }
    if (cityCodeStr == nil) {
        cityCodeStr = @"";
    }
    if (tradeCodeStr == nil) {
        tradeCodeStr = @"";
    }
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    if (loadType == 1)
    {
        paramDic = @{
                     @"userToken":strUsertoken,
                     @"userImei":IMEI,
                     @"page":[NSNumber numberWithInt:pageIndex1],
                     @"location":cityCodeStr,
                     @"searchCityCode":cityCodeStr,
                     @"count":@"20",
                     @"version":@"1"
                     };
    }
    else //if (loadType == 2)
    {
        paramDic = @{
                     @"userToken":GRBToken,
                     @"userImei":IMEI,
                     @"page":[NSNumber numberWithInt:pageIndex1],
                     @"location":cityCodeStr,
                     @"searchCityCode":cityCodeStr,
                     @"count":@"20",
                     @"searchIndustry":tradeCodeStr,
                     @"version":@"1"
                     };
    }
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        if([hrTableView isHeaderRefreshing] == YES){
            [hrTableView headerEndRefreshing];
        }
        if([hrTableView isFooterRefreshing] == YES){
            [hrTableView footerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDics=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSNumber *error_code =[resultDics valueForKey:@"error_code"];
        
        if(!resultDics||error_code.integerValue == 101){
            [loadView hide:YES];
        
            //[self.navigationController pushViewController:vc animated:YES];
            ////            other.isHrBool = YES;
            //            [other otherAreaLogin];
            //[self loadDataOfHRCircle:header1];
            return;
        }
        if(error_code.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            NSMutableDictionary * resultDic = resultDics[@"data"];
            self.dataDicAll = [resultDic mutableCopy];
            //将HR的信息保存到本地NSUserDefaults中
            //[self saveHrInfoToNSUserDefaults:[resultDic objectForKey:@"hrInfo"]];
            
            //本地存储
            //            NSUserDefaults * HRHomeDefault = [NSUserDefaults standardUserDefaults];
            //            [HRHomeDefault setValue:self.dataDicAll forKey:@"HRHomeDic"];
            //            [HRHomeDefault synchronize];
            
            self.dataDicOfHRInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            self.dataDicOfHRInfo = [resultDic objectForKey:@"hrInfo"];
            [self refreshDataOfHeaderWithDic:self.dataDicOfHRInfo];
            //将HR的信息保存到本地NSUserDefaults中
            //[self saveHrInfoToNSUserDefaults:self.dataDicOfHRInfo];
            NSLog(@"self.dataDic是-----***%@",self.dataDicOfHRInfo);
            //self.dataArray = [[resultDic objectForKey:@"data"] mutableCopy];
            if (pageIndex1 == 1) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary * item in [resultDic objectForKey:@"data"])
                {
                    HRHomeIntroduceModel * homeModel = [[HRHomeIntroduceModel alloc]initWithDictionary:item];
                    [self.dataArray addObject:homeModel];
                }
                [hrTableView reloadData];
                if (_dataArray.count==0) {
                    titleContentLabel.hidden = YES;
                    if (loadType == 2) {
                        ghostView.message=@"您目前所在的HR圈暂无奖金职位";
                        [ghostView show];
                    }
                }else{
                    titleContentLabel.hidden = NO;
                    
                }
            }
            else//refresh == footer
            {
                [loadView hide:YES];
                
                for (NSDictionary * item in [resultDic objectForKey:@"data"])
                {
                    HRHomeIntroduceModel * homeModel = [[HRHomeIntroduceModel alloc]initWithDictionary:item];
                    [self.dataArray addObject:homeModel];
                }
                if ([[resultDic objectForKey:@"data"] count] == 0) {
                    ghostView.message=@"没有更多数据";
                    [ghostView show];
                }
                [hrTableView reloadData];
            }
        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message=@"请求失败";
        [ghostView show];
        if([hrTableView isHeaderRefreshing] == YES){
            [hrTableView headerEndRefreshing];
        }
        if([hrTableView isFooterRefreshing] == YES){
            [hrTableView footerEndRefreshing];
        }
    }];
    [request startAsynchronous];
}

#pragma mark - 刷新头像的通知方法
- (void)refreshHeaderImage{
    NSLog(@"刷新头像的通知方法");
    [chooseIconBtn sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"headUrl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"personal_center_head_default"]];
    
}

#pragma mark - 保存HR信息到NSUserDefaults
-  (void)saveHrInfoToNSUserDefaults:(NSDictionary *)dic{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([dic objectForKey:@"cityCode"]) {
        [ud setObject:[dic objectForKey:@"cityCode"] forKey:@"cityCode"];
    }
    
    if ([dic objectForKey:@"cityName"]) {
        [ud setObject:[dic objectForKey:@"cityName"] forKey:@"cityName"];
    }
    if ([dic objectForKey:@"company_pid"]) {
        if ([[dic objectForKey:@"company_pid"] isKindOfClass:[NSNull class]]) {
            [ud setObject:@"" forKey:@"company_pid"];
        }else{
            [ud setObject:[dic objectForKey:@"company_pid"] forKey:@"company_pid"];
        }
        
    }
    if ([dic objectForKey:@"headUrl"]) {
        [ud setObject:[dic objectForKey:@"headUrl"] forKey:@"headUrl"];
    }
    if ([dic objectForKey:@"hrState"]) {
        [ud setObject:[dic objectForKey:@"hrState"] forKey:@"hrState"];
    }
    if ([dic objectForKey:@"is_family"]) {
        [ud setObject:[dic objectForKey:@"is_family"] forKey:@"is_family"];
    }
    if ([dic objectForKey:@"isRegisterCompany"]) {
        [ud setObject:[dic objectForKey:@"isRegisterCompany"] forKey:@"isRegisterCompany"];
    }
    if ([dic objectForKey:@"occupation"]) {
        [ud setObject:[dic objectForKey:@"occupation"] forKey:@"occupation"];
    }
    if ([dic objectForKey:@"realName"]) {
        [ud setObject:[dic objectForKey:@"realName"] forKey:@"realName"];
    }
    if ([dic objectForKey:@"regDate"]) {
        [ud setObject:[dic objectForKey:@"regDate"] forKey:@"regDate"];
    }
    if ([dic objectForKey:@"tradeCode"]) {
        [ud setObject:[dic objectForKey:@"tradeCode"] forKey:@"tradeCode"];
    }
    if ([dic objectForKey:@"tradeName"]) {
        [ud setObject:[dic objectForKey:@"tradeName"] forKey:@"tradeName"];
    }
    if ([dic objectForKey:@"userCompany"]) {
        [ud setObject:[dic objectForKey:@"userCompany"] forKey:@"userCompany"];
    }
    
    if ([dic objectForKey:@"userEmail"]) {
        [ud setObject:[dic objectForKey:@"userEmail"] forKey:@"userEmail"];
    }
    [ud synchronize];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:uid forKey:@"userUid"];
    int hrStateInt = [[dic objectForKey:@"hrState"] intValue];
    NSString * userUidStr = [defaults objectForKey:@"userUid"];
    //
    NSString *strIsEvaluated = [[defaults objectForKey:@"IsEvaluated"] objectForKey:userUidStr];
    if (![strIsEvaluated isEqualToString:@"1"] && hrStateInt != 2 && hrStateInt != 4) {
        //没认证且没引导过 !审核中 !审核成功 修改之后重新等待审核是4
        [self makeAlertView];
    }else{
        
    }
    NSLog(@"更新HR信息成功");
}

//显示引导界面逻辑
-(void)makeAlertView
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userUidStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"userUid"]];
    
    [self makeUIOfLeading];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"IsEvaluated"]];
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setValue:@"1" forKey:userUidStr?:@"0"];
    [defaults setObject:dic forKey:@"IsEvaluated"];
}

#pragma mark - 下拉刷新的时候重新赋值获取最新数据
-(void)refreshDataOfHeaderWithDic:(NSMutableDictionary *)dataDic
{
    UIImageView * imageV = [[UIImageView alloc]init];
    
    [chooseIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"headUrl"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            imageV.image = image;
        }
    }];
    //头像替换本地
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString *str1 = [st valueForKey:@"UserName"];
    NSData *imageData = UIImageJPEGRepresentation(imageV.image, 1);
    NSString*finame = [NSString stringWithFormat:@"_%@.png",str1];
    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    [imageCache storeData:imageData forKey:finame];
    [_pathCover setAvatarImage:imageV.image];
    
    [chooseIconBtn setBackgroundImage:((imageV.image == nil)?[UIImage imageNamed:@"personal_center_head_default"]:imageV.image) forState:UIControlStateNormal];
    
    NSString *name = dataDic[@"realName"];
    NSString *hrState = [NSString stringWithFormat:@"%@",dataDic[@"hrState"]];
    if ([hrState isEqualToString:@"4"]) {
        [nameLabel setText:@"(身份认证中)"];
    }else if([hrState isEqualToString:@"2"]){
        [nameLabel setText:name];
    }else{
        [nameLabel setText:@"(点击此处认证)"];
    }
    UITapGestureRecognizer *tapNameLabel =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardBtnClick)];
    nameLabel.userInteractionEnabled = YES;
    [nameLabel addGestureRecognizer:tapNameLabel];
    nameLabel.numberOfLines = 1;
    
    if (name.length > 8) {
        nameLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 105, 17);
    }else{
        [nameLabel sizeToFit];
    }
    HRImageV.frame = CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+4, HRImageV.frame.origin.y, HRImageV.frame.size.width, HRImageV.frame.size.height);
    VCompanyImageV.frame = CGRectMake(HRImageV.frame.origin.x+HRImageV.frame.size.width+4, VCompanyImageV.frame.origin.y, VCompanyImageV.frame.size.width, VCompanyImageV.frame.size.height);
    
    //    [nameLabel setFont:(name.length > 0)?[UIFont boldSystemFontOfSize:17]:[UIFont systemFontOfSize:11]];
    
    NSString *isHr = [NSString stringWithFormat:@"%@",dataDic[@"hrState"]];//1 待审核 2tongguo  3 拒绝
    if ([isHr isEqualToString:@"2"]) {
        [HRImageV setImage:[UIImage imageNamed:@"hr_authed"]];
    }else
    {
        [HRImageV setImage:[UIImage imageNamed:@"hr_noauth"]];
    }
    
    NSString *isPayVip = [NSString stringWithFormat:@"%@",dataDic[@"isRegisterCompany"]];
    if ([isPayVip isEqualToString:@"1"]) {
        [VCompanyImageV setImage:[UIImage imageNamed:@"hr_company_y"]];
        VCompanyImageV.userInteractionEnabled = NO;
    }else{
        [VCompanyImageV setImage:[UIImage imageNamed:@"hr_company_n"]];
        VCompanyImageV.userInteractionEnabled = YES;
    }
    
    //NSString * companyName = [AppUD objectForKey:@"companyName"];
//    NSString * occupation = dataDic[@"occupation"];
//    companmyNameLabel.text = (occupation.length > 0)?occupation:@"暂无";
    
    NSString * tradeName = dataDic[@"tradeName"];
    //    tradeName = @"推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人推荐%@人";
    jobTypeLabel.text = (tradeName.length > 0)?tradeName:@"暂无";
    jobTypeLabel.frame = CGRectMake(companmyNameLabel.frame.origin.x, companmyNameLabel.frame.origin.y + companmyNameLabel.frame.size.height + 1.0f, 205.0f, 33.0f);
    [jobTypeLabel sizeToFit];
    
    recommendLabel.text = [NSString stringWithFormat:@"%@",self.dataDicAll[@"recommendNum"]];
    rewardLabel.text = [NSString stringWithFormat:@"%@",self.dataDicAll[@"countMoney"]];
    resumeLabel.text = [NSString stringWithFormat:@"简历%@份",self.dataDicAll[@"resumeNum"]];
    if (loadType == 1) {
        //XX（城市名称）共有微猎头职位100个   奖金总额541178-589223元
        //XX（城市名称）共有HR圈•效果招聘职位X个，其中简历付费职位X个，入职付费职位X个。奖金总额：X元 bonusJobCount resumeJobCount
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@共有微猎头职位%@个 奖金总额:%@元",self.dataDicOfHRInfo[@"cityName"],self.dataDicAll[@"allCounts"],self.dataDicAll[@"bouns"]]];//,self.dataDicAll[@"resumeJobCount"],self.dataDicAll[@"bonusJobCount"],
        NSString * rawStr = [str string];
        NSString * allCounts = [NSString stringWithFormat:@"%@",self.dataDicAll[@"allCounts"]];
//        NSString * bonusJobCount = [NSString stringWithFormat:@"%@",self.dataDicAll[@"bonusJobCount"]];
//        NSString * resumeJobCount = [NSString stringWithFormat:@"%@",self.dataDicAll[@"resumeJobCount"]];
        NSString * bouns = [NSString stringWithFormat:@"%@",self.dataDicAll[@"bouns"]];
        
        int l_count = (int)[allCounts length];//获取职位个数的长度
//        int l_bonusJobCount = (int)[bonusJobCount length];//获取简历付费的长度
//        int l_resumeJobCount = (int)[resumeJobCount length];//获取效果付费的长度
        int l_reward = (int)[bouns length];//获取奖金数目的长度
        
        NSRange range01 = [rawStr rangeOfString:@"共有微猎头职位"];
//        NSRange range02 = [rawStr rangeOfString:@"其中简历付费职位"];
//        NSRange range03 = [rawStr rangeOfString:@"入职付费职位"];
        NSRange range04 = [rawStr rangeOfString:@"奖金总额:"];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range01.location+range01.length, l_count)];
        
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range02.location+range02.length,l_bonusJobCount)];
        
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range03.location+range03.length,l_resumeJobCount)];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range04.location+range04.length,l_reward)];
        
        titleContentLabel.attributedText = str;
    }
    else if (loadType == 2)
    {
        //您所在的HR圈共有微猎头职位100个   奖金总额541178-589223元
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您所在的HR圈共有微猎头职位%@个 奖金总额:%@元",self.dataDicAll[@"allCounts"],self.dataDicAll[@"bouns"]]];//其中简历付费职位%@个\n入职付费职位%@个 self.dataDicAll[@"resumeJobCount"],self.dataDicAll[@"bonusJobCount"],
        NSString *rawStr = [str string];
        //[NSString stringWithFormat:@"%@",self.dataDicOfHRInfo[@"cityName"]];
        NSString * allCounts = [NSString stringWithFormat:@"%@",self.dataDicAll[@"allCounts"]];
//        NSString * bonusJobCount = [NSString stringWithFormat:@"%@",self.dataDicAll[@"bonusJobCount"]];
//        NSString * resumeJobCount = [NSString stringWithFormat:@"%@",self.dataDicAll[@"resumeJobCount"]];
        NSString * bouns = [NSString stringWithFormat:@"%@",self.dataDicAll[@"bouns"]];
        
        int l_count = (int)[allCounts length];//获取职位个数的长度
//        int l_bonusJobCount = (int)[bonusJobCount length];//获取简历付费的长度
//        int l_resumeJobCount = (int)[resumeJobCount length];//获取效果付费的长度
        int l_reward = (int)[bouns length];//获取奖金数目的长度
        
        
        NSRange range01 = [rawStr rangeOfString:@"共有微猎头职位"];
//        NSRange range02 = [rawStr rangeOfString:@"其中简历付费职位"];
//        NSRange range03 = [rawStr rangeOfString:@"入职付费职位"];
        NSRange range04 = [rawStr rangeOfString:@"奖金总额:"];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range01.location+range01.length, l_count)];
        
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range02.location+range02.length,l_bonusJobCount)];
//        
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range03.location+range03.length,l_resumeJobCount)];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range04.location+range04.length,l_reward)];
        titleContentLabel.attributedText = str;
    }
    
    else
    {
        
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    searchBgImageV.frame = CGRectMake(11.5f, 5, iPhone_width - 11.5 - 70, 30);
    searchBtn.hidden = NO;
    
    if (textField.text.length == 0) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: RGBA(142, 142, 142, 1)}];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    searchBgImageV.frame = CGRectMake(11.5f, 5, iPhone_width - 11.5 * 2, 30);
    searchBtn.hidden = YES;
    if (textField.text.length == 0) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入职位关键字" attributes:@{NSForegroundColorAttributeName: RGBA(142, 142, 142, 1)}];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnClick:nil];
    return YES;
}

-(void)searchBtnClick:(UIButton *)sender
{
    if (textField_Search.text.length == 0) {
        [ghostView setTitle:@"请输入有效长度"];
        [ghostView show];
    }
    else
    {
        HR_searchResultViewController * vc = [[HR_searchResultViewController alloc]init];
        vc.searchKeyStr = textField_Search.text;
        vc.cityCodeStr = cityCodeStr;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - makeUI新效果,旧的注释掉
-(void)makeUI
{
    //home_search22 搜索图标
    //104 - 64 = 40
    UIView * orangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + ios7jj, iPhone_width, 40)];
    orangeView.backgroundColor = XZhiL_colour;
    [self.view addSubview:orangeView];
    
    searchBtn = [MyControl createButtonFrame:CGRectMake(iPhone_width - 68,5, 58, 30) bgImageName:@"" image:nil title:@"搜索" method:@selector(searchBtnClick:) target:self];
    [searchBtn setTitleColor:RGBA(142, 142, 142, 1) forState:UIControlStateNormal];
    [orangeView addSubview:searchBtn];
    searchBtn.layer.cornerRadius = 4;
    searchBtn.clipsToBounds = YES;
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.hidden = YES;
    searchBgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(11.5f, 5, iPhone_width - 11.5 * 2, 30)];
    searchBgImageV.userInteractionEnabled = YES;
    searchBgImageV.backgroundColor = [UIColor whiteColor];
    searchBgImageV.layer.cornerRadius = 4;
    searchBgImageV.clipsToBounds = YES;
    //searchBgImageV.image = [[UIImage imageNamed:@"hr_search"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:0.0f];
    [orangeView addSubview:searchBgImageV];
    
    // 26 24 38 38
    UIImageView * searchIconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(13.0f, 5, 20, 20)];
    searchIconImageV.image = [UIImage imageNamed:@"hr_search_icon"];
    [searchBgImageV addSubview:searchIconImageV];
    
    textField_Search = [[UITextField alloc]initWithFrame:CGRectMake(searchIconImageV.frame.size.width + searchIconImageV.frame.origin.x + 10.0f, 6.5f, searchBgImageV.frame.size.width - searchIconImageV.frame.size.width - 20, searchBgImageV.frame.size.height - 5.0 * 2)];
    textField_Search.delegate = self;
    UIColor * color = RGBA(142, 142, 142, 1);
    textField_Search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入职位关键字" attributes:@{NSForegroundColorAttributeName: color}];
    textField_Search.textAlignment = NSTextAlignmentLeft;
    textField_Search.returnKeyType = UIReturnKeySearch;
    textField_Search.tintColor = RGBA(142, 142, 142, 1);
    textField_Search.textColor = RGBA(142, 142, 142, 1);
    textField_Search.font = [UIFont systemFontOfSize:15];
    [searchBgImageV addSubview:textField_Search];
    
    headerView.userInteractionEnabled = YES;

    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 4, iPhone_width, 70)];

    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 0.5, 18, 1, bgView.frame.size.height - 18 * 2)];
    lineV.backgroundColor = RGBA(142, 142, 142, 1);
    [bgView addSubview:lineV];
    
    //20 18
    recommendLabel = [MyControl createLableFrame:CGRectMake(20, 16, iPhone_width / 2 - 20 * 2, 31) font:30 title:@"0"];
    recommendLabel.textColor = [UIColor orangeColor];
    UITapGestureRecognizer *taprec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToReccomend)];
    recommendLabel.userInteractionEnabled = YES;
    [recommendLabel addGestureRecognizer:taprec];
    //recommendLabel.backgroundColor = [UIColor yellowColor];
    recommendLabel.font = [UIFont boldSystemFontOfSize:30];
    recommendLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:recommendLabel];
    UILabel * recommendLabel2 = [MyControl createLableFrame:CGRectMake(20, 50, recommendLabel.frame.size.width, 11) font:11 title:@"推荐人数"];
    recommendLabel2.textAlignment = NSTextAlignmentCenter;
    //recommendLabel2.backgroundColor = [UIColor yellowColor];
    recommendLabel2.textColor = RGBA(142, 142, 142, 1);
    [bgView addSubview:recommendLabel2];
    
    rewardLabel = [MyControl createLableFrame:CGRectMake( iPhone_width / 2 + 20, recommendLabel.frame.origin.y, recommendLabel.frame.size.width, recommendLabel.frame.size.height) font:30 title:@"0"];
    rewardLabel.textColor = [UIColor orangeColor];
    //rewardLabel.backgroundColor = [UIColor purpleColor];
    UITapGestureRecognizer *tapreward = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToReward)];
    rewardLabel.userInteractionEnabled = YES;
    [rewardLabel addGestureRecognizer:tapreward];
    rewardLabel.textColor = [UIColor orangeColor];
    //rewardLabel.backgroundColor = [UIColor purpleColor];
    rewardLabel.font = [UIFont boldSystemFontOfSize:30];
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:rewardLabel];
    
    UILabel * rewardLabel2 = [MyControl createLableFrame:CGRectMake(iPhone_width / 2 + 20, 50, recommendLabel.frame.size.width, 11) font:11 title:@"奖金金额"];
    //rewardLabel2.backgroundColor = [UIColor yellowColor];
    rewardLabel2.textAlignment = NSTextAlignmentCenter;
    rewardLabel2.textColor = RGBA(142, 142, 142, 1);
    [bgView addSubview:rewardLabel2];

    titleContentLabel = [MyControl createLableFrame:CGRectMake(0, bgView.frame.size.height + bgView.frame.origin.y + 3, iPhone_width, 30) font:11 title:@""];
    titleContentLabel.textAlignment = NSTextAlignmentCenter;
    titleContentLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0];
    titleContentLabel.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleContentLabel];
}

#pragma mark 头部数据缓存读
-(void)valueDataOfheader
{
    UIImage *headImage = nil;
    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    NSString *headName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    NSData *imageData = [imageCache dataFromKey:[NSString stringWithFormat:@"_%@.png",headName] fromDisk:YES];
    
    headImage = [UIImage imageWithData:imageData];
    [chooseIconBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    
    [chooseIconBtn setBackgroundImage:((headImage == nil)?[UIImage imageNamed:@"personal_center_head_default"]:headImage) forState:UIControlStateNormal];
    
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    NSString *name = [AppUD objectForKey:@"realName"];
    [nameLabel setText:((name.length>0)?name:@"(点击此处认证)")];
    nameLabel.numberOfLines = 1;
    
    if (name.length > 8) {
        nameLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 105, 17);
    }else{
        //        if (name.length == 2) {
        //            name = [NSString stringWithFormat:@"%@ %@",[name substringToIndex:1],[name substringFromIndex:1]];
        //            nameLabel.text = name;
        //        }
        [nameLabel sizeToFit];
    }
    HRImageV.frame = CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+4, HRImageV.frame.origin.y, HRImageV.frame.size.width, HRImageV.frame.size.height);
    VCompanyImageV.frame = CGRectMake(HRImageV.frame.origin.x+HRImageV.frame.size.width+4, VCompanyImageV.frame.origin.y, VCompanyImageV.frame.size.width, VCompanyImageV.frame.size.height);
    
    NSString * hrState = [AppUD objectForKey:@"hrState"];
    if ([hrState isEqualToString:@"2"]) {
        [HRImageV setImage:[UIImage imageNamed:@"hr_authed"]];
    }
    else
    {
        [HRImageV setImage:[UIImage imageNamed:@"hr_noauth"]];
    }
    
    NSString *isPayVip = [NSString stringWithFormat:@"%@",[AppUD objectForKey:@"isRegisterCompany"]];
    if ([isPayVip isEqualToString:@"1"]) {
        [VCompanyImageV setImage:[UIImage imageNamed:@"hr_company_y"]];
        VCompanyImageV.userInteractionEnabled = NO;
    }else{
        [VCompanyImageV setImage:[UIImage imageNamed:@"hr_company_n"]];
        VCompanyImageV.userInteractionEnabled = YES;
    }
    
#pragma mark - 全局变量保存城市名称 城市code 行业code
    cityNameStr =  [AppUD objectForKey:@"cityName"];
    tradeCodeStr =  [AppUD objectForKey:@"tradeCode"];
    cityCodeStr =  [AppUD objectForKey:@"cityCode"];
    NSString * occupation = [AppUD objectForKey:@"occupation"];
    companmyNameLabel.text = (occupation.length > 0)?occupation:@"暂无";
    
    NSString * tradeName = [AppUD objectForKey:@"tradeName"];
    jobTypeLabel.text = (tradeName.length > 0)?tradeName:@"暂无";
    [jobTypeLabel sizeToFit];
    
    [titleBtn setTitle:[NSString stringWithFormat:@"HR圈·%@",cityNameStr] forState:UIControlStateNormal];
}

#pragma mark- 企业图标点击
-(void)companyImageTap{
    //    if (VCompanyImageV.image == [UIImage imageNamed:@""]) {
    PCResumeTutorViewController *vc = [[PCResumeTutorViewController alloc] init];
    vc.webTitle = @"小职了企业版";
    vc.urlString = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@",KXZhiLiaoAPI,BootDownloadCompany,kUserTokenStr,IMEI];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
    }
    
    
    //    }
}

#pragma mark- 跳转推荐
-(void)jumpToReccomend{
    RecommendedRecordViewController * vc = [[RecommendedRecordViewController alloc]init];
    //vc.enterItem = EnterTypeHome;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
    }

}

#pragma mark- 跳转奖金
-(void)jumpToReward{
    HR_MyRewardViewController * vc = [[HR_MyRewardViewController alloc]init];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 上传头像点击事件
-(void)chooseIconClick
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"本地上传", nil];
    [sheet showInView:self.view];
}
#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"拍照上传");
        [self takePhotos];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"本地上传");
        [self callPhotos];
    }
    else if (buttonIndex == 2)
    {
        NSLog(@"取消");
    }
}
#pragma mark - 拍照
-(void)takePhotos
{//拍照
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    vc.delegate = self;
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 打开相册
-(void)callPhotos
{
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    //vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}
#pragma mark - Picker的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //头像保存本地
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString *str = [st valueForKey:@"UserName"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString*finame = [NSString stringWithFormat:@"_%@.png",str];
    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    [imageCache storeData:imageData forKey:finame];
    [_pathCover setAvatarImage:image];
    //上传头像
    [self uploadPath2:image name:[NSString stringWithFormat:@"%@.png",str]];
    imageSuccess = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//上传头像
- (void)uploadPath2:(UIImage *)image name:(NSString *)name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken", nil];
    //Filedata
    //[net send2ToServerWithImage:image imageName:name param:params];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"hr_api/hr_operation/uploadFace?"];
    [net send_HRIcon_ToServerWithImage:image imageName:name param:params withURLStr:urlStr];
}

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shang传头像_______%@",requestDic);
    
    NSNumber * state = [requestDic valueForKey:@"status"];
    if(!requestDic){
        [loadView hide:YES];

    }
    
    if ([state boolValue]) {
        //[self uploadResult:requestDic];
        NSString *fileName = [NSString stringWithFormat:@"%@",[requestDic valueForKey:@"fileName"]];
        [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:@"headUrl"];
        [[SDImageCache sharedImageCache] storeImage:imageSuccess forKey:fileName toDisk:YES];
        
        [chooseIconBtn setBackgroundImage:imageSuccess forState:UIControlStateNormal];
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)receiveDataFail:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)requestTimeOut
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - tableViewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRHomeIntroduceModel * model = [_dataArray objectAtIndex:indexPath.row];
//    NSString *count = [NSString stringWithFormat:@"%@",model.hrRecommendTotal];
//    if([count isEqualToString:@"0"]||!count||[count isEqualToString:@""]){
//        return 135.0f;
//    }
    return 135;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IDCustom"];
    if (!cell) {
        cell = [[HRHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDCustom"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //HRjobListmodel * Model = [self.dataArray objectAtIndex:indexPath.row];
        //cell.model = Model;
    }
    cell.backgroundColor = RGBA(241, 239, 240, 1);
    HRHomeIntroduceModel * model = [_dataArray objectAtIndex:indexPath.row];
    [cell configData:model withIndexPath:indexPath];
    cell.delegate = self;
    cell.IndexPath = indexPath;
    cell.tag = (int)indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).viewNum intValue];
    ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).viewNum = [NSString stringWithFormat:@"%d",a + 1];
    //[NSNumber numberWithInt:1];
    [hrTableView reloadData];
    
    for (HRHomeIntroduceModel *item in _dataArray) {
        NSString *temp = item.required;
        //替换全角符号为半角
        temp =  [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
        temp =  [temp stringByReplacingOccurrencesOfString:@"　" withString:@""];
        temp =  [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；" withString:@";"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；" withString:@";"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：" withString:@":"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：" withString:@":"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"，" withString:@","];
        temp =  [temp stringByReplacingOccurrencesOfString:@"，" withString:@","];
        temp =  [temp stringByReplacingOccurrencesOfString:@"。" withString:@"。"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"－" withString:@"-"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"＋" withString:@"+"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"！" withString:@"!"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"？" withString:@"?"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"、" withString:@"、"];
        
        //避免错误换行
        for (int i =1; i<=10; i++) {
            temp =  [temp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d:",i] withString:[NSString stringWithFormat:@"%d.",i]];
        }
        for (int i =1; i<=10; i++) {
            temp =  [temp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d、",i] withString:[NSString stringWithFormat:@"%d.",i]];
        }
        
        
        temp =  [temp stringByReplacingOccurrencesOfString:@";\n" withString:@";"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；\n" withString:@"；"];
        temp =  [temp stringByReplacingOccurrencesOfString:@":\n" withString:@":"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：\n" withString:@"："];
        temp =  [temp stringByReplacingOccurrencesOfString:@"。\n" withString:@"。"];
        
        
        temp =  [temp stringByReplacingOccurrencesOfString:@";" withString:@";\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；" withString:@"；\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@":" withString:@":\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：" withString:@"：\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
        
        if (temp.length == 0 ||!temp) {
            ;
        }else{
            NSString *temp_n = [temp substringFromIndex:temp.length-1];
            if ([temp_n isEqualToString:@"\n"]) {
                temp = [temp substringToIndex:temp.length-1];
            }
            
            item.required = temp;
        }
    }
    
    
    HR_JobDetailVC * jobDetailVC = [[HR_JobDetailVC alloc] init];
    jobDetailVC.dataArray=_dataArray;
    jobDetailVC.index=indexPath.row;
    jobDetailVC.delegate_collect=self;
    
    HRHomeIntroduceModel *model=[_dataArray objectAtIndex:indexPath.row];
    jobDetailVC.cityCode=model.cityCode;
    
    jobDetailVC.isJianzhi=NO;
    
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        [((UINavigationController *)app.window.rootViewController) pushViewController:jobDetailVC animated:YES];
    }
}
#pragma mark - 点击收藏按钮实现功能
-(void)CollectionClick:(NSIndexPath *)indexPath
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HRHomeIntroduceModel * model = (HRHomeIntroduceModel *)[self.dataArray objectAtIndex:indexPath.row];
    NSString *url = kCombineURL(KXZhiLiaoAPI,HRCollectPosition);
    NSDictionary *paramDic = [[NSDictionary alloc]init];
    collectType = [model.isfavorites intValue];
    if (collectType == 1)
    {
        NSLog(@"已收藏的状态");
        //取消收藏接口// http://api.xzhiliao.com/ hr_api/job/job_fav?
        paramDic = @{
                     @"userToken":GRBToken,
                     @"userImei":IMEI,
                     @"jobId":model.postId,
                     @"localcity":model.cityCode,
                     @"flag":@"del"//为空代表添加收藏即可
                     };
    }
    else
    {
        //        [cell changeCollectionImagewithNumber:0];
        //        loadType = 1;
        NSLog(@"没收藏过");
        paramDic = @{
                     @"userToken":GRBToken,
                     @"userImei":IMEI,
                     @"jobId":model.postId,
                     @"localcity":model.cityCode,
                     @"flag":@""//为空代表添加收藏即可
                     };
    }
    
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    request.tag = collectType;
    [request setCompletionBlock:^{
        [loadView hide:NO];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic)
        {
            NSLog(@"请重新登录");
            [loadView hide:YES];

        }
        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            ghostView.message=@"操作成功";
            [ghostView show];
            if (request.tag == 1) {
                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).isfavorites = @"0";
                int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum intValue];
                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum = [NSString stringWithFormat:@"%d",a - 1];
                [hrTableView reloadData];
                
            }
            else if (request.tag == 0){
                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).isfavorites = @"1";
                int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum intValue];
                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum = [NSString stringWithFormat:@"%d",a + 1];
                [hrTableView reloadData];
            }
        }
    }];
    
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message=@"请求失败";
        [ghostView show];
        NSLog(@"请求失败");
        
    }];
    [request startAsynchronous];//开启request的Block
    
}

#pragma mark- 简历推荐点击事件
-(void)introduceClick:(NSIndexPath *)IndexPath
{
    current_index = IndexPath;
    HRHomeIntroduceModel *model_job = [_dataArray objectAtIndex:IndexPath.row];
    NSUserDefaults * AppUD=[NSUserDefaults standardUserDefaults];

    NSString *hr_company_id = [AppUD valueForKey:@"company_pid"];
    if (hr_company_id) {
        if ([hr_company_id isEqualToString:model_job.companyId]) {
            ghostView.message=@"您不能给自己的东家推荐人才哦~";
            [ghostView show];
            return;
        }
    }
    
    HR_ResumeRecommendListViewController *hr_ResumeRec = [[HR_ResumeRecommendListViewController alloc] init];
    hr_ResumeRec.model_job = [_dataArray objectAtIndex:IndexPath.row];
    //        [self.navigationController pushViewController:hr_resume animated:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)app.window.rootViewController) pushViewController:hr_ResumeRec animated:YES];
    }
}

-(void)requestSeeNum:(NSIndexPath *)INDEXPATH
{
    int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:INDEXPATH.row]).viewNum intValue];
    ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:INDEXPATH.row]).viewNum = [NSString stringWithFormat:@"%d",a + 1];
    //[NSNumber numberWithInt:1];
    [hrTableView reloadData];
}

#pragma mark - createNav
-(void)createNav
{
    float topdistance = 0;
    long losVersion = [[UIDevice currentDevice].systemVersion floatValue] * 10000;
    if (losVersion >= 70000) {
        topdistance = 20;
    }
    self.num =topdistance;
    self.view.backgroundColor = XZHILBJ_colour;
    UIImageView *titleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+self.num)];
    titleImageV.userInteractionEnabled = YES;
    titleImageV.backgroundColor = XZhiL_colour;
    [self.view addSubview:titleImageV];
    
#pragma mark - 创建navigation的中间的titleView
    titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 75, self.num, 150, 40)];
    titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    //titleBtn.backgroundColor = RGBA(125, 125, 125, 0.5);
    [titleBtn setTitle:[NSString stringWithFormat:@"HR圈·%@",cityNameStr] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    titleBtn.tag = 1;
    [titleImageV addSubview:titleBtn];
    
    arrowImageV = [[UIImageView alloc]initWithFrame:CGRectMake(titleBtn.frame.size.width - 27, titleBtn.frame.size.height / 2 - 15, 30, 30)];
    arrowImageV.image = [UIImage imageNamed:@"icon_down"];
    [titleBtn addSubview:arrowImageV];
    
    leftItem = [[UIButton alloc]initWithFrame:CGRectMake(10, 5 + self.num, 40.0f, 40.0f)];
    [leftItem addTarget:self action:@selector(back:) forControlEvents:
     UIControlEventTouchUpInside];
    leftItem.tag = 1;
    
    UIImageView* backItem = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0f, 25.0f)];
    [leftItem addSubview:backItem];
    backItem.image = [UIImage imageNamed:@"hr_menu_left"];
    [titleImageV addSubview:leftItem];
    
    rightItem = [[UIButton alloc]initWithFrame:CGRectMake(iPhone_width - 40, 5 + self.num, 30.0f, 30.0f)];
    [rightItem addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* right_item = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 33.0f, 30.0f)];
    [rightItem addSubview:right_item];
    rightItem.tag = 1;
    right_item.image = [UIImage imageNamed:@"bonus_job_message"];
    [titleImageV addSubview:rightItem];
    
    rightItemUnread = [[UIButton alloc]initWithFrame:CGRectMake(iPhone_width - 30, 5 + self.num, 15.0f, 15.0f)];
    [rightItemUnread addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemUnread.layer setCornerRadius:rightItemUnread.frame.size.width/2];
    [rightItemUnread.layer setMasksToBounds:YES];
    [rightItemUnread setBackgroundColor:[UIColor redColor]];
    rightItemUnread.alpha = 0;
    [titleImageV addSubview:rightItemUnread];
    
    
#pragma mark-创建头部选择器
    [self makeChoseUI];
}
#pragma mark - 导航的点击事件
-(void)back:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenLeftSide" object:nil];
}
-(void)addClick:(UIButton*)sender
{
    if (sender.tag == 1)
    {
        BgView.hidden = NO;
        [self.view addSubview:BgView];
        btnbgImageV.hidden = NO;
        [self.view addSubview:btnbgImageV];
        arrowImageV.image = [UIImage imageNamed:@"icon_up"];
        sender.tag = 2;
    }
    else if(sender.tag == 2)
    {
        arrowImageV.image = [UIImage imageNamed:@"icon_down"];
        BgView.hidden = YES;
        btnbgImageV.hidden = YES;
        sender.tag = 1;
    }
    else
    {
        
    }
}
#pragma mark - 创建头部选择器
-(void)makeChoseUI
{
    UIImage* bgImage = [UIImage imageNamed:@"pop_bg2"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:25 topCapHeight:30];
    //AppDelegate * del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (IOS7) {
        //btnBg = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 60, 64 -7.7, 120, 37*2 + 5)];
        BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 , iPhone_width, iPhone_height)];
        btnbgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 60, 64 -7.7, 120, 37*2 + 5)];
    }
    else
    {
        //btnBg = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 60, 44 -7.7, 120, 37*2 + 5)];
        BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height)];
        btnbgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 60, 44 -7.7, 120, 37*2 + 5)];
    }
    BgView.userInteractionEnabled = YES;
    //btnBg.image = bgImage;
    BgView.backgroundColor = RGBA(0, 0, 0, 0.15);
    [self.view addSubview:BgView];
    btnbgImageV.userInteractionEnabled = YES;
    btnbgImageV.image = bgImage;
    [BgView addSubview:btnbgImageV];
    
    chooseBtnAll = [[UIButton alloc]initWithFrame:CGRectMake(2.5,7.7+36*0, 120, 36.5)];
    chooseBtnAll.titleLabel.font = [UIFont systemFontOfSize:14];
    [chooseBtnAll setTitle: @"全城职位" forState:UIControlStateNormal];
    [chooseBtnAll setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    chooseBtnAll.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseBtnAll.tag = 10086;
    [chooseBtnAll addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
    [btnbgImageV addSubview:chooseBtnAll];
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(2, 36.5, 110, 0.5)];
    line.image = [UIImage imageNamed:@"page_category_line"];
    line.backgroundColor = RGBA(152, 167, 160, 1);
    [chooseBtnAll addSubview:line];
    chooseBtnMyHR = [[UIButton alloc]initWithFrame:CGRectMake(2.5,7.7+36*1, 120, 36.5)];
    [chooseBtnMyHR setTitle: @"我的HR圈职位" forState:UIControlStateNormal];
    chooseBtnMyHR.titleLabel.font = [UIFont systemFontOfSize:14];
    [chooseBtnMyHR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chooseBtnMyHR.titleLabel.textAlignment = NSTextAlignmentCenter;
    chooseBtnMyHR.tag = 10087;
    [chooseBtnMyHR addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
    [btnbgImageV addSubview:chooseBtnMyHR];
    BgView.hidden = YES;
    btnbgImageV.hidden = YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BgView.hidden = YES;
    btnbgImageV.tag = 1;
    btnbgImageV.hidden = YES;
}
-(void)occlusion:(UIButton*)sender
{
    NSLog(@"哎呀");
}
#pragma mark - 点击选择器操作
-(void)chose:(UIButton*)sender
{
    pageIndex1 = 1;
    titleBtn.tag = 1;
    if (sender.tag - 10086 == 0) {
        NSLog(@"点击了全城职位");
        [chooseBtnAll setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [chooseBtnMyHR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn setTitle:[NSString stringWithFormat:@"HR圈·%@",cityNameStr] forState:UIControlStateNormal];
        arrowImageV.image = [UIImage imageNamed:@"icon_down"];
        loadType = 1;
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestDataWithPage:pageIndex1];
        [hrTableView scrollsToTop];
    }
    else if (sender.tag - 10086 == 1)
    {
        [chooseBtnAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chooseBtnMyHR setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [titleBtn setTitle:@"我的HR圈职位" forState:UIControlStateNormal];
        arrowImageV.image = [UIImage imageNamed:@"icon_down"];
        NSLog(@"点击了我的HR圈职位");
        loadType = 2;
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestDataWithPage:pageIndex1];
        [hrTableView scrollsToTop];
    }
    else
    {//点击了剩余部分
        
    }
    BgView.hidden = YES;
    btnbgImageV.hidden = YES;
}
#pragma mark - 跳私信列表
-(void)rightBtnClick:(UIButton *)sender
{
    MessageListViewController *jobCollectVC = [[MessageListViewController alloc] init];
    jobCollectVC.isFromHr = YES;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        [((UINavigationController *)app.window.rootViewController) pushViewController:jobCollectVC animated:YES];
    }
}
#pragma mark - 点击进入我的名片
-(void)cardBtnClick
{
    NSLog(@"我的名片页面");
    HR_MyCardViewController * vc = [[HR_MyCardViewController alloc]init];
    AppDelegate * del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([del.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)del.window.rootViewController) pushViewController:vc animated:YES];
    }
}
#pragma mark- HR_JobDetailVCCollectDelegate
//职位详细页收藏操作后，更新列表页
-(void)afterCollectOperationDoneWithDataArray:(NSMutableArray *)array{
    _dataArray = [NSMutableArray arrayWithArray:array];
    [hrTableView reloadData];
}

-(void)setSiXinCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userUid = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"userUid"]];
    NSDictionary *dic = [mUserDefaults valueForKey:@"SixinCount"];
    NSString *countStr = [dic valueForKey:userUid];
    if (countStr.length == 0) {
        countStr = @"0";
    }
    
    NSString *loginStr=[userDefaults valueForKey:@"LoginNew"];
    
    if (loginStr&&loginStr.integerValue==0&&countStr.integerValue!=0) {
        rightItemUnread.alpha=1;
    }else
    {
        rightItemUnread.alpha=0;
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
//以前的头部
//    chooseIconBtn = [MyControl createButtonFrame:CGRectMake(27.0f, searchBgImageV.frame.size.height + searchBgImageV.frame.origin.y + 18.0f, 57.5f, 57.5f) bgImageName:@"personal_center_head_default" image:nil title:nil method:@selector(chooseIconClick) target:self];
//    chooseIconBtn.layer.cornerRadius = chooseIconBtn.frame.size.width /2;
//    chooseIconBtn.layer.masksToBounds = YES;
//    [headerView addSubview:chooseIconBtn];
//
//    nameLabel = [MyControl createLableFrame:CGRectMake(chooseIconBtn.frame.origin.x + chooseIconBtn.frame.size.width + 15.0f, searchBgImageV.frame.origin.y + searchBgImageV.frame.size.height + 18.0f, 136, 17) font:17 title:@"徐雪妮"];
//    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    nameLabel.textAlignment = NSTextAlignmentLeft;
//    nameLabel.font = [UIFont boldSystemFontOfSize:17];
//
//    UITapGestureRecognizer *tapNameLabel =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardBtnClick)];
//    nameLabel.userInteractionEnabled = YES;
//    [nameLabel addGestureRecognizer:tapNameLabel];
//
//    [headerView addSubview:nameLabel];
//
//    HRImageV = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 4, nameLabel.frame.origin.y + 2.0f, 34.0f, 15.0f)];
//    HRImageV.image = [UIImage imageNamed:@"hr_noauth"];
//    [headerView addSubview:HRImageV];
//
//    VCompanyImageV = [[UIImageView alloc]initWithFrame:CGRectMake(HRImageV.frame.origin.x + HRImageV.frame.size.width + 4, HRImageV.frame.origin.y, HRImageV.frame.size.width, HRImageV.frame.size.height)];
//    VCompanyImageV.image = [UIImage imageNamed:@"hr_company_n"];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyImageTap)];
//    VCompanyImageV.userInteractionEnabled = YES;
//    [VCompanyImageV addGestureRecognizer:tap];
//    [headerView addSubview:VCompanyImageV];
//
//    companmyNameLabel = [MyControl createLableFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 3.0f, 205.0f, 11.0f) font:11 title:@"青岛英网资讯股份有限公司"];
//    companmyNameLabel.textColor = [UIColor whiteColor];
//    //companmyNameLabel.backgroundColor = [UIColor greenColor];
//    companmyNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [headerView addSubview:companmyNameLabel];
//
//    jobTypeLabel = [MyControl createLableFrame:CGRectMake(companmyNameLabel.frame.origin.x, companmyNameLabel.frame.origin.y + companmyNameLabel.frame.size.height + 1.0f, 205.0f, 34.0f) font:11 title:@"纵观移动市场，一款移动app，要想长期在移动市场立足，最起码要包含以下几个要素：实用的功能、极强的用户体验、华丽简洁的外观。华丽外观的背后，少不了美工的辛苦设计，但如果开发人员不懂得怎么合理展示这些设计好的图片，将会糟蹋了这些设计，功亏一篑比如下面张图片，本来是设计来做按钮背景的"];
//    jobTypeLabel.numberOfLines = 3;
//    //jobTypeLabel.adjustsFontSizeToFitWidth = YES;
//    //jobTypeLabel.backgroundColor = [UIColor magentaColor];
//    jobTypeLabel.userInteractionEnabled = YES;
//    [jobTypeLabel addGestureRecognizer:tapNameLabel];
//    jobTypeLabel.textAlignment = NSTextAlignmentLeft;
//    jobTypeLabel.textColor = [UIColor whiteColor];
//    jobTypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [headerView addSubview:jobTypeLabel];

//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0, headerView.frame.size.height - 80.0f, iPhone_width, 0.5f)];
//    lineView.backgroundColor = RGBA(255, 255, 255, 0.4);
//    [headerView addSubview:lineView];
//
//    for (int i = 0; i < 2; i++) {
//        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( iPhone_width / 3 * (i + 1), headerView.frame.size.height - 80.0f, 0.5f, 40)];
//        lineView.backgroundColor = RGBA(255, 255, 255, 0.4);
//        [headerView addSubview:lineView];
//    }
//
//    recommendLabel = [MyControl createLableFrame:CGRectMake(0, headerView.frame.size.height - 65.0f, iPhone_width / 3, 11.0f) font:11 title:@"推荐0人"];
//    recommendLabel.textColor = [UIColor whiteColor];
//    recommendLabel.font = [UIFont boldSystemFontOfSize:11];
//    recommendLabel.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:recommendLabel];
//
//    rewardLabel = [MyControl createLableFrame:CGRectMake( iPhone_width / 3, headerView.frame.size.height - 65.0f, iPhone_width / 3, 11.0f) font:11 title:@"奖金0元"];
//    rewardLabel.textColor = [UIColor whiteColor];
//    rewardLabel.font = [UIFont boldSystemFontOfSize:11];
//    rewardLabel.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:rewardLabel];
//
//    resumeLabel = [MyControl createLableFrame:CGRectMake( iPhone_width / 3 * 2, headerView.frame.size.height - 65.0f, iPhone_width / 3, 11.0f) font:11 title:@"简历0份"];
//    resumeLabel.textColor = [UIColor whiteColor];
//    resumeLabel.font = [UIFont boldSystemFontOfSize:11];
//    resumeLabel.textAlignment = NSTextAlignmentCenter;
//    [headerView addSubview:resumeLabel];
//
//    for (int i = 0; i < 3; i++) {
//        UIButton * alphaBtn = [MyControl createButtonFrame:CGRectMake(iPhone_width / 3 * i, headerView.frame.size.height - 80, iPhone_width / 3, 40) bgImageName:nil image:nil title:nil method:@selector(alphaBtnClick:) target:self];
//        alphaBtn.tag = 10086 + i;
//        //        alphaBtn.backgroundColor = RGBA(123, 123, 123, 0.4);
//        [headerView addSubview:alphaBtn];
//    }
@end
