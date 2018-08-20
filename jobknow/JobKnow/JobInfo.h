//
//  JobInfo.h
//  JobKnow
//
//  Created by faxin sun on 13-3-6.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobInfo : NSObject

@property (nonatomic, copy) NSString *pid;    //企业
@property (nonatomic, copy) NSString *job_id;   //职位
@property (nonatomic, copy) NSString *cid;    //
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *jobName;//职位名称
@property (nonatomic, copy) NSString *companyName;//公司名称
@property (nonatomic, copy) NSString *cityName;//城市名称
@property (nonatomic, copy) NSString *publishDate;//发布日期
@property (nonatomic, copy) NSString *salary;//薪水
@property (nonatomic, copy) NSString *education;//学历
@property (nonatomic, copy) NSString *companyType;//企业性质
@property (nonatomic, copy) NSString *require;//任职要求
@property (nonatomic, copy) NSString *isfav;
@property (nonatomic,copy)  NSString *read;
@property(nonatomic,assign)   NSInteger isJianzhi;
+ (NSArray *)jobInfoPutToArray:(NSArray *)array;
+ (NSString *)stringBecomeTime:(NSString *)time;
+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr;
@end
