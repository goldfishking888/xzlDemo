//
//  myButton.m
//  JobKnow
//
//  Created by Zuo on 13-12-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "myButton.h"

@implementation myButton
@synthesize isClicked;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isClicked=NO;
    }
    return self;
}

@end
