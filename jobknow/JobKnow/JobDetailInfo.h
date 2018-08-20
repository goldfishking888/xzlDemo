//
//  JobDetailInfo.h
//  JobKnow
//
//  Created by faxin sun on 13-3-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobInfo.h"
@interface JobDetailInfo : NSObject

@property (nonatomic, strong) JobInfo *info;
@property (nonatomic, copy) NSString *finishDate;
@property (nonatomic, copy) NSString *workExperience;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *connectPerson;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *netAddress;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;


//快捷订阅的信息
@property (nonatomic,copy)NSString *allCount;   //今日新增
@property (nonatomic,copy)NSString *allTotal;   //总数
@property (nonatomic,copy)NSString *areaname;  //城市
@property (nonatomic,copy)NSString *jobsortname;//订阅的职位的名称
@property (nonatomic,copy)NSString *couunt;  //单条今日
@property (nonatomic,copy)NSString *total;   //单条总数
@property (nonatomic,copy)NSString *posatioID; //每条的id
@property (nonatomic,copy)NSString *jobType;



@end
