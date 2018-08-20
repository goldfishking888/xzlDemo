//
//  HrApplyCashHistoryListViewController.m
//  JobKnow
//
//  Created by admin on 15/8/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HrApplyCashHistoryListViewController.h"
#import "Config.h"

#define CashListTableViewWidth 300
#define CashListCellHeight 67

#pragma mark - HrApplyCashHistoryListCell
@implementation HrApplyCashHistoryListCell

-(id)initCashHistoryListCellWithReuserIdentifier:(NSString *)reuserId{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    if (self) {
        [self setFrame:CGRectMake(0, 0, CashListTableViewWidth, CashListCellHeight)];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, CashListCellHeight)];
        [_moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [_moneyLabel setTextColor:mRGBToColor(0xFF9204)];
        [_moneyLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_moneyLabel];
        
        _bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 90, 27)];
        [_bankNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_bankNameLabel setTextColor:mRGBToColor(0x333333)];
        [_bankNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_bankNameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 37, 90, 20)];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
        [_timeLabel setTextColor:mRGBToColor(0x999999)];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_timeLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, CashListTableViewWidth-180, 27)];
        [_stateLabel setTextAlignment:NSTextAlignmentCenter];
        [_stateLabel setTextColor:mRGBToColor(0x333333)];
        [_stateLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_stateLabel];
        
        _stateDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 37, CashListTableViewWidth-180, 20)];
        [_stateDetailLabel setTextAlignment:NSTextAlignmentCenter];
        [_stateDetailLabel setTextColor:mRGBToColor(0x999999)];
        [_stateDetailLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_stateDetailLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CashListCellHeight, CashListTableViewWidth-14-10, 1)];
        lineLabel.backgroundColor = mRGBToColor(0xE1E1E1);
        [self addSubview:lineLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

@end



#pragma mark - HrApplyCashHistoryListViewController
@interface HrApplyCashHistoryListViewController ()

@end

@implementation HrApplyCashHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightBarBtnItem:@"hr_ic_call" WithXtoRight:40.0f WithWidth:28.0f WithHeight:28.0f];
    [self addCenterTitle:@"提现记录"];
    
    _dataArray = [NSMutableArray new];
    
    //_noDataView
    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-ios7jj-44)];
    [_noDataView setBackgroundColor:XZHILBJ_colour];
    UIImageView *noDataIV = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2, 150, 100, 100)];
    [noDataIV setImage:[UIImage imageNamed:@"hr_table_nodata"]];
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150+100+30, kMainScreenWidth, 20)];
    [noDataLabel setText:@"您当前没有提现记录~"];
    [noDataLabel setTextColor:mRGBToColor(0x999999)];
    [noDataLabel setFont:[UIFont systemFontOfSize:14]];
    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
    [_noDataView addSubview:noDataIV];
    [_noDataView addSubview:noDataLabel];
    [self.view addSubview:_noDataView];
    [self.view sendSubviewToBack:_noDataView];
    
    //_mainScrollView
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-ios7jj-44)];
    [_mainScrollView setBackgroundColor:[UIColor clearColor]];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    
    //_listTableView
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 15, CashListTableViewWidth, kMainScreenFrame.size.height-ios7jj-44-15)];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    [_listTableView setShowsVerticalScrollIndicator:NO];
    [_listTableView.layer setCornerRadius:8];
    [_listTableView setScrollEnabled:NO];
    [_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_mainScrollView addSubview:_listTableView];
    [self.view addSubview:_mainScrollView];
    
    [self getCashListFromeServer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationRightButton
- (void)onClickRightBtn:(UIButton *)sender
{
    NSString * str = [NSString stringWithFormat:@"tel:%@",@"0532-80901998"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 从服务器获取提现记录
-(void)getCashListFromeServer{
    NSString *urlStr = kCombineURL(KXZhiLiaoAPI, HRInviteCashList);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr,@"userToken",IMEI,@"userImei",nil];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
    __block typeof(self) weakSelf = self;
    [request setCompletionBlock:^(void){
        [_progressView hide:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSNumber *errorValue = resultDic[@"error"];
        NSNumber *totalValue = resultDic[@"total"];
        if ([errorValue intValue] == 200 && [totalValue intValue] > 0) {
            [weakSelf.view sendSubviewToBack:_noDataView];
            NSArray *dicArray = [resultDic objectForKey:@"data"];
            _dataArray = [NSMutableArray arrayWithArray:dicArray];
            [_listTableView setFrame:CGRectMake(_listTableView.frame.origin.x, _listTableView.frame.origin.y, _listTableView.frame.size.width, [_dataArray count]*CashListCellHeight)];
            [_mainScrollView setContentSize:CGSizeMake(kMainScreenWidth, _listTableView.frame.origin.y+_listTableView.frame.size.height+20)];
            [_listTableView reloadData];
            if ([_dataArray count] == 0) {
                [_noDataView setHidden:NO];
            }else{
                [_noDataView setHidden:YES];
            }
        }else{
            [weakSelf.view bringSubviewToFront:_noDataView];
        }
    }];
    [request setFailedBlock:^(void){
        [_progressView hide:YES];
        [weakSelf.view bringSubviewToFront:_noDataView];
    }];
    [request startAsynchronous];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CashListCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cashHistoryListCellId = @"CashHistoryListCellId";
    
    HrApplyCashHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:cashHistoryListCellId];
    if (!cell) {
        cell = [[HrApplyCashHistoryListCell alloc] initCashHistoryListCellWithReuserIdentifier:cashHistoryListCellId];
    }
    NSDictionary *dataDic = _dataArray[indexPath.row];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"￥%@",dataDic[@"money"]]];
    [cell.bankNameLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"bank"]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"time"]]];
    NSNumber *state = dataDic[@"apply_status"];
    if ([state intValue] == 1) {//审核中
        
        [cell.stateLabel setText:@"申请中"];
        [cell.stateDetailLabel setTextColor:mRGBToColor(0x999999)];
        [cell.stateDetailLabel setText:@"预计3个工作日到账"];
        
    }else if ([state intValue] == 2){//已转账
        
        [cell.stateLabel setText:@"提现成功"];
        [cell.stateDetailLabel setTextColor:mRGBToColor(0xFF9204)];
        [cell.stateDetailLabel setText:@""];
        
    }else if ([state intValue] == 5){//失败
        
        [cell.stateLabel setText:@"提现失败"];
        [cell.stateDetailLabel setTextColor:mRGBToColor(0x999999)];
        [cell.stateDetailLabel setText:@""];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray count];
}
@end
