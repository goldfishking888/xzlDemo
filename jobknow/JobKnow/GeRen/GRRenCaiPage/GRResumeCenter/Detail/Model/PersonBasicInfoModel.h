//
//  PersonBasicInfoModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonBasicInfoModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *resumeId;
@property (copy,nonatomic) NSString *name;

@property (copy,nonatomic) NSString *gender;
@property (copy,nonatomic) NSString *genderCode;
@property (copy,nonatomic) NSString *age;
@property (copy,nonatomic) NSString *birthday;
@property (copy,nonatomic) NSString *avatar;//头像
@property (copy,nonatomic) NSString *qulification;
@property (copy,nonatomic) NSString *qulificationCode;
@property (copy,nonatomic) NSString *city;
@property (copy,nonatomic) NSString *cityCode;
@property (copy,nonatomic) NSString *workYears;//工作经验
@property (copy,nonatomic) NSString *workYearsCode;//工作经验code

@property (copy,nonatomic) NSString *marriage;//婚姻状况
@property (copy,nonatomic) NSString *marriageCode;//婚姻code
@property (copy,nonatomic) NSString *household;//户口
@property (copy,nonatomic) NSString *household_code;//户口
@property (copy,nonatomic) NSString *political;//政治面貌
@property (copy,nonatomic) NSString *workNature;//工作性质
@property (copy,nonatomic) NSString *workNatureCode;//工作性质Code

@property (copy,nonatomic) NSString *tel;
@property (copy,nonatomic) NSString *email;
@property (copy,nonatomic) NSString *IDNum;

@property (copy,nonatomic) NSString *updated_at;
@end
