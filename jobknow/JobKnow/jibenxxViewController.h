//
//  jibenxxViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "nianxianViewController.h"
#import "leixingViewController.h"
@interface jibenxxViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,chuanzDeleat,chuanlx,UITextFieldDelegate,SendRequest,UIScrollViewDelegate>
{
    UITableView *myTabView;
    UIScrollView *myScrollow;
    NSString *nianxianStr;
    UISwitch *swith;
    NSString *leixingstr;
    UITextField *textField01;
    UITextField *textField02;
    MBProgressHUD *loadView;
    NSString *sexStr;
    NSString *sexCode;
     OLGhostAlertView *alert;
    NSString *tipString;
}
@end
