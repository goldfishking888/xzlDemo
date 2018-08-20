//
//  GRResumeInterestEditViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "InterestsHobbiesModel.h"


@interface GRResumeInterestEditViewController : BaseViewController<UITextViewDelegate>{
    UITextView *placeholderLabel;
    UITextView *tv_content;
    UIView *view_bottom;
    UILabel *label_count;
    OLGhostAlertView *ghostView;
}
@property (nonatomic,strong) InterestsHobbiesModel *model;

@end
