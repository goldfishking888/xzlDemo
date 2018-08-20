//
//  GRBookerAndCityInfo.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/21.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRBookerAndCityInfo.h"

@implementation GRBookerAndCityInfo
+ (GRBookerAndCityInfo *)standerDefault
{
    static GRBookerAndCityInfo *cityInfo = nil;
    if (cityInfo == nil) {
        cityInfo = [[GRBookerAndCityInfo alloc] init];
    }
    return cityInfo;
}
@end
