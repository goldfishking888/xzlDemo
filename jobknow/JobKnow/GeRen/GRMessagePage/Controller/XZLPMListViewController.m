//
//  XZLPMListViewController.m
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "XZLPMListViewController.h"
#import "XZLPMListModel.h"
#import "XZLNewPMListCell.h"
#import "XZLPMDetailViewController.h"
#import "MBProgressHUD.h"

typedef enum {
    PMListRequestBackward = 0,// 用最小的时间戳，向后取历史记录
    PMListRequestForward = 1,// 用最大的时间戳，向前取最新的列表数据
    
}PMListRequestToward;

@interface XZLPMListViewController ()
{
    NSMutableArray *dataArray;// 存放列表数据
    UITableView *_myTableView;// 列表
}

@end

@implementation XZLPMListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if (_hasBackBtn) {
        [self addBackBtnGR];
    }else{
        [self configHeadViewGR];
    }
    
    [self addTitleLabelGR:@"私信"];
    dataArray = [NSMutableArray array];
    
    [self initTableView];
//    [self initDataFromDB];
    [self initDidLoadWithNoDataTitle:@"暂无数据"];
    //去服务器请求最新数据
    [self requestDataWithToward:PMListRequestForward];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:kReceiveRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:kReceiveRemoteNotificationPMList object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 从DB中重新获取数据并刷新
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *tempArray = [XZLPMListModel findByCriteria:@"order by created_time desc"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            dataArray = [NSMutableArray arrayWithArray:tempArray];
//            [_myTableView reloadData];
//        });
//    });
    [self setSixinCount:@"0"];
    [[NSNotificationCenter defaultCenter]postNotificationName:kHasMessageUnread object:@999];
}

#pragma mark 设置未读私信数量
- (void)setSixinCount:(NSString *)count{
    // 重置私信红点
    NSString *pid = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"company_email"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mUserDefaults valueForKey:@"SixinCount"]];
    [dic setValue:count forKey:pid];
    [mUserDefaults setObject:dic forKey:@"SixinCount"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 收到推送消息

- (void)receiveRemoteNotification{
    
    [self requestDataWithToward:PMListRequestForward];
    
}

#pragma mark - 初始化tableView

- (void)initTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-(_hasBackBtn?0:50)) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myTableView];
    
//    // 上拉刷新
//    [_myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
//    _myTableView.footerPullToRefreshText= @"上拉刷新";
//    _myTableView.footerReleaseToRefreshText = @"松开马上刷新";
//    _myTableView.footerRefreshingText = @"努力加载中……";
    
    // 上拉刷新
    [_myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _myTableView.footerPullToRefreshText= @"下拉刷新";
    _myTableView.footerReleaseToRefreshText = @"松开马上刷新";
    _myTableView.footerRefreshingText = @"努力加载中……";
}

- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle
{
    _noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
    _noDateView.frame = CGRectMake(0,0, kMainScreenWidth, kMainScreenHeight - 64-50);
    _noDateView.hidden = YES;
    [_myTableView addSubview:_noDateView];
}

#pragma mark - 上拉刷新的方法

- (void)footerRefresh{
    
    // 取历史记录
    [self requestDataWithToward:PMListRequestBackward];
    
}

- (void)headerRefresh{
    
    // 取新记录
    [self requestDataWithToward:PMListRequestForward];
    
}

#pragma mark - 从DB获取数据

- (void)initDataFromDB{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tempArray = [XZLPMListModel findByCriteria:@"order by created_time desc"];
        dispatch_async(dispatch_get_main_queue(), ^{
            dataArray = [NSMutableArray arrayWithArray:tempArray];
            [_myTableView reloadData];
        });
    });
    
}

#pragma mark - 根据DB时间戳，获取服务器的列表数据
- (void)requestDataWithToward:(PMListRequestToward)toward
{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/get/conversation/member/list"];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    NSString *sqlCriteria = nil;
    if (toward == PMListRequestForward) {//取新
        sqlCriteria = @"order by created_time desc";
    }else{// 取旧
        sqlCriteria = @"order by created_time asc";
    }
    XZLPMListModel *pmTempModel = [XZLPMListModel findFirstByCriteria:sqlCriteria];
    NSString *lastDateline = pmTempModel ? pmTempModel.created_time : @"0";
    [paramDic setValue:@"0" forKey:@"createdTime"];
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if([_myTableView isHeaderRefreshing] == YES){
            [_myTableView headerEndRefreshing];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *array = data[@"memberList"];
            if (error.integerValue == 0) {
                if ([array count] > 0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in array) {
                        
                        [tempArray addObject:[XZLPMListModel getPMListModelWithDic:dataDic isHistory:(((toward == PMListRequestBackward) || ([lastDateline isEqualToString:@"0"]))?YES:NO)]];
                    }
                    dataArray = tempArray;
                    
                    [_myTableView reloadData];
                }
                if (dataArray.count == 0) {
                    _noDateView.hidden = NO;
                }else{
                    _noDateView.hidden = YES;
                }

            }else{
//                ghostView.message = @"用户名或密码错误，登录失败";
//                [ghostView show];
            }
        }
    } failure:^(NSError *error) {
//        [loadView hide:YES];
        mAlertView(@"提示", @"获取数据失败，请检查网络");
        NSLog(@"failed block%@",error);
        if([_myTableView isHeaderRefreshing] == YES){
            [_myTableView headerEndRefreshing];
        }

        
    }];
    
}


#pragma mark - tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PMListCell";
    XZLNewPMListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XZLNewPMListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    XZLPMListModel *model = dataArray[indexPath.row];
    [cell setModelData:model];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XZLPMDetailViewController *talklistVC = [[XZLPMDetailViewController alloc] init];
    XZLPMListModel *pmListModel = dataArray[indexPath.row];
//    XZLPMListModel *pmListModel = [[XZLPMListModel alloc] init];
//    pmListModel.uid = @"1";
    if ([pmListModel.unRead isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kHasMessageUnread object:@999];
        pmListModel.unRead = @"0";
        [pmListModel saveOrUpdate];
    }
    
    talklistVC.pmlistModel = pmListModel;
    
    [self.navigationController pushViewController:talklistVC animated:YES];
    
    [tableView reloadData];
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XZLPMListModel *model = dataArray[indexPath.row];
        
        void (^finished) (NSDictionary *data) = ^(NSDictionary *data){
            
            NSNumber *error = data[@"error"];
            if ([error isEqualToNumber:@(0)]) {
                [model deleteObject];
                if(dataArray||dataArray.count>indexPath.row){
                    [dataArray removeObjectAtIndex:indexPath.row];
                }
                // Delete the row from the data source.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        
        void (^failed)(NSString *error) = ^(NSString *error){
            [tableView reloadData];
            NSLog(@"failed block%@",error);
            
        };
//        
//        XZLNetworkRequest *net = [[XZLNetworkRequest alloc]init];
//        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//        [paramDic setValue:IMEI forKey:@"imei"];
//        [paramDic setValue:kToken forKey:@"token"];
////        [paramDic setValue:model.plid forKey:@"plid"];
//        
//        net.httpMethod = @"GET";
//        NSString *urlstr = [NSString stringWithFormat:@"%@%@",kHostAddress,@"/adminapi/pm/pm_del"];
//        [net requestDataWithParams:paramDic forPath:urlstr finished:finished failed:failed];
        
        
        
    }
    
}

@end
