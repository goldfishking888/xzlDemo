//
//  GRBookerModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRBookerModel.h"

@implementation GRBookerModel

// dic => model
+ (GRBookerModel *)getBookerModelWithDic:(NSDictionary*)dic{
    
    GRBookerModel *model = [[GRBookerModel alloc] init];
    model.bookId = dic[@"id"];
    // 设置pk是必须的
    model.pk = [model getPkWithParamName:@"bookId" paramValue:[NSString stringWithFormat:@"%@",dic[@"id"]]];
    model.bookPostName = dic[@"position_name"];
    
    model.bookIndustryCode = [NSString stringWithFormat:@"%@",dic[@"trade"]];
    model.bookIndustryName = [XZLUtil getIndustryNameWithCode:model.bookIndustryCode];
    
    model.bookLocationCode = [NSString stringWithFormat:@"%@",dic[@"area"]];
    model.bookLocationName = [XZLUtil getCityNameWithCityCode:model.bookLocationCode];
    
    model.bookSalaryCode = [NSString stringWithFormat:@"%@",dic[@"salary"]];
    model.bookSalaryName = [XZLUtil getSalaryRangeWithSalaryCode:model.bookSalaryCode];
    
    model.bookTodayData = [NSString stringWithFormat:@"%@",dic[@"today_total"]];
    model.bookTotalData = [NSString stringWithFormat:@"%@",dic[@"total"]];
    model.bookDateCreated = [NSString stringWithFormat:@"%@",dic[@"created_at"]];
    model.bookDateUpdated = [NSString stringWithFormat:@"%@",dic[@"updated_at"]];
    model.recount = [NSString stringWithFormat:@"%@",dic[@"recount"]];
    return model;
}

+ (NSArray *)transients{
    return [NSArray array];
}


@end
