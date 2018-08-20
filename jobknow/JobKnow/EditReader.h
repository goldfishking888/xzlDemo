//
//  EditReader.h
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditReader : NSObject
//行业
@property (nonatomic, strong) NSMutableArray *industry;
//职业
@property (nonatomic, strong) NSMutableArray *jobArray;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *jobOtherArray;
+ (EditReader *)standerDefault;
//行业字符串
+ (NSString *)tradeStr;
//职业字符串
+ (NSString *)jobStr;
//行业代码
+ (NSString *)industryCode;
//职业代码
+ (NSString *)jobCode;
//期望地点
+ (NSString *)areaStr;
+ (NSString *)areaCode;

//清楚行业和职业数据
+ (void)removeAllData;
+ (BOOL)containTheTradeCode:(NSString *)code;
+ (BOOL)containTheCode:(NSString *)code;
+ (void)deleteJobWithCode:(NSString *)code;

+ (void)deleteTradeWithCode:(NSString *)code;


@property (nonatomic, strong) NSMutableArray *areaArray;
@end
