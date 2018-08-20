//
//  MyBounsListViewController.m
//  JobKnow
//
//  Created by Jiang on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "MyBounsListViewController.h"
#import "UIImageView+WebCache.h"
#import "MyBounsCashViewController.h"


#define MyBounsListTableViewCellHeight 70

#pragma mark - MyBounsListTableViewCell

@implementation MyBounsListTableViewCell

- (MyBounsListTableViewCell *)initWithReuseIdentifier:(NSString *)reuserId{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    if (self) {
        _headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, MyBounsListTableViewCellHeight-20, MyBounsListTableViewCellHeight-20)];
        [_headerIV setImage:[UIImage imageNamed:@"header_default"]];
        [self addSubview:_headerIV];
        
        _jobNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MyBounsListTableViewCellHeight, 10, 180, MyBounsListTableViewCellHeight/2-10)];
        [_jobNameLabel setTextColor:[UIColor darkGrayColor]];
        [_jobNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_jobNameLabel];
        
        _companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MyBounsListTableViewCellHeight, MyBounsListTableViewCellHeight/2, 180, MyBounsListTableViewCellHeight/2)];
        [_companyNameLabel setTextColor:[UIColor lightGrayColor]];
        [_companyNameLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [_companyNameLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_companyNameLabel];
        
        _bounsLabel = [[UILabel alloc] initWithFrame:CGRectMake(MyBounsListTableViewCellHeight+180, 10, 60, MyBounsListTableViewCellHeight/2-10)];
        [_bounsLabel setTextColor:[UIColor orangeColor]];
        [_bounsLabel setTextAlignment:NSTextAlignmentCenter];
        [_bounsLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_bounsLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(MyBounsListTableViewCellHeight+180, MyBounsListTableViewCellHeight/2, 60, MyBounsListTableViewCellHeight/2)];
        [_statusLabel setTextColor:[UIColor grayColor]];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_statusLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_statusLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MyBounsListTableViewCellHeight-1, iPhone_width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    return self;
}

@end


#pragma mark - MyBounsListViewController
@interface MyBounsListViewController ()<UITableViewDelegate,UITableViewDataSource,MyBounsCashViewControllerDelegate>{

    UITableView *_tableView;
    NSMutableArray *_dataArray;// 列表数据
    UILabel *_cashLabel;// 金额label
    UIView *_bottomView;// 底部提现界面
}

@end

@implementation MyBounsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"我的入职奖金"];
    
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,ios7jj+44, iPhone_width, iPhone_height-ios7jj-44-44)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = XZHILBJ_colour;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [self createCashView];
    
    [self requestDataFromServer];
   
}

#pragma mark - 创建底部CashView
- (void)createCashView{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, iPhone_height - 44, iPhone_width, 44)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 0.8)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:lineView];
    UILabel * cashTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    [cashTipLabel setText:@"可提现金额："];
    [cashTipLabel setTextColor:[UIColor grayColor]];
    [cashTipLabel setFont:[UIFont systemFontOfSize:17]];
    [cashTipLabel setTextAlignment:NSTextAlignmentRight];
    [_bottomView addSubview:cashTipLabel];
    _cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 110, 44)];
    [_cashLabel setTextColor:[UIColor orangeColor]];
    [_cashLabel setFont:[UIFont systemFontOfSize:14]];
    [_bottomView addSubview:_cashLabel];
    UIButton *cashBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, 80, 44)];
    [cashBtn setBackgroundColor:[UIColor orangeColor]];
    [cashBtn setTitle:@"提现" forState:UIControlStateNormal];
    [cashBtn addTarget:self action:@selector(cashBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cashBtn];
    [self.view addSubview:_bottomView];
}

#pragma mark - 提现按钮的点击事件
- (void)cashBtnClick{
    CGFloat cash = [[_cashLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue];
    if (cash > 0) {
        MyBounsCashViewController *vc = [[MyBounsCashViewController alloc] init];
        vc.delegate = self;
        vc.cashMoney = [NSString stringWithFormat:@"%.2f",cash];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}

#pragma mark - MyBounsCashViewControllerDelegate
- (void)myBounsCashSuccess{
    [self requestDataFromServer];
}

#pragma mark - request我的入职奖金列表
- (void)requestDataFromServer{
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/senior/bouns_list?"];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString * errorStr = [NSString stringWithFormat:@"%@",resultDic[@"error"]];
        if ([errorStr isEqualToString:@"0"] == YES) {
            _dataArray = [NSMutableArray arrayWithArray:resultDic[@"data_list"]];
            _cashLabel.text = [NSString stringWithFormat:@"￥%.2f",[(NSNumber*)(resultDic[@"total_bouns"]) floatValue]];
            [_tableView reloadData];
        }else{
            [_dataArray removeAllObjects];
            _cashLabel.text = @"￥0.00";
        }
        
    }];
    [request setFailedBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark - 数据为空时的view
- (UIView *)createNoDataView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height)];
    view.backgroundColor = XZHILBJ_colour;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (_tableView.frame.size.height-80)/2, _tableView.frame.size.width, 80)];
    [imgView setImage:[UIImage imageNamed:@"nodata1"]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [view addSubview:imgView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height/2+50, _tableView.frame.size.width, 30)];
    [label setText:@"亲，您暂时没有获得入职奖金哦~"];
    [label setTextColor:[UIColor orangeColor]];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    return view;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_dataArray count] == 0) {
        _bottomView.hidden = YES;
        return 1;
    }else{
        _bottomView.hidden = NO;
        return [_dataArray count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataArray count] == 0) {
        [_tableView setScrollEnabled:NO];
        return _tableView.frame.size.height;
        
    }else{
        [_tableView setScrollEnabled:YES];
        return MyBounsListTableViewCellHeight;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([_dataArray count] == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nodata"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nodata"];
            [cell addSubview:[self createNoDataView]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }else{
        MyBounsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBounsListTableViewCell"];
        if (cell == nil) {
            cell = [[MyBounsListTableViewCell alloc] initWithReuseIdentifier:@"MyBounsListTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
        [cell.headerIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"companyFace"]]] placeholderImage:[UIImage imageNamed:@"header_default"]];
        cell.jobNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"jobName"]];
        cell.companyNameLabel.text = [NSString stringWithFormat:@"%@",dic[@"companyName"]];
        cell.bounsLabel.text = [NSString stringWithFormat:@"+%@",dic[@"bouns"]];
        // 1：已提现 2：提现中 3：未提现
        NSNumber *status = dic[@"status"];
        if([status intValue] == 1){
            cell.statusLabel.text = @"已提现";
        }else if ([status intValue] == 2){
            cell.statusLabel.text = @"提现中";
        }else{
            cell.statusLabel.text = @"未提现";
        }
        return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
