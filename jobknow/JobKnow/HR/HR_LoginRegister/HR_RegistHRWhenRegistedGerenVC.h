//
//  HR_RegistHRWhenRegistedGerenVC.h
//  JobKnow
//
//  Created by Suny on 15/8/19.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HRregistChooseTradeVC.h"

@interface HR_RegistHRWhenRegistedGerenVC : BaseViewController<UITextFieldDelegate,SendRequest,ASIHTTPRequestDelegate>
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

@property(nonatomic,strong)UITextField *inviteCodeField;

@property(nonatomic,strong)NetWorkConnection *net;

@end
