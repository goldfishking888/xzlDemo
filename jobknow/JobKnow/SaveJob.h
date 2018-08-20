//
//  SaveJob.h
//  JobsGather
//
//  Created by faxin sun on 13-1-26.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectJob.h"

@interface SaveJob : NSObject

@property (nonatomic,strong)NSMutableArray *saveArr;    //存放行业数据的数组
@property (nonatomic,strong)NSMutableArray *positionArr;//存放职位订阅数据的数组
@property (nonatomic,strong)NSMutableArray *saveArrSalary;    //存放薪资数据的数组
@property (nonatomic,strong)NSMutableArray *saveArrEduQualification;    //存放学历的数组

@property(nonatomic,strong)NSMutableArray *choiceArr;
@property(nonatomic,strong)NSMutableArray *seniorChoiceArr;//存放入职奖金列表筛选结果
/**
jobDic中存放的是也是字典，每一个键是一个职位类别名称
jobDic里面存放的是字典，键为_jobItem
值jobName也是一个字典，由code和name两个键值对组成
**/

@property (nonatomic,strong)NSMutableDictionary *jobDic;

/*********************************************************************/
/*********************************************************************/

/*********************************************************************/
/*********************************************************************/

+ (id)standardDefault;

//将键为name的一个键值对存放到jobDic字典中
- (void)exsitNameKey:(NSString *)name;
//返回所选择的数量
- (NSInteger)allNumber;
//返回所选择职业的数组
- (NSMutableArray *)dicKeyName:(NSString *)jobItem jobKeyName:(NSString *)jobName;

//清理所有的数组和字典
- (void)clearTheCache;

//得到行业字符串，得到行业code字符串
- (NSString *)industry;
- (NSMutableString *)industryCode;

//得到薪资字符串，得到薪资code字符串
- (NSString *)salary;
- (NSMutableString *)salaryCode;

//得到薪资字符串，得到学历code字符串
- (NSString *)EDUQua;
- (NSMutableString *)EDUQuaCode;

//得到职业字符串，得到职业code字符串
- (NSString *)jobStr;
- (NSString *)jobCodeStr;


- (NSMutableArray *)allSelectJob;
- (NSMutableArray *)allSelectJobInfo;
- (BOOL)deleteSelectJob:(NSDictionary *)dic;

- (void)positionArrInit;
- (void)choiceArrInit;
- (void)seniorChoiceArrInit;

//过滤字符
+(NSString *)string2Json2:(NSString *)jsonString;

//将unicode字符转化为字符串
+(NSString *)replaceUnicode:(NSString *)unicodeStr;
@end
