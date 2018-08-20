//
//  XZLUserInfoTool.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/24.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLUserInfoTool : NSObject
//个人信息存
+(void)setUserInfo:(NSDictionary *)dic;
//删个人信息
+(void)clearUserInfo;
//存取token
+(void)setToken:(NSString *)token;

+(NSString *)getToken;

//判断是否已经登录
+ (BOOL)isLogin;

//获取定位city
+(NSString *)getLocalCity;

//设置个人/猎头登录状态
+(void)setGRStatus:(NSString *)status;

//取个人/猎头状态
+(NSString *)getGRStatus;

//是否第一次启动
+(BOOL)isFirstBOOT;

//是否是合伙人
+(BOOL)isPartner;

//存合法简历状态
+(void)setIsResumeUploaded:(NSString *)isResumeUploaded;

//取合法简历状态
+(BOOL)isResumeUploaded;

+(void)updateUserInfo;

//是否有合伙人信息
+(void)setPartnerInfo:(NSDictionary *)pInfo;
+(BOOL)isPartnerInfo;

@end
