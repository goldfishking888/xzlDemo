//
//  XZLUserInfoTool.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/24.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "XZLUserInfoTool.h"

@implementation XZLUserInfoTool

//更新个人信息
+(void)updateUserInfo{
    if (![self isLogin]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kTestToken,@"token",nil];
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/user/info"];
    [XZLNetWorkUtil requestPostURL:url params:params success:^(id responseObject){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSLog(@"responseObject is %@",responseObject);
            NSString *error_code = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if ([error_code isEqualToString:@"0"]) {
                NSDictionary *dicUser = responseObject[@"data"];
                
                [self setUserInfo:dicUser];
                if ([[dicUser valueForKey:@"name"] isNullOrEmpty]) {
                    [mUserDefaults setValue:[NSString stringWithFormat:@"用户%@",[dicUser valueForKey:@"mobile"]] forKey:@"name"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedUserInfo" object:nil];
//                
//                NSString *isUploaded = [NSString stringWithFormat:@"%@",dicUser[@"isResume"]];
//                [XZLUserInfoTool setIsResumeUploaded:isUploaded];
            }else{
                //                mAlertView(@"", @"该企业不能注册");
            }
        }
    }failure:^(NSError *error){
        NSLog(@"error is %@",error);
    }];
}

//存返回个人信息
+(void)setUserInfo:(NSDictionary *)dic{
    for (NSString *key in [dic allKeys]) {
        if (![key isEqualToString:@"partnerInfo"]) {
            NSString *value = [NSString stringWithFormat:@"%@",[dic valueForKey:key]];
            if ([NSString isNullOrEmpty:value]) {
                value = @"";
            }
            [mUserDefaults setValue:value forKey:key];
        }else{
            NSDictionary *pdic =[dic valueForKey:key];
            if ([pdic isKindOfClass:[NSDictionary class]]) {
                if (pdic) {
                    [mUserDefaults setValue:pdic forKey:key];
                }else{
                    NSDictionary *dicp = [NSDictionary new];
                    [mUserDefaults setValue:dicp forKey:key];
                }
                [self setPartnerInfo:pdic];
            }else{
                [self setPartnerInfo:nil];
            }
        }
        
    }
}
//删返回个人信息
+(void)clearUserInfo{

        [mUserDefaults removeObjectForKey:@"name"];
    [mUserDefaults removeObjectForKey:@"token"];
}
//存token
+(void)setToken:(NSString *)token{
    NSString *value = token;
    if ([NSString isNullOrEmpty:value]) {
        value = @"";
    }
    [mUserDefaults setValue:value forKey:@"token"];
}
//取token
+(NSString *)getToken{
    NSString *value = [mUserDefaults valueForKey:@"token"];
    if (value&&![NSString isNullOrEmpty:value]) {
        return value;
    }
    return @"";
}

//判断是否已经登录
+ (BOOL)isLogin{
    
    NSString *str = [mUserDefaults valueForKey:@"isLogin"];
    BOOL isLogin = [str isEqualToString:@"1"];
    if( kTestToken!= nil && ![kTestToken isEqual: @""] && isLogin)
        return YES;
    
    return NO;
    
}

//获取定位city
+(NSString *)getLocalCity{
    NSString * localCityName = @"北京";
    if ([mUserDefaults valueForKey:@"localCity"]) {
        localCityName = [mUserDefaults valueForKey:@"localCity"];
    }
    return localCityName;
}

//取个人/猎头状态
+(NSString *)getGRStatus{
    NSString *value = [mUserDefaults valueForKey:@"GRStatus"];
    if (value&&![NSString isNullOrEmpty:value]) {
        return value;
    }
    return @"";
}

+(void)setGRStatus:(NSString *)status//0 个人 1 猎头
{
    [mUserDefaults setValue:status forKey:@"GRStatus"];
}
//#pragma mark - 判读APP是否第一次启动
+(BOOL)isFirstBOOT
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"firstBOOT"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstBOOT"];
        return YES;
    }
    
    return NO;
}

//是否是合伙人
+(BOOL)isPartner{
    if ([self isResumeUploaded]) {
        if ([self isPartnerInfo]) {
            NSDictionary *dic = [mUserDefaults valueForKey:@"partnerInfo"];
            if (dic) {
                NSString *payStatus = [NSString stringWithFormat:@"%@",dic[@"pay_status"]];
                long long endDateInt = [XZLUtil getMillisecondWithDate:[XZLUtil getDateWithString:dic[@"end_date"]]];
                long long dateNowInt = [XZLUtil getMillisecondWithDate:[NSDate date]];
                if ([payStatus isEqualToString:@"1"]&&(endDateInt-dateNowInt)>0) {
                    NSNumber *pay_money = dic[@"pay_money"];
                    if (pay_money.intValue>0) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

//存合法简历状态
+(void)setIsResumeUploaded:(NSString *)isResumeUploaded{
    [mUserDefaults setValue:isResumeUploaded forKey:@"isResume"];
}
//取合法简历状态
+(BOOL)isResumeUploaded{
    NSString *value = [mUserDefaults valueForKey:@"isResume"];
    if (value&&![NSString isNullOrEmpty:value]) {
        if ([value isEqualToString:@"1"]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

//是否有合伙人信息
+(void)setPartnerInfo:(NSDictionary *)pInfo{
    if (pInfo) {
        [mUserDefaults setValue:pInfo forKey:@"partnerInfo"];
        [mUserDefaults setValue:@"1" forKey:@"ispartnerInfo"];
    }else{
        [mUserDefaults setValue:@"0" forKey:@"ispartnerInfo"];
    }
    
    
}

+(BOOL)isPartnerInfo{
    NSString *s = [mUserDefaults valueForKey:@"ispartnerInfo"];
    if (s.length>0) {
        if([s isEqualToString:@"1"]){
            return YES;
        }
    }
    return NO;
}

@end
