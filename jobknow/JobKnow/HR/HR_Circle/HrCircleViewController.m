//
//  HrCircleViewController.m
//  JobKnow
//
//  Created by admin on 15/8/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HrCircleViewController.h"
#import "Config.h"
#import "RecommendDynamicList.h"
#import "HRDynamicModel.h"
#import "MBProgressHUD.h"
#import "HRTradeModel.h"
#import "OLGhostAlertView.h"

#define RecomendTableCellHeight 60
#define BigBackgroundViewHeight 1228

@interface HrCircleViewController (){

    UILabel *_tradeLabel;//行业Label
    UIScrollView *_scrollView;
    UILabel *_jobNumLabel;//奖金职位数量
    UILabel *_hrNumLabel;//HR经理数量
    UILabel *_moneyNumLabel;//已发奖金数量
    UITableView *_recommendTable;//底部的推荐列表
    
    NSString *_cityName;//当前的城市
    NSString *_tradeName;//当前的行业
    NSMutableArray *_selectArray;//选中的行业数组
    OLGhostAlertView *_ghostAlert;

}

@end

@implementation HrCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightBarBtnItem:@"hr_circle_share" WithXtoRight:40.0f WithWidth:28.0f WithHeight:28.0f];
    [self addCenterTitle:@"HR圈"];
    [self createView];
    
    _cityName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"]];
    _tradeName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tradeName"]];
    [self setTradeLabelWithCity:_cityName trade:_tradeName];
    _selectArray = nil;
    _ghostAlert = [[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    _ghostAlert.position=OLGhostAlertViewPositionCenter;
    
    if([RecommendDynamicList shareInstance].hrNum.length  > 0){//当缓存中有值时，先显示出来旧数据，并刷新
        NSString *jobNumStr = [NSString stringWithFormat:@"%@个",[RecommendDynamicList shareInstance].seniorNums];
        NSString *hrNumStr = [NSString stringWithFormat:@"%@位",[RecommendDynamicList shareInstance].cityTradeHrNum];
        NSString *moneyNumStr = [NSString stringWithFormat:@"%@元",[RecommendDynamicList shareInstance].payMoneyNum];
        [_jobNumLabel setAttributedText:[self createMutableAttributedStringWithText:jobNumStr otherFontSize:18]];
        [_hrNumLabel setAttributedText:[self createMutableAttributedStringWithText:hrNumStr otherFontSize:23]];
        [_moneyNumLabel setAttributedText:[self createMutableAttributedStringWithText:moneyNumStr otherFontSize:18]];
        [_recommendTable reloadData];
        [_recommendTable setFrame:CGRectMake(_recommendTable.frame.origin.x, _recommendTable.frame.origin.y, kMainScreenWidth, 60+RecomendTableCellHeight*[[RecommendDynamicList shareInstance].dynamicArray count])];
        [_scrollView setContentSize:CGSizeMake(kMainScreenWidth, 80+233+BigBackgroundViewHeight+60+RecomendTableCellHeight*[[RecommendDynamicList shareInstance].dynamicArray count])];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecommendDynamicSuccess) name:reloadRecommendDynamicListSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRecommendDynamicFail) name:reloadRecommendDynamicListFail object:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建界面

-(void)createView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+ios7jj, kMainScreenWidth, kMainScreenFrame.size.height-44-ios7jj)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
    
    //行业view的背景颜色
    UIImageView *tradeIV01BG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    [tradeIV01BG setImage:[UIImage imageNamed:@"hr_circle_color_background"]];
    [_scrollView addSubview:tradeIV01BG];
    
    //行业view的背景框
    UIView *tradeV = [[UIView alloc] init];
    tradeV.backgroundColor = [UIColor whiteColor];
    tradeV.layer.cornerRadius = 10;
    tradeV.layer.borderColor = RGBA(298, 161, 46, 1).CGColor;
    tradeV.layer.borderWidth = 2;
    [tradeV setFrame:CGRectMake(15, 10, 290, 50)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTradeView:)];
    [tradeV addGestureRecognizer:tapGesture];
    [_scrollView addSubview:tradeV];
    
    //行业view的箭头
    UIImageView *tradeArrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hr_circle_arrow"]];
    [tradeArrowIV setFrame:CGRectMake(280, 27, 15, 15)];
    [_scrollView addSubview:tradeArrowIV];

    //行业view的文本Label
    _tradeLabel = [self createLabelWithFrame:CGRectMake(30, 15, 252, 40) textAlignment:NSTextAlignmentLeft fontSize:14 textColor:mRGBToColor(0x999999) numberOfLines:2 text:nil];
    [_tradeLabel setAdjustsFontSizeToFitWidth:NO];
    [_tradeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_scrollView addSubview:_tradeLabel];
    
    //头部view的背景图
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, kMainScreenWidth, 233)];
    [headerIV setImage:[UIImage imageNamed:@"hr_circle_header_background"]];
    [_scrollView addSubview:headerIV];
    
    //左圈圈
    UIImage *roundImg = [UIImage imageNamed:@"hr_circle_round"];
    UIImageView *roundIV01 = [[UIImageView alloc] initWithImage:roundImg];
    [roundIV01 setFrame:CGRectMake(5, 123, 75, 75)];
    [_scrollView addSubview:roundIV01];
    UILabel *label01 = [self createLabelWithFrame:CGRectMake(12, 123+37-20, 60, 20) textAlignment:NSTextAlignmentCenter fontSize:14 textColor:mRGBToColor(0x5c5c5c) numberOfLines:1 text:@"奖金职位"];
    [_scrollView addSubview:label01];
    NSMutableAttributedString * attStr01= [self createMutableAttributedStringWithText:@"0个" otherFontSize:18];
    _jobNumLabel = [self createLabelWithFrame:CGRectMake(5+3, 123+30, 69, 50) textAlignment:NSTextAlignmentCenter fontSize:14 textColor:mRGBToColor(0xFF9204) numberOfLines:0 text:attStr01];
    [_scrollView addSubview:_jobNumLabel];
    
    //中圈圈
    UIImageView *roundIV02 = [[UIImageView alloc] initWithImage:roundImg];
    [roundIV02 setFrame:CGRectMake((kMainScreenWidth-150)/2, 100, 150, 150)];
    [_scrollView addSubview:roundIV02];
    UILabel *label02 = [self createLabelWithFrame:CGRectMake((kMainScreenWidth-150)/2+10, 123+37-20, 130, 20) textAlignment:NSTextAlignmentCenter fontSize:14 textColor:mRGBToColor(0x5c5c5c) numberOfLines:1 text:@"本圈共有HR经理"];
    [_scrollView addSubview:label02];
    NSMutableAttributedString * attStr02= [self createMutableAttributedStringWithText:@"0位" otherFontSize:23];
    _hrNumLabel = [self createLabelWithFrame:CGRectMake((kMainScreenWidth-150)/2+10, 123+37, 130, 50) textAlignment:NSTextAlignmentCenter fontSize:14 textColor:mRGBToColor(0xFF9204) numberOfLines:0 text:attStr02];
    [_scrollView addSubview:_hrNumLabel];
    
    //右圈圈
    UIImageView *roundIV03 = [[UIImageView alloc] initWithImage:roundImg];
    [roundIV03 setFrame:CGRectMake(kMainScreenWidth-5-75, 123, 75, 75)];
    [_scrollView addSubview:roundIV03];
    UILabel *label03 = [self createLabelWithFrame:CGRectMake(kMainScreenWidth-5-75+7, 123+37-20, 60, 20) textAlignment:NSTextAlignmentCenter fontSize:14 textColor:mRGBToColor(0x5c5c5c) numberOfLines:1 text:@"已发奖金"];
    [_scrollView addSubview:label03];
    NSMutableAttributedString * attStr03= [self createMutableAttributedStringWithText:@"0元" otherFontSize:18];
    _moneyNumLabel = [self createLabelWithFrame:CGRectMake(kMainScreenWidth-5-75+3, 123+30, 69, 50) textAlignment:NSTextAlignmentCenter fontSize:14 textColor:mRGBToColor(0xFF9204) numberOfLines:0 text:attStr03];
    [_scrollView addSubview:_moneyNumLabel];
    
    //大背景
    UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,80+233, kMainScreenWidth, BigBackgroundViewHeight)];
    [backgroundIV setImage:[UIImage imageNamed:@"hr_trend_introduce"]];
    [_scrollView addSubview:backgroundIV];

    _recommendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 80+233+BigBackgroundViewHeight, kMainScreenWidth, 60)];
    _recommendTable.delegate = self;
    _recommendTable.dataSource = self;
    [_recommendTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_recommendTable setBackgroundColor:RGBA(240, 240, 240, 1)];
    [_scrollView addSubview:_recommendTable];
    
    [_scrollView setContentSize:CGSizeMake(kMainScreenWidth, 80+233+BigBackgroundViewHeight+60)];
     

}

#pragma mark - 通知方法

- (void)reloadRecommendDynamicSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *jobNumStr = [NSString stringWithFormat:@"%@个",[RecommendDynamicList shareInstance].seniorNums];
    NSString *hrNumStr = [NSString stringWithFormat:@"%@位",[RecommendDynamicList shareInstance].cityTradeHrNum];
    NSString *moneyNumStr = [NSString stringWithFormat:@"%@元",[RecommendDynamicList shareInstance].payMoneyNum];
    [_jobNumLabel setAttributedText:[self createMutableAttributedStringWithText:jobNumStr otherFontSize:18]];
    [_hrNumLabel setAttributedText:[self createMutableAttributedStringWithText:hrNumStr otherFontSize:23]];
    [_moneyNumLabel setAttributedText:[self createMutableAttributedStringWithText:moneyNumStr otherFontSize:18]];
    [_recommendTable reloadData];
    [_recommendTable setFrame:CGRectMake(_recommendTable.frame.origin.x, _recommendTable.frame.origin.y, kMainScreenWidth, 60+RecomendTableCellHeight*[[RecommendDynamicList shareInstance].dynamicArray count])];
    [_scrollView setContentSize:CGSizeMake(kMainScreenWidth, 80+233+BigBackgroundViewHeight+60+RecomendTableCellHeight*[[RecommendDynamicList shareInstance].dynamicArray count])];
}

- (void) reloadRecommendDynamicFail{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 设置行业Label的数据

- (void)setTradeLabelWithCity:(NSString *)city trade:(NSString *)trade{
    
    NSString *str = [NSString stringWithFormat:@"您所在的%@HR圈：",city];
    [_tradeLabel setAttributedText:[self createMutableAttributedStringWithText:[NSString stringWithFormat:@"%@%@",str,trade] orangeText:str]];
}

#pragma mark - 创建Label

- (UILabel *)createLabelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment fontSize:(float)fontSize textColor:(UIColor *)textColor numberOfLines:(int)numberOfLines text:(id)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = textAlignment;
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    [label setTextColor:textColor];
    [label setNumberOfLines:numberOfLines];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    if ([[text class] isSubclassOfClass:[NSMutableAttributedString class]]) {
        
        [label setAttributedText:text];
        
    }else if([[text class] isSubclassOfClass:[NSString class]]){
        
        [label setText:text];
        
    }
    
    return label;
}
     
#pragma mark - 创建一个NSMutableAttributedString，最后一位灰色，其他位置指定字号
- (NSMutableAttributedString *)createMutableAttributedStringWithText:(NSString *)text otherFontSize:(float)fontSize{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x5c5c5c) range:NSMakeRange(text.length-1, 1)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, text.length-1)];
    return attStr;
}
#pragma mark - 创建一个NSMutableAttributedString，指定字符串桔红色显示
- (NSMutableAttributedString *)createMutableAttributedStringWithText:(NSString *)text orangeText:(NSString *)orangeText{
    NSRange range = [text rangeOfString:orangeText];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0xFF9204) range:range];
    return attStr;
}

#pragma mark - 右按钮分享
- (void)onClickRightBtn:(id)sender
{
    NSLog(@"分享~~~~~");

    
}
     
#pragma mark - 点击行业选择
- (void)tapOnTradeView:(id)sender{
    NSLog(@"tapOnTradeView");
    if ([[RecommendDynamicList shareInstance].tradeArray count] == 0) {
        _ghostAlert.message = @"数据获取失败";
        [_ghostAlert show];
        return;
    }
    if(_selectArray == nil){
        _selectArray =[NSMutableArray array];
        NSString *tradeTempCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tradeCode"]];
        NSArray *tempArray =[tradeTempCode componentsSeparatedByString:@","];
        for (HRTradeModel *model in [RecommendDynamicList shareInstance].tradeArray) {
            if ([tempArray containsObject:model.tradeCode]) {
                [_selectArray addObject:model];
            }
        }
    }

    HrSelectCircleViewController *vc = [[HrSelectCircleViewController alloc] init];
    vc.delegate = self;
    vc.selectArray = _selectArray;
    vc.cityName = _cityName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HrSelectCircleDelegate

- (void)didSelectCircleWithSelectArray:(NSMutableArray *)selectTradeArray cityName:(NSString *)cityName{
    _selectArray = selectTradeArray;
    NSMutableString *tradeStr = [NSMutableString string];
    unsigned long num = 0;
    for (HRTradeModel *model in _selectArray) {
        [tradeStr appendFormat:@"，%@",model.tradeName];
        num = num+[model.HRnum intValue];
    }
    if (tradeStr.length > 0) {
        [tradeStr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    _cityName = cityName;
    [self setTradeLabelWithCity:_cityName trade:tradeStr];
    [_hrNumLabel setAttributedText:[self createMutableAttributedStringWithText:[NSString stringWithFormat:@"%lu位",num] otherFontSize:23]];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((kMainScreenWidth-110)/2, (60-28)/2, 110, 28)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [backView.layer setCornerRadius:8];
    UILabel *tipLabel = [self createLabelWithFrame:CGRectMake(25, 6, 75, 16) textAlignment:NSTextAlignmentCenter fontSize:15 textColor:mRGBToColor(0x999999) numberOfLines:1 text:@"推荐进行时"];
    [backView addSubview:tipLabel];
    UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 11, 12)];
    [tipIV setImage:[UIImage imageNamed:@"hr_circle_tips"]];
    [backView addSubview:tipIV];
    [headView addSubview:backView];
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return RecomendTableCellHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[RecommendDynamicList shareInstance].dynamicArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *recomendTavleViewCellId = @"RecomendTavleViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recomendTavleViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recomendTavleViewCellId];
        [cell setBackgroundColor:RGBA(240, 240, 240, 1)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"hr_circle_item"] stretchableImageWithLeftCapWidth:30 topCapHeight:14]];
        [imgV setFrame:CGRectMake(10, 0, kMainScreenWidth-20, RecomendTableCellHeight-15)];
        [cell addSubview:imgV];
        
        UILabel *companyLabel = [self createLabelWithFrame:CGRectMake(20, 5, 196, RecomendTableCellHeight-15-5-5) textAlignment:NSTextAlignmentLeft fontSize:14 textColor:mRGBToColor(0x5c5c5c) numberOfLines:0 text:nil];
        companyLabel.tag = 13001;

        [cell addSubview:companyLabel];
        
        UILabel *timeLabel = [self createLabelWithFrame:CGRectMake(220, 0, 85, RecomendTableCellHeight-15) textAlignment:NSTextAlignmentRight fontSize:12 textColor:mRGBToColor(0x999999) numberOfLines:1 text:@""];
        timeLabel.tag = 13002;
        [cell addSubview:timeLabel];
    }
    HRDynamicModel *model = (HRDynamicModel *)[[RecommendDynamicList shareInstance].dynamicArray objectAtIndex:indexPath.row];
    NSAttributedString *companyStr = nil;
    if ([model.type isEqualToString:@"1"]) {
        
        NSString * tempStr = [NSString stringWithFormat:@"%@收到%@份简历",model.companyName,model.jobRecommendNum];
        companyStr = [self createMutableAttributedStringWithText:tempStr orangeText:[NSString stringWithFormat:@"%@份",model.jobRecommendNum]];
        
    }else if ([model.type isEqualToString:@"2"]){
        
        NSString * tempStr = [NSString stringWithFormat:@"%@发出%@元推荐奖金",model.companyName,model.applyMoney];
        companyStr = [self createMutableAttributedStringWithText:tempStr orangeText:[NSString stringWithFormat:@"%@元",model.applyMoney]];
    
    }else if ([model.type isEqualToString:@"3"]){
    
        NSString * tempStr = [NSString stringWithFormat:@"%@收到%@元的简历推荐奖金",model.hrName,model.applyMoney];
        companyStr = [self createMutableAttributedStringWithText:tempStr orangeText:[NSString stringWithFormat:@"%@元",model.applyMoney]];
    
    }
    UILabel *companyTempLabel = (UILabel *)[cell viewWithTag:13001];
    [companyTempLabel setAttributedText:companyStr];
    
    UILabel *timeTempLabel = (UILabel *)[cell viewWithTag:13002];
    [timeTempLabel setText:model.date];
    
    return cell;
    
}

@end
