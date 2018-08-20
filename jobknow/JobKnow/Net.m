//
//  Net.m
//  JobKnow
//
//  Created by faxin sun on 13-5-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "Net.h"

@implementation Net

+ (Net *)standerDefault
{
    static Net *n = nil;
    if (n == nil) {
        n = [[Net alloc] init];
        n.status = ReachableViaWiFi;
    }
    return n;
}

@end
