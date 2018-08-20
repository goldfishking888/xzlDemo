//
//  GRReadModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRReadModel.h"

@implementation GRReadModel
+ (GRReadModel *)ModelWithDic:(NSDictionary*)dic{
    
    GRReadModel *model = [[GRReadModel alloc] init];
    model.code = dic[@"id"];
    model.name = dic[@"name"];
    return model;
}
@end
