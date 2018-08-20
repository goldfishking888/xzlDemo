//
//  TipButton.h
//  JobKnow
//
//  Created by Apple on 14-8-6.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipButton : UIButton
{
    UILabel *subLabel;
    
    UIImageView *imageView;
}

@property (nonatomic,assign)BOOL isClicked;

@property (nonatomic,assign)BOOL isChoosen;

- (void)setImage2:(UIImage *)image;

- (void)setImage:(UIImage *)image AndFrame:(CGRect)frame AndText:(NSString *)textStr AndFrame2:(CGRect)frame2;

@end
