//
//  MessageListViewController.m
//  JobKnow
//
//  Created by AnyTime on 14-4-21.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"
#import "MJRefresh.h"

typedef enum {
    PMListRequestBackward = 0,// 用最小的时间戳，向后取历史记录
    PMListRequestForward = 1,// 用最大的时间戳，向前取最新的列表数据
    
}PMListRequestToward;

@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _num = ios7jj;
        _messageArray = [NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //清空私信未读数
    NSString *userUid = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"userUid"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mUserDefaults valueForKey:@"SixinCount"]];
    [dic setValue:@"0" forKey:userUid];
    [mUserDefaults setObject:dic forKey:@"SixinCount"];
    //将未读私信数置为0
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetSiXinCount" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayOut];
    
    [self initDataFromDB];
    [self requestDataWithToward:PMListRequestForward];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:kReceiveRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTableViewReloadNotification) name:kMessageListTableReload object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)initLayOut{
    [self addBackBtn];
    [self addTitleLabel:@"申请·私信"];
    [self initTableView];
    [self initDataFromDB];
    [self.view addSubview:_tableView];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+_num, iPhone_width, iPhone_height-44-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 上拉刷新
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"上拉加载更多";
    _tableView.footerReleaseToRefreshText = @"松开马上刷新";
    _tableView.footerRefreshingText = @"努力加载中……";
}
#pragma mark - 收到推送消息

- (void)receiveRemoteNotification{
    
    [self requestDataWithToward:PMListRequestForward];
    
}

#pragma mark - 收到刷新列表的推送

- (void)receiveTableViewReloadNotification{
    
    [_tableView reloadData];
    
}

#pragma mark - 从DB获取数据

- (void)initDataFromDB{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tempArray = [MessageListModel findByCriteria:@"order by dateline desc"];
        dispatch_async(dispatch_get_main_queue(), ^{
            _messageArray = [NSMutableArray arrayWithArray:tempArray];
            [_tableView reloadData];
        });
    });
    
}

#pragma mark - 上拉刷新的方法
- (void)footerRefresh{
    
    // 取历史记录
    [self requestDataWithToward:PMListRequestBackward];
    
}


#pragma mark - 获取私信列表
- (void)requestDataWithToward:(PMListRequestToward)toward
{
    Net *n = [Net standerDefault];
    if (n.status == NotReachable) {
        OLGhostAlertView *_alert = [[OLGhostAlertView alloc] initWithTitle:@"" message:@"无网络连接，请检查您的网络！"];
        [_alert show];
        return;
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@(toward),@"getunread",nil];
    NSString *sqlCriteria = nil;
    if (toward == PMListRequestForward) {//取新
        sqlCriteria = @"order by dateline desc";
    }else{// 取旧
        sqlCriteria = @"order by dateline asc";
    }
    MessageListModel *listTempModel = [MessageListModel findFirstByCriteria:sqlCriteria];
    NSString *lastDateline = listTempModel ? listTempModel.dateline : @"0";
    if([lastDateline isEqualToString:@"0"] == NO){
        lastDateline = [XZLUtil changeDateStrToTimestampStr:lastDateline];
    }
    [param setValue:lastDateline forKey:@"dateline"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/pm/pm_list_new?"];
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:param urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];//解析数据
        NSNumber *error = data[@"error"];
        if ([error isEqualToNumber:@(0)]) {
            NSMutableArray *array = data[@"data"];
            NSLog(@"PMList 获取到%@",array);
            if ([array count] > 0) {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (NSDictionary *dataDic in array) {
                    if (toward == PMListRequestForward && ![lastDateline isEqualToString:@"0"] ) {//取新
                        [tempArray addObject:[MessageListModel getMessageListModelWithDic:dataDic IsHistory:NO]];
                    }else{// 取旧
                        [tempArray addObject:[MessageListModel getMessageListModelWithDic:dataDic IsHistory:YES]];
                    }    
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [MessageListModel saveOrUpdateObjects:tempArray];
                    if((toward == PMListRequestForward) && ([tempArray count] == 20)){// 取新时，如果获取到20条数据，则继续去获取
                        [self requestDataWithToward:PMListRequestForward];
                    }
                    NSArray *tempArray = [MessageListModel findByCriteria:@"order by dateline desc"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _messageArray = [NSMutableArray arrayWithArray:tempArray];
                        [_tableView reloadData];
                    });
                });
            }
        }

    }];
    [request setFailedBlock:^{
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
    }];
    [request startAsynchronous];
}


//#pragma mark - sendRequest代理方法
//- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
//{
//   }
//- (void)receiveDataFail:(NSError *)error
//{
//    
//}
//- (void)requestTimeOut
//{
//    
//}

#pragma mark - tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    MessageListModel *info = [_messageArray objectAtIndex:indexPath.row];
    cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier message:info];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageDetailViewController *messageVC = [[MessageDetailViewController alloc] init];
    MessageListModel *msg = [_messageArray objectAtIndex:indexPath.row];
    messageVC.isFromHr = _isFromHr;
    messageVC.message = msg;
    messageVC.headerUrlString = msg.msgListhead;
    NSNull *null = [NSNull null];
    if ([null isEqual:msg.name]) {
        return;
    }
    [self.navigationController pushViewController:messageVC animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageListModel *msg = [_messageArray objectAtIndex:indexPath.row];
        
        NSString *url = kCombineURL(KXZhiLiaoAPI, kDeleteMessage);
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",
                               msg.plid,@"plid",nil];
        NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:param urlString:url];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
        [request setCompletionBlock:^{
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];//解析数据
            NSNumber *error = data[@"error"];
            if ([error isEqualToNumber:@(0)]) {
                [msg deleteObject];
                if(_messageArray||_messageArray.count>indexPath.row){
                    [_messageArray removeObjectAtIndex:indexPath.row];
                }
                // Delete the row from the data source.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }];
        [request setFailedBlock:^{
            [tableView reloadData];
        }];
        [request startAsynchronous];

        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
