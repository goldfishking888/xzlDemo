//
//  GRBookerModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "DBModel.h"

@interface GRBookerModel : DBModel
// 存数据库
@property (nonatomic ,copy) NSNumber *bookId;// 唯一标志（订阅器id）
@property (nonatomic ,copy) NSString *bookPostName;// 职位名称
@property (nonatomic ,copy) NSString *bookIndustryName;// 行业名(，相连，最多五个)
@property (nonatomic ,copy) NSString *bookIndustryCode;// 行业code(，相连，最多五个)
//@property (nonatomic ,copy) NSString *flag;//
@property (nonatomic ,copy) NSString *bookLocationName;// 所在地
@property (nonatomic ,copy) NSString *bookLocationCode; // 所在地code
@property (nonatomic ,copy) NSString *bookSalaryName;// 薪资
@property (nonatomic ,copy) NSString *bookSalaryCode; // 薪资code
@property (nonatomic ,copy) NSString *bookTodayData;// 今日数据
@property (nonatomic ,copy) NSString *bookTotalData;// 所有数据
@property (nonatomic ,copy) NSString *bookDateCreated;// 关键字
@property (nonatomic ,copy) NSString *bookDateUpdated;// 关键字

@property (nonatomic ,copy) NSString *recount;// 去重前职位数


//
+ (GRBookerModel *)getBookerModelWithDic:(NSDictionary*)dic;

@end
