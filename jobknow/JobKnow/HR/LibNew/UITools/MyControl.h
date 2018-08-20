//
//  MyControl.h
//  LimitFreeProject
//
//  Created by zhangcheng on 14-9-25.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyControl : NSObject
//View
+(UIView*)createViewWithFrame:(CGRect)frame;
//ImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName;
//UIButton
+(UIButton*)createButtonFrame:(CGRect)frame bgImageName:(NSString*)bgImageName image:(NSString*)imageName title:(NSString*)title method:(SEL)method target:(id)target;
//Label
+(UILabel*)createLableFrame:(CGRect)frame font:(float)font title:(NSString*)title;
//返回导航高度
+(float)isIOS7;


@end
