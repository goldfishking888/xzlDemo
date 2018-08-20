//
//  PersonBasicInfoModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "PersonBasicInfoModel.h"

@implementation PersonBasicInfoModel

//@property (copy,nonatomic) NSString *name;
//
//@property (copy,nonatomic) NSString *gender;
//@property (copy,nonatomic) NSString *genderCode;
//@property (copy,nonatomic) NSString *age;
//@property (copy,nonatomic) NSString *birthday;
//@property (copy,nonatomic) NSString *qulification;
//@property (copy,nonatomic) NSString *qulificationCode;
//@property (copy,nonatomic) NSString *city;
//@property (copy,nonatomic) NSString *cityCode;
//@property (copy,nonatomic) NSString *workYears;//工作经验
//@property (copy,nonatomic) NSString *workYearsCode;//工作经验code
//
//@property (copy,nonatomic) NSString *marriage;//婚姻状况
//@property (copy,nonatomic) NSString *marriageCode;//婚姻code
//@property (copy,nonatomic) NSString *from;//籍贯
//@property (copy,nonatomic) NSString *political;//政治面貌
//@property (copy,nonatomic) NSString *workNature;//工作性质
//@property (copy,nonatomic) NSString *workNatureCode;//工作性质Code
//
//@property (copy,nonatomic) NSString *tel;
//@property (copy,nonatomic) NSString *email;
//@property (copy,nonatomic) NSString *IDNum;

- (id)init
{
    if (self = [super init])
    {
        self.resumeId = @"";
        self.name = @"";
        self.age = @"";
        self.birthday = @"";
        self.avatar = @"";
        
        self.gender = @"";
        self.genderCode = @"";
        self.qulification = @"";
        self.qulificationCode = @"";
        self.city = @"";
        self.cityCode = @"";
        self.workYears = @"";
        self.workYearsCode = @"";
        
        self.marriage = @"";
        self.marriageCode = @"";
        self.household = @"";
        self.household_code = @"";
        self.political = @"";
        self.workNature = @"";
        self.workNatureCode = @"";
        
        self.tel = @"";
        self.email = @"";
        self.IDNum = @"";
        
        self.updated_at = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    
    if (self) {
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        self.age = [NSString stringWithFormat:@"%@",dic[@"age"]];
        self.birthday = [NSString stringWithFormat:@"%@",dic[@"birthday"]];
        self.avatar = [NSString stringWithFormat:@"%@",dic[@"portrait"]];
        
        self.genderCode = [NSString stringWithFormat:@"%@",dic[@"sex"]];
        self.gender = [XZLUtil getGenderWithGenderCode:self.genderCode];
        self.qulification = [NSString stringWithFormat:@"%@",dic[@"degree"]];
        self.qulificationCode = [NSString stringWithFormat:@"%@",dic[@"degree_code"]];
        self.city = [NSString stringWithFormat:@"%@",dic[@"now_city"]];
        self.city = [self.city stringWithoutShi];
        self.cityCode = [NSString stringWithFormat:@"%@",dic[@"now_city_code"]];
        self.workYearsCode = [NSString stringWithFormat:@"%@",dic[@"work_years"]];
        self.workYears = [XZLUtil getWorkYearsWithWorkYearCode:self.workYearsCode];
        
        self.marriageCode = [NSString stringWithFormat:@"%@",dic[@"marriage"]];
        self.marriage = [XZLUtil getMarriageWithMarriageCode:self.marriageCode];
        
        self.household = [NSString stringWithFormat:@"%@",dic[@"household"]];
        self.household = [self.household stringWithoutShi];
        self.household_code = [NSString stringWithFormat:@"%@",dic[@"household_code"]];
        self.political = [NSString stringWithFormat:@"%@",dic[@"political"]];
        self.workNatureCode = [NSString stringWithFormat:@"%@",dic[@"work_nature"]];
        self.workNature = [XZLUtil getWorkCropWithWorkCropCode:self.workNatureCode];
        
        
        self.tel = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
        self.email = [NSString stringWithFormat:@"%@",dic[@"email"]];
        self.IDNum = [NSString stringWithFormat:@"%@",dic[@"idcard"]];
        
        self.updated_at = [NSString stringWithFormat:@"%@",dic[@"updated_at"]];
        self.updated_at = [self.updated_at stringWithRi];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    PersonBasicInfoModel *obj = [[[self class] allocWithZone:zone] init];
    obj.resumeId = [self.resumeId copy];
    obj.name = [self.name copy];
    obj.age = [self.age copy];
    obj.birthday = [self.birthday copy];
    obj.avatar = [self.avatar copy];
    
    obj.gender = [self.gender copy];
    obj.genderCode = [self.genderCode copy];
    obj.qulification = [self.qulification copy];
    obj.qulificationCode = [self.qulificationCode copy];
    obj.city = [self.city copy];
    obj.cityCode = [self.cityCode copy];
    obj.workYears = [self.workYears copy];
    obj.workYearsCode = [self.workYearsCode copy];
    obj.marriage = [self.marriage copy];
    obj.marriageCode = [self.marriageCode copy];
    
    obj.household = [self.household copy];
    obj.household_code = [self.household_code copy];
    obj.political = [self.political copy];
    obj.workNature = [self.workNature copy];
    obj.workNatureCode = [self.workNatureCode copy];
    
    obj.tel = [self.tel copy];
    obj.email = [self.email copy];
    obj.IDNum = [self.IDNum copy];
    
    obj.updated_at = [self.updated_at copy];

    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    PersonBasicInfoModel *obj = [[[self class] allocWithZone:zone] init];
    obj.resumeId = [self.resumeId mutableCopy];
    obj.name = [self.name mutableCopy];
    obj.age = [self.age mutableCopy];
    obj.birthday = [self.birthday mutableCopy];
    obj.avatar = [self.avatar mutableCopy];
    
    obj.gender = [self.gender mutableCopy];
    obj.genderCode = [self.genderCode mutableCopy];
    obj.qulification = [self.qulification mutableCopy];
    obj.qulificationCode = [self.qulificationCode mutableCopy];
    obj.city = [self.city mutableCopy];
    obj.cityCode = [self.cityCode mutableCopy];
    obj.workYears = [self.workYears mutableCopy];
    obj.workYearsCode = [self.workYearsCode mutableCopy];
    obj.marriage = [self.marriage mutableCopy];
    obj.marriageCode = [self.marriageCode mutableCopy];
    
    obj.household = [self.household mutableCopy];
    obj.household_code = [self.household_code mutableCopy];
    obj.political = [self.political mutableCopy];
    obj.workNature = [self.workNature mutableCopy];
    obj.workNatureCode = [self.workNatureCode mutableCopy];
    
    obj.tel = [self.tel mutableCopy];
    obj.email = [self.email mutableCopy];
    obj.IDNum = [self.IDNum mutableCopy];
    
    obj.updated_at = [self.updated_at mutableCopy];
    return obj;
}

@end
