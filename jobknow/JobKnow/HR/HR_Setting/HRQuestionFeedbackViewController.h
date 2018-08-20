//
//  HRQuestionFeedbackViewController.h
//  JobKnow
//
//  Created by Suny on 15/8/16.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
//声明一个协议
@protocol BackColor02 <NSObject>
@optional
-(void)changeColur02;
@end
@interface HRQuestionFeedbackViewController : BaseViewController<UITextViewDelegate,UITextFieldDelegate,SendRequest,UIActionSheetDelegate>
{
    
    UIScrollView *scrollView;
    UIImageView *tableViewImage;
    UIImageView *tableViewImage1;
    UIImageView *tableViewImage2;
    UIView *tchuView;
    NSUserDefaults *myUser;
    OLGhostAlertView *olalterView;
}
@property (nonatomic, retain)UITextView *textView;
@property (nonatomic,retain)UITextField *textField;
@property (nonatomic,retain)UITextField *textField2;
@property (nonatomic,retain)UIScrollView *scrollView;
@property (nonatomic,retain)NSArray *textFields ;
@property (nonatomic ,assign)id<BackColor02>deleat;

@end
