//
//  GRResumePrivacyModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRResumePrivacyModel : NSObject

@property (nonatomic ,copy) NSString *user_id;// 
@property (nonatomic ,copy) NSString *resume_id;//

@property (nonatomic ,copy) NSString *name;// name
@property (nonatomic ,copy) NSString *nameShow;// name // 0显示1不显示
@property (nonatomic ,copy) NSString *resumeAvailable; // 简历可见性
@property (nonatomic ,copy) NSMutableArray *resumeShieldCompanyKeysArray;//屏蔽企业关键字
@property (nonatomic ,copy) NSString *contactAvailable;// 联系方式可见性
@property (nonatomic ,copy) NSString *contactTime;// 联系时间
@property (nonatomic ,copy) NSString *myContactTime;// 自定义联系时间
@property (nonatomic ,copy) NSString *salary;// 以往薪资

@end
