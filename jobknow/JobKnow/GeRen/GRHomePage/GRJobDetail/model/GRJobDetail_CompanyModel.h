//
//  GRJobDetail_CompanyModel.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRCompanyInfoModel.h"//公司信息里面的公司详情
@interface GRJobDetail_CompanyModel : NSObject
@property (nonatomic,copy) NSString * bonus_withdraw;
@property (nonatomic,copy) NSString * business_bonus_withdrawals;
@property (nonatomic,copy) NSString * check_at;
@property (nonatomic,copy) NSNumber * city;
@property (nonatomic,strong) GRCompanyInfoModel * companyInfo;
@property (nonatomic,copy) NSString * created_at;
@property (nonatomic,copy) NSString * email;
@property (nonatomic,copy) NSString * free_hr_all_withdraw;
@property (nonatomic,copy) NSString * free_hr_invite_withdraw;
@property (nonatomic,copy) NSString * free_hr_withdraw;
@property (nonatomic,copy) NSString * hr_qrcode_path;
@property (nonatomic,copy) NSNumber * Id;
@property (nonatomic,copy) NSNumber * interview_withdrawals;
@property (nonatomic,copy) NSNumber * isAuthor;
@property (nonatomic,copy) NSNumber * is_partner;
@property (nonatomic,copy) NSString * is_realname_info;
@property (nonatomic,copy) NSNumber * is_test;
@property (nonatomic,copy) NSString * last_ip;
@property (nonatomic,copy) NSString * last_login_at;
@property (nonatomic,copy) NSString * license;
@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * password;
@property (nonatomic,copy) NSString * pid;
@property (nonatomic,copy) NSString * portrait;
@property (nonatomic,copy) NSString * property;
@property (nonatomic,copy) NSString * qrcode_path;
@property (nonatomic,copy) NSString * remember_token;
@property (nonatomic,copy) NSNumber * resume_withdraw;
@property (nonatomic,copy) NSNumber * resume_withdraw_person;
@property (nonatomic,copy) NSNumber * role;
@property (nonatomic,copy) NSNumber * score;
@property (nonatomic,copy) NSNumber * type;
@property (nonatomic,copy) NSNumber * uid;
@property (nonatomic,copy) NSNumber * updated_at;
@property (nonatomic,copy) NSString * vip;
@property (nonatomic,copy) NSString * work_company;
@property (nonatomic,copy) NSString * work_trade;
@property (nonatomic,copy) NSString * trade_name;
@end
/*
 (lldb) po responseObject
 {
 data =     {
 "bonus_withdraw" = "3650.00";
 "business_bonus_withdrawals" = "23350.00";
 "check_at" = "2017-01-04 17:00:17";
 city = 4016;
 "company_info" =         {
 "company_address" = "\U5eca\U574a\U4e16\U7eaa\U5927\U90533\U53f7";
 "company_intro" = "\U516c\U53f8\U7b80\U4ecb\Uff0c\U975e\U5e38\U597d11111";
 "company_linkemail" = "as@a.com";
 "company_linkman" = "\U5218\U5148\U751f";
 "company_linktel" = "6666-11111111";
 "company_logo" = "";
 "company_size" = 14;
 "company_trade" = "1114,1117";
 corpprop = 05;
 "created_at" = "-0001-11-30 00:00:00";
 "financing_type" = "-1";
 id = 71;
 "listing_status" = 3;
 "updated_at" = "2017-06-30 14:48:55";
 "user_id" = 10;
 website = "";
 };
 "created_at" = "2016-05-19 09:55:01";
 email = "as@a.com";
 "free_hr_all_withdraw" = "0.00";
 "free_hr_invite_withdraw" = "0.00";
 "free_hr_withdraw" = "0.00";
 "hr_qrcode_path" = "";
 id = 10;
 "interview_withdrawals" = 0;
 isAuthor = 4;
 "is_partner" = 0;
 "is_realname_info" = "<null>";
 "is_test" = 1;
 "last_ip" = "192.168.8.241";
 "last_login_at" = "2017-08-08 13:02:46";
 license = "http://timages.hrbanlv.com/file/pmattachment/7/35/14841309307908901484130909180.png";
 mobile = 13356262356;
 name = "\U5eca\U574a\U5929\U5947\U79d1\U6280\U53d1\U5c55\U6709\U9650\U516c\U53f8";
 nickname = "<null>";
 password = e10adc3949ba59abbe56e057f20f883e;
 pid = 36000104016;
 portrait = "http://timages.hrbanlv.com/file/pmattachment/7/35/1484208838885966logo.png";
 property = "<null>";
 "qrcode_path" = "";
 "remember_token" = "";
 "resume_withdraw" = 1;
 "resume_withdraw_person" = 0;
 role = 1;
 score = 19000;
 type = 1;
 uid = 0;
 "updated_at" = "2017-08-08 13:02:46";
 vip = 1;
 "work_company" = "<null>";
 "work_trade" = "<null>";
 };
 "error_code" = 0;
 "status_code" = 200;
 }
 */
