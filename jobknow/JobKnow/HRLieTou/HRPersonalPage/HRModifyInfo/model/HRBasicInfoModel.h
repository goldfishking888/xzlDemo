//
//  HRBasicInfoModel.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/30.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRBasicInfoModel : NSObject//<NSCopying, NSMutableCopying>

//@property (copy,nonatomic) NSString *resumeId;
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *city;
@property (copy,nonatomic) NSString *cityCode;
@property (copy,nonatomic) NSString *company;
@property (copy,nonatomic) NSString *industry_name;//行业
@property (copy,nonatomic) NSString *industry_code;//行业code
@property (copy,nonatomic) NSString *occupation;
@property (copy,nonatomic) NSString *mobile;
@property (copy,nonatomic) NSString *telphone;
@property (copy,nonatomic) NSString *email;
@property (copy,nonatomic) NSString *wechat;
@property (copy,nonatomic) NSString *qq;
@end
