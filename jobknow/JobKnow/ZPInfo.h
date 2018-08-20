//
//  ZPInfo.h
//  JobsGather
//
//  Created by faxin sun on 13-1-21.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPInfo : NSObject

@property (nonatomic,strong) NSString *z_id;
@property (nonatomic,strong) NSString *z_title;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *isread;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *week;


 
@property (nonatomic,strong) NSString *descriptionStr;
@property (nonatomic,strong) NSString *pubdate;
@property (nonatomic,strong) NSString *meetingType;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *schoolName;
@property (nonatomic,strong)NSString *schoolRead;
@property (nonatomic ,strong)NSString *sociRead;

//累计才币
@property (nonatomic,strong)NSString *acount;
@property (nonatomic,strong)NSString *from;
@property (nonatomic,strong)NSString *insert_date;
@property (nonatomic,strong)NSString *score;

@end
