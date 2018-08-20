//
//  yulanViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface yulanViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    
    OLGhostAlertView *ghostView;
    
    MBProgressHUD *loadView;

    
}
@end
