//
//  UIMenuItem.h
//  TesdXcodeUserGuideDemo
//
//  Created by xd.su on 13-2-19.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIBarButtonItem
// UITabBarItem

@interface UIMenuBarItem : UIControl
{
    NSString    *_title;
    UIImage     *_image;
    id           _target;
    SEL          _action;
    UIControl   *_containView;
    UIImageView *_imageView;
    UILabel     *_titleLabel;
    CGFloat     _sizeValue;
}

@property (nonatomic) SEL action;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, retain) UIControl *containView;
@property (nonatomic, readonly) CGFloat sizeValue;
@property (nonatomic, assign) NSInteger number;
- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action;

@end
