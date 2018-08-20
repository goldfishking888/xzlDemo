//
//  CodeVersionModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/24.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "CodeVersionModel.h"

@implementation CodeVersionModel

+ (CodeVersionModel *)modelWithDic:(NSDictionary*)dic{
    CodeVersionModel *model = [[CodeVersionModel alloc] init];
    model.salary = [NSString stringWithFormat:@"%@",dic[@"salary"]];
    model.work_year = [NSString stringWithFormat:@"%@",dic[@"work_year"]];
    model.company_crop = [NSString stringWithFormat:@"%@",dic[@"company_crop"]];
    model.company_size = [NSString stringWithFormat:@"%@",dic[@"company_size"]];
    model.marriage = [NSString stringWithFormat:@"%@",dic[@"marriage"]];
    model.degree = [NSString stringWithFormat:@"%@",dic[@"degree"]];
    model.work_crop = [NSString stringWithFormat:@"%@",dic[@"work_crop"]];
    model.now_status = [NSString stringWithFormat:@"%@",dic[@"now_status"]];
    model.position_complain = [NSString stringWithFormat:@"%@",dic[@"position_complain"]];
    
    return model;
}

@end
