//
//  XZLCodeFileTool.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/23.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "XZLCodeFileTool.h"
#define SALARY @"file_salary"
#define WORKYEAR @"file_workyear"
#define COMPANYCROP @"file_companycrop"
#define COMPANYSIZE @"file_companysize"
#define MARRIAGE @"file_marriage"
#define DEGREE @"file_degree"
#define WORKCROP @"file_workcrop"
#define NOWSTATUS @"file_nowstatus"
#define COMPLAIN @"file_complain"

#define CODE_VERSION @"dic_CODE_VERSION"

#import "CodeVersionModel.h"

@implementation XZLCodeFileTool

#pragma mark-初始时将本地文件读取的code存入userdefault
+(void)resetAllCode{
    [mUserDefaults setValue:[self getSalaryArray] forKey:SALARY];
    [mUserDefaults setValue:[self getWorkYears] forKey:WORKYEAR];
    [mUserDefaults setValue:[self getCompanyNature] forKey:COMPANYCROP];
    [mUserDefaults setValue:[self getCompanySize] forKey:COMPANYSIZE];
    [mUserDefaults setValue:[self getMarriage] forKey:MARRIAGE];
    [mUserDefaults setValue:[self getXueli] forKey:DEGREE];
    [mUserDefaults setValue:[self getWorkCrop] forKey:WORKCROP];
    [mUserDefaults setValue:[self getNowStatus] forKey:NOWSTATUS];
    [mUserDefaults setValue:[self getComplain] forKey:COMPLAIN];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"salary",@"1",@"work_year",@"1",@"company_crop",@"1",@"company_size",@"1",@"marriage",@"1",@"degree",@"1",@"work_crop",@"1",@"now_status",@"1",@"position_complain", nil];
    [mUserDefaults setObject:dic forKey:CODE_VERSION];
    
    NSDictionary *dic2 = [mUserDefaults objectForKey:CODE_VERSION];
    NSLog(@"%@",dic2);
    NSLog(@"%@",dic2);
}

#pragma mark-从

+(void)setSalaryCodeFileWithArray:(NSMutableArray *)array{
    [mUserDefaults setValue:array forKey:SALARY];
    
    NSMutableArray *array_s = [mUserDefaults valueForKey:SALARY];
    NSLog(@"\arrayS = \n%@",array_s);
}

+ (void)checkCodeVersions{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/code/versions"];
    [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                
                CodeVersionModel *model = [CodeVersionModel modelWithDic:dataDic];
                NSMutableDictionary *dic_local = [[mUserDefaults objectForKey:CODE_VERSION] mutableCopy];
                CodeVersionModel *model_local = [CodeVersionModel modelWithDic:dic_local];
                if (![model.company_size isEqualToString:model_local.company_size]) {
                    [dic_local setValue:model.company_size forKey:@"company_size"];
                    [self downloadCode:COMPANYSIZE WithModelToSave:dic_local];
                }else if (![model.company_crop isEqualToString:model_local.company_crop]) {
                    [dic_local setValue:model.company_size forKey:@"company_crop"];
                    [self downloadCode:COMPANYCROP WithModelToSave:dic_local];
                }else if (![model.salary isEqualToString:model_local.salary]) {
                    [dic_local setValue:model.company_size forKey:@"salary"];
                    [self downloadCode:SALARY WithModelToSave:dic_local];
                }else if (![model.work_year isEqualToString:model_local.work_year]) {
                    [dic_local setValue:model.work_year forKey:@"work_year"];
                    [self downloadCode:WORKYEAR WithModelToSave:dic_local];
                }else if (![model.marriage isEqualToString:model_local.marriage]) {
                    [dic_local setValue:model.marriage forKey:@"marriage"];
                    [self downloadCode:MARRIAGE WithModelToSave:dic_local];
                }else if (![model.degree isEqualToString:model_local.degree]) {
                    [dic_local setValue:model.degree forKey:@"degree"];
                    [self downloadCode:DEGREE WithModelToSave:dic_local];
                }else if (![model.work_crop isEqualToString:model_local.work_crop]) {
                    [dic_local setValue:model.work_crop forKey:@"work_crop"];
                    [self downloadCode:WORKCROP WithModelToSave:dic_local];
                }else if (![model.now_status isEqualToString:model_local.now_status]) {
                    [dic_local setValue:model.company_size forKey:@"now_status"];
                    [self downloadCode:NOWSTATUS WithModelToSave:dic_local];
                }else if (![model.position_complain isEqualToString:model_local.position_complain]) {
                    [dic_local setValue:model.position_complain forKey:@"position_complain"];
                    [self downloadCode:COMPLAIN WithModelToSave:dic_local];
                }
                
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        
    }];
    
}


+ (void)downloadCode:(NSString *)codeString WithModelToSave:(NSDictionary *)dic{
    NSString *str = @"";
    if ([codeString isEqualToString:COMPANYSIZE]) {
        str = @"/api/code/company_size";
    }else if ([codeString isEqualToString:WORKYEAR]) {
        str = @"/api/code/work_years";
    }else if ([codeString isEqualToString:SALARY]) {
        str = @"/api/code/salary";
    }else if ([codeString isEqualToString:MARRIAGE]) {
        str = @"/api/code/marriage";
    }else if ([codeString isEqualToString:COMPANYCROP]) {
        str = @"/api/code/company_crop";
    }else if ([codeString isEqualToString:DEGREE]) {
        str = @"/api/code/degree";
    }else if ([codeString isEqualToString:WORKCROP]) {
        str = @"/api/code/work_crop";
    }else if ([codeString isEqualToString:NOWSTATUS]) {
        str = @"/api/code/now_status";
    }else if ([codeString isEqualToString:COMPLAIN]) {
        str = @"/api/code/position/complain";
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,str];
    [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                NSMutableArray *arrayKeys = [self bubbleSort:[NSMutableArray arrayWithArray:[dataDic allKeys]]];
                if ([codeString isEqualToString:COMPANYCROP]) {
                    arrayKeys = [self addZero:arrayKeys];
                }
                
                NSMutableArray *array = [NSMutableArray new];
                for (NSString *key in arrayKeys) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"id",[dataDic valueForKey:key],@"name", nil];
                    [array addObject:dic];
                }
//                [XZLCodeFileTool setSalaryCodeFileWithArray:array];
                [mUserDefaults setValue:array forKey:codeString];
                [mUserDefaults setValue:dic forKey:CODE_VERSION];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        
    }];
    
}



#pragma - mark 冒泡排序
+ (NSMutableArray *)bubbleSort:(NSMutableArray *)array
{
    BOOL isStr = false;;
    NSMutableArray *arrayNum = [NSMutableArray new];
    if ([array[0] isKindOfClass:[NSString class]]) {
        isStr = YES;
        for (NSString *item in array) {
            NSNumber *num = @([item integerValue]);
            [arrayNum addObject:num];
        }
        array = arrayNum;
    }
    
    if(array == nil || array.count == 0){
        return nil;
    }
    
    for (int i = 1; i < array.count; i++) {
        for (int j = 0; j < array.count - i; j++) {
            if ([array[j] compare:array[j+1]] == NSOrderedDescending) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
            
//            printf("排序中:");
        }
    }
    if (isStr) {
        NSMutableArray *arrayStr = [NSMutableArray new];
        for (NSNumber *item in array) {
            NSString *str = [NSString stringWithFormat:@"%@",item];
            [arrayStr addObject:str];
        }
        return arrayStr;
    }
    return array;
    
}

+(NSMutableArray *)addZero:(NSArray *)array{
    NSMutableArray *arrayWithZero = [NSMutableArray new];
    for (NSString *item in array) {
        if (item.length == 1) {
            NSString *newItem = [NSString stringWithFormat:@"0%@",item];
            [arrayWithZero addObject:newItem];
        }else{
            [arrayWithZero addObject:item];
        }
    }
    return arrayWithZero;
}

#pragma mark -从本地json文件读取
+(NSMutableArray *)getSalaryArray{

    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"salary" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    
    return jsonArray;
}

+(NSMutableArray *)getXueli{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"xueli" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
   
    return jsonArray;
}

+(NSMutableArray *)getWorkYears{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"workyears" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    return jsonArray;
}

+(NSMutableArray *)getNowStatus{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"now_status" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
       return jsonArray;
}

+(NSMutableArray *)getMarriage{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"marriage" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
       return jsonArray;
}

+(NSMutableArray *)getCompanyNature{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"company_nature" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    return jsonArray;
}

+(NSMutableArray *)getCompanySize{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"company_size" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    return jsonArray;
}

+(NSMutableArray *)getWorkCrop{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"work_crop" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    return jsonArray;
}

+(NSMutableArray *)getComplain{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"complain" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    return jsonArray;
}


@end
