//
//  LoadView.m
//  JobKnow
//
//  Created by faxin sun on 13-5-22.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.frame = CGRectMake(25, 25, 50, 50);
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        blackView.center = self.center;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 80, 50, 20)];
        label.text = @"加载中...";
        [blackView addSubview:_activityView];
        [self addSubview:_activityView];
        self.alpha = 0;
    }
    return self;
}

- (void)show
{
    self.alpha = 1;
    [_activityView startAnimating];
}

- (void)hidden
{
    self.alpha = 0 ;
    [_activityView stopAnimating];
}


@end
