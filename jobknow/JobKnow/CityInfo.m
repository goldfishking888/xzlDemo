//
//  CityInfo.m
//  JobKnow
//
//  Created by faxin sun on 13-3-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "CityInfo.h"
@implementation CityInfo
+ (CityInfo *)standerDefault
{
    static CityInfo *cityInfo = nil;
    if (cityInfo == nil) {
        cityInfo = [[CityInfo alloc] init];
    }
    return cityInfo;
}
@end
