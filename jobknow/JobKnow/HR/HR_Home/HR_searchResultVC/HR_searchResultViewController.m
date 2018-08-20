//
//  HR_searchResultViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_searchResultViewController.h"
#import "MJRefresh.h"
#import "HRHomeIntroduceModel.h"
#import "OtherLogin.h"//重新登录
#import "HR_JobDetailVC.h"
#import "AppDelegate.h"
#import "HR_ResumeRecommendListViewController.h"
@interface HR_searchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    MJRefreshHeaderView * header1;
//    MJRefreshFooterView * footer1;
    int pageIndex1;
    UITableView * hrTableView;
     MBProgressHUD *loadView;
    UILabel * headerLabel;
    NSString * positionCountStr;
    NSString * moneyStr;
    
    int collectType;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * dataDicAll;
@property (nonatomic,strong)NSMutableDictionary * dataDicOfHRInfo;
@property (nonatomic,strong)NSMutableDictionary * dataDic;

@end

@implementation HR_searchResultViewController

#pragma mark - 创建下拉刷新

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    positionCountStr = @"0";
    moneyStr = @"0";
    pageIndex1 = 1;
    [self addBackBtn];
    [self addCenterTitle:@"搜索结果"];
    [self createTableView];
    [self requestDataWithPage:pageIndex1];
    // Do any additional setup after loading the view.
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    pageIndex1 =1;
    // 取新
    [self requestDataWithPage:pageIndex1];
    
}
- (void)footerRefresh{
    pageIndex1 ++;
    // 取更多记录
    [self requestDataWithPage:pageIndex1];
    
}

#pragma mark - createTableView
-(void)createTableView
{
    hrTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + (ios7jj), self.view.frame.size.width, self.view.frame.size.height - (44 + (ios7jj))) style:UITableViewStylePlain];
    hrTableView.delegate = self;
    hrTableView.dataSource = self;
    hrTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:hrTableView];
    
    // 下拉刷新
    [hrTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    hrTableView.headerPullToRefreshText= @"下拉刷新";
    hrTableView.headerReleaseToRefreshText = @"松开马上刷新";
    hrTableView.headerRefreshingText = @"努力加载中……";
    // 上拉刷新
    [hrTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    hrTableView.headerPullToRefreshText= @"上拉加载更多";
    hrTableView.headerReleaseToRefreshText = @"松开马上刷新";
    hrTableView.headerRefreshingText = @"努力加载中……";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRHomeIntroduceModel * model = [_dataArray objectAtIndex:indexPath.row];
//    NSString *count = [NSString stringWithFormat:@"%@",model.hrRecommendTotal];
//    if([count isEqualToString:@"0"]||!count||[count isEqualToString:@""]){
//        return 135.0f;
//    }
    return 155;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    else
    {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerLabel = [MyControl createLableFrame:CGRectMake(0, 0, self.view.frame.size.width, 20) font:11 title:nil];
    [headerLabel setText:[NSString stringWithFormat:@"共为您搜到%@个职位,奖金%@元",positionCountStr,moneyStr]];
    headerLabel.backgroundColor = RGBA(243, 243, 243, 1);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IDHR"];
    if (!cell) {
        cell = [[HRHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDHR"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = RGBA(241, 239, 240, 1);
    HRHomeIntroduceModel * model = [self.dataArray objectAtIndex:indexPath.row];
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
-(void)requestDataWithPage:(int)page
{
    NSString *url = kCombineURL(KWWWXZhiLiaoAPI,HRPositonList);
    
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    
    paramDic = @{
                     @"userToken":GRBToken,
                     @"userImei":IMEI,
                     @"page":[NSNumber numberWithInt:pageIndex1],
                     @"location":self.cityCodeStr,
                     @"searchCityCode":self.cityCodeStr,
                     @"searchKeyword":self.searchKeyStr,
                     @"count":@"20",
                     @"version":@"1"
                     };
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        if([hrTableView isHeaderRefreshing] == YES){
            [hrTableView headerEndRefreshing];
        }
        if([hrTableView isFooterRefreshing] == YES){
            [hrTableView footerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDics=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        NSNumber *error_code =[resultDics valueForKey:@"error_code"];
        
        NSMutableDictionary * resultDic = resultDics[@"data"];
        if(!resultDic||error_code.integerValue == 101){
            NSLog(@"请重新登录");
            ghostView.message=@"请重新登录";
            [ghostView show];
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return ;
        }
        if(error_code.integerValue == 0)
        {
            NSLog(@"请求成功");
            
            if (page == 1) {
                positionCountStr = [NSString stringWithFormat:@"%@",resultDic[@"allCounts"]];
                moneyStr = [NSString stringWithFormat:@"%@",resultDic[@"bouns"]];
                [headerLabel setText:[NSString stringWithFormat:@"共为您搜到%@个职位,奖金%@元",positionCountStr,moneyStr]];
                if([resultDic[@"data"] count] == 0)
                {
                    [self makeBgUI];
                }
                else
                {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
               
                    for (NSDictionary * item in [resultDic objectForKey:@"data"])
                    {
                        HRHomeIntroduceModel * homeModel = [[HRHomeIntroduceModel alloc]initWithDictionary:item];
                        [self.dataArray addObject:homeModel];
                    }
                    [hrTableView reloadData];
                }
                    //allCounts = 6  bouns = "22200-29394";
            }
            else//refresh == footer
            {
                    for (NSDictionary * item in [resultDic objectForKey:@"data"])
                    {
                        HRHomeIntroduceModel * homeModel = [[HRHomeIntroduceModel alloc]initWithDictionary:item];
                        [self.dataArray addObject:homeModel];
                    }
                    [hrTableView reloadData];
            }
        }
        
    }];
    [request setFailedBlock:^{
        ghostView.message=@"请求失败";
        [ghostView show];
        if([hrTableView isHeaderRefreshing] == YES){
            [hrTableView headerEndRefreshing];
        }
        if([hrTableView isFooterRefreshing] == YES){
            [hrTableView footerEndRefreshing];
        }
        NSLog(@"请求失败");
    }];
    [request startAsynchronous];
}
-(void)makeBgUI
{
//aio_face_default_fail
    hrTableView.hidden = YES;
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + (ios7jj), self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:bgView];
    
    UIImageView * errorImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height / 2 - 50 - 44 - (ios7jj), 100, 100)];
    errorImageV.image = [UIImage imageNamed:@"aio_face_default_fail"];
    [bgView addSubview:errorImageV];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, errorImageV.frame.origin.y + errorImageV.frame.size.height + 5, self.view.frame.size.width - 60, 40)];
    textLabel.font = [UIFont systemFontOfSize:11];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 2;
//    textLabel.backgroundColor = [UIColor orangeColor];
    textLabel.text = @"不好意思呢亲,没搜到您要的推荐奖金职位,您再瞅瞅别的吧";
    textLabel.textColor = RGBA(143, 143, 143, 1);
    [bgView addSubview:textLabel];
    
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
            ghostView.message=@"请重新登录";
            [ghostView show];
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return ;
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
    current_index = IndexPath;HRHomeIntroduceModel *model_job = [_dataArray objectAtIndex:IndexPath.row];
    
    NSUserDefaults * AppUD=[NSUserDefaults standardUserDefaults];
    if (![[AppUD valueForKey:@"hrState"] isEqualToString:@"2"]) {
        NSString *isHr = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"isHr"]];
        if([isHr isEqualToString:@"2"]){
            ghostView.message=@"兼职猎手身份通过认证后才能进行推荐";
        }else{
            ghostView.message=@"HR身份通过认证后才能进行推荐";
        }
        
        [ghostView show];
        return;
    }
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
    [self.navigationController pushViewController:hr_ResumeRec animated:YES];

}

-(void)requestSeeNum:(NSIndexPath *)INDEXPATH
{
    int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:INDEXPATH.row]).viewNum intValue];
    ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:INDEXPATH.row]).viewNum = [NSString stringWithFormat:@"%d",a + 1];
    //[NSNumber numberWithInt:1];
    [hrTableView reloadData];
}

#pragma mark- HR_JobDetailVCCollectDelegate
//职位详细页收藏操作后，更新列表页
-(void)afterCollectOperationDoneWithDataArray:(NSMutableArray *)array{
    _dataArray = [NSMutableArray arrayWithArray:array];
    [hrTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a stoninhairyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
