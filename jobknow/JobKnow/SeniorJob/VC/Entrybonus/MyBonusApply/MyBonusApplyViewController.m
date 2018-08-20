//
//  MyBonusApplyViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//我的入职奖金

#import "MyBonusApplyViewController.h"
#import "MJRefresh.h"
//#import "MJRefreshHeaderView.h"
//#import "MJRefreshFooterView.h"

#import "OtherLogin.h"
#import "AppDelegate.h"
#import "MyBonusApplyModel.h"
#import "MyBonusApplyCell.h"
#import "MyBonusApplyDetailVC.h"//申请状态详情页
@interface MyBonusApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
//    MJRefreshHeaderView * header1;
//    MJRefreshFooterView * footer1;
    MBProgressHUD * loadView;
    int pageIndex1;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * dataDicAll;
@end

@implementation MyBonusApplyViewController

- (BOOL)judgmentLogin
{
    
    BOOL isLogin = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginNew"]] isEqualToString:@"0"];
    if( kUserTokenStr!= nil && ![kUserTokenStr isEqual: @""] && isLogin)    return YES;
    
    else return NO;
    //    NSUserDefaults *AppUD = [NSUserDefaults standardUserDefaults];
    //    NSString *pwd = [AppUD valueForKey:@"passWord"];
    //    if(pwd.length>0)
    //    {
    //        return YES;
    //    }else
    //    {
    //        return NO;
    //    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBtn];
    [self addTitleLabel:@"我的奖金申请"];
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    pageIndex1 = 1;
    [self createTableView];
    if([self judgmentLogin]){
        [self requestDataWithPage:pageIndex1];
    }else{

    }
    NSUserDefaults * BonusApplyDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dicHuanCun = [BonusApplyDefault valueForKey:@"BonusApplyDic"];
//    if (dicHuanCun != nil) {
//        self.dataDicAll = dicHuanCun;
//        [_tableView reloadData];
//        [header1 beginRefreshing];
//    }
//    else
//    {
//        [header1 beginRefreshing];
//    }

}

#pragma mark - 创建tableview
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + ios7jj, self.view.frame.size.width, self.view.frame.size.height - (44 + ios7jj)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = RGBA(243, 243, 243, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // 下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    // 上拉刷新
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"上拉刷新";
    _tableView.footerReleaseToRefreshText = @"松开马上刷新";
    _tableView.footerRefreshingText = @"努力加载中……";
    
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    pageIndex1 =1;
    // 取新
    [self requestDataWithPage:pageIndex1];
    
}
- (void)footerRefresh{
    pageIndex1 ++;
    // 取历史记录
    [self requestDataWithPage:pageIndex1];
    
}

#pragma mark - loadDataOfCircle
-(void)requestDataWithPage:(int)page
{
        //http://api.xzhiliao.com/ new_api/senior/bill_list?
    NSString *url = kCombineURL(KXZhiLiaoAPI,SeniorMyBillApplyList);
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
    NSDictionary * paramDic = [[NSDictionary alloc]init];
        paramDic = @{
                     @"userToken":strUsertoken,
                     @"userImei":IMEI,
                     @"page":[NSNumber numberWithInt:pageIndex1],
                     };
   
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
        NSError *error;
        NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        if ([resultStr isEqualToString:@"please login"])
        {

            [loadView hide:YES];
            ghostView.message=@"请重新登录";
            [ghostView show];
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
//            HRLogin *vc = [[HRLogin alloc]init];
//            vc.backType = @"BackPersonalVC";
////            NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
        }
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            [loadView hide:YES];
            ghostView.message=@"暂无奖金申请";
            [ghostView show];

            return;
        }
        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            self.dataDicAll = [resultDic mutableCopy];
            
            NSMutableArray *array = [resultDic objectForKey:@"date_list"];
            if (array.count==0&&pageIndex1 == 1) {
                JumpWebViewController *vc = [[JumpWebViewController alloc] init];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                vc.jumpRequest = [NSString stringWithFormat:@"%@new_api/senior/senior_about?userImei=%@&userToken=%@&ios_ver=2.8.5",KXZhiLiaoAPI,IMEI,[userDefaults valueForKey:@"userToken"]];
                vc.webTitle = @"入职奖金";
                vc.isFromNodataApplyList = YES;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }

            //本地存储
//            NSUserDefaults * HRHomeDefault = [NSUserDefaults standardUserDefaults];
//            [HRHomeDefault setValue:self.dataDicAll forKey:@"BonusApplyDic"];
//            [HRHomeDefault synchronize];

            if (pageIndex1 == 1) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
                
                for (NSDictionary * item in [resultDic objectForKey:@"date_list"])
                {
                    MyBonusApplyModel * bonusModel = [[MyBonusApplyModel alloc]initWithDictionary:item];
                    [self.dataArray addObject:bonusModel];
                }
                [_tableView reloadData];
            }
            else//refresh == footer
            {
                [loadView hide:YES];
                
                for (NSDictionary * item in [resultDic objectForKey:@"date_list"])
                {
                    MyBonusApplyModel * bonusModel = [[MyBonusApplyModel alloc]initWithDictionary:item];
                    [self.dataArray addObject:bonusModel];
                }
                if ([[resultDic objectForKey:@"data"] count] == 0) {
                    ghostView.message=@"没有更多数据";
                    [ghostView show];
                }
                [_tableView reloadData];
            }

        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message=@"请求失败";
        [ghostView show];
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }

    }];
    [request startAsynchronous];
}
- (void)backUp:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBonusApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IDBonus"];
    if (!cell) {
        cell = [[MyBonusApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDBonus"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = RGBA(243, 243, 243, 1);
    MyBonusApplyModel * model = [self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"%@",model);
    [cell configData:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBonusApplyDetailVC * vc = [[MyBonusApplyDetailVC alloc]init];
    MyBonusApplyModel * model = [self.dataArray objectAtIndex:indexPath.row];
    vc.bonusState = [NSString stringWithFormat:@"%@",model.bounsStatus];
    vc.NewModel = model;
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
