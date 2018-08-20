//
//  CityDetailModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "CityDetailModel.h"

@implementation CityDetailModel

+ (CityDetailModel *)ModelWithDic:(NSDictionary*)dic{
    
    CityDetailModel *model = [[CityDetailModel alloc] init];
    model.city = dic[@"city"];
    model.letter = dic[@"letter"];
    model.code = dic[@"code"];
    return model;
}

@end
