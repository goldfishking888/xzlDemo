//
//  XZLUtil.h
//  JobKnow
//
//  Created by Jiang on 15/8/22.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>

@interface XZLUtil : NSObject
//获取系统版本号
+ (NSString *)currentVersion;

//获取imei
+ (NSString *)getIMEI;

#pragma mark 正在审核
+ (BOOL) isUnderCheck;
//手机号校验
+ (BOOL) isValidateMobile:(NSString *)mobile;

// 数字校验
+ (BOOL) isValidateNumber:(NSString *)number;

//发送极光推送的别名
+ (void)sendAliasToJPush;

//获得设备型号
+ (NSString *)getCurrentDeviceModel;

+ (BOOL )isiPhone6;

+ (BOOL )isiPhone6p;

+ (NSString *)changeDateToStr:(NSDate *)date;

+ (NSDate *)changeStrToDate:(NSString *)dateStr;

// NSDate转NSString，formatter为格式化字符串
+ (NSString *)changeDateToString:(NSDate *)date withFormatter:(NSString *)formatter;
// NSString转NSDate，formatter为格式化字符串
+ (NSDate *)changeStringToDate:(NSString *)dateStr withFormatter:(NSString *)formatter;
//返回时间戳
+ (NSString *)stringBecomeTime:(NSString *)time;
//在某日期上增加x年x月x日x时x分x秒(负值为减少)
+(NSDate *)addToStartDate:(NSDate *)startDate withYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second;
// QQ、sina、微信是否都未安装
+(BOOL)isShareAppInstalled;

//将“yyyy-MM-dd HH:mm:ss”的日期转为时间戳格式
+ (NSString *)changeDateStrToTimestampStr:(NSString *)dateStr;

//将时间戳格式转为“yyyy-MM-dd HH:mm:ss”的日期
+ (NSString *)changeTimestampStrToDateStr:(NSString *)dateStr;

+(NSString *)getDateWithMillisecond:(long long)millisecond;
+(long long)getMillisecondWithDate:(NSDate *)date;
+(NSDate *)getDateWithString:(NSString *)dateString;

//获取手机型号
+ (NSString*)deviceVersion;

//判断是否已经登录
+ (BOOL)isLogin;

//退出程序
+ (void)exitApplication;

//URL Encode
+ (NSString*)urlEncodedString:(NSString *)string;

+(NSMutableArray *)getIndustryArrayWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getSalaryArrayWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getXueliWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getWorkYearsWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getCitiesWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getPositionWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getGenderWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getNowStatusWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getMarriageWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getCompanyNatureWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getCompanySizeWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getWorkCropWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getLanguageLevelWithModel:(BOOL)withGRReadModel;
+(NSMutableArray *)getComplainWithModel:(BOOL)withGRReadModel;
//根据城市code获取城市名
+(NSString *)getCityNameWithCityCode:(NSString *)cityCode;

//根据城市城市名获取code
+(NSString *)getCityCodeWithCityName:(NSString *)cityName;

//根据degreeCode获取学历
+(NSString *)getDegreeStrWithDegreeCode:(NSString *)code;

//根据学历获取学历Code
+(NSString *)getDegreeCodeStrWithDegree:(NSString *)name;

//根据薪资code获取薪资段
+(NSString *)getSalaryRangeWithSalaryCode:(NSString *)code;

//根据薪资范围获取薪资范围code
+(NSString *)getSalaryRangeCodeWithSalary:(NSString *)name;

//根据workyears code获取workyear
+(NSString *)getWorkYearsWithWorkYearCode:(NSString *)code;

//根据工作年限获取工作年限Code
+(NSString *)getWorkYearsCodeWithWorkYear:(NSString *)name;

// 根据industryCode获取薪资范围
+(NSString *)getIndustryNameWithCode:(NSString *)industryCode;

//根据industryname获取薪资范围industrycode
+(NSString *)getindustryCodeWithindustry:(NSString *)industryname;

//根据企业性质code获取企业性质
+(NSString *)getCompanyCorpWithCompanyCorpCode:(NSString *)CompanyCorpCode;

//根据企业性质获取企业性质code
+(NSString *)getCompanyCorpCodeWithCompanyCorp:(NSString *)CompanyCorp;


//根据性别code获取性别
+(NSString *)getGenderWithGenderCode:(NSString *)GenderCode;

//根据性别获取性别code
+(NSString *)getGenderCodeWithGender:(NSString *)Gender;
//根据职业code获取职业
+(NSString *)getJobWithJobCode:(NSString *)JobCode;
//根据职业获取职业code
+(NSString *)getJobCodeWithJob:(NSString *)job;

+(NSString *)getMarriageWithMarriageCode:(NSString *)code;
+(NSString *)getMarriageCodeWithMarriage:(NSString *)name;

//根据工作性质code获取工作性质
+(NSString *)getWorkCropWithWorkCropCode:(NSString *)code;
//根据工作性质获取工作性质code
+(NSString *)getWorkCropCodeWithWorkCrop:(NSString *)name;

//根据NowStatuscode获取NowStatus
+(NSString *)getNowStatusWithNowStatusCode:(NSString *)code;
//根据NowStatus获取NowStatuscode
+(NSString *)getNowStatusCodeWithNowStatus:(NSString *)name;

//根据company_size code获取company_size
+(NSString *)getCompanySizeWithCompanySizeCode:(NSString *)code;
//根据company_size获取company_size code
+(NSString *)getCompanySizeCodeWithCompanySize:(NSString *)name;

//根据LanguageLevel code获取LanguageLevel
+(NSString *)getLanguageLevelWithLanguageLevelCode:(NSString *)code;
//根据LanguageLevel获取LanguageLevel code
+(NSString *)getLanguageLevelCodeWithLanguageLevel:(NSString *)name;

@end
