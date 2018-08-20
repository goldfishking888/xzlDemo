//
//  JobModel.h
//  JobKnow
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobModel : NSObject

@property(nonatomic,assign) NSString *flag;
@property(nonatomic,strong) NSString *bookID;
@property(nonatomic,strong) NSString *positionName;
@property(nonatomic,strong) NSString *industry;
@property(nonatomic,strong) NSString *todayData;
@property(nonatomic,strong) NSString *totalData;
@property(nonatomic,strong) NSString *cityStr;
@property(nonatomic,strong) NSString *cityCodeStr;
@property(nonatomic,strong) NSString *keyWord;
@end
