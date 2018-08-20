//
//  LanguageLevelModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageLevelModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *l_id;
@property (copy,nonatomic) NSString *resume_id;

@property (copy,nonatomic) NSString *l_name;
@property (copy,nonatomic) NSString *l_level;

@end
