//
//  LanguageLevelModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LanguageLevelModel.h"

@implementation LanguageLevelModel
- (id)init
{
    if (self = [super init])
    {
        self.l_id = @"";
        self.resume_id = @"";
        self.l_name = @"";
        self.l_level = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.l_id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.resume_id = [NSString stringWithFormat:@"%@",dic[@"rid"]];
        self.l_name = [NSString stringWithFormat:@"%@",dic[@"languages"]];
        self.l_level = [NSString stringWithFormat:@"%@",dic[@"lang_read_write"]];//一般 良好 熟练 精通没有code
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LanguageLevelModel *obj = [[[self class] allocWithZone:zone] init];
    obj.l_id = [self.l_id copy];
    obj.resume_id = [self.resume_id copy];
    obj.l_name = [self.l_name copy];
    obj.l_level = [self.l_level copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    LanguageLevelModel *obj = [[[self class] allocWithZone:zone] init];
    obj.l_id = [self.l_id mutableCopy];
    obj.resume_id = [self.resume_id mutableCopy];
    obj.l_name = [self.l_name mutableCopy];
    obj.l_level = [self.l_level mutableCopy];
    return obj;
}

@end
