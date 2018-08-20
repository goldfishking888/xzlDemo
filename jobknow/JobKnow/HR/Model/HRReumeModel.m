//
//  HRReumeModel.m
//  JobKnow
//
//  Created by Suny on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRReumeModel.h"

@implementation HRReumeModel
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

//- (void)dealloc
//{
//    [super dealloc];
//}

- (id)copyWithZone:(NSZone *)zone
{
    HRReumeModel *result = [[[self class] allocWithZone:zone] init];
    return result;
}


@end
