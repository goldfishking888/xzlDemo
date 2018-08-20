//
//  OtherJobListView.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "OtherJobListView.h"
#import "SearchResultCell.h"
#import "JobDetailViewController.h"//职位查看xin页
#import "MJRefresh.h"

@interface OtherJobListView()<UITableViewDelegate,UITableViewDataSource>
{
    int pageIndex;
    NSString * posiID;
    NSUserDefaults *userDefaults;

    UITableView * _tableView;
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation OtherJobListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - 初始化的数据
- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle
{
self.noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
self.noDateView.frame = CGRectMake(0, 44 + 20, iPhone_width, iPhone_height - 44 - 20);
}

- (id)initWithFrame:(CGRect)frame withPositionId:(NSString *)positionID //WithJobDetail:(PositionModel *)model
{
    self = [super initWithFrame:frame];
    if (self){
        pageIndex = 1;
        posiID = positionID;
        [self makeUI];
        [self initDidLoadWithNoDataTitle:nil];
        [self requestDataWithPage:1];
        
    }
    return self;
}

#pragma mark --*************____requestDataWithPage____**********
-(void)requestDataWithPage:(int)page
{
    //http://test.appapi.xzhiliao.com/api/position/partner/search_index
    //keyword city trade work_year degree 这些是参数，除了keyword，其他都是code
    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/other");
    NSString * tokenStr = [XZLUserInfoTool getToken];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:posiID forKey:@"position_id"];//position_id
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [paramDic setValue:@"10" forKey:@"count"];
    NSLog(@"paramDic is %@",paramDic);
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                if ([data[@"total"] intValue] != 0) {
                    if (page == 1) {
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        self.dataArray = tempArray;
                        [_tableView reloadData];
                    }else{
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        [self.dataArray addObjectsFromArray:tempArray];
                        [_tableView reloadData];
                    }
                    
                }else{
                    if (self.dataArray.count == 0) {
                        //                        _tableView.bounces = NO;
                        [self addSubview:self.noDateView];
                    }else
                    {
                        //                        _tableView.bounces = YES;
                        [self.noDateView removeFromSuperview];
                    }
                }
            }
            
        }
    } failure:^(NSError *error) {
         [_tableView headerEndRefreshing];
        NSLog(@"failed block%@",error);
    }];
}

-(void)makeUI
{
    self.backgroundColor = [UIColor cyanColor];
    UIView * sepaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 10)];
    sepaV.backgroundColor = RGBA(243, 243, 243, 1);
    [self addSubview:sepaV];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    // 上拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"上拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"上拉刷新";
    _tableView.footerReleaseToRefreshText = @"松开马上刷新";
    _tableView.footerRefreshingText = @"努力加载中……";
    
}

#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"otherJobCellID";
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        SearchResultModel * searchModel = [self.dataArray objectAtIndex:indexPath.row];
        [cell setDataWithModel:searchModel];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_otherDelegate checkOtherJob:self.dataArray otherIndex:indexPath.row];

}


#pragma mark - 上拉刷新的方法
- (void)headerRefresh{
    
    // 取新记录
    pageIndex = 1;
    [self requestDataWithPage:pageIndex];
    
}

- (void)footerRefresh{
    pageIndex++;
    [self requestDataWithPage:pageIndex];
}
@end
