//
//  FindPassWordViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-1.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum requestFindPwd
{
    requestCheckNum,
    requestGetNum
}requestNum;

@interface FindPassWordViewController : BaseViewController <SendRequest,UITextFieldDelegate>
{
    NSInteger num;
    
    requestNum item;
    
    NSString *phoneNum;
    NSString *tipString;
    
    NSTimer *timer;
    NSArray *tableArray;
    NSMutableArray *emailArray;
    
    UIButton *sendBtn;
    UIButton *findBtn; //找回按钮
    UITextField *insertWordField;
    
    UITableView *tableView;
    UIAlertView *alertView;
    UIScrollView *scrollView;
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
}

@end
