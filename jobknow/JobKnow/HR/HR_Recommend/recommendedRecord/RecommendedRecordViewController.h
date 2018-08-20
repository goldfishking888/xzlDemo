//
//  RecommendedRecordViewController.h
//  FreeChat
//
//  Created by WangJinyu on 5/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"

@interface RecommendedRecordViewController :BaseViewController<UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate>
{
    OLGhostAlertView * ghostView;
    BOOL isResumeRec;
    UIButton *btn_menu_left;
    UIButton *btn_menu_right;
    
    UIWebView *_webView;//新改成web界面
    MBProgressHUD *_progressView;

}
@property (nonatomic, strong) NSString *jumpRequest;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@end
