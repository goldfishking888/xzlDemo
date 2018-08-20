//
//  JobOrientationModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobOrientationModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *resumeId;

@property (copy,nonatomic) NSString *expect_job;
@property (copy,nonatomic) NSString *expect_job_code;
@property (copy,nonatomic) NSString *expect_industry;
@property (copy,nonatomic) NSString *expect_industry_code;
@property (copy,nonatomic) NSString *expect_city;
@property (copy,nonatomic) NSString *expect_city_code;
@property (copy,nonatomic) NSString *expect_salary;
@property (copy,nonatomic) NSString *expect_salary_code;
@property (copy,nonatomic) NSString *status;
@property (copy,nonatomic) NSString *status_code;


@end
