//
//  GRBookerAndCityInfo.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/21.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRBookerModel.h"
#import "GRCityInfoNumsModel.h"
@interface GRBookerAndCityInfo : NSObject
@property (nonatomic, strong) GRBookerModel *model_booker;
@property (nonatomic, strong) GRCityInfoNumsModel *model_cityInfo;

+ (GRBookerAndCityInfo *)standerDefault;
@end
