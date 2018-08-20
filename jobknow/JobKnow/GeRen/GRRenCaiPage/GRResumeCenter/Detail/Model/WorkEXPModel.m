//
//  WorkEXPModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "WorkEXPModel.h"

@implementation WorkEXPModel

//@property (copy,nonatomic) NSString *company;
//@property (copy,nonatomic) NSString *position;
//@property (copy,nonatomic) NSString *date_start;
//@property (copy,nonatomic) NSString *date_end;
//@property (copy,nonatomic) NSString *industry;
//@property (copy,nonatomic) NSString *industry_code;
//@property (copy,nonatomic) NSString *company_nature;
//@property (copy,nonatomic) NSString *company_nature_code;
//@property (copy,nonatomic) NSString *company_scale;
//@property (copy,nonatomic) NSString *company_scale_code;
//@property (copy,nonatomic) NSString *work_intro;
- (id)init
{
    if (self = [super init])
    {
        self.workEXP_Id = @"";
        self.resumeId = @"";
        self.company = @"";
        self.position = @"";
        self.position_code = @"";
        self.date_start = @"";
        self.date_end = @"";
        self.industry = @"";
        self.industry_code = @"";
        self.company_nature = @"";
        self.company_nature_code = @"";
        self.company_scale = @"";
        self.company_scale_code = @"";
        self.salary = @"";
        self.salary_code = @"";
        self.work_intro = @""; 
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.workEXP_Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"rid"]];
        self.company = [NSString stringWithFormat:@"%@",dic[@"company"]];
        self.position = [NSString stringWithFormat:@"%@",dic[@"job"]];
        self.position_code = [NSString stringWithFormat:@"%@",dic[@"job_code"]];
        self.date_start = [NSString stringWithFormat:@"%@",dic[@"start_at"]];
        self.date_start = [self.date_start stringWithoutRi];
        self.date_end = [NSString stringWithFormat:@"%@",dic[@"end_at"]];
        self.date_end = [self.date_end stringWithoutRi];
        self.industry = [self getIndustryTransformedString:dic[@"trade_code"] isCode:NO];;
        self.industry_code = [self getIndustryTransformedString:dic[@"trade_code"] isCode:YES];
        self.company_nature = [NSString stringWithFormat:@"%@",dic[@"type"]];
        self.company_nature_code = [XZLUtil getCompanyCorpCodeWithCompanyCorp:self.company_nature];//企业性质code并未返回
        self.company_scale = [NSString stringWithFormat:@"%@",dic[@"size"]];
        self.company_scale_code = [XZLUtil getCompanySizeCodeWithCompanySize:self.company_scale];//企业规模code并未返回
        self.salary = [NSString stringWithFormat:@"%@",dic[@"salary"]];
        self.salary_code = [NSString stringWithFormat:@"%@",dic[@"salary_code"]];
        self.work_intro = [NSString stringWithFormat:@"%@",dic[@"describe"]];
    }
    return self;
}

-(NSString *)getIndustryTransformedString:(NSString *)codeString isCode:(BOOL)isCode{

    if ([NSString isNullOrEmpty:codeString]) {
        return @"";
    }
    NSArray *array = [codeString componentsSeparatedByString:@","];
    NSMutableArray *arrayNew = [NSMutableArray new];
    for (NSString *num in array) {
        NSNumber *nums = [[[NSNumberFormatter alloc] init] numberFromString:num];
        NSString *numNew = [NSString stringWithFormat:@"%d",(nums.intValue/100)*100];
        [arrayNew addObject:numNew];
    }
    
    NSMutableDictionary *dica = [NSMutableDictionary new];
    
    for (NSString *str in arrayNew) {
        [dica setValue:str forKey:str];
    }
    
    array = [XZLCodeFileTool bubbleSort:[NSMutableArray arrayWithArray:[dica allKeys]]];
    NSString *strCode = @"";
    NSString *strName = @"";
    for (NSString *code in array) {
        NSString *tempName = [XZLUtil getIndustryNameWithCode:code];
        strName = [strName stringByAppendingString:[NSString stringWithFormat:@",%@",tempName]];
        strCode = [strCode stringByAppendingString:[NSString stringWithFormat:@",%@",code]];
        
    }
    if ([strName hasPrefix:@","]) {
        strName = [strName substringFromIndex:1];
    }
    
    if ([strCode hasPrefix:@","]) {
        strCode = [strCode substringFromIndex:1];
    }
    if (isCode) {
        return strCode;
    }else{
        return strName;
        
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    WorkEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.workEXP_Id = [self.workEXP_Id copy];
    obj.resumeId = [self.resumeId copy];
    obj.company = [self.company copy];
    obj.position = [self.position copy];
    obj.position_code = [self.position_code copy];
    obj.date_start = [self.date_start copy];
    obj.date_end = [self.date_end copy];
    obj.industry = [self.industry copy];
    obj.industry_code = [self.industry_code copy];
    obj.company_nature = [self.company_nature copy];
    obj.company_nature_code = [self.company_nature_code copy];
    obj.company_scale = [self.company_scale copy];
    obj.company_scale_code = [self.company_scale_code copy];
    obj.salary = [self.salary copy];
    obj.salary_code = [self.salary_code copy];
    obj.work_intro = [self.work_intro copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WorkEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.workEXP_Id = [self.workEXP_Id mutableCopy];
    obj.resumeId = [self.resumeId mutableCopy];
    obj.company = [self.company mutableCopy];
    obj.position = [self.position mutableCopy];
    obj.position_code = [self.position_code mutableCopy];
    obj.date_start = [self.date_start mutableCopy];
    obj.date_end = [self.date_end mutableCopy];
    obj.industry = [self.industry mutableCopy];
    obj.industry_code = [self.industry_code mutableCopy];
    obj.company_nature = [self.company_nature mutableCopy];
    obj.company_nature_code = [self.company_nature_code mutableCopy];
    obj.company_scale = [self.company_scale mutableCopy];
    obj.company_scale_code = [self.company_scale_code mutableCopy];
    obj.salary = [self.salary mutableCopy];
    obj.salary_code = [self.salary_code mutableCopy];
    obj.work_intro = [self.work_intro mutableCopy];
    return obj;
}

@end
