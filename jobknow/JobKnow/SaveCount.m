//
//  SaveCount.m
//  JobKnow
//
//  Created by faxin sun on 13-4-27.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "SaveCount.h"

@implementation SaveCount

+ (SaveCount *)standerDefault
{
    static SaveCount *save = nil;
    if (save == nil) {
        save = [[SaveCount alloc] init];
        save.cityAllJob = @"0";
        save.addjob = @"0";
        save.readers = 1;
        save.zpCount = @"0";
        save.readerCount = @"0";
        save.souceCount = @"42";
        save.change = NO;
        save.bookCity = @"";
    }
    return save;
}

@end
