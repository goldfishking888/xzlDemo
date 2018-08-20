//
//  TestLabel.m
//  JobKnow
//
//  Created by Apple on 14-8-11.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "TestLabel.h"

@implementation TestLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor=[UIColor clearColor];
    }    
    return self;
}

- (void)setDot:(UIImage *)image  andFrame:(CGRect)frame
{
    _dotImageView=[[UIImageView  alloc]initWithImage:image];
    _dotImageView.frame=frame;
    [self addSubview:_dotImageView];
}


- (void)setLabelFrame:(CGRect)frame  AndText:(NSString *)text
{
    _textLabel=[[UILabel alloc]initWithFrame:frame];
 
    _textLabel.text=text;
    
    _textLabel.numberOfLines=2;
    
    _textLabel.backgroundColor=[UIColor whiteColor];
    
    //_textLabel.textAlignment=UITextAlignmentCenter;
    
    _textLabel.textColor=XZhiL_colour;
    
    _textLabel.font=[UIFont systemFontOfSize:13.0f];
    
    [self addSubview:_textLabel];
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