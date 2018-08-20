//
//  TipButton.m
//  JobKnow
//
//  Created by Apple on 14-8-6.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "TipButton.h"

@implementation TipButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _isClicked=NO;
        
        _isChoosen=NO;
        
        imageView=[[UIImageView alloc]init];
        
        [self addSubview:imageView];
    
        subLabel=[[UILabel alloc]init];
        
        [self addSubview:subLabel];
        
        self.backgroundColor=[UIColor clearColor];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image AndFrame:(CGRect)frame AndText:(NSString *)textStr AndFrame2:(CGRect)frame2
{
    imageView.image =image;
    imageView.frame=frame;

    subLabel.frame =frame2;
    subLabel.backgroundColor=[UIColor clearColor];
    subLabel.font=[UIFont systemFontOfSize:15];
    subLabel.textColor=[UIColor grayColor];
    subLabel.text=textStr;
}

- (void)setImage2:(UIImage *)image
{
    imageView.image =image;
}

@end