//
//  HRResumeInfoModel.h
//  JobKnow
//
//  Created by Suny on 15/8/6.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRResumeInfo_Base_Model.h"

@interface HRResumeInfoModel : NSObject

//@property (copy,nonatomic) NSString *attach;

@property (strong,nonatomic) HRResumeInfo_Base_Model *base;

@property (copy,nonatomic) NSString *Id;

@property (copy,nonatomic) NSString *introduction;

@property (copy,nonatomic) NSString *is_visible;

@property (copy,nonatomic) NSString *perfectInfo;

@property (copy,nonatomic) NSString *pid;

@property (copy,nonatomic) NSString *resumePrice;

@property (copy,nonatomic) NSString *uid;

@property (copy,nonatomic) NSString *userResumeUrl;

@end
