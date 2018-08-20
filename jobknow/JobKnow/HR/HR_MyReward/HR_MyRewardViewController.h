//
//  HR_MyRewardViewController.h
//  JobKnow
//
//  Created by Wangjinyu on 10/08/2015.
//  Copyright (c) 2015 Wangjinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HR_MyResumeRecRewardCell.h"
#import "WebViewJavascriptBridge.h"
#import "MyHrFamilyViewController.h"

@interface HR_MyRewardViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate>
{
    OLGhostAlertView * ghostView;
    MBProgressHUD *_progressView;
    UIWebView *_webView;
    BOOL isPersonRecList;
    BOOL isWeb;
    UIButton *btn_menu_web;
    UIButton *btn_menu_left;
    UIButton *btn_menu_right;
    NSString *allow_money;
    UIView *view_NoHrFamily;
    BOOL isHRFamily;
}
@property (nonatomic, strong) NSString *jumpRequest;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;

@end
