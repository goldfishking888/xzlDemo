//
//  ActivetView.m
//  JobKnow
//
//  Created by faxin sun on 13-3-14.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ActivetView.h"

@implementation ActivetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:self.activityView];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, frame.size.width - 20,20)];
        _title.backgroundColor = [UIColor clearColor];
        [_title setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_title];
    }
    return self;
}



//显示要加载的文字
- (void)show:(NSString *)text
{
    self.alpha = 1;
    self.title.text = text;
    self.title.textColor=[UIColor grayColor];
    [self.activityView startAnimating];
}
//隐藏菊花
- (void)hidden
{
    self.alpha = 0;
    [self.activityView stopAnimating];
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
