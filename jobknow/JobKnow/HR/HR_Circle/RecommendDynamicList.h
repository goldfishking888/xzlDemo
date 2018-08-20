//
//  RecommendDataList.h
//  JobKnow
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

#define reloadRecommendDynamicListSuccess @"ReloadRecommendDynamicListSuccess"
#define reloadRecommendDynamicListFail @"ReloadRecommendDynamicListFail"
#define RecommendDynamicPlayStatus @"recommendDynamicPlayStatus" //on-开启 off-关闭 存放到NSUserDefaults中

@interface RecommendDynamicList : NSObject{
    
    NSTimer *_timer;
    unsigned  order;
}

@property (nonatomic, strong) NSMutableArray *dynamicArray;//动态推荐数据HRDynamicModel
@property (nonatomic, strong) NSMutableArray *tradeArray;//行业数据HRTradeModel
@property (nonatomic, strong) NSNumber *cityTradeHrNum;//本圈共有HR经理的数量
@property (nonatomic, strong) NSString *payMoneyNum;//已发奖金的数量
@property (nonatomic, strong) NSNumber *seniorNums;//奖金职位的数量
@property (nonatomic, strong) NSString *hrNum;//全国共有HR的数量
@property (nonatomic, strong) UIView *dynamicView;//轮播view


+ (RecommendDynamicList *)shareInstance;
//传nil会使用默认值去获取
//- (void)reloadDataFromServerWithCityCode:(NSString *)cityCode page:(NSString *)page count:(NSString *)count;

//启动和关闭轮播
- (void)startPlay;
- (void)stopPlay;
@end
