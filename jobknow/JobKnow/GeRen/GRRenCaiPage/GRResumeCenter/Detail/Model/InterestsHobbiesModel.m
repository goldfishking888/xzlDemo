//
//  InterestsHobbiesModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "InterestsHobbiesModel.h"

@implementation InterestsHobbiesModel
- (id)init
{
    if (self = [super init])
    {
        self.content = @"";
        self.resumeId = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.content = [NSString stringWithFormat:@"%@",dic[@"interests"]];
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    InterestsHobbiesModel *obj = [[[self class] allocWithZone:zone] init];
    obj.content = [self.content copy];
    obj.resumeId = [self.resumeId copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    InterestsHobbiesModel *obj = [[[self class] allocWithZone:zone] init];
    obj.content = [self.content mutableCopy];
    obj.resumeId = [self.resumeId mutableCopy];
    return obj;
}
@end
