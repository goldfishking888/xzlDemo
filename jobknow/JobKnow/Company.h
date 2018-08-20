//
//  Company.h
//  JobKnow

//  Created by Zuo on 14-1-22.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityInfo.h"
@interface Company : NSObject
@property (nonatomic,strong)NSString *cid;
@property (nonatomic,strong)NSString *cName;
@property (nonatomic,strong)NSString *isBook;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@end
