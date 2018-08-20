//
//  HRDynamicModel.h
//  JobKnow
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRDynamicModel : NSObject
@property (nonatomic, strong) NSString *companyName;//公司名
@property (nonatomic, strong) NSString *date;//时间
@property (nonatomic, strong) NSString *jobName;//职位名
@property (nonatomic, strong) NSNumber *jobRecommendNum;//收到了多少份简历
@property (nonatomic, strong) NSString *type;//类型 1某公司的某职位收到多少份简历 2某公司发出多少元的推荐奖金 3某HR收到了多少元的简历推荐奖金
@property (nonatomic, strong) NSNumber *applyMoney;//支付的金额
@property (nonatomic, strong) NSString *hrName;//HR的名字
@end
