//
//  HrSelectBankViewController.m
//  JobKnow
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HrSelectBankViewController.h"
#import "Config.h"

#define BankTableCellHeight 44
#define SelectedImgTag 10101

@interface HrSelectBankViewController (){
    UITableView *_bankTableView;
    NSArray *_bankArray;
    NSString *_selectedStr;//@"1"~@"8"
}

@end

@implementation HrSelectBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"选择开户银行"];
    
    _bankArray = @[@"中国工商银行",@"中国农业银行",@"中国银行",@"中国建设银行",@"交通银行",@"上海银行",@"招商银行",@"平安银行",@"中国民生银行",@"中信银行",@"中国光大银行",@"浦发银行",@"广发银行",@"兴业银行",@"中国邮政储蓄银行"];
    _selectedStr = @"";
    
    _bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+(ios7jj), kMainScreenWidth, iPhone_height-44-ios7jj)];
    _bankTableView.dataSource = self;
    _bankTableView.delegate = self;
    [_bankTableView setScrollEnabled:YES];
    [self.view addSubview:_bankTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BankTableCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_bankArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bankTableCellID = @"BankTableCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankTableCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankTableCellID];
    }
    [cell.textLabel setText:_bankArray[indexPath.row]];
    [cell.textLabel setTextColor:mRGBToColor(0x333333)];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    
    [[cell viewWithTag:SelectedImgTag] removeFromSuperview];
    if (_selectedStr.intValue == (indexPath.row + 1)) {
        UIImageView *selectedIV = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-20-20, (BankTableCellHeight-20)*0.5, 20, 20)];
        [selectedIV setImage:[UIImage imageNamed:@"hr_bank_select"]];
        [selectedIV setTag:SelectedImgTag];
        [cell addSubview:selectedIV];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedStr = [NSString stringWithFormat:@"%d",indexPath.row+1];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectBank:bankName:)]) {
        [_delegate didSelectBank:_selectedStr bankName:[NSString stringWithFormat:@"%@",_bankArray[indexPath.row]]];
    }
    [_bankTableView reloadData];
}

@end
