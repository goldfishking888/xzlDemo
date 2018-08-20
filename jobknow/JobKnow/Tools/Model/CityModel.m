//
//  CityModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

+ (CityModel *)ModelWithDic:(NSDictionary*)dic{
    
    CityModel *model = [[CityModel alloc] init];
    model.letter = dic[@"letter"];
    model.list = dic[@"list"];
    return model;
}
@end
