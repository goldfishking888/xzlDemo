//
//  RecommendDataList.m
//  JobKnow
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "RecommendDynamicList.h"
#import "Config.h"
#import "HRDynamicModel.h"
#import "HRTradeModel.h"
#import "HrCircleViewController.h"
#import "AppDelegate.h"

static RecommendDynamicList *rdl= nil;

@implementation RecommendDynamicList

+ (RecommendDynamicList *)shareInstance{
    
    if (rdl == nil) {
        rdl = [[[self class] alloc] init];
        [rdl initData];
        [rdl createDynamicView];
    }
    return rdl;
}

// 初始化数据
-(void)initData{
    rdl.dynamicArray = [NSMutableArray array];
    rdl.tradeArray = [NSMutableArray array];
    rdl.cityTradeHrNum = @(0);
    rdl.payMoneyNum = @"";
    rdl.seniorNums = @(0);
    rdl.hrNum = @"0";
}

- (void)reloadDataFromServerWithCityCode:(NSString *)cityCode page:(NSString *)page count:(NSString *)count{

    __weak typeof(self) weakSelf = self;
    if (cityCode.length == 0) {
        cityCode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityCode"]];
    }
    NSString *urlStr = kCombineURL(KXZhiLiaoAPI, HRRecommendDynamicList);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr,@"userToken",IMEI,@"userImei",cityCode,@"localcity",(([page intValue]>0)?page:@"1"),@"page",(([count intValue]>0)?count:@"10"),@"count",nil];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setTimeOutSeconds:12];
    [request setCompletionBlock:^{
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        // 成功返回结果之后再重置数据
        [weakSelf initData];
        NSArray *dynamicTempArray = [resultDic objectForKey:@"dynamicRecommend"];
        for (NSDictionary *dic in dynamicTempArray) {
            HRDynamicModel *dynamicModel = [[HRDynamicModel alloc] initWithDictionary:dic];
            [_dynamicArray addObject:dynamicModel];
        }
        NSArray *tradeTempArray = [resultDic objectForKey:@"cityHrCenter"];
        for (NSDictionary *dic in tradeTempArray) {
            HRTradeModel *tradeModel = [[HRTradeModel alloc] initWithDictionary:dic];
            [_tradeArray addObject:tradeModel];
        }
        _seniorNums = [resultDic objectForKey:@"seniorNums"];
        _payMoneyNum = [resultDic objectForKey:@"payMoneyNum"];
        _cityTradeHrNum = [resultDic objectForKey:@"cityTradeHrNum"];
        _hrNum = [resultDic objectForKey:@"hrNum"];
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadRecommendDynamicListSuccess object:nil];

    }];
    [request setFailedBlock:^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadRecommendDynamicListFail object:nil];
    }];
    [request startAsynchronous];
}

//创建推荐动态界面
- (void)createDynamicView{
    _dynamicView = [[UIView alloc] initWithFrame:CGRectMake(0, iPhone_height - 40, kMainScreenWidth, 40)];
    [_dynamicView setBackgroundColor:RGBA(241, 239, 240, 1)];
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 190, 40)];
    companyLabel.tag = 13001;
    [companyLabel setTextAlignment:NSTextAlignmentLeft];
    [companyLabel setFont:[UIFont systemFontOfSize:13]];
    [companyLabel setTextColor:mRGBToColor(0xFF9204)];
    [companyLabel setNumberOfLines:2];
    [_dynamicView addSubview:companyLabel];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 110, 40)];
    timeLabel.tag = 13002;
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setTextColor:mRGBToColor(0xFF9204)];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [_dynamicView addSubview:timeLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoHRCircleVC)];
    [_dynamicView addGestureRecognizer:tapGesture];
}

//轮播推荐动态
- (void)setDynamicViewData{
    
    if ([self.dynamicArray count] == 0) {
        return;
    }
    order++;
    if (order >= [self.dynamicArray count]) {
        order = 0;
    }
    HRDynamicModel *model = [self.dynamicArray objectAtIndex:order];
    NSString * tempStr = nil;
    if ([model.type isEqualToString:@"1"]) {
        
        tempStr = [NSString stringWithFormat:@"%@收到%@份简历",model.companyName,model.jobRecommendNum];

        
    }else if ([model.type isEqualToString:@"2"]){
        
        tempStr = [NSString stringWithFormat:@"%@发出%@元推荐奖金",model.companyName,model.applyMoney];

        
    }else if ([model.type isEqualToString:@"3"]){
        
        tempStr = [NSString stringWithFormat:@"%@收到%@元的简历推荐奖金",model.hrName,model.applyMoney];
        
    }
    UILabel *companyLabel = (UILabel *)[_dynamicView viewWithTag:13001];
    [companyLabel setText:tempStr];
    UILabel *timeLabel = (UILabel *)[_dynamicView viewWithTag:13002];
    [timeLabel setText:model.date];
    
}
//启动轮播
- (void)startPlay{
    if ((_timer == nil)||([_timer isValid] == NO)) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setDynamicViewData) userInfo:nil repeats:YES];
        [_timer fire];
    }
}
//关闭轮播
- (void)stopPlay{
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
    }
}
#pragma mark 跳转到HR圈页面
- (void)gotoHRCircleVC{

    //HR圈
    HrCircleViewController *vc = [[HrCircleViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
    }
}
@end
