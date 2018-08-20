//
//  SelfIntroModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelfIntroModel.h"

@implementation SelfIntroModel
- (id)init
{
    if (self = [super init])
    {
        self.intro = @"";
        self.resumeId = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.intro = [NSString stringWithFormat:@"%@",dic[@"self_evaluation"]];
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SelfIntroModel *obj = [[[self class] allocWithZone:zone] init];
    obj.intro = [self.intro copy];
    obj.resumeId = [self.resumeId copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    SelfIntroModel *obj = [[[self class] allocWithZone:zone] init];
    obj.intro = [self.intro mutableCopy];
    obj.resumeId = [self.resumeId mutableCopy];
    return obj;
}
@end
