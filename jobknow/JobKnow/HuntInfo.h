//
//  HuntInfo.h
//  JobsGather
//
//  Created by faxin sun on 13-1-23.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuntInfo : NSObject
@property (nonatomic,strong) NSString *h_id;
@property (nonatomic,strong) NSString *jobName;
@property (nonatomic,strong) NSString *workArea;
@property (nonatomic,strong) NSString *cName;
@property (nonatomic,strong) NSString *updateDate;
@property (nonatomic,strong) NSString *isFav;
@property (nonatomic,strong) NSString *isRead;
@property (nonatomic,strong) NSString *cityName;
@end
