//
//  HR_ResumeText.h
//  JobKnow
//
//  Created by Suny on 15/8/7.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HR_ResumeTextDelegate<NSObject>
//简历基本信息修改后需要reset简历详情的model
- (void)resetRusumeTextWithString:(NSString *)text;


@end

@interface HR_ResumeText : UIViewController<UITextViewDelegate>
{
    NSInteger num;
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    
    UILabel *label_placeholder;
    
    UITextView *tv_content;

}

@property (nonatomic,assign) id<HR_ResumeTextDelegate> delegate;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *content;

@end
