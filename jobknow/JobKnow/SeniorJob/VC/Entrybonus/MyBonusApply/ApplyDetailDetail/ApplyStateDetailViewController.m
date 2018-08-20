//
//  ApplyStateDetailViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
// 申请状态详情

#import "ApplyStateDetailViewController.h"
#import "ApplyDetailCell.h"

#import "MJRefresh.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface ApplyStateDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    MJRefreshHeaderView * header1;
    //MJRefreshFooterView * footer1;
    MBProgressHUD * loadView;
    
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * dataDicAll;
@end

@implementation ApplyStateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    [self addBackBtn];
    [self addTitleLabel:@"申请详情"];
    [self createTableView];
    [self loadDataOfHRCircle];
    // Do any additional setup after loading the view.
}
#pragma mark - loadDataOfCircle
-(void)loadDataOfHRCircle
{
    // //http://api.xzhiliao.com/ new_api/senior/bill_status_list?userImei=863654020155172&billId=80902263&userToken=fbe4c2bb8d09ccc41dbfc4b147d8bce5
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = kCombineURL(KXZhiLiaoAPI,SeniorMyBillDetail);
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
                 @"billId":self.detailIDStr
                 };
    
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            [loadView hide:YES];
            [header1 endRefreshing];
            return;
        }
        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            [loadView hide:YES];
            self.dataDicAll = [resultDic mutableCopy];
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary * item in [resultDic objectForKey:@"data"])
            {
                [self.dataArray addObject:item];
            }
            NSDictionary * item = [self.dataArray objectAtIndex:0];
            if ([item[@"status"] intValue] == 3) {//如果是提交入职证明,添加上入职证明审核中
             [self.dataArray insertObject:@{@"status":@"10",@"time":@""} atIndex:0];
             //[self.dataArray addObject:@{@"status":@"10",@"time":@""}];
             }else if([item[@"status"] intValue] == 0) {//如果是提交入职证明,添加上奖金申请审核中
             [self.dataArray insertObject:@{@"status":@"9",@"time":@""} atIndex:0];
             }else if ([item[@"status"] intValue] == 5)
             {//如果是入职证明审核通过,添加等待入职满月发放奖金
             [self.dataArray insertObject:@{@"status":@"11",@"time":self.applyTimeStr} atIndex:0];
             }
             else if ([item[@"status"] intValue] == 6)
             {//如果是入职证明直接通过,添加等待入职满月发放奖金
                 [self.dataArray insertObject:@{@"status":@"11",@"time":self.applyTimeStr} atIndex:0];
             }
             else if ([item[@"status"] intValue] == 8)
             {//奖金提现中,需要添加状态
                 [self.dataArray insertObject:@{@"status":@"12",@"time":@""} atIndex:0];
             }
            [_tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message=@"请求失败";
        [ghostView show];
    }];
    [request startAsynchronous];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + ios7jj, self.view.frame.size.width, self.view.frame.size.height - 44 - ios7jj) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    view.backgroundColor = RGBA(243, 243, 243, 1);
    _tableView.tableHeaderView = view;
    _tableView.backgroundColor = RGBA(243, 243, 243, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IDcell"];
    if (!cell) {
        cell = [[ApplyDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBA(243, 243, 243, 1);
    }
    cell.applyTimeStrs = self.applyTimeStr;
    [cell config:self.dataArray[indexPath.row] withIndexPath:indexPath];
    return cell;
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
