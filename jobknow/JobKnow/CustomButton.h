//
//  CustomButton.h
//  JobKnow
//
//  Created by faxin sun on 13-4-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
+(CustomButton *)customButtonInitWithButtonType:(UIButtonType)type frame:(CGRect)frame title:(NSString *)title fontNum:(NSInteger)font;

+(NSInteger)buttonWidthWithTitle:(NSString *)title width:(NSInteger)width font:(NSInteger)fontNum;
@end
