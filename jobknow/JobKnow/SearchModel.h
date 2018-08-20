//
//  SearchModel.h
//  JobKnow

//  Created by Apple on 14-3-26.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityCode;

@property(nonatomic,strong)NSString *industry;
@property(nonatomic,strong)NSString *industryCode;

@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *positionCode;

@property(nonatomic,strong)NSString *salary;
@property(nonatomic,strong)NSString *salaryCode;

@property(nonatomic,strong)NSString *jobType;
@property(nonatomic,strong)NSString *jobTypeCode;

@property(nonatomic,strong)NSString *education;
@property(nonatomic,strong)NSString *educationCode;

@property(nonatomic,strong)NSString *experience;
@property(nonatomic,strong)NSString *experienceCode;

@property(nonatomic,strong)NSString *workYear;
@property(nonatomic,strong)NSString *workYearCode;

@property(nonatomic,strong)NSString *nature;
@property(nonatomic,strong)NSString *natureCode;

@property(nonatomic,strong)NSString *keyWord;

@end