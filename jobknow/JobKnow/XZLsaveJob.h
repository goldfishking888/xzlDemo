//
//  XZLsaveJob.h
//  XzlEE
//
//  Created by ralbatr on 14-9-22.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLsaveJob : NSObject
@property (nonatomic,strong)NSMutableArray *saveArr;    //存放行业数据的数组
/**
 jobDic中存放的是也是字典，每一个键是一个职位类别名称
 jobDic里面存放的是字典，键为_jobItem
 值jobName也是一个字典，由code和name两个键值对组成
 **/

@property (nonatomic,strong)NSMutableDictionary *jobDic;

+ (id)standardDefault;
//返回所选择的数量
- (NSInteger)allNumber;
//得到行业字符串，得到行业code字符串
- (NSString *)industry;
- (NSMutableString *)industryCode;

//返回所选择职业的数组
- (NSMutableArray *)dicKeyName:(NSString *)jobItem jobKeyName:(NSString *)jobName;

@end
