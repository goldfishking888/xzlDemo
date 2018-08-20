//
//  HeadView.m
//  JobKnow
//
//  Created by Apple on 14-3-3.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "HeadView.h"
#import "myButton.h"
@implementation HeadView
@synthesize delegate=_delegate;
@synthesize section,open,backBtn;

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        open=NO;
        
        myButton *btn=[myButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10,0,iPhone_width-20,50);
        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"jianzhiLong.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"jianzhiLongYinying.png"] forState:UIControlStateHighlighted];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15,20,10,10)];
        lab.backgroundColor=RGBA(148,186,187,1);
        [btn addSubview:lab];
        
        [self addSubview:btn];
        self.backBtn = btn;
    }
    
    return self;
}

-(void)doSelected
{
    if (_delegate &&[_delegate respondsToSelector:@selector(selectedWith:)]) {
        [_delegate selectedWith:self];
    }
}
@end
