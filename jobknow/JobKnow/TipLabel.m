//
//  TipLabel.m
//  JobKnow
//
//  Created by Apple on 14-8-6.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "TipLabel.h"

@implementation TipLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
       
    }
    
    return self;
}

- (void)setLabelPattern:(UIImage *)image  AndFrame:(CGRect)frame  AndText:(NSString *)textStr
{
    self.backgroundColor=[UIColor clearColor];
 
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=frame;
    [self addSubview:imageView];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,0,iPhone_width-30,40)];
    subLabel.numberOfLines=2;
    subLabel.text=textStr;
    subLabel.textColor=[UIColor grayColor];
    subLabel.font=[UIFont systemFontOfSize:13];
    subLabel.textAlignment=NSTextAlignmentLeft;
    subLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:subLabel];
}

@end
