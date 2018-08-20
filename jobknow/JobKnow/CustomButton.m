//
//  CustomButton.m
//  JobKnow
//
//  Created by faxin sun on 13-4-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (CustomButton *)customButtonInitWithButtonType:(UIButtonType)type frame:(CGRect)frame title:(NSString *)title fontNum:(NSInteger)font
{
    
    CustomButton *btn =[CustomButton buttonWithType:type];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    
    NSInteger height = [CustomButton buttonWidthWithTitle:title width:frame.size.width font:font];
    
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.numberOfLines =0;

    [btn setTitleColor:RGBA(40, 100, 210, 1) forState:UIControlStateNormal];
    
    if (height< 30) {
        height = 30;
    }
    
    btn.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,height);
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

+ (CustomButton *)customButtonInitWithButtonType2:(UIButtonType)type frame:(CGRect)frame title:(NSString *)title fontNum:(NSInteger)font
{
    CustomButton *btn =[CustomButton buttonWithType:type];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    // [btn.titleLabel setTextColor:[UIColor blueColor]];
    NSInteger heigth = [CustomButton buttonWidthWithTitle:title width:frame.size.width font:font];
    //  heigth = heigth-8;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.numberOfLines = 0;
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    if (heigth< 30) {
        heigth = 30;
        btn.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, heigth);
    }else
    {
        heigth = heigth/16*25;
        btn.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, heigth-5);
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}




+ (NSInteger)buttonWidthWithTitle:(NSString *)title width:(NSInteger)width font:(NSInteger)fontNum
{
    UIFont *font = [UIFont systemFontOfSize:fontNum];
    CGSize autoSize = CGSizeMake(width, MAXFLOAT);
    CGSize size = [title sizeWithFont:font constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
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
