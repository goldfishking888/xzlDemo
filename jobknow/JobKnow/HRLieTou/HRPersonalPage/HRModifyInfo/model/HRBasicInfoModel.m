//
//  HRBasicInfoModel.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/30.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRBasicInfoModel.h"

@implementation HRBasicInfoModel
//@property (copy,nonatomic) NSString *name;
//@property (copy,nonatomic) NSString *city;
//@property (copy,nonatomic) NSString *cityCode;
//@property (copy,nonatomic) NSString *company;
//@property (copy,nonatomic) NSString *industry_name;//行业
//@property (copy,nonatomic) NSString *industry_code;//行业code
//@property (copy,nonatomic) NSString *occupation;
//@property (copy,nonatomic) NSString *mobile;
//@property (copy,nonatomic) NSString *telphone;
//@property (copy,nonatomic) NSString *email;
//@property (copy,nonatomic) NSString *wechat;
//@property (copy,nonatomic) NSString *qq;

- (id)init
{
    if (self = [super init])
    {
        self.name = @"";
        self.city = @"";
        self.cityCode = @"";
        self.company = @"";
        self.industry_name = @"";
        self.industry_code = @"";
        self.occupation = @"";
        self.mobile = @"";
        self.telphone = @"";
        self.email = @"";
        self.wechat = @"";
        self.qq = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    
    if (self) {
        //4个从本地拿 dic里面是不返回的
        self.name = [mUserDefaults valueForKey:@"name"];
        self.mobile = [mUserDefaults valueForKey:@"mobile"];
        self.email = [mUserDefaults valueForKey:@"email"];
        self.cityCode = [mUserDefaults valueForKey:@"cityCode"];
        self.city = [XZLUtil getCityNameWithCityCode:self.cityCode];
        self.city = [self.city stringWithoutShi];//去掉"市"

        
        self.company = [NSString stringWithFormat:@"%@",dic[@"company"]];
        self.industry_name = [NSString stringWithFormat:@"%@",dic[@"industry_name"]];
        self.industry_code = [NSString stringWithFormat:@"%@",dic[@"industry_code"]];
        self.occupation = [NSString stringWithFormat:@"%@",dic[@"occupation"]];
        self.telphone = [NSString stringWithFormat:@"%@",dic[@"telphone"]];
        self.wechat = [NSString stringWithFormat:@"%@",dic[@"wechat"]];
        self.qq = [NSString stringWithFormat:@"%@",dic[@"qq"]];

//        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"id"]];
//        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
//        self.age = [NSString stringWithFormat:@"%@",dic[@"age"]];
//        self.birthday = [NSString stringWithFormat:@"%@",dic[@"birthday"]];
//        self.avatar = [NSString stringWithFormat:@"%@",dic[@"portrait"]];
//        
//        self.genderCode = [NSString stringWithFormat:@"%@",dic[@"sex"]];
//        self.gender = [XZLUtil getGenderWithGenderCode:self.genderCode];
//        self.qulification = [NSString stringWithFormat:@"%@",dic[@"degree"]];
//        self.qulificationCode = [NSString stringWithFormat:@"%@",dic[@"degree_code"]];
//        self.city = [NSString stringWithFormat:@"%@",dic[@"now_city"]];
//        self.city = [self.city stringWithoutShi];
//        self.cityCode = [NSString stringWithFormat:@"%@",dic[@"now_city_code"]];
//        self.workYearsCode = [NSString stringWithFormat:@"%@",dic[@"work_years"]];
//        self.workYears = [XZLUtil getWorkYearsWithWorkYearCode:self.workYearsCode];
//        
//        self.marriageCode = [NSString stringWithFormat:@"%@",dic[@"marriage"]];
//        self.marriage = [XZLUtil getMarriageWithMarriageCode:self.marriageCode];
//        
//        self.household = [NSString stringWithFormat:@"%@",dic[@"household"]];
//        self.household = [self.household stringWithoutShi];
//        self.household_code = [NSString stringWithFormat:@"%@",dic[@"household_code"]];
//        self.political = [NSString stringWithFormat:@"%@",dic[@"political"]];
//        self.workNatureCode = [NSString stringWithFormat:@"%@",dic[@"work_nature"]];
//        self.workNature = [XZLUtil getWorkCropWithWorkCropCode:self.workNatureCode];
//        
//        
//        self.tel = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
//        self.email = [NSString stringWithFormat:@"%@",dic[@"email"]];
//        self.IDNum = [NSString stringWithFormat:@"%@",dic[@"idcard"]];
//        
//        self.updated_at = [NSString stringWithFormat:@"%@",dic[@"updated_at"]];
//        self.updated_at = [self.updated_at stringWithRi];
    }
    
    return self;
}
//- (id)copyWithZone:(NSZone *)zone
//{
//    PersonBasicInfoModel *obj = [[[self class] allocWithZone:zone] init];
//    obj.resumeId = [self.resumeId copy];
//    obj.name = [self.name copy];
//    obj.age = [self.age copy];
//    obj.birthday = [self.birthday copy];
//    obj.avatar = [self.avatar copy];
//    
//    obj.gender = [self.gender copy];
//    obj.genderCode = [self.genderCode copy];
//    obj.qulification = [self.qulification copy];
//    obj.qulificationCode = [self.qulificationCode copy];
//    obj.city = [self.city copy];
//    obj.cityCode = [self.cityCode copy];
//    obj.workYears = [self.workYears copy];
//    obj.workYearsCode = [self.workYearsCode copy];
//    obj.marriage = [self.marriage copy];
//    obj.marriageCode = [self.marriageCode copy];
//    
//    obj.household = [self.household copy];
//    obj.household_code = [self.household_code copy];
//    obj.political = [self.political copy];
//    obj.workNature = [self.workNature copy];
//    obj.workNatureCode = [self.workNatureCode copy];
//    
//    obj.tel = [self.tel copy];
//    obj.email = [self.email copy];
//    obj.IDNum = [self.IDNum copy];
//    
//    obj.updated_at = [self.updated_at copy];
//    
//    return obj;
//}
//
//- (id)mutableCopyWithZone:(NSZone *)zone
//{
//    PersonBasicInfoModel *obj = [[[self class] allocWithZone:zone] init];
//    obj.resumeId = [self.resumeId mutableCopy];
//    obj.name = [self.name mutableCopy];
//    obj.age = [self.age mutableCopy];
//    obj.birthday = [self.birthday mutableCopy];
//    obj.avatar = [self.avatar mutableCopy];
//    
//    obj.gender = [self.gender mutableCopy];
//    obj.genderCode = [self.genderCode mutableCopy];
//    obj.qulification = [self.qulification mutableCopy];
//    obj.qulificationCode = [self.qulificationCode mutableCopy];
//    obj.city = [self.city mutableCopy];
//    obj.cityCode = [self.cityCode mutableCopy];
//    obj.workYears = [self.workYears mutableCopy];
//    obj.workYearsCode = [self.workYearsCode mutableCopy];
//    obj.marriage = [self.marriage mutableCopy];
//    obj.marriageCode = [self.marriageCode mutableCopy];
//    
//    obj.household = [self.household mutableCopy];
//    obj.household_code = [self.household_code mutableCopy];
//    obj.political = [self.political mutableCopy];
//    obj.workNature = [self.workNature mutableCopy];
//    obj.workNatureCode = [self.workNatureCode mutableCopy];
//    
//    obj.tel = [self.tel mutableCopy];
//    obj.email = [self.email mutableCopy];
//    obj.IDNum = [self.IDNum mutableCopy];
//    
//    obj.updated_at = [self.updated_at mutableCopy];
//    return obj;
//}
@end
