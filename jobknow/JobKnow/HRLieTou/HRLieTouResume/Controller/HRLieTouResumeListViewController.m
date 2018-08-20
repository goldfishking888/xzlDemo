//
//  HRLieTouResumeListViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRLieTouResumeListViewController.h"
#import "MJRefresh.h"
#import "HRLieTouResumeListModel.h"
#import "HRLieTouResumeListTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "XZLCommonWebViewController.h"

@interface HRLieTouResumeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HRLieTouResumeListViewController{
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    NSMutableArray *dataArray;//简历数据源
    UITableView *_tableView;
    int page;
    UILabel *label_resumeCount;
    HRLieTouResumeListModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHeadViewGR];
    [self addTitleLabelGR:@"简历"];
    [self initData];
    [self initTableView];
    [self requestData];
}

-(void)initData{
    page = 1;
    _model = [HRLieTouResumeListModel new];
    dataArray = [NSMutableArray new];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    [self initDidLoadWithNoDataTitle:@"暂无信息"];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] init];
    [_tableView setFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // 下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    // 上拉刷新
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"上拉加载更多";
    _tableView.footerReleaseToRefreshText = @"松开马上加载";
    _tableView.footerRefreshingText = @"努力加载中……";

}

- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle
{
    self.noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
    self.noDateView.frame = CGRectMake(0,64+104, kMainScreenWidth, kMainScreenHeight - 64-104);
    self.noDateView.hidden = NO;
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    page = 1;
    [self requestData];
    
    
}
- (void)footerRefresh{
    page++;
    [self requestData];
    
}

#pragma mark 网络连接方法
-(void)requestData
{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/resumelib"];
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
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                if (data[@"resume"] != nil) {
                    NSMutableArray *arrayFormed  = data[@"resume"];
//                    NSMutableArray *arrayFormed  = [NSMutableArray new];
//                    for (NSString *key in [data[@"resume"] allKeys]) {
//                        NSDictionary *dic = [data[@"resume"] valueForKey:key];
//                        [arrayFormed addObject:dic];
//                    }
                    if (page == 1) {
                        NSMutableArray * array = arrayFormed;
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            HRLieTouResumeListModel * model = [[HRLieTouResumeListModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:model];
                        }
                        dataArray = tempArray;
                        [_tableView reloadData];
                        [_tableView addSubview:self.noDateView];
                        if (dataArray.count == 0) {
                            _noDateView.hidden = NO;
                        }else{
                            _noDateView.hidden = YES;
                        }
                        
                    }else{
                        NSMutableArray * array = arrayFormed;
                        if (array.count == 0) {
                            ghostView.message=@"没有更多数据";
                            [ghostView show];
                            return ;
                        }
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            HRLieTouResumeListModel * model = [[HRLieTouResumeListModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:model];
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
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
    }];
}

-(void)jumpToPCResumeInstruction{
    XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
    vc.titleStr = @"简历库管理";
    NSString *url = kCombineURL(kTestAPPAPIGR, @"/web/account/how_to_upload");
    vc.urlStr = url;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  104;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    [image setImage:[UIImage imageNamed:@"hrresume_header"]];
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapJump = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPCResumeInstruction)];
    [image addGestureRecognizer:tapJump];
    
    UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 104)];
    [view_back setBackgroundColor:RGB(102, 102, 102)];
    [view_back addSubview:image];
    
    label_resumeCount = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, kMainScreenWidth-20*2, 44)];
    [label_resumeCount setFont:[UIFont systemFontOfSize:13]];
    [label_resumeCount setTextColor:color_lightgray];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"简历数 %lu",(unsigned long)dataArray.count]];
    
    int l_count = (int)[[NSString stringWithFormat:@"%lu",(unsigned long)dataArray.count] length];//获取职位个数的长度
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(255, 163, 29) range:NSMakeRange(4, l_count)];
    
    label_resumeCount.attributedText = str;
    
    [view_back addSubview:label_resumeCount];
    return view_back;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"basicInfoCell";
    HRLieTouResumeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HRLieTouResumeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = dataArray[indexPath.row];
    return cell;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [_tableView cellHeightForIndexPath:indexPath model:_model keyPath:@"model" cellClass:[HRLieTouResumeListTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    return 163;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRLieTouResumeListModel *model = dataArray[indexPath.row];
    
    XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
    vc.titleStr = model.name;
    NSString *url = kCombineURL(KWWWXZhiLiaoAPI,@"/zhiliao/resume");
    url = [url stringByAppendingString:[NSString stringWithFormat:@"?rid=%@",model.resumeId]];
    vc.urlStr = url;
    [self.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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
