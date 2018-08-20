//
//  GRMyIntroViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRMyIntroViewController.h"
#import "GRMyIntroCell.h"
#import "MJRefresh.h"
#import "JobDetailViewController.h"
@interface GRMyIntroViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    int pageIndex;
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation GRMyIntroViewController

#pragma mark - 初始化的数据
- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle
{
    self.noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
    self.noDateView.frame = CGRectMake(0, 44 + self.num + 75, iPhone_width, iPhone_height - 44 - self.num - 75);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"我的自荐"];
    [self initDidLoadWithNoDataTitle:nil];
    [self initTableView];
    [self requestDataWithPage:1];
}

#pragma mark --*************____requestDataWithPage____**********
-(void)requestDataWithPage:(int)page
{
    //http://test.appapi.xzhiliao.com/api/position/partner/recommend/oneself
    //page token
    
    NSString *urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/partner/recommend/oneself");
    NSString * tokenStr = [XZLUserInfoTool getToken];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:@"" forKey:@"position_id"];//position_id
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
                            GRMyIntroModel * searchModel = [[GRMyIntroModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        self.dataArray = tempArray;
                        [_tableView reloadData];
                    }else{
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            GRMyIntroModel * searchModel = [[GRMyIntroModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        [self.dataArray addObjectsFromArray:tempArray];
                        [_tableView reloadData];
                    }
                    
                }else{
                    if (self.dataArray.count == 0) {
                        _tableView.bounces = NO;
                        [self.view addSubview:self.noDateView];
                    }else
                    {
                       _tableView.bounces = YES;
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


-(void)initTableView
{
    UIView * bgV = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + self.num, iPhone_width, 85)];
    bgV.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bgV];
    
    UIImageView * toastImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, iPhone_width - 10 - 15, 60)];
    UIImage *image1 =[UIImage imageNamed:@"Personal_MyIntro"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width*0.3 topCapHeight:image1.size.height*0.7];
    toastImageV.image=image1;
    [bgV addSubview:toastImageV];
    
    UILabel * toastLab = [[UILabel alloc]initWithFrame:CGRectMake(7 + 12, 5, toastImageV.frame.size.width - 29, 50)];
    toastLab.backgroundColor = [UIColor clearColor];
    toastLab.text = @"若您的简历和企业需求匹配，通常小职了会在7个工作日内给您致电邀约面试。已经停止招聘的职位不会出现在列表中。";
    toastLab.textColor = RGBA(255, 146, 4, 1);
    toastLab.font = [UIFont systemFontOfSize:13];
    toastLab.numberOfLines = 0;
    [toastImageV addSubview:toastLab];

    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(15, bgV.frame.size.height - 1, iPhone_width - 15, 0.7)];
    lineV.backgroundColor = RGBA(239, 239, 239, 1);
    [bgV addSubview:lineV];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + self.num, iPhone_width, iPhone_height - 44 - self.num) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = bgV;//这样可让头部不停留
    
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

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"collectID";
    GRMyIntroCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GRMyIntroCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        GRMyIntroModel * introModel = [self.dataArray objectAtIndex:indexPath.row];
        [cell setDataWithModel:introModel];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobDetailViewController * vc = [[JobDetailViewController alloc]init];
    if (self.dataArray.count > 0) {
        GRMyIntroModel * model = [self.dataArray objectAtIndex:indexPath.row];
        vc.positionID = [NSString stringWithFormat:@"%@",model.Id];
        vc.companyName = model.company_name;

    }
    [self.navigationController pushViewController:vc animated:YES];
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
