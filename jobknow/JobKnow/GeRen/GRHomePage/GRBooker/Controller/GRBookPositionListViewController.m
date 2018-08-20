//
//  GRBookPositionListViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/23.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRBookPositionListViewController.h"
#import "SearchResultCell.h"
#import "GRBookerModel.h"
#import "MJRefresh.h"
#import "JobDetailViewController.h"
#import "AppDelegate.h"
#import "XZLCommonWebViewController.h"

#define ColorHeadNum RGB(49,153,255)

@interface GRBookPositionListViewController ()

@end

@implementation GRBookPositionListViewController{
    NSMutableArray *dataArray;
    NSInteger page;
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    NSInteger count_today;
    NSInteger count_all;
    
    NSInteger count_today_all;
    NSInteger count_all_all;
    
    NSInteger count_source;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtnGR];
    [self addTitleLabelGR:[self combineStr1:_model.bookPostName andStr2:_model.bookLocationName andStr3:_model.bookIndustryName]];
    
    [self initData];
    
    // 初始化tableView
    [self setupTableView];
    [self requestPositionList];
    
    
}

- (void)backUp:(id)sender
{
    if (_isFromRegister) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app SetRootVC:@"0"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**连接3个字符串**/

- (NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3
{
    NSString *totalString=@"";
    
    if (![NSString isNullOrEmpty:str]) {
        totalString=[totalString stringByAppendingString:str];
    }
    
    if (![NSString isNullOrEmpty:str2]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:str2];
    }
    if (![NSString isNullOrEmpty:str3]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:str3];
    }
    
    
    if ([totalString length]>=17) {
        totalString=[totalString substringToIndex:16];
    }
    
    return totalString;
}

-(void)initData{
    dataArray = [NSMutableArray new];
    
    page = 1;
    
    count_today = [_model.bookTodayData integerValue];
    count_all = [_model.bookTotalData integerValue];
    
    for (GRBookerModel *item in _array_model_booker) {
        count_today_all += [item.bookTodayData integerValue];
        count_all_all += [item.bookTotalData integerValue];
    }
    
    count_source = [_model_cityInfo.website integerValue]+[_model_cityInfo.fair integerValue]+[_model_cityInfo.newspaper integerValue]+[_model_cityInfo.school integerValue]+[_model_cityInfo.company integerValue];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
}



-(void)headClick{
//    XZLLoginVC *loginVC = [[XZLLoginVC alloc]init];
//    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark -初始化tableView

- (void)setupTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight -64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    
    // 上拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"加载更多";
    _tableView.footerReleaseToRefreshText = @"松开马上刷新";
    _tableView.footerRefreshingText = @"努力加载中……";
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    page = 1;
    [self requestPositionList];
}

#pragma mark - 上拉加载更多的方法
- (void)footerRefresh{
    page += 1;
    [self requestPositionList];
}

#pragma mark- 订阅职位列表请求
-(void)requestPositionList{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    
    [paramDic setValue:_model.bookPostName forKey:@"keyword"];//关键字
    [paramDic setValue:_model.bookLocationCode forKey:@"city"];//城市的code
//    [paramDic setValue:@"" forKey:@"trade"];//十大行业单选
    [paramDic setValue:_model.bookIndustryCode forKey:@"trade"];//十大行业单选
    [paramDic setValue:_model.bookSalaryCode forKey:@"hope_salary"];//期望薪资
    [paramDic setValue:@"" forKey:@"work_year"];//工作年限
    [paramDic setValue:@"" forKey:@"degree"];//学历
    [paramDic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [paramDic setValue:@"10" forKey:@"count"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/position/partner/search_index"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        if (page == 1) {
            dataArray = [NSMutableArray arrayWithCapacity:0];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                if (data[@"position_list"] != nil) {
                    if (page == 1) {
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        dataArray = tempArray;
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
                        
                        [dataArray addObjectsFromArray:tempArray];
                        [_tableView reloadData];
                    }
                    
                    
                }else{
                    
                }
            }
            
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        //        ghostView.message = @"网络出现问题，请稍后重试";
        //        [ghostView show];
        
    }];
    
}

-(void)gotoBigData{
    XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
    vc.titleStr = @"职位大数据";
    NSString *url = kCombineURL(kTestAPPAPIGR, @"/web/account/from_source");
    url = [url stringByAppendingString:[NSString stringWithFormat:@"?localcity=%@",_model.bookLocationCode]];
    vc.urlStr = url;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 60;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    view_back.backgroundColor = [UIColor whiteColor];
    view_back.userInteractionEnabled = YES;
    
    //创建用来显示的label
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,9, kMainScreenWidth-80-33-15-5, 18)];
    numberLabel.font = [UIFont systemFontOfSize:13];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.textColor=RGB(155, 155, 155);
    
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"所有今日新增%ld条|累计%ld条",(long)count_today_all,(long)count_all_all]];
    
    [strA addAttribute:NSForegroundColorAttributeName value:ColorHeadNum range:NSMakeRange(6,[NSString stringWithFormat:@"%ld",(long)count_today_all].length)];
    [strA addAttribute:NSForegroundColorAttributeName value:ColorHeadNum range:NSMakeRange(6+[NSString stringWithFormat:@"%ld",(long)count_today_all].length+4,[NSString stringWithFormat:@"%ld",(long)count_all_all].length)];
    
    numberLabel.attributedText = strA;
    [view_back addSubview:numberLabel];
    
    
    //创建用来显示的label
    UILabel *numberLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15,33, kMainScreenWidth-90-33-15-5, 18)];
    numberLabel2.numberOfLines = 0;
    numberLabel2.font = [UIFont systemFontOfSize:13];
    numberLabel2.textAlignment = NSTextAlignmentLeft;
    numberLabel2.textColor=RGB(155, 155, 155);
    
    NSMutableAttributedString *strB = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"本条今日新增%ld条|累计%ld条",(long)count_today,(long)count_all]];
    
    [strB addAttribute:NSForegroundColorAttributeName value:ColorHeadNum range:NSMakeRange(6,[NSString stringWithFormat:@"%ld",(long)count_today].length)];
    [strB addAttribute:NSForegroundColorAttributeName value:ColorHeadNum range:NSMakeRange(6+[NSString stringWithFormat:@"%ld",(long)count_today].length+4,[NSString stringWithFormat:@"%ld",(long)count_all].length)];
    numberLabel2.attributedText = strB;
    [view_back addSubview:numberLabel2];
    
    //创建用来显示的label
    UILabel *numberLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-33-90,22,100, 18)];
    numberLabel3.numberOfLines = 0;
    numberLabel3.font = [UIFont systemFontOfSize:13];
    numberLabel3.textAlignment = NSTextAlignmentLeft;
    numberLabel3.textColor=RGB(155, 155, 155);
    numberLabel3.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoBigData)];
    [numberLabel3 addGestureRecognizer:tap];
    
    NSMutableAttributedString *strC = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"职位来源%ld个  >",(long)count_source]];
    
    [strC addAttribute:NSForegroundColorAttributeName value:ColorHeadNum range:NSMakeRange(4,[NSString stringWithFormat:@"%ld",(long)count_source].length)];
    numberLabel3.attributedText = strC;
    [view_back addSubview:numberLabel3];
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, kMainScreenWidth, 1)];
    view_line.backgroundColor = RGB(242, 242, 242);
    [view_back addSubview:view_line];
    
    return view_back;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellID = @"searchCellID";
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SearchResultModel * searchModel = [dataArray objectAtIndex:indexPath.row];
    [cell setDataWithModel:searchModel];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self requestAliPayData];
    SearchResultModel *model = dataArray[indexPath.row];
    JobDetailViewController * vc = [[JobDetailViewController alloc]init];
    vc.positionID = [NSString stringWithFormat:@"%@",model.Id];
    vc.companyName = model.company_name;
    [self.navigationController pushViewController:vc animated:YES];
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
