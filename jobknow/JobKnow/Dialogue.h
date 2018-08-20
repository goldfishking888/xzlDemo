//
//  Dialogue.h
//  JobKnow
//
//  Created by faxin sun on 13-4-19.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dialogue : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIButton *sendBtn;//发送按钮
@property (nonatomic, strong) UIImageView *inputbg;
@property (nonatomic, strong) UITextView *textView;//输入框
@property (nonatomic, strong) UIImageView *backgroundImage;//背景图片
@property (nonatomic, strong) UIButton *toolBtn;

@end
