//
//  EduEXPModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EduEXPModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *EDUExp_Id;
@property (copy,nonatomic) NSString *resumeId;

@property (copy,nonatomic) NSString *university;
@property (copy,nonatomic) NSString *date_start;
@property (copy,nonatomic) NSString *date_end;
@property (copy,nonatomic) NSString *major;
@property (copy,nonatomic) NSString *major_code;
@property (copy,nonatomic) NSString *degree;
@property (copy,nonatomic) NSString *degree_code;

@end
