//
//  SoundView.m
//  JobKnow
//
//  Created by faxin sun on 13-5-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "SoundView.h"

@implementation SoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 50, 30)];
        self.sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 30, 30)];
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 100, 30)];
        self.overLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, 100, 30)];
        
        self.overLabel.text = @"松手结束录音";
        self.currentLabel.text = @"正在录音...";
        UIColor *c = [UIColor clearColor];
        //设置背景色
        [self.currentTime setBackgroundColor:c];
        [self.sumLabel setBackgroundColor:c];
        [self.overLabel setBackgroundColor:c];
        [self.currentLabel setBackgroundColor:c];

        
        [self addSubview:self.currentLabel];
        [self addSubview:self.sumLabel];
        [self addSubview:self.currentTime];
        [self addSubview:self.overLabel];

    }
    return self;
}


- (void)startRecord
{
    self.alpha = 1;
}

- (void)stopRecord
{
    self.alpha = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
