//
//  ZhiFuBaoViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-29.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface ZhiFuBaoViewController : BaseViewController<UIWebViewDelegate>
{
    int num;
 
    UIWebView *_webView;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong)NSURL *URL;

@end