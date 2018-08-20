//
//  HRCollectionsVC.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRCollectionsVC.h"
@interface HRCollectionsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
}
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation HRCollectionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"收藏的职位"];
    [self initTableView];
    // Do any additional setup after loading the view.
}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + self.num, iPhone_width, iPhone_height - 44 - self.num) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"collectID";
    HRCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HRCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HRCollectionModel * coll_model = [_dataArray objectAtIndex:indexPath.row];
    [cell configData:coll_model withIndexPath:indexPath];
    cell.delegate = self;
    cell.IndexPath = indexPath;
    cell.tag = (int)indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 点击收藏按钮实现功能
-(void)CollectionClick:(NSIndexPath *)indexPath
{
    mGhostView(nil, @"收藏");
//    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HRHomeIntroduceModel * model = (HRHomeIntroduceModel *)[self.dataArray objectAtIndex:indexPath.row];
//    NSString *url = kCombineURL(KXZhiLiaoAPI,HRCollectPosition);
//    NSDictionary *paramDic = [[NSDictionary alloc]init];
//    collectType = [model.isfavorites intValue];
//    if (collectType == 1)
//    {
//        NSLog(@"已收藏的状态");
//        //取消收藏接口// http://api.xzhiliao.com/ hr_api/job/job_fav?
//        paramDic = @{
//                     @"userToken":GRBToken,
//                     @"userImei":IMEI,
//                     @"jobId":model.postId,
//                     @"localcity":model.cityCode,
//                     @"flag":@"del"//为空代表添加收藏即可
//                     };
//    }
//    else
//    {
//        //        [cell changeCollectionImagewithNumber:0];
//        //        loadType = 1;
//        NSLog(@"没收藏过");
//        paramDic = @{
//                     @"userToken":GRBToken,
//                     @"userImei":IMEI,
//                     @"jobId":model.postId,
//                     @"localcity":model.cityCode,
//                     @"flag":@""//为空代表添加收藏即可
//                     };
//    }
//    
//    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
//    request.tag = collectType;
//    [request setCompletionBlock:^{
//        [loadView hide:NO];
//        NSError *error;
//        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
//        NSString *errorStr =[resultDic valueForKey:@"error"];
//        
//        if(!resultDic)
//        {
//            NSLog(@"请重新登录");
//            [loadView hide:YES];
//            ghostView.message=@"请重新登录";
//            [ghostView show];
//            HRLogin *vc = [HRLogin new];
//            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//                [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
//            }
//            return ;
//        }
//        if(errorStr.integerValue == 0)
//        {
//            NSLog(@"请求成功");
//            [loadView hide:YES];
//            ghostView.message=@"操作成功";
//            [ghostView show];
//            if (request.tag == 1) {
//                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).isfavorites = @"0";
//                int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum intValue];
//                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum = [NSString stringWithFormat:@"%d",a - 1];
//                [hrTableView reloadData];
//                
//            }
//            else if (request.tag == 0){
//                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).isfavorites = @"1";
//                int a = [((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum intValue];
//                ((HRHomeIntroduceModel *)[_dataArray objectAtIndex:indexPath.row]).favNum = [NSString stringWithFormat:@"%d",a + 1];
//                [hrTableView reloadData];
//            }
//        }
//    }];
//    
//    [request setFailedBlock:^{
//        [loadView hide:YES];
//        ghostView.message=@"请求失败";
//        [ghostView show];
//        NSLog(@"请求失败");
//        
//    }];
//    [request startAsynchronous];//开启request的Block
    
}

#pragma mark- 简历推荐点击事件
-(void)introduceClick:(NSIndexPath *)IndexPath
{
     mGhostView(nil, @"推荐投递0");
//    current_index = IndexPath;
//    HRHomeIntroduceModel *model_job = [_dataArray objectAtIndex:IndexPath.row];
//    NSUserDefaults * AppUD=[NSUserDefaults standardUserDefaults];
//    
//    NSString *hr_company_id = [AppUD valueForKey:@"company_pid"];
//    if (hr_company_id) {
//        if ([hr_company_id isEqualToString:model_job.companyId]) {
//            ghostView.message=@"您不能给自己的东家推荐人才哦~";
//            [ghostView show];
//            return;
//        }
//    }
//    
//    HR_ResumeRecommendListViewController *hr_ResumeRec = [[HR_ResumeRecommendListViewController alloc] init];
//    hr_ResumeRec.model_job = [_dataArray objectAtIndex:IndexPath.row];
//    //        [self.navigationController pushViewController:hr_resume animated:YES];
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//        [((UINavigationController *)app.window.rootViewController) pushViewController:hr_ResumeRec animated:YES];
//    }
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
