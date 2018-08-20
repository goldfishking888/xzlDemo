//
//  TrainEXPModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainEXPModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *train_id;
@property (copy,nonatomic) NSString *resumeId;

@property (copy,nonatomic) NSString *train_name;
@property (copy,nonatomic) NSString *date_start;
@property (copy,nonatomic) NSString *date_end;
@property (copy,nonatomic) NSString *train_city;
@property (copy,nonatomic) NSString *train_cer;
@property (copy,nonatomic) NSString *train_intro;

@end
