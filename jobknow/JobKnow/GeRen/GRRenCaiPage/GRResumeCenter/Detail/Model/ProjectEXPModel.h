//
//  ProjectEXPModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectEXPModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *project_ID;
@property (copy,nonatomic) NSString *resumeId;

@property (copy,nonatomic) NSString *project_name;
@property (copy,nonatomic) NSString *date_start;
@property (copy,nonatomic) NSString *date_end;
@property (copy,nonatomic) NSString *duty_content;
@property (copy,nonatomic) NSString *project_intro;

@end
