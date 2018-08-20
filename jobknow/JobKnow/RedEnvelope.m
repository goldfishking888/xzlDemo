//
//  RedEnvelope.m
//  JobKnow
//
//  Created by Apple on 14-7-31.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "RedEnvelope.h"

@implementation RedEnvelope

+ (RedEnvelope *)standerDefault
{
    static RedEnvelope *envelope = nil;

    if (envelope == nil) {
        envelope = [[RedEnvelope alloc] init];
        envelope.isCanUse=YES;
    }
    
    return envelope;
}

@end
