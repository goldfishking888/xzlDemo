//
//  RecommendProcessViewController.m
//  FreeChat
//
//  Created by WangJinyu on 6/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "RecommendProcessViewController.h"
#import "RecommendProcessCell.h"
//重新登录
#import "AppDelegate.h"
@interface RecommendProcessViewController ()
{
    UITableView *mainTableView;
    MBProgressHUD *loadView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RecommendProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    [self addBackBtn];
    [self addCenterTitle:@"推荐进度"];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;

    [self loadData];
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + (ios7jj), self.view.frame.size.width, self.view.frame.size.height - (44 + (ios7jj)))];
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}
- (void)loadData
{//http://api.xzhiliao.com/hr_api/recommend/recommendState?userToken=9dceef2c631dc7bef16c63f5b4798a66&userImei=357512057333281&uid=9174175&companyId=1019618&jobId=763305
    NSString * url = kCombineURL(KXZhiLiaoAPI,HRRecommendState);
    
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    paramDic = @{@"userToken":GRBToken,
                 @"userImei":IMEI,
                 @"uid":self.self.uidStr,
                 @"companyId":self.companyIdStr,
                 @"jobId":self.jobIdStr
                 };
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSError *error;
        NSMutableArray *resultArr=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        if(!resultArr){
            [loadView hide:YES];
            return;
        }
        if(resultArr.count > 0)
        {
            NSLog(@"请求成功");
            
            NSLog(@"self.dataArray是-----***%@",resultArr);
            self.dataArray = resultArr;
            [mainTableView reloadData];
        }
     }];
    [request setFailedBlock:^{
        ghostView.message=@"请求失败";
        [ghostView show];
        NSLog(@"请求失败");
    }];
    [request startAsynchronous];
    
}

#pragma mark tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    RecommendProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[RecommendProcessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = self.dataArray[indexPath.row];
    if (indexPath.row == 0)
    {
        cell.isOrange = @"1";
    }
    if (indexPath.row == self.dataArray.count - 1)
    {
        cell.isLine = @"0";
    }
    else
    {
        cell.isLine = @"1";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(152, 17, 16, 16)];
    icon.image = [UIImage imageNamed:@"item_bonus_detail_point.png"];
    [bgView addSubview:icon];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(160, 33, 1, 17)];
    line.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
    [bgView addSubview:line];
    
    return bgView;
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
