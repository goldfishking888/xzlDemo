//
//  peixun2ViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface peixun2ViewController : BaseViewController<UITextFieldDelegate,SendRequest>
{
    UITextField *textField01;
    UITextField *textField02;
    UITextField *textField03;
    UIScrollView *myScrollow;
    MBProgressHUD *loadView;
    OLGhostAlertView * alert;
}
@property (nonatomic,retain)NSString *myId;
@property (nonatomic,retain)NSString *myType;
@property (nonatomic,retain)NSString *wheretr;
@property (nonatomic,retain)NSString *contentr;
@property (nonatomic,retain)NSString *booktr;

@end
