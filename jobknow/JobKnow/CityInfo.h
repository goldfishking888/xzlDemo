//
//  CityInfo.h
//  JobKnow
//
//  Created by faxin sun on 13-3-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject

@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *com_num;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sourceAll;

+ (CityInfo *)standerDefault;//单例
@end
