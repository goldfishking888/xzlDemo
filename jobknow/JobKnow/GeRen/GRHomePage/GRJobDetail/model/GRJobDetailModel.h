//
//  GRJobDetailModel.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRJobDetailModel : NSObject
@property (nonatomic,copy) NSString * company_id;
@property (nonatomic,copy) NSString * company_pid;
@property (nonatomic,copy) NSString * cost;
@property (nonatomic,copy) NSString * created_at;
@property (nonatomic,copy) NSNumber * degree;
@property (nonatomic,copy) NSString * email;
@property (nonatomic,copy) NSString * enddate;
@property (nonatomic,copy) NSString * fromWhere;
@property (nonatomic,copy) NSString * hunter_earning;
@property (nonatomic,copy) NSString * Id;
@property (nonatomic,copy) NSString * ifPrepayBonus;
@property (nonatomic,copy) NSString * incrementProfit;
@property (nonatomic,copy) NSString * is_contract;
@property (nonatomic,copy) NSNumber * is_fast;//是否急招
@property (nonatomic,copy) NSNumber * is_fav;//是否收藏
@property (nonatomic,copy) NSNumber * is_recommend;//是否自荐
@property (nonatomic,copy) NSString * is_publish;
@property (nonatomic,copy) NSString * job_sort;
@property (nonatomic,copy) NSString * linkman;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSNumber * num;
@property (nonatomic,copy) NSString * offer_score;
@property (nonatomic,copy) NSString * old_city;
@property (nonatomic,copy) NSString * old_id;
@property (nonatomic,copy) NSString * origin;
@property (nonatomic,copy) NSString * phone_num;
@property (nonatomic,copy) NSString * position_type;
@property (nonatomic,copy) NSNumber * position_validateDate;
@property (nonatomic,copy) NSString * rank;
@property (nonatomic,copy) NSString * recount;
@property (nonatomic,copy) NSString * remark;
@property (nonatomic,copy) NSNumber * salary;
@property (nonatomic,copy) NSString * sex;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSNumber * type;
@property (nonatomic,copy) NSString * updated_at;
@property (nonatomic,copy) NSString * user_city;
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * validate_status;
@property (nonatomic,copy) NSString * work_area;
@property (nonatomic,copy) NSNumber * work_years;
@end
/*
 positionInfo =         {
 name = "\U9ad8\U7ea7PHP\U5de5\U7a0b\U5e08";
 num = 1;
 "offer_score" = "-1";
 "old_city" = 0;
 "old_id" = 0;
 origin = 0;
 "phone_num" = "010-56191605";
 "position_type" = 0;
 rank = 0;
 recount = 0;
 remark = "\U4e3b\U8981\U5de5\U6587\U6863\U548c\U4e66\U7c4d\U8005\U4f18\U5148\U3002";
 salary = 2001;
 sex = 0;
 status = 1;
 type = 1;
 "updated_at" = "2017-04-27 14:52:51";
 "user_city" = 1111;
 "user_id" = 652;
 "validate_status" = 0;
 "work_area" = "\U5317\U4eac";
 "work_years" = 3;
 "company_id" = "eyJpdiI6Iml1dlwvZFdYVXdVMTFoc1BVNGxZVUxnPT0iLCJ2YWx1ZSI6InBnQkg2R0dNT3h5elJSQ0pRMkRobWc9PSIsIm1hYyI6Ijg0MjJjNjgxNTNjNDM1ODZjODM5N2RjZmJjMjNjYjQzMGJmOTBjMjAwZDAwOGM0MmU3NzJlMTYzN2Q2NjA2N2IifQ==";
 cost = 10200;
 "created_at" = "2016-10-09 09:35:19";
 degree = 15;
 email = "cuishuang@qijiayoudao.com";
 enddate = "2017-01-07";
 fromWhere = "";
 "hunter_earning" = "20000-29999";
 id = 217;
 ifPrepayBonus = 0;
 incrementProfit = 2000;
 "is_contract" = 0;
 "is_publish" = 1;
 "job_sort" = "\U8f6f\U4ef6\U5de5\U7a0b\U5e08";
 linkman = "\U4eba\U4e8b\U90e8";
 };
 };
 "error_code" = 0;
 "status_code" = 200;
 */
