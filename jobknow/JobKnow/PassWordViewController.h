//
//  PassWordViewController.h
//  JobKnow
//
//  Created by Zuo on 14-1-13.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@interface PassWordViewController : BaseViewController<UITextFieldDelegate,SendRequest,ASIHTTPRequestDelegate>
{
    int num ;
    
    UIButton *loginBtn;
    
    NSString *tipString;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
}

@property(nonatomic,strong)NSString *userStr;

@property(nonatomic,strong)NSString *myType;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UITextField *passwordField2;

@property(nonatomic,strong)NetWorkConnection *net;
@end