//
//  UIView+FrameCategory.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameCategory)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end
