//
//  MyControl.m
//  LimitFreeProject
//
//  Created by yangyang on 14-9-25.
//  Copyright (c) 2014年 yangyang. All rights reserved.
//

#import "MyControl.h"

@implementation MyControl
//View
+(UIView*)createViewWithFrame:(CGRect)frame
{

    UIView*view=[[UIView alloc]initWithFrame:frame];
    
    return view;
}
//ImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    if (imageName) {
        imageView.image=[UIImage imageNamed:imageName];
    }
    //开启用户交互属性
    imageView.userInteractionEnabled=YES;
    return imageView;
}
//UIButton
+(UIButton*)createButtonFrame:(CGRect)frame bgImageName:(NSString*)bgImageName image:(NSString*)imageName title:(NSString*)title method:(SEL)method target:(id)target
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//Label
+(UILabel*)createLableFrame:(CGRect)frame font:(float)font title:(NSString*)title
{

    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.text=title;
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:font];
    return label;
}
+(float)isIOS7{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        return 64;
    }else{
        return 44;
    
    }
}
@end
