//
//  SaveCount.h
//  JobKnow
//
//  Created by faxin sun on 13-4-27.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveCount : NSObject <SendRequest>
//判断是否走动画（全城职位），以及职位新增数招聘会新增数
@property (nonatomic, copy) NSString *cityAllJob;
@property (nonatomic, copy) NSString *addjob;//新增职位数

@property (nonatomic, assign) NSInteger readers;//是否有订阅器

@property (nonatomic, copy) NSString *readerCount;
@property (nonatomic, copy) NSString *zpCount;//招聘会新增数
@property (nonatomic, copy) NSString *souceCount;//来源数

@property (nonatomic, copy) NSString *deviceToken;//设备的推送token
@property (nonatomic, assign) BOOL change;//订阅器是否发生改变
@property (nonatomic,copy)NSString *bookCity; //订阅器订阅的城市

+ (SaveCount *)standerDefault;
@end
