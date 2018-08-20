//
//  HR_ApplyCashWebViewController.h
//  JobKnow
//
//  Created by Suny on 15/12/9.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface HR_ApplyCashWebViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *jumpRequest;//要跳转的链接

@end
