//
//  JobSourceViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobSourceViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    MBProgressHUD *loadView;
}

@end
