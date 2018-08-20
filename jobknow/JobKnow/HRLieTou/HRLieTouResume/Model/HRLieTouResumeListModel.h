//
//  HRLieTouResumeListModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRLieTouResumeListModel : NSObject
@property (copy,nonatomic) NSString *resumeId;
@property (copy,nonatomic) NSString *name;

@property (copy,nonatomic) NSString *city;
@property (copy,nonatomic) NSString *cityCode;
@property (copy,nonatomic) NSString *salary;
@property (copy,nonatomic) NSString *salaryCode;
@property (copy,nonatomic) NSString *workYears;//工作经验
@property (copy,nonatomic) NSString *workYearsCode;//工作经验code
@property (copy,nonatomic) NSString *degree;
@property (copy,nonatomic) NSString *degreeCode;
@property (copy,nonatomic) NSString *work;
@property (copy,nonatomic) NSString *workCode;
@property (copy,nonatomic) NSString *status;
@property (copy,nonatomic) NSString *statusCode;
@property (copy,nonatomic) NSString *date_updated;

@end
