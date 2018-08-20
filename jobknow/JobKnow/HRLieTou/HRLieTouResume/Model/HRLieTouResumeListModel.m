//
//  HRLieTouResumeListModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRLieTouResumeListModel.h"

@implementation HRLieTouResumeListModel
//@property (copy,nonatomic) NSString *resumeId;
//@property (copy,nonatomic) NSString *name;
//
//@property (copy,nonatomic) NSString *city;
//@property (copy,nonatomic) NSString *cityCode;
//@property (copy,nonatomic) NSString *salary;
//@property (copy,nonatomic) NSString *salaryCode;
//@property (copy,nonatomic) NSString *workYears;//工作经验
//@property (copy,nonatomic) NSString *workYearsCode;//工作经验code
//@property (copy,nonatomic) NSString *degree;
//@property (copy,nonatomic) NSString *degreeCode;
//@property (copy,nonatomic) NSString *work;
//@property (copy,nonatomic) NSString *workCode;
//@property (copy,nonatomic) NSString *status;
//@property (copy,nonatomic) NSString *statusCode;
//@property (copy,nonatomic) NSString *date_updated;

- (id)init
{
    if (self = [super init])
    {
        self.resumeId = @"";
        self.name = @"";
        self.city = @"";
        self.cityCode = @"";
        self.salary = @"";
        self.salaryCode = @"";
        self.workYears = @"";
        self.workYearsCode = @"";
        self.degree = @"";
        self.degreeCode = @"";
        self.work = @"";
        self.workCode = @"";
        
        
        self.status = @"";
        self.statusCode = @"";
        self.date_updated = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    
    if (self) {
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        self.city = [NSString stringWithFormat:@"%@",dic[@"hope_area"]];
        self.city = [self.city stringWithoutShi];
        self.cityCode = [XZLUtil getCityCodeWithCityName:self.city];
        self.salary = [NSString stringWithFormat:@"%@",dic[@"hope_salary"]];
        self.salaryCode = [NSString stringWithFormat:@"%@",dic[@"hope_salary_code"]];
        self.workYearsCode = [NSString stringWithFormat:@"%@",dic[@"work_years"]];
        self.workYears = [XZLUtil getWorkYearsWithWorkYearCode:self.workYearsCode];
        
        self.degree = [NSString stringWithFormat:@"%@",dic[@"degree"]];
        self.degreeCode = [NSString stringWithFormat:@"%@",dic[@"degree_code"]];
        
        self.work = [NSString stringWithFormat:@"%@",dic[@"hope_job_orgin"]];
//        self.workCode = [XZLUtil getGenderWithGenderCode:self.genderCode];
        self.date_updated = [NSString stringWithFormat:@"%@",dic[@"refreshed"]];
        self.statusCode = [NSString stringWithFormat:@"%@",dic[@"now_status"]];
        self.status = [XZLUtil getNowStatusWithNowStatusCode:self.statusCode];
    }
    
    return self;
}

@end
