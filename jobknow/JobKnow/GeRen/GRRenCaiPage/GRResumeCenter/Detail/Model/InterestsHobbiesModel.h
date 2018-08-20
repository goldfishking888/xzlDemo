//
//  InterestsHobbiesModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestsHobbiesModel : NSObject<NSCopying, NSMutableCopying>

@property (copy,nonatomic) NSString *resumeId;
@property (copy,nonatomic) NSString *content;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
