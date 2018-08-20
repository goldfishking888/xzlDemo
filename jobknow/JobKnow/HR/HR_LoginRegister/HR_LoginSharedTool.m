//
//  HR_LoginSharedTool.m
//  JobKnow
//
//  Created by Suny on 15/8/21.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_LoginSharedTool.h"
static HR_LoginSharedTool *defaultTool;

@implementation HR_LoginSharedTool

+(void )saveUserInfoDic:(NSDictionary *)resultDic LoginType:(NSString *)type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
    
    //取出个人信息
    //    UserResumeBrith = "1900-01-01";
    //    UserResumeEmail = "";
    NSString *UserResumeHead = [resultDic valueForKey:@"UserResumeHead"];
    //    UserResumeLocation = "";
    //    UserResumeLocationName = "";
    //    UserResumeMobile = 18253592732;
    NSString *UserResumeMobile = [resultDic valueForKey:@"UserResumeMobile"];
    //    UserResumeName = "";
    NSString *UserResumeName = [resultDic valueForKey:@"UserResumeName"];
    //    UserResumeSex = 0;
    //    UserResumeState = 0;
    //    canDeliver = 1;
    NSString * canDeliver=[resultDic valueForKey:@"canDeliver"];
    //    cardUrl = "http://api.xzhiliao.com/file_read/hr_card/92159341440136000.png";
    NSString * cardUrl = [resultDic valueForKey:@"cardUrl"];//认证名片
    //    cityCode = 2012;
    NSString * cityCode = [resultDic valueForKey:@"cityCode"];//cotyCode
    //    cityName = "\U9752\U5c9b";
    NSString * cityName = [resultDic valueForKey:@"cityName"];//cityName
    //    deliverys = 0;
    //    error = 0;
    //    favorites = 0;
    //    headUrl = "http://api.xzhiliao.com/file_read/hr_face/9215934.jpg?1440136846";
    NSString * headUrl = [resultDic valueForKey:@"headUrl"];//头像网址
    //    hrMobile = 18253592732;
    NSString *hrMobile = [resultDic valueForKey:@"hrMobile"];
    //    hrState = 4;
    NSString * hrState = [resultDic valueForKey:@"hrState"];//HRstate判断是否点亮图标
    //    inviteId = 1589919;
    NSString *inviteId = [resultDic valueForKey:@"inviteId"];
    //    inviteSite = "http://www.xzhiliao.com/m/i/1589919";
    //    isHr = 1;
    //    "is_pay_vip" = 0;
    NSString *isPayVip = [resultDic valueForKey:@"is_pay_vip"];//is_pay_vip是否企业认证
    //    israises = 0;
    //    occupation = "\U4eba\U529b\U8d44\U6e90\U7ecf\U7406";
    NSString * occupation = [resultDic valueForKey:@"occupation"];//职位
    //    realName = "";
    NSString *realName = [resultDic valueForKey:@"realName"];//HRname
    //    regDate = 7;
    //    resumeId = 280009215934;
    //    telephone = "";
    NSString * telephone = [resultDic valueForKey:@"telephone"];//认证名片
    //    tradeCode = "1113,1115";
    NSString * tradeCode = [resultDic valueForKey:@"tradeCode"];//tradeCode
    //    tradeName = "IT\U670d\U52a1\Uff08\U7cfb\U7edf/ ,\U7f51\U7edc\U6e38\U620f";
    NSString * tradeName = [resultDic valueForKey:@"tradeName"];//行业
    //    userBookType = "0-0-0-0";
    //    userCompany = "";
    NSString * userCompany = [resultDic valueForKey:@"userCompany"];//公司
    //    userEmail = "";
    NSString * userEmail = [resultDic valueForKey:@"userEmail"];//认证名片
    //    userId = 6326252;
    //    userInviter = "";
    //    userMessage = 0;
    //    userMobile = 18253592732;
    //    userName = "";
    //    userRemindTime = "08:30";
    //    userTag = "";
    //    userToken = f5ed103b65933efc3dc7c873b09053aa;
    NSString *userToken=[resultDic valueForKey:@"userToken"];
    //    userUid = 9215934;
    NSString *uid = [resultDic valueForKey:@"userUid"];
    //"work_years" = 0;
    NSString *year=[resultDic valueForKey:@"work_years"];
    NSString*workYear=[self configBianma:year];
    
    NSString *isHr = [resultDic valueForKey:@"isHr"];//是否hr
    
    [userDefaults setObject:type forKey:@"LoginType"];
    [userDefaults setObject:isHr forKey:@"isHr"];
    [userDefaults setObject:@"0" forKey:@"LoginNew"];//是否登录 //0 登录成功
    
    
    [userDefaults setObject:workYear forKey:@"mWorkYear"];
    [userDefaults setObject:UserResumeName forKey:@"personName"];
    [userDefaults setObject:UserResumeMobile forKey:@"user_tel"];
    [userDefaults setObject:UserResumeHead forKey:@"UserResumeHead"];
    
    [userDefaults setObject:hrState forKey:@"hrState"];//1 审核中 2 审核成功 3 审核失败 4 是修改之后重新等待审核是4
    [userDefaults setObject:userCompany forKey:@"userCompany"];
    [userDefaults setObject:occupation forKey:@"occupation"];
    [userDefaults setObject:tradeName forKey:@"tradeName"];
    [userDefaults setObject:headUrl  forKey:@"headUrl"];
    [userDefaults setObject:cardUrl  forKey:@"cardUrl"];
    [userDefaults setObject:userEmail  forKey:@"userEmail"];
    [userDefaults setObject:telephone  forKey:@"telephone"];
    
    [userDefaults setObject:isPayVip forKey:@"is_pay_vip"];
    [userDefaults setObject:realName forKey:@"realName"];
    [userDefaults setObject:cityName forKey:@"cityName"];
    [userDefaults setObject:cityCode forKey:@"cityCode"];
    [userDefaults setObject:tradeCode forKey:@"tradeCode"];
    
    [userDefaults setObject:hrMobile forKey:@"hrMobile"];
    
    [userDefaults setObject:userToken forKey:@"userToken"];
    [userDefaults setObject:canDeliver forKey:@"canDeliver"];
    [userDefaults setObject:inviteId forKey:@"inviteId"];
    [userDefaults setObject:uid forKey:@"userUid"];
    
    //清空判断是否是HR但不是vip的数组，实现重新登录时显示点击推荐时显示的对话框
    [userDefaults setObject:@"" forKey:@"IsHRButNotVIP"];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH-mm-ss"];
    NSString *currentTime=[dateFormatter stringFromDate:[NSDate date]];
    [userDefaults setObject:currentTime forKey:@"zhangxinTime"];
    [userDefaults synchronize];
}
+(void )clearUserInfo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"LoginType"];
    [ud removeObjectForKey:@"isHr"];
    [ud removeObjectForKey:@"mWorkYear"];
    [ud removeObjectForKey:@"personName"];
    [ud removeObjectForKey:@"user_tel"];
    [ud removeObjectForKey:@"UserResumeHead"];
    [ud removeObjectForKey:@"hrState"];
    [ud removeObjectForKey:@"userCompany"];
    [ud removeObjectForKey:@"occupation"];
    [ud removeObjectForKey:@"tradeName"];
    [ud removeObjectForKey:@"headUrl"];
    [ud removeObjectForKey:@"cardUrl"];
    [ud removeObjectForKey:@"userEmail"];
    [ud removeObjectForKey:@"telephone"];
    [ud removeObjectForKey:@"is_pay_vip"];
    [ud removeObjectForKey:@"realName"];
    [ud removeObjectForKey:@"cityName"];
    [ud removeObjectForKey:@"cityCode"];
    [ud removeObjectForKey:@"tradeCode"];
    [ud removeObjectForKey:@"hrMobile"];
    [ud removeObjectForKey:@"userToken"];
    [ud removeObjectForKey:@"canDeliver"];
    [ud removeObjectForKey:@"inviteId"];
    [ud removeObjectForKey:@"userUid"];
    [ud removeObjectForKey:@"IsHRButNotVIP"];
    [ud removeObjectForKey:@"zhangxinTime"];
    [ud synchronize];
}
//根据传入参数返回工作经验年限

+ (NSString *)configBianma:(NSString *)year
{
    NSString *workYear;
    
    if (year&&year.integerValue==-2) {
        
        workYear=@"不限";
        
    }else if(year&&year.integerValue==-1){
        
        workYear=@"在读学生";
        
    }else if (year&&year.integerValue==0)
    {
        workYear=@"应届毕业生";
    }else
    {
        workYear=[NSString stringWithFormat:@"%@年",year];
    }
    
    return workYear;
}

@end
