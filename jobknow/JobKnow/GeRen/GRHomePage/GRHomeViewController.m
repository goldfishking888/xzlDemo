//
//  GRHomeViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/4/24.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRHomeViewController.h"
#import "PYSearch.h"
#import "SearchResultViewController.h"//搜索结果界面
#import "MenuDownView.h"
#import "XZLLoginVC.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayModel.h"
//
#import "XZLLoginVC.h"
#import "SearchResultCell.h"
#import "JobDetailViewController.h"
#import "GRBookerViewController.h"

#import "GRBookerModel.h"

#import "ReaderViewController.h"

#import "MJRefresh.h"

#import "PersonBasicInfoModel.h"
#import "JobOrientationModel.h"
#import "GRPartnerViewController.h"
#import "GRUploadResumeWebViewController.h"
#import "XZLPMListModel.h"

#import "GRPreBookViewController.h"



@interface GRHomeViewController ()<PYSearchViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,SDCycleScrollViewDelegate,MenuDropViewDelegate,CityDelegate>
{
    UIImageView *_navView;
    UIView *_selectLine ;
    UIButton *_preButton;
    BOOL isALL ;//0订阅 1全部
    int menueBar_height;
//    BOOL isPartner;//高度44的点击成文人才合伙人区域是否显示
    int TableViewSectionHeaderHeight;
    int LunboViewHeight;
    NSMutableArray * urlLinkArr;
    NSMutableArray * urlPicArr;
    
    MenuDownView *menuView ;
    NSMutableArray * array_booker;
    GRBookerModel *model_current;
    
    NSMutableArray *array_allPosition;
    NSMutableArray *array_bookerPosition;
    
    NSInteger index_booker;
    NSInteger index_all;
    
//    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    
    BOOL canGotoBookerView;//弹出订阅器列表时，不能跳转到其他界面，或者点击其他按钮
}

@end

@implementation GRHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}


#pragma mark- 获取订阅器
- (void)downloadReaderAndBookPosition:(BOOL)shouldRequestPositionList{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    if (array_booker.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/subscribe"];
    [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            if (!shouldRequestPositionList) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSMutableArray *dataArray = responseObject[@"data"];
                //                NSDictionary *dataDic = responseObject[@"data"];
                NSMutableArray *modelArray = [[NSMutableArray alloc] init];
                if (dataArray.count == 0) {
//                    _noDateView.hidden = NO;
                    [GRBookerModel deleteObjects:array_booker];
                    array_booker = [NSMutableArray new];
                    [GRBookerModel saveOrUpdateObjects:array_booker];
                   BOOL t =  [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return ;
                }else{
                    _noDateView.hidden = YES;
                }
                   NSMutableArray *array_booker_temple = (NSMutableArray *)[GRBookerModel findAll];
                if (array_booker_temple.count>0) {
                    [GRBookerModel deleteObjects:array_booker_temple];
                }
                array_booker_temple = [NSMutableArray new];
                [GRBookerModel saveOrUpdateObjects:array_booker_temple];
                
                for (NSDictionary *dic in dataArray) {
                    GRBookerModel *model = [GRBookerModel getBookerModelWithDic:dic];
                    [modelArray addObject:model];
                }
                [GRBookerModel saveOrUpdateObjects:modelArray];
                
                NSArray *modelArray2 = [GRBookerModel findAll];
                if (modelArray2.count==0) {
                    return ;
                }
                array_booker = [NSMutableArray arrayWithArray:modelArray2];
//                [_tableView reloadData];
                if(!model_current){
                    model_current = array_booker[0];
                }
                
                NSString*titleStr=[self combineStr1:model_current];
                menuView.menuTitles = @[titleStr];
                if (shouldRequestPositionList) {
                    [self requestPositionListWithModel:model_current];
                }
                
                NSLog(@"%@",modelArray2);
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        ghostView.message = @"网络出现问题，请稍后重试";
        //        [ghostView show];
        
    }];
    
}

-(void)LoginSucceed:(NSNotification *)noti{
    
}

#pragma mark - 根据DB时间戳，获取服务器的列表数据
- (void)requestDataWithToward{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/get/conversation/member/list"];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    NSString *sqlCriteria = nil;
    
    XZLPMListModel *pmTempModel = [XZLPMListModel findFirstByCriteria:sqlCriteria];
    NSString *lastDateline = pmTempModel ? pmTempModel.created_time : @"0";
    [paramDic setValue:@"0" forKey:@"createdTime"];
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *array = data[@"memberList"];
            if (error.integerValue == 0) {
                if ([array count] > 0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in array) {
                        
                        [tempArray addObject:[XZLPMListModel getPMListModelWithDic:dataDic isHistory:NO]];
                    }
                    int count = 0;
                    for (XZLPMListModel *model in tempArray) {
                        if ([model.unRead isEqualToString:@"1"]) {
                            count++;
                        }
                    }
                    if (count>0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnread object:[NSNumber numberWithInt:count]];
                    }
                }
                
            }else{
                
            }
        }
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        mAlertView(@"提示", @"获取数据失败，请检查网络");
        NSLog(@"failed block%@",error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    // 初始化tableView
    [self setupTableView];
    
    // 初始化轮播图
    [self setupBanerScrollview];
//    if (![XZLUserInfoTool isPartner]) {
        // 人才banner
        [self setupPBanner];
//    }

    [self setupNavigationBar];
    
    if (!isALL) {
        [self downloadReaderAndBookPosition:YES];
        
    }
    [XZLUserInfoTool updateUserInfo];
    
    //获取简历信息 有用的存一下
    [self getResumeInfo];
    //获取私信列表，用于获取未读消息数
    [self requestDataWithToward];
    
    
    //接受来自登录界面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSucceed:) name:@"LoginSucceed" object:nil];
    
    // 设置tableview的偏移量通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewContenInset) name:@"kSetTableViewContentInsetNSNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTableViewContenInset) name:@"kReSetTableViewContentInsetNSNotification" object:nil];
    //刷新用户信息操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedUserInfo) name:@"UpdatedUserInfoAction" object:nil];
    //用户信息刷新成功后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdatedUserInfo) name:@"updatedUserInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookerChangeReloadData:) name:@"bookerChangeReloadData" object:nil];
    
}

-(void)bookerChangeReloadData:(NSNotification *)noti{
    NSString *str = noti.object;
    if ([str isEqualToString:@"1"]) {
        array_booker = [NSMutableArray new];
    }else{
        
        array_booker = (NSMutableArray *)[GRBookerModel findAll];
    }
    
    if (array_booker.count==0) {
        menuView.menuTitles = @[@"您还未添加订阅器"];
        array_bookerPosition = [[NSMutableArray alloc] init];
        [_tableView reloadData];
        _noDateView.hidden = NO;
    }else{
        model_current = array_booker[0];
        NSString*titleStr=[self combineStr1:model_current];
        menuView.menuTitles = @[titleStr];
        [self downloadReaderAndBookPosition:YES];
    }
    
    
    
}

//刷新用户信息
-(void)updatedUserInfo{
    [XZLUserInfoTool updateUserInfo];
}

//刷新用户信息成功后
-(void)onUpdatedUserInfo{
    if ([XZLUserInfoTool isPartner]) {
        TableViewSectionHeaderHeight = LunboViewHeight ;
        [_headerView setFrame:CGRectMake(0, 0, kMainScreenWidth, TableViewSectionHeaderHeight)];
        [_tableView reloadData];

    }else{
        TableViewSectionHeaderHeight = LunboViewHeight +44;
        [_headerView setFrame:CGRectMake(0, 0, kMainScreenWidth, TableViewSectionHeaderHeight)];
        [_tableView reloadData];
    }
}

-(void)initData{
    array_booker = (NSMutableArray *)[GRBookerModel findAll];
    if (array_booker.count>0) {
        [GRBookerModel deleteObjects:array_booker];
    }
    array_booker = [NSMutableArray new];
    [GRBookerModel saveOrUpdateObjects:array_booker];
    array_allPosition = [NSMutableArray new];
    array_bookerPosition = [NSMutableArray new];
    
    index_booker = 1;
    index_all = 1;
//    isPartner = [XZLUserInfoTool isPartner];
    isALL = NO;
    canGotoBookerView = YES;
    menueBar_height = 96 ;
    LunboViewHeight = 200;
    TableViewSectionHeaderHeight = LunboViewHeight +44;
    
    //TableViewSectionHeaderHeight = LunboViewHeight + ([XZLUserInfoTool isPartner]?0:44) ;
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    [self initDidLoadWithNoDataTitle:@"暂无信息"];
    
}

- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle
{
    self.noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
    self.noDateView.frame = CGRectMake(0,TableViewSectionHeaderHeight+menueBar_height, kMainScreenWidth, kMainScreenHeight - TableViewSectionHeaderHeight-50-menueBar_height);
    self.noDateView.hidden = NO;
}

#pragma mark-获取简历信息
- (void)getResumeInfo{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    loadView.userInteractionEnabled = NO;
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                //                NSMutableArray *dataArray = responseObject[@"data"];
                NSDictionary *dataDic = responseObject[@"data"][@"resume"];
                PersonBasicInfoModel *modelB = [[PersonBasicInfoModel alloc] initWithDictionary:dataDic];
                JobOrientationModel *modelJ = [[JobOrientationModel alloc] initWithDictionary:dataDic];
                if (![modelJ.expect_job isNullOrEmpty]) {
                    [mUserDefaults setValue:modelJ.expect_job forKey:@"expect_job"];
                }else{
                    [mUserDefaults setValue:@"" forKey:@"expect_job"];
                }
                
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];
    
}



#pragma mark -设置tableview的偏移量通知

- (void)setTableViewContenInset {
    
    canGotoBookerView = NO;
    _searchButton.enabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        NSLog(@"%f",_tableView.contentInset.top);
    }];
}

- (void)resetTableViewContenInset {
    
    canGotoBookerView = YES;
    _searchButton.enabled = YES;
    //    [UIView animateWithDuration:0.1 animations:^{
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //
    //        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //        NSLog(@"%f",_tableView.contentInset.top);
    //    }];
}

-(void)logClick
{
    GRPreBookViewController *vc = [GRPreBookViewController new];
    [self.navigationController pushViewController:vc animated:YES];
//    XZLLoginVC *loginVC = [[XZLLoginVC alloc]init];
//    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark -初始化navigationBar
- (void)setupNavigationBar {
    
    // 导航栏背景view
    _navigationBackView = [[UIView alloc] init];
    _navigationBackView.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
    //    _navigationBackView.backgroundColor = RGBA(255, 255,255, 0);
    _navigationBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navigationBackView];
    
    UIView *s_back = [[UIView alloc] init];
    s_back.frame = CGRectMake(14, 27, kMainScreenWidth-14-45,32);
    s_back.backgroundColor = [UIColor whiteColor];
    s_back.userInteractionEnabled = YES;
    mViewBorderRadius(s_back, 15, 1, [UIColor whiteColor]);
    [_navigationBackView addSubview:s_back];
    
    UITapGestureRecognizer *tapSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBtnClick)];
    [s_back addGestureRecognizer:tapSearch];
    
//    UIButton * logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    logBtn.frame = CGRectMake(20, 100, 80, 30);
//    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [logBtn setBackgroundColor:[UIColor lightGrayColor]];
//    [logBtn addTarget:self action:@selector(logClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:logBtn];
    
    UILabel *label_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(92, 0, 100, 32)];
    label_placeholder.textColor = RGB(155, 155, 155);
    label_placeholder.font = [UIFont systemFontOfSize:14];
    label_placeholder.text= @"搜索职位";
    [s_back addSubview:label_placeholder];
    
    //右侧搜索按钮
    _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-36, 32, 22, 22)];
    
    [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_search22"] forState:UIControlStateNormal];
    
    [_searchButton addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBackView addSubview:_searchButton];
    
    
    UIButton * chooseCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseCityBtn.frame = CGRectMake(0, 0, 70, 32);
    //    chooseCityBtn.backgroundColor = [UIColor greenColor];
    [chooseCityBtn addTarget:self action:@selector(chooseCityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [s_back addSubview:chooseCityBtn];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 32)];
    _locationLabel.text = @"定位中";
    [self startLocation];
    
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _locationLabel.textColor = RGB(74, 74, 74);
    [chooseCityBtn addSubview:_locationLabel];
    
    UIImageView * image_down = [[UIImageView alloc]initWithFrame:CGRectMake(_locationLabel.frame.origin.x + _locationLabel.frame.size.width+5, 13, 12, 7)];
    image_down.image = [UIImage imageNamed:@"GRChooseCity_down"];
    [chooseCityBtn addSubview:image_down];
    
    
    //    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapClick)];
    //    [_locationView addGestureRecognizer:locationTap];
    
}

#pragma mark - chooseCityBtnClick 选择城市
-(void)chooseCityBtnClick:(UIButton *)sender
{
    if (!canGotoBookerView) {
        return;
    }
    allCityViewController *allCityVC=[[allCityViewController  alloc]init];
    allCityVC.delegate=self;
    allCityVC.city_selected = _locationLabel.text;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName{
    _locationLabel.text = cityName;
    [mUserDefaults setValue:cityName forKey:@"localCity"];
    [array_allPosition removeAllObjects];
    
}

#pragma mark -初始化tableView

- (void)setupTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight -50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // tableView头视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, TableViewSectionHeaderHeight)];
    //    _headerView.backgroundColor = [UIColor greenColor];
    _tableView.tableHeaderView = _headerView;
    
    // 上拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"加载更多";
    _tableView.footerReleaseToRefreshText = @"松开马上刷新";
    _tableView.footerRefreshingText = @"努力加载中……";
    
    [_tableView addSubview:_noDateView];
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    
    
    [self downloadReaderAndBookPosition:NO];
    
    if (isALL) {
        index_all = 1;
        [self requestALLPositionList];
    }else{
        if (array_booker.count==0) {
             [_tableView headerEndRefreshing];
            return;
        }
        index_booker = 1;
        [self requestPositionListWithModel:model_current];
    }
    
    
    
}
#pragma mark - 上拉加载更多的方法
- (void)footerRefresh{
    if (isALL) {
        index_all += 1;
        [self requestALLPositionList];
    }else{
        if (array_bookerPosition.count==0) {
            [_tableView footerEndRefreshing];
            return;
        }
        index_booker += 1;
        [self requestPositionListWithModel:model_current];
    }
}

#pragma mark- 订阅职位列表请求
-(void)requestPositionListWithModel:(GRBookerModel *)model{
    model_current = model;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    
    [paramDic setValue:model.bookPostName forKey:@"keyword"];//关键字
    [paramDic setValue:model.bookLocationCode forKey:@"city"];//城市的code
    [paramDic setValue:model.bookIndustryCode forKey:@"trade"];//十大行业单选
    [paramDic setValue:model.bookSalaryCode forKey:@"hope_salary"];//期望薪资
    [paramDic setValue:@"" forKey:@"work_year"];//工作年限
    [paramDic setValue:@"" forKey:@"degree"];//学历
    [paramDic setValue:[NSString stringWithFormat:@"%ld",(long)index_booker] forKey:@"page"];
    [paramDic setValue:@"10" forKey:@"count"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/position/partner/search_index"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        if (index_booker == 1) {
            array_bookerPosition = [NSMutableArray arrayWithCapacity:0];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                if (data[@"position_list"] != nil) {
                    if (index_booker == 1) {
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        array_bookerPosition = tempArray;
                        [_tableView reloadData];
                        if (array_bookerPosition.count == 0) {
                            _noDateView.hidden = NO;
                        }else{
                            _noDateView.hidden = YES;
                        }
                    }else{
                        NSMutableArray * array = data[@"position_list"];
                        if (array.count == 0) {
                            ghostView.message=@"没有更多数据";
                            [ghostView show];
                            return ;
                        }
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        
                        [array_bookerPosition addObjectsFromArray:tempArray];
                        [_tableView reloadData];

                    }
                    
                    
                }else{
                    
                }
            }
            
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        ghostView.message = @"网络出现问题，请稍后重试";
        //        [ghostView show];
        
    }];
    
}

#pragma mark- 全部职位列表请求
-(void)requestALLPositionList{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    
    NSString *cityCode = [XZLUtil getCityCodeWithCityName:_locationLabel.text];
    [paramDic setValue:cityCode forKey:@"city"];//城市的code
    [paramDic setValue:[NSString stringWithFormat:@"%ld",(long)index_all] forKey:@"page"];
    [paramDic setValue:@"10" forKey:@"count"];
    [paramDic setValue:@"" forKey:@"hope_salary"];//期望薪资
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/position/partner/search_index"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        if (index_all == 1) {
            array_allPosition = [NSMutableArray arrayWithCapacity:0];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                if (data[@"position_list"] != nil) {
                    if (index_all == 1) {
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        array_allPosition = tempArray;
                        if (array_allPosition.count == 0) {
                            _noDateView.hidden = NO;
                        }
                        [_tableView reloadData];
                    }else{
                        NSMutableArray * array = data[@"position_list"];
                        if (array.count == 0) {
                            ghostView.message=@"没有更多数据";
                            [ghostView show];
                            return ;
                        }
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        [array_allPosition addObjectsFromArray:tempArray];
                        [_tableView reloadData];
                    }
                    
                }else{
                    
                }
            }
            
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        ghostView.message = @"网络出现问题，请稍后重试";
        //        [ghostView show];
        
    }];
    
    
}


#pragma mark -初始化轮播图

- (void)setupBanerScrollview {
    
    NSString *urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/nav/list");
    NSString * tokenStr = kTestToken;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:tokenStr forKey:@"token"];//
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSMutableArray * dataArray = responseObject[@"data"];
                urlPicArr = [[NSMutableArray alloc]init];
                urlLinkArr = [[NSMutableArray alloc]init];
                for (int i = 0; i < dataArray.count; i++) {
                    [urlPicArr addObject:dataArray[i][@"imgUrl"]];
                    [urlLinkArr addObject:dataArray[i][@"redirectUrl"]];
                }
                // 本地加载 --- 创建不带标题的图片轮播器
                self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, LunboViewHeight) imageURLStringsGroup:urlPicArr];
                [self.cycleScrollView setImageURLStringsGroup:urlLinkArr];
                [self.cycleScrollView setPlaceholderImage:[UIImage imageNamed:@"GR_Home_banner"]];
                self.cycleScrollView.delegate = self;
                //                [self.cycleScrollView clickItemOperationBlock];//打开图片能点击可以调到事件
                self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
                self.cycleScrollView.currentPageDotColor = [UIColor orangeColor];
                [_headerView addSubview:self.cycleScrollView];
                self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"failed block%@",error);
    }];
    
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%@",urlLinkArr[index]);
    if (urlLinkArr[index] != nil) {
//        mGhostView(nil, @"不为空可跳转web");    
    }
}

#pragma mark -未成为人才合伙人banner
-(void)setupPBanner{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, LunboViewHeight, kMainScreenWidth, 44)];
    //    view.backgroundColor = [UIColor orangeColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(254, 112, 92).CGColor, (__bridge id)RGB(254, 140 , 104).CGColor, (__bridge id)RGB(253, 173, 114).CGColor];
    gradientLayer.locations = @[@0.3, @0.6];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
    //    [self.view.layer addSublayer:gradientLayer];
    [view.layer addSublayer:gradientLayer];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    label.text = @"您还未成为人才合伙人\n立即成为人才合伙人，享100%猎头总收益";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.contentMode = UIViewContentModeCenter;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = RTTextLineBreakModeWordWrapping;
    label.userInteractionEnabled = YES;
    [view addSubview:label];

    [_headerView addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclickPBanner)];
    [label addGestureRecognizer:tap];
}

#pragma mark -点击未成为人才合伙人banner
-(void)onclickPBanner{
    if([XZLUtil isUnderCheck]){
        GRUploadResumeWebViewController *vc = [GRUploadResumeWebViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (![XZLUserInfoTool isPartner]) {
        if ([XZLUserInfoTool isPartnerInfo]) {
            NSDictionary *dic = [mUserDefaults valueForKey:@"partnerInfo"];
            if (dic) {
                NSNumber *pay_money = dic[@"pay_money"];
                if (pay_money.intValue>0) {
                    GRUploadResumeWebViewController *vc = [GRUploadResumeWebViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
            }
            
        }
        GRPartnerViewController *vc = [GRPartnerViewController new];
        vc.isFullHeight = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -TableviewHeader 悬浮view
-(UIView *)view_back{
    if (_view_back == nil) {
        _view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, menueBar_height)];
        _view_back.backgroundColor = [UIColor clearColor];
        [_view_back addSubview:self.menuBar];
        
        UIView *view_book_back = [[UIView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, 48)];
        view_book_back.backgroundColor = RGB(247, 247, 247);
        view_book_back.tag = 1;
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48-0.5, kMainScreenWidth, 0.5)];
        viewLine.backgroundColor = RGB(231, 231, 231);
        [view_book_back addSubview:viewLine];
        
        
        menuView = [MenuDownView MenuDropViewWithSize:CGSizeMake(kMainScreenWidth/2, 48)];
                if (array_booker.count>0) {
                    GRBookerModel *model  = array_booker[0];
                    NSString*titleStr=[self combineStr1:model];
                    menuView.menuTitles = @[titleStr];
                }else{
                    menuView.menuTitles = @[@"您还未添加订阅器"];
                }
        
        menuView.delegate = self;
        [view_book_back addSubview:menuView];
        [_view_back addSubview:view_book_back];
        
        UIImageView *img_down = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-6, 0, 12, 48)];
        img_down.contentMode = UIViewContentModeCenter;//UIViewContentModeCenter
        img_down.image = [UIImage imageNamed:@"btn_down"];
        [view_book_back addSubview:img_down];
        
        UIButton *btn_book  = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-80, 0, 60, 48)];
        [btn_book setTitle:@"去订阅" forState:UIControlStateNormal];
        [btn_book addTarget:self action:@selector(goBooker) forControlEvents:UIControlEventTouchUpInside];
        [btn_book.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn_book setTitleColor:RGB(59, 153, 255) forState:UIControlStateNormal];
        [view_book_back addSubview:btn_book];
        
        [view_book_back bringSubviewToFront:viewLine];
        
        
        
    }
    UIView *temp_book = [_view_back viewWithTag:1];
    if (menueBar_height>48) {
        temp_book.hidden = NO;
    }else{
        temp_book.hidden = YES;
    }
    if (array_booker.count>0) {
//        GRBookerModel *model  = array_booker[0];
//        NSString*titleStr=[self combineStr1:model.bookPostName andStr2:model.bookLocationName andStr3:model.bookIndustryName];
//        menuView.menuTitles = @[titleStr];
    }else{
        menuView.menuTitles = @[@"您还未添加订阅器"];
    }
    return _view_back;
}

/**连接3个字符串**/

- (NSString *)combineStr1:(GRBookerModel *)model
{
    NSString *name = model.bookPostName;
    NSString  *city = model.bookLocationName;
    NSString *industry = model.bookIndustryName;
    NSString *salary = model.bookSalaryName;
    
    NSString *totalString=@"";
    
    if (![NSString isNullOrEmpty:name]) {
        totalString=[totalString stringByAppendingString:name];
    }
    
    if (![NSString isNullOrEmpty:city]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:city];
    }
    if (![NSString isNullOrEmpty:industry]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:industry];
    }
    
    if (![NSString isNullOrEmpty:salary]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:salary];
    }
    
    
//    if ([totalString length]>=17) {
//        totalString=[totalString substringToIndex:16];
//    }
    
    return totalString;
}


#pragma mark -MenuBar @"订阅",@"全部"
- (UIView *)menuBar
{
    if (_menuBar == nil) {
        CGRect frame = CGRectMake(0, 0, kMainScreenWidth, 48);
        _menuBar = [[UIView alloc] initWithFrame:frame];
        _menuBar.backgroundColor = [UIColor whiteColor];
        NSArray *titleArray = @[@"订阅",@"全部"];
        
        for (int i=0; i<titleArray.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(kMainScreenWidth/titleArray.count*i, 0,  kMainScreenWidth/titleArray.count, frame.size.height);
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHex:0x666666 alpha:1] forState:UIControlStateNormal];
            if (i==0) {
                [button setTitleColor:[UIColor colorWithHex:0xff9204 alpha:1] forState:UIControlStateNormal];
            }
            button.titleLabel.font = kContentFontSmall;
            [button addTarget:self action:@selector(touchPositionBar:) forControlEvents:UIControlEventTouchUpInside];
            [_menuBar addSubview:button];
            button.tag = 133 + i;
            if ( 0 == i) {
                button.backgroundColor = [UIColor whiteColor];
                _preButton = button;
                _selectLine = [[UIView alloc] init];
                _selectLine.backgroundColor = [UIColor orangeColor];
                _selectLine.frame = CGRectMake(button.frame.origin.x, frame.size.height-2, button.frame.size.width, 2);
                [_menuBar addSubview:_selectLine];
            }
        }
        [_menuBar bringSubviewToFront:_selectLine];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB(231, 231, 231);
        lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 1);
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48-1, kMainScreenWidth, 1)];
        viewLine.backgroundColor = RGB(231, 231, 231);
        [_menuBar addSubview:viewLine];
        
        [_menuBar addSubview:lineView];
        
    }
    return _menuBar;
}


#pragma mark- 点击 订阅 全部 按钮
- (void)touchPositionBar:(UIButton *)button{
    
    if (!canGotoBookerView) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _preButton.backgroundColor = [UIColor colorWithHex:0xf5f5f5 alpha:1];
        [_preButton setTitleColor:[UIColor colorWithHex:0x666666 alpha:1] forState:UIControlStateNormal];
        
        
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor colorWithHex:0xff9204 alpha:1] forState:UIControlStateNormal];
        _preButton = button;
    }];
    _selectLine.frame = CGRectMake(button.frame.origin.x+button.frame.size.width/2-_selectLine.frame.size.width/2, 48-2, _selectLine.frame.size.width, 2);
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    switch (button.tag - 133) {
        case 0:
            isALL = false;
            menueBar_height = 96;
            _noDateView.hidden = YES;
            if (array_bookerPosition.count>0) {
                [_tableView reloadData];
            }else{
                if(array_booker.count>0){
                    index_booker = 1;
                    [self requestPositionListWithModel:model_current];
                }else{
                    _noDateView.hidden = NO;
                    [_tableView reloadData];
                }
            }
            
            break;
        case 1:
            menueBar_height = 48;
            isALL = YES;
            _noDateView.hidden = YES;
            if (array_allPosition.count>0) {
                
                [_tableView reloadData];
            }else{
                index_all = 1;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self requestALLPositionList];
            }
            break;
            
        default:
            break;
    }
}



#pragma mark- 点击 去订阅
-(void)goBooker{
    
    if (!canGotoBookerView) {
        return;
    }
    //    ReaderViewController *booker = [[ReaderViewController alloc] init];
    
    GRBookerViewController *booker = [[GRBookerViewController alloc] init];
    [self.navigationController pushViewController:booker animated:YES];
}

//响应来自通知中心的方法,只有在登录成功之后才会调用该方法
- (void)downloadReader
{
    //    [self downloadBooker];
    //如果登录时订阅器数据下载失
    
}

#pragma mark -UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(tableView == self.tableView && section == 0){
        return menueBar_height;
    }else{
        return 0;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView == self.tableView && section == 0){
        return self.view_back;
    }else {
        
        return nil;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isALL) {
        return array_allPosition.count;
    }else{
        
        NSInteger minNum = 2;
        if (isScreenIPhone6Upper) {
            minNum = 4;
        }else if (isScreenIPhone6Below){
            minNum = 2;
        }
        if (array_bookerPosition.count<=minNum) {
            return minNum+2;
        }
        
        return array_bookerPosition.count;
        //        return 2;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellID = @"searchCellID";
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    NSMutableArray *array;
    if (isALL) {
        array = array_allPosition;
    }else{
        array = array_bookerPosition;
    }
    if (array.count > 0) {
        if (indexPath.row+1>array.count) {
            static NSString *indenifier=@"cellIndenifier";
            
            UITableViewCell *cell0=[tableView dequeueReusableCellWithIdentifier:indenifier];
            
            if (cell0==nil) {
                
                cell0=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenifier];
            }
            cell0.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell0;
        }
        SearchResultModel * searchModel = [array objectAtIndex:indexPath.row];
        [cell setDataWithModel:searchModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self requestAliPayData];
    NSMutableArray *array;
    if (isALL) {
        array = array_allPosition;
    }else{
        array = array_bookerPosition;
    }
    if (indexPath.row+1>array.count) {
        return;
    }
    
    
    SearchResultModel *model = array[indexPath.row];
    JobDetailViewController * vc = [[JobDetailViewController alloc]init];
    vc.positionID = [NSString stringWithFormat:@"%@",model.Id];
    vc.companyName = model.company_name;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)requestHotSearch
{
    
    NSString *urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/hot/keyword");//kCombineURL(kGRApi, @"");
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    NSLog(@"paramDic is %@",paramDic);
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray * dataArray = data[@"hotKeyword"];
                //                NSLog(@"dataarray %@",dataArray);
                NSArray *hotSeaches = [[NSArray alloc]init];
                hotSeaches = dataArray;
                NSLog(@"hotSeaches is %@",hotSeaches);
                PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索职位", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
                    // Called when search begain.
                    // eg：Push to a temp view controller
                    SearchResultViewController * vc = [[SearchResultViewController alloc]init];
                    vc.searchKey = searchText;
                    [searchViewController.navigationController pushViewController:vc animated:YES];
                }];
                // 3. Set style for popular search and search history
                searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
                searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
                // 隐藏搜索建议
                searchViewController.searchSuggestionHidden = YES;
                // 4. Set delegate
                searchViewController.delegate = self;
                // 5. Present a navigation controller
                //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
                //    [self presentViewController:nav animated:NO completion:nil];
                searchViewController.cityStr = _locationLabel.text;
                [self.navigationController pushViewController:searchViewController animated:true];
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"failed block%@",error);
        NSArray *hotSeaches = @[@"PHP",@"Android",@"产品经理",@"UI"];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索职位", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // Called when search begain.
            // eg：Push to a temp view controller
            SearchResultViewController * vc = [[SearchResultViewController alloc]init];
            vc.searchKey = searchText;
            [searchViewController.navigationController pushViewController:vc animated:YES];
        }];
        // 3. Set style for popular search and search history
        searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
        searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
        // 隐藏搜索建议
        searchViewController.searchSuggestionHidden = YES;
        // 4. Set delegate
        searchViewController.delegate = self;
        // 5. Present a navigation controller
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        //    [self presentViewController:nav animated:NO completion:nil];
        [self.navigationController pushViewController:searchViewController animated:true];
    }];
}

#pragma mark - 搜索
-(void)searchBtnClick
{
    if (!canGotoBookerView) {
        return;
    }
    [self requestHotSearch];
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat tableViewoffsetY = scrollView.contentOffset.y;
    
    NSLog(@"tableViewoffsetY is %f",tableViewoffsetY);
    UIColor * color = [UIColor whiteColor];
    CGFloat alpha = MIN(1, tableViewoffsetY/136);
    
    //    self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:alpha];
    
    
    //    if (tableViewoffsetY > 0) {
    //         [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    //
    //    }else {
    //        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    }
    
    if (tableViewoffsetY < 116){
        
        if (tableViewoffsetY<-1) {
            [UIView animateWithDuration:0.25 animations:^{
                
                _navigationBackView.hidden = YES;
                
            }];
            
        }else{
            [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            if (_tableView.y == 64) {
                [_tableView setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
            }
            _navigationBackView.hidden = NO;
            [UIView animateWithDuration:0.1 animations:^{
                
                
                _navigationBackView.backgroundColor = [UIColor clearColor];
                
            }];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        
    } else if (tableViewoffsetY >= 150){
        
//        [UIView animateWithDuration:0.1 animations:^{
            [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
            _navigationBackView.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            _navigationBackView.backgroundColor = kNavigationBarBg;
//        }];
    }
}


#pragma mark -MenuDropViewDelegate 订阅列表回调

- (NSInteger)numOfColInMenuView{
    
    return 1;
}

- (NSArray *)MenuDataSourceAtMenuBtnIndex:(NSInteger)menuBtnIndex{
    
    if (menuBtnIndex == 0) {
        if (array_booker.count>0) {
            NSMutableArray *array_titles = [NSMutableArray new];
            for (GRBookerModel *model in array_booker) {
                NSString *title = [self combineStr1:model];
                NSString *count = model.bookTodayData;
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:title forKey:@"title"];
                [dic setValue:count forKey:@"count"];
                [array_titles addObject:dic];
            }
            return array_titles;
        }
        return @[];
    }
}

#pragma mark 点击订阅列表其中一条
-(void)MenuDidSelectedItemWithMenuBtnIndex:(NSInteger)menuBtnIndex menuItem:(NSString *)menuString leftMenuItemString:(NSString *)leftItemString{
    canGotoBookerView = YES;
    _searchButton.enabled = YES;
    
    GRBookerModel *model = array_booker[menuBtnIndex];
    [self requestPositionListWithModel:model];
    
}

#pragma mark - 请求支付宝支付的数据
- (void)requestAliPayData
{
    
    
    //    void (^finished) (NSDictionary *data) = ^(NSDictionary *data){
    //        NSLog(@"login %@",data);
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        if ([[NSString stringWithFormat:@"%@",[data objectForKey:@"error"]] isEqualToString:@"0"]) {
    //            NSString *tradeNum = [NSString stringWithFormat:@"%@",data[@"out_trade_no"]];
    //            NSLog(@"%@",data[@"out_trade_no"]);
    //            _aliPayModel = [AliPayModel modelWithDic:data[@"signInfo"]];
    //            [self doAlipayPayWithModel:_aliPayModel andTradeNum:tradeNum];
    //        }else
    //        {
    //            OLGhostAlertView *ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:@"服务器开小差了，稍后再试···" timeout:1 dismissible:YES];
    //            [ghostView show];
    //        }
    //    };
    //
    //    void (^failed)   (NSString *error) = ^(NSString *error){
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        NSLog(@"failed block%@",error);
    //    };
    //
    //    GeneralNet *net   = [[GeneralNet alloc]init];
    //    NSString *pathStr = @"/app_pay/create_order";
    //    NSString *hostStr = kHostSite;
    //    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    //    [paramDic setValue:kToken forKey:@"token"];
    //    [paramDic setValue:IMEI forKey:@"imei"];
    //    [paramDic setValue:self.cityCode forKey:@"pay_city"];
    //    [paramDic setValue:[NSString stringWithFormat:@"%d",_price] forKey:@"price"];
    //    [paramDic setValue:[NSString stringWithFormat:@"%d",_personNum] forKey:@"quantity"];
    //    //    [paramDic setValue:@"1" forKey:@"totalMoney"];
    //    [paramDic setValue:[NSString stringWithFormat:@"%d",_personNum*_price] forKey:@"totalMoney"];
    //    [paramDic setValue:isSelfAccount?@"1":@"0" forKey:@"isSelfAccount"];
    //
    //    net.httpMethod = @"GET";
    //    [net requestDataWithParams:paramDic forPath:pathStr forHost:hostStr finished:finished failed:failed];
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText = @"正在请求订单……";
    //    [XZLNetWorkUtil requestGETURL:url params:param success:^(id responseObject) {
    //        NSDictionary *dic = responseObject;
    //        AliPayModel *payModel = [AliPayModel modelWithDic:dic];
    //        [self doAlipayPayWithModel:dic andTradeNum:@"1"];
    //
    //    } failure:^(NSError *error) {
    //        NSLog(@"失败");
    //        return ;
    //
    //    }];
    [self doAlipayPayWithModel:nil andTradeNum:@"1"];
    
}

- (void)doAlipayPayWithModel:(NSDictionary *)dic andTradeNum:(NSString *)tradeNum
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017071807798614";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    //    if ([appID length] == 0 ||
    //        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
    //                                                        message:@"缺少appId或者私钥。"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"确定"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    
    /*
     *生成订单信息及签名
     */
    //    //将商品信息赋予AlixPayOrder的成员变量
    //    Order* order = [Order new];
    //
    //    // NOTE: app_id设置
    //    order.app_id = @"2017071807798614";
    //
    //    // NOTE: 支付接口名称
    //    order.method = dic[@"service"];
    //
    //    // NOTE: 参数编码格式
    //    order.charset = @"utf-8";
    //    // NOTE: 支付宝服务器主动通知商户服务器里指定的页面http路径
    //    order.notify_url = @"http://www.xzhiliao.com/pay/back/partner";
    //
    //    // NOTE: 当前时间点
    //    NSDateFormatter* formatter = [NSDateFormatter new];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    //    order.timestamp = [formatter stringFromDate:[NSDate date]];
    //    //    order.timestamp = @"2017-02-10 14:20:04";
    //    //    order.timestamp = [XZLUtil getCurrentTimeStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    order.timestamp = dic[@"timestamp"];
    //    // NOTE: 支付版本
    //    order.version = dic[@"version"];
    //
    //    // NOTE: sign_type 根据商户设置的私钥来决定
    //    order.sign_type = dic[@"sign_type"];
    //
    //    // NOTE: 商品数据
    //    order.biz_content = @"";
    //
    //    //将商品信息拼接成字符串
    //    NSString *orderInfo = [order orderInfoEncoded:NO];
    //    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    //    NSLog(@"orderSpec = %@",orderInfo);
    //
    //    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *appScheme = @"XZHiLiao";
    //
    //    //签名在服务端没有urlencode,在这使用之前需要urlencode以下
    //    NSString *sign_encode = [XZLUtil urlEncodedString:dic[@"sign"]];
    //
    //    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    //    NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
    //                             orderInfoEncoded, sign_encode];
    
    //    NSString *orderString = dic[@"data"];
    NSString *orderString = @"alipay_sdk=alipay-sdk-php-20161101&app_id=2017071807798614&biz_content=%7B%22body%22%3A%22%E4%BA%BA%E6%89%8D%E5%90%88%E4%BC%99%E4%BA%BA%E8%B4%AD%E4%B9%B0%22%2C%22subject%22%3A+%22%E4%BA%BA%E6%89%8D%E5%90%88%E4%BC%99%E4%BA%BA%22%2C%22out_trade_no%22%3A+%221500543226597078fa2e655%22%2C%22timeout_express%22%3A+%2230m%22%2C%22total_amount%22%3A+%220.01%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fwww.xzhiliao.com%2Fpay%2Fback%2Fpartner&sign_type=RSA&timestamp=2017-07-20+17%3A33%3A46&version=1.0&sign=Rbf1VHQMAQz0ZiyjOd%2FbV9dcO1q4P6m%2FPT0IDbKIiYxJbH179ni9pp%2Bh7G6zvAnYUu6Y3pt%2Fv279RNTxpmZ%2B23PA7ipujKHDlfNGwkxrhyhNodxsf0DGQMAt61RjYU6LuQYd924IjbeXHoYFOGIrPdH%2BAbTdfmfCvc3eOtOltW0rbQ1%2B4P7zoCqxBO83h1FOQ81HFOWTr5IGlCUt4S74LBoh9quWzzOK9Kqvzp0q1TOJmkIMmPtd%2BG8YQ8jWbcWCY6Az%2FJRwPO3ECCHc%2BGyZOd4ENWMvOa7onn1QCalbW%2B%2FdhdfJ4GnjpbNyP7DMf44hahtN%2Fd9%2BPk90qrCRBbDtmQ%3D%3D";
    //    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSNumber *resultStatus = resultDic[@"resultStatus"];
        if (resultStatus.intValue == 9000) {
            //成功
            //            NSDictionary *result = [XZLUtil dictionaryWithJsonString:resultDic[@"result"]];
            //            NSDictionary *response = result[@"alipay_trade_app_pay_response"];
            //            NSString *out_trade_no = response[@"out_trade_no"];
            //            [self requestCheckAliPayWithOutTradeNumber:out_trade_no];
            NSLog(@"1");
        }else if(resultStatus.intValue == 6001) {
            //取消
            //            _ghostView.message = @"支付取消";
            //            [_ghostView show];
        }else{
            //失败
            //            [self goToPayResultViewWithIfSucceeded:NO];
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 定位
-(void)startLocation{
    if (![CLLocationManager locationServicesEnabled] )
    {
        ghostView.message = @"定位失败，请手动选择城市！";
        [ghostView show];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        _locationLabel.text = @"北京";
        [mUserDefaults setValue:@"北京" forKey:@"localCity"];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        ghostView.message =@"请允许使用你的地理位置！";
        [ghostView show];
        [MBProgressHUD hideHUDForView:self.view animated:true];
        _locationLabel.text = @"北京";
        [mUserDefaults setValue:@"北京" forKey:@"localCity"];
    }
    else
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        [_locationManager startUpdatingLocation];
        return;
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [MBProgressHUD hideHUDForView:self.view animated:true];
    [_locationManager stopUpdatingLocation];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f 纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    //_latitude = newLocation.coordinate.latitude;
    //_longitude = newLocation.coordinate.longitude;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (error == nil &&[placemarks count] > 0) {
            for (CLPlacemark * placemark in placemarks) {
                ghostView.message = @"定位成功";
                [ghostView show];
                NSDictionary *test = [placemark addressDictionary];
                //  Country(国家)  State(省) City(城市)  SubLocality(区)
                NSString * cityStr = [test valueForKey:@"City"];
                cityStr = [cityStr stringWithoutShi];
               
                [mUserDefaults setValue:cityStr forKey:@"localCity"];
                _locationLabel.text = cityStr;
                return ;
            }
        }
        else if (error == nil &&
                 [placemarks count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
        ghostView.message = @"定位失败,默认为北京,请检查网络并在设置中开启定位权限";
        [ghostView show];
        _locationLabel.text = @"北京";
        [mUserDefaults setValue:@"北京" forKey:@"localCity"];
    }];
    
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    ghostView.message = @"定位失败,默认为北京,请检查网络并在设置中开启定位权限";
    [ghostView show];
    [mUserDefaults setValue:@"北京" forKey:@"localCity"];
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
