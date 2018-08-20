//
//  GRResumePrivacyModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumePrivacyModel.h"
#import "ResumeShieldCompany.h"

//@property (nonatomic ,copy) NSString *name;// name
//@property (nonatomic ,copy) NSString *nameShow;// name // 0显示1不显示
//@property (nonatomic ,copy) NSString *resumeAvailable; // 简历可见性
//@property (nonatomic ,copy) NSMutableArray *resumeShieldCompanyKeysArray;//屏蔽企业关键字
//@property (nonatomic ,copy) NSString *contactAvailable;// 联系方式可见性
//@property (nonatomic ,copy) NSString *contactTime;// 联系时间
//@property (nonatomic ,copy) NSString *myContactTime;// 自定义联系时间
//@property (nonatomic ,copy) NSString *salary;// 以往薪资

@implementation GRResumePrivacyModel
- (id)init
{
    if (self = [super init])
    {
        self.user_id = @"";
        self.resume_id = @"";
        self.name = @"";
        
        self.nameShow = @"";
        self.resumeAvailable = @"";
        self.resumeShieldCompanyKeysArray = [NSMutableArray new];
        self.contactAvailable = @"";
        self.contactTime = @"0";
        self.myContactTime = @"";
        self.salary = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    
    if (self) {
        NSDictionary *dic_privacy = dic[@"privacySetting"];
        NSMutableArray *arrayCom = [NSMutableArray new];
        for (NSDictionary *item in dic[@"companys"]) {
            ResumeShieldCompany *model = [[ResumeShieldCompany alloc] initWithDictionary:item];
            [arrayCom addObject:model];
        }
        self.name = @"";
        self.user_id = [NSString stringWithFormat:@"%@",dic_privacy[@"user_id"]];
        self.resume_id = [NSString stringWithFormat:@"%@",dic_privacy[@"resume_id"]];
        
        self.nameShow = [NSString stringWithFormat:@"%@",dic_privacy[@"name_visibility"]];
        self.resumeAvailable = [NSString stringWithFormat:@"%@",dic_privacy[@"resume_visibility"]];
        self.resumeShieldCompanyKeysArray = arrayCom;
        self.contactAvailable = [NSString stringWithFormat:@"%@",dic_privacy[@"contact_visibility"]];
        self.myContactTime = [NSString stringWithFormat:@"%@",dic_privacy[@"suggested_contact_time"]];
        self.contactTime = [self.myContactTime isEqualToString:@"随时都可以联系我"]?@"0":@"1";
        if ([self.contactTime isEqualToString:@"0"]) {
            self.myContactTime = @"";
        }
        self.salary = [NSString stringWithFormat:@"%@",dic_privacy[@"past_salary_visibility"]];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    GRResumePrivacyModel *obj = [[[self class] allocWithZone:zone] init];
    obj.user_id = [self.user_id copy];
    obj.resume_id = [self.resume_id copy];
    
    obj.name = [self.name copy];
    
    obj.nameShow = [self.nameShow copy];
    obj.resumeAvailable = [self.resumeAvailable copy];
    obj.resumeShieldCompanyKeysArray = [self.resumeShieldCompanyKeysArray copy];
    obj.contactAvailable = [self.contactAvailable copy];
    obj.contactTime = [self.contactTime copy];
    obj.myContactTime = [self.myContactTime copy];
    obj.salary = [self.salary copy];
    
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    GRResumePrivacyModel *obj = [[[self class] allocWithZone:zone] init];
    obj.user_id = [self.user_id mutableCopy];
    obj.resume_id = [self.resume_id mutableCopy];
    
    obj.name = [self.name mutableCopy];
    
    obj.nameShow = [self.nameShow mutableCopy];
    obj.resumeAvailable = [self.resumeAvailable mutableCopy];
    obj.resumeShieldCompanyKeysArray = [self.resumeShieldCompanyKeysArray mutableCopy];
    obj.contactAvailable = [self.contactAvailable mutableCopy];
    obj.contactTime = [self.contactTime mutableCopy];
    obj.myContactTime = [self.myContactTime mutableCopy];
    obj.salary = [self.salary mutableCopy];
    
    return obj;
}

@end
