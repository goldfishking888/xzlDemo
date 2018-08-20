//
//  GRResumeSelfIntroEditViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "SelfIntroModel.h"
@interface GRResumeSelfIntroEditViewController : BaseViewController<UITextViewDelegate>{
    UITextView *placeholderLabel;
    UITextView *tv_content;
    UIView *view_bottom;
    UILabel *label_count;
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong) SelfIntroModel *model;

@end
