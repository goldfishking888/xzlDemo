//
//  HrSelectCircleViewController.m
//  JobKnow
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HrSelectCircleViewController.h"
#import "Config.h"
#import "RecommendDynamicList.h"
#import "HRTradeModel.h"
#import "HRSelectCityViewController.h"
#import "MBProgressHUD.h"

#define SelectCircleTableCellHeight 50

@interface HrSelectCircleViewController ()<HRSelectCityDelegate>{

    UITableView *_circleTable;
    UILabel *_localCityLabel;//当前城市Label
    UILabel *_firstLabel;
    UILabel *_secondLabel;
}

@end

@implementation HrSelectCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightButtonWithTitle:@"确定"];
    [self addCenterTitle:@"选择HR圈"];
    
    _circleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+ios7jj, kMainScreenWidth, kMainScreenFrame.size.height-44-ios7jj)];
    _circleTable.delegate = self;
    _circleTable.dataSource = self;
    [_circleTable setBackgroundColor:RGBA(240, 240, 240, 1)];
    [self.view addSubview:_circleTable];
    _circleTable.tableHeaderView = [self createHeaderView];
    [self setLabelTextOfHeader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecommendDynamicSuccess) name:reloadRecommendDynamicListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecommendDynamicFail) name:reloadRecommendDynamicListFail object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建HeaderView
-(UIView *)createHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40+50+40)];
    
    UIImageView * firstIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [firstIV setImage:[UIImage imageNamed:@"hr_circle_select_tip1"]];
    [headerView addSubview:firstIV];
    _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(33, 10, kMainScreenWidth - 33, 20)];
    [_firstLabel setTextColor:mRGBToColor(0x5C5C5C)];
    [_firstLabel setNumberOfLines:1];
    [_firstLabel setFont:[UIFont systemFontOfSize:10]];
    [headerView addSubview:_firstLabel];
    
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 50)];
    [midView setBackgroundColor:[UIColor whiteColor]];
    UILabel *cityInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 60, 50)];
    [cityInfoLabel setTextColor:mRGBToColor(0x333333)];
    [cityInfoLabel setFont:[UIFont systemFontOfSize:15]];
    [cityInfoLabel setText:@"当前城市"];
    [midView addSubview:cityInfoLabel];
    _localCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-30-150, 0, 150, 50)];
    [_localCityLabel setTextColor:mRGBToColor(0xFF9204)];
    [_localCityLabel setTextAlignment:NSTextAlignmentRight];
    [_localCityLabel setText:_cityName];
    [midView addSubview:_localCityLabel];
    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-20, 17, 12, 16)];
    [arrowIV setImage:[UIImage imageNamed:@"hr_circle_gray_arrow"]];
    [midView addSubview:arrowIV];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLocalCityView:)];
    [midView addGestureRecognizer:tapGesture];
    [headerView addSubview:midView];
    
    UIImageView * secondIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10+90, 20, 20)];
    [secondIV setImage:[UIImage imageNamed:@"hr_circle_select_tip2"]];
    [headerView addSubview:secondIV];
    _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(33, 10+90, kMainScreenWidth - 33, 20)];
    [_secondLabel setTextColor:mRGBToColor(0x5C5C5C)];
    [_secondLabel setNumberOfLines:1];
    [_secondLabel setFont:[UIFont systemFontOfSize:13]];
    [headerView addSubview:_secondLabel];
    
    return headerView;
}

#pragma mark - 设置两行label的内容
- (void)setLabelTextOfHeader{
    NSString *firstStr = [NSString stringWithFormat:@"全国共有463个城市，26854个HR圈，%@位HR经理",[RecommendDynamicList shareInstance].hrNum];
    [_firstLabel setText:[firstStr stringByReplacingOccurrencesOfString:@"," withString:@""]];
    unsigned long num = 0;
    for (HRTradeModel *mode in _selectArray) {
        num = num + [mode.HRnum intValue];
    }
    [_secondLabel setText:[NSString stringWithFormat:@"已选%@HR圈%lu/%lu个，本城共%lu位HR经理",_cityName,(unsigned long)[_selectArray count],(unsigned long)[[RecommendDynamicList shareInstance].tradeArray count],num]];
}

#pragma mark - 当前城市点击

- (void)tapOnLocalCityView:(id)sender{
    NSLog(@"tapOnLocalCityView");
    HRSelectCityViewController *vc = [[HRSelectCityViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 右按钮点击方法

-(void)onClickRightBtn:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectCircleWithSelectArray:cityName:)]){
        
        [_delegate didSelectCircleWithSelectArray:_selectArray cityName:_cityName];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HRSelectCityDelegate

- (void)didSelectWithCityCode:(NSString *)cityCode cityName:(NSString *)cityName{
    if ([_cityName isEqualToString:cityName] == NO) {
        [_localCityLabel setText:cityName];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

#pragma mark - 获取数据成功的通知方法

- (void) reloadRecommendDynamicSuccess{
    _cityName = _localCityLabel.text;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _selectArray = [NSMutableArray array];//成功则清空已选择数组
    [self setLabelTextOfHeader];
    [_circleTable reloadData];
}
- (void) reloadRecommendDynamicFail{
    [_localCityLabel setText:_cityName];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SelectCircleTableCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[RecommendDynamicList shareInstance].tradeArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *selectCircleTableCellId = @"SelectCircleTableCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCircleTableCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectCircleTableCellId];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 225, SelectCircleTableCellHeight)];
        tradeLabel.tag = 13001;
        [tradeLabel setTextAlignment:NSTextAlignmentLeft];
        [tradeLabel setFont:[UIFont systemFontOfSize:15]];
        [tradeLabel setTextColor:mRGBToColor(0x333333)];
        [cell addSubview:tradeLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 15, 50, 20)];
        numLabel.tag = 13002;
        [numLabel setBackgroundColor:RGBA(255, 115, 4, 1)];
        [numLabel setTextColor:[UIColor whiteColor]];
        [numLabel setFont:[UIFont systemFontOfSize:12]];
        [numLabel.layer setCornerRadius:10];
        [numLabel.layer setMasksToBounds:YES];
        [cell addSubview:numLabel];
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-20-10, 15, 20, 20)];
        selectBtn.tag = 13003;
        [selectBtn setUserInteractionEnabled:NO];
        [selectBtn setImage:[UIImage imageNamed:@"hr_bank_select"] forState:UIControlStateSelected];
        [cell addSubview:selectBtn];
        
    }
    HRTradeModel *model = (HRTradeModel *)[[RecommendDynamicList shareInstance].tradeArray objectAtIndex:indexPath.row];
    
    UILabel *tradeTempLabel = (UILabel *)[cell viewWithTag:13001];
    [tradeTempLabel setText:model.tradeName];
    
    UILabel *numTempLabel = (UILabel *)[cell viewWithTag:13002];
    NSString *numTempStr = [NSString stringWithFormat:@" %@人 ",model.HRnum];
    [numTempLabel setText:numTempStr];
    CGSize size = [numTempStr sizeWithFont:[UIFont systemFontOfSize:12]];
    [numTempLabel setBounds:CGRectMake(0, 0, size.width, 20)];
    
    UIButton *selectBtn = (UIButton *)[cell viewWithTag:13003];
    if ([_selectArray containsObject:model]){
        [selectBtn setSelected:YES];
    }else{
        [selectBtn setSelected:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HRTradeModel *model = (HRTradeModel *)[[RecommendDynamicList shareInstance].tradeArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *selectBtn = (UIButton *)[cell viewWithTag:13003];
    if ([selectBtn isSelected]) {
        [selectBtn setSelected:NO];
        [_selectArray removeObject:model];
    }else{
        [selectBtn setSelected:YES];
        [_selectArray addObject:model];
    }
    [self setLabelTextOfHeader];
}


@end
