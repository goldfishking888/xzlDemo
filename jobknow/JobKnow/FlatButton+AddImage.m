//
//  FlatButton+AddImage.m
//  JobKnow
//
//  Created by Apple on 14-7-17.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "FlatButton+AddImage.h"

@implementation FlatButton (AddImage)

- (void)addText:(NSString *)textStr AndImage:(UIImage *)image  AndRect:(CGRect)rect  AndRect2:(CGRect)rect2
{
    UILabel *lab=[[UILabel alloc]initWithFrame:self.bounds];
    lab.backgroundColor=[UIColor clearColor];

    UILabel *textLab=[[UILabel alloc]initWithFrame:rect];
    textLab.backgroundColor=[UIColor clearColor];
    textLab.text=textStr;
    textLab.textColor=[UIColor whiteColor];
    textLab.font=[UIFont fontWithName:@"HiraKakuProN-W3" size:15.0f];
    //textLab.font=[UIFont boldSystemFontOfSize:15.0f];
    [lab addSubview:textLab];

    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.frame=rect2;
    [lab addSubview:imageView];
    
    [self addSubview:lab];
}


@end