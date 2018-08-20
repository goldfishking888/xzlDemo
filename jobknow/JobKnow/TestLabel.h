//
//  TestLabel.h
//  JobKnow
//
//  Created by Apple on 14-8-11.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestLabel : UILabel
{
    UIImageView *_dotImageView;

    UIView *_bgView;

    UILabel *_textLabel;
}

- (void)setLabelFrame:(CGRect)frame  AndText:(NSString *)text;

- (void)setDot:(UIImage *)image  andFrame:(CGRect)frame;

@end
