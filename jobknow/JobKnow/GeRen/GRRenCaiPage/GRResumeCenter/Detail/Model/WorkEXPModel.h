//
//  WorkEXPModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkEXPModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *workEXP_Id;
@property (copy,nonatomic) NSString *resumeId;

@property (copy,nonatomic) NSString *company;
@property (copy,nonatomic) NSString *position;
@property (copy,nonatomic) NSString *position_code;
@property (copy,nonatomic) NSString *date_start;
@property (copy,nonatomic) NSString *date_end;
@property (copy,nonatomic) NSString *industry;
@property (copy,nonatomic) NSString *industry_code;
@property (copy,nonatomic) NSString *company_nature;
@property (copy,nonatomic) NSString *company_nature_code;
@property (copy,nonatomic) NSString *company_scale;
@property (copy,nonatomic) NSString *company_scale_code;
@property (copy,nonatomic) NSString *salary;
@property (copy,nonatomic) NSString *salary_code;
@property (copy,nonatomic) NSString *work_intro;

@end
