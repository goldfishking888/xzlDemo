//
//  JobOrientationModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "JobOrientationModel.h"
#import "GRReadModel.h"

@implementation JobOrientationModel
//@property (copy,nonatomic) NSString *expect_job;
//@property (copy,nonatomic) NSString *expect_job_code;
//@property (copy,nonatomic) NSString *expect_industry;
//@property (copy,nonatomic) NSString *expect_industry_code;
//@property (copy,nonatomic) NSString *expect_city;
//@property (copy,nonatomic) NSString *expect_city_code;
//@property (copy,nonatomic) NSString *expect_salary;
//@property (copy,nonatomic) NSString *expect_salary_code;
//@property (copy,nonatomic) NSString *status;
//@property (copy,nonatomic) NSString *status_code;
- (id)init
{
    if (self = [super init]){
        self.resumeId = @"";
        self.expect_job = @"";
        self.expect_job_code = @"";
        self.expect_industry = @"";
        self.expect_industry_code = @"";
        self.expect_city = @"";
        self.expect_city_code = @"";
        self.expect_salary = @"";
        self.expect_salary_code = @"";
        self.status = @"";
        self.status_code = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    
    if (self) {
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        
        
        self.expect_job_code = [self getTransformedString:dic[@"hope_job"] isCode:YES];
        self.expect_job = [self getTransformedString:dic[@"hope_job"] isCode:NO];
        self.expect_industry_code = [self getIndustryTransformedString:dic[@"hope_trade"] isCode:YES];
        self.expect_industry = [self getIndustryTransformedString:dic[@"hope_trade"] isCode:NO];
        
        self.expect_city = [self getFormedStringWithDic:dic[@"hope_area"] isName:YES];
        self.expect_city = [self.expect_city stringWithoutShi];
        self.expect_city_code = [self getFormedStringWithDic:dic[@"hope_area"] isName:NO];
        self.expect_salary = [NSString stringWithFormat:@"%@",dic[@"hope_salary"]];
        self.expect_salary_code = [NSString stringWithFormat:@"%@",dic[@"hope_salary_code"]];
        self.status_code = [NSString stringWithFormat:@"%@",dic[@"now_status"]];
        self.status = [XZLUtil getNowStatusWithNowStatusCode:self.status_code];
        
        
    }
    
    return self;
}

-(NSString *)getTransformedString:(NSDictionary *)dic isCode:(BOOL)isCode{
    if ([dic isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (!dic) {
        return @"";
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSNumber *num in [dic allKeys]) {
        NSString *numNew = [NSString stringWithFormat:@"%d",(num.intValue/100)*100];
        [array addObject:numNew];
    }
    
    NSMutableDictionary *dica = [NSMutableDictionary new];
    
    for (NSString *str in array) {
        [dica setValue:str forKey:str];
    }
    
    array = [XZLCodeFileTool bubbleSort:[NSMutableArray arrayWithArray:[dica allKeys]]];
    NSString *strCode = @"";
    NSString *strName = @"";
    for (NSString *code in array) {
        NSString *tempName = [XZLUtil getJobWithJobCode:code];
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

-(NSString *)getIndustryTransformedString:(NSDictionary *)dic isCode:(BOOL)isCode{
    if ([dic isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (!dic) {
        return @"";
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSNumber *num in [dic allKeys]) {
        NSString *numNew = [NSString stringWithFormat:@"%d",(num.intValue/100)*100];
        [array addObject:numNew];
    }
    
    NSMutableDictionary *dica = [NSMutableDictionary new];
    
    for (NSString *str in array) {
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

-(NSString *)getFormedStringWithDic:(NSDictionary *)dic isName:(BOOL)isName {
    id value = dic;
    if ([value isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (!value) {
        return @"";
    }
//    if ([dic allKeys].count>0) {
//        
//    }else{
//       return @"";
//    }
    
    NSMutableArray *array = [self getFormArrayWithDic:dic];
    
    NSString *str = @"";
    if (isName) {
        for (GRReadModel *model in array) {
            str = [NSString stringWithFormat:@"%@,%@",str,model.name];
        }
    }else{
        {
            for (GRReadModel *model in array) {
                str = [NSString stringWithFormat:@"%@,%@",str,model.code];
            }
        }
    }
    if ([str hasPrefix:@","]) {
        str = [str substringFromIndex:1];
    }
    return str;
}

-(NSMutableArray *)getFormArrayWithDic:(NSDictionary *)dic{
    NSMutableArray *array = [NSMutableArray new];
     NSMutableArray *arrayKeys = [XZLCodeFileTool bubbleSort:[NSMutableArray arrayWithArray:[dic allKeys]]];
    for (NSString *key in arrayKeys) {
        
        NSDictionary *dicNew = [NSDictionary dictionaryWithObjectsAndKeys:key,@"id",[dic valueForKey:key],@"name", nil];
        GRReadModel *model = [GRReadModel ModelWithDic:dicNew];
        [array addObject:model];
    }
    return array;
}

- (id)copyWithZone:(NSZone *)zone
{
    JobOrientationModel *obj = [[[self class] allocWithZone:zone] init];
    obj.resumeId = [self.resumeId copy];
    obj.expect_job = [self.expect_job copy];
    obj.expect_job_code = [self.expect_job_code copy];
    obj.expect_industry = [self.expect_industry copy];
    obj.expect_industry_code = [self.expect_industry_code copy];
    obj.expect_city = [self.expect_city copy];
    obj.expect_city_code = [self.expect_city_code copy];
    obj.expect_salary = [self.expect_salary copy];
    obj.expect_salary_code = [self.expect_salary_code copy];
    obj.status = [self.status copy];
    obj.status_code = [self.status_code copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    JobOrientationModel *obj = [[[self class] allocWithZone:zone] init];
    obj.resumeId = [self.resumeId mutableCopy];
    obj.expect_job = [self.expect_job mutableCopy];
    obj.expect_job_code = [self.expect_job_code mutableCopy];
    obj.expect_industry = [self.expect_industry mutableCopy];
    obj.expect_industry_code = [self.expect_industry_code mutableCopy];
    obj.expect_city = [self.expect_city mutableCopy];
    obj.expect_city_code = [self.expect_city_code mutableCopy];
    obj.expect_salary = [self.expect_salary mutableCopy];
    obj.expect_salary_code = [self.expect_salary_code mutableCopy];
    obj.status = [self.status mutableCopy];
    obj.status_code = [self.status_code mutableCopy];
    return obj;
}


@end
