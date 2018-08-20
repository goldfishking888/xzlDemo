//
//  FileButton.h
//  JobKnow
//
//  Created by liuxiaowu on 13-9-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeFile.h"

@interface FileButton : UIView

@property (nonatomic, strong) UIButton *fileBtn;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *bindingView;
@property (nonatomic, assign) BOOL binding;//是否绑定
@property (nonatomic, assign) FileOption option;
@property (nonatomic, assign) NSInteger btnTag;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (id)initWithFrame:(CGRect)frame fileType:(FileOption)option binding:(BOOL)bd resumeFile:(ResumeFile *)file type:(NSString *)myType;



@end
