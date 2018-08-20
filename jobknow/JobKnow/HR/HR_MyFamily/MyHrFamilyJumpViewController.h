//
//  MyHrFamilyJumpViewController.h
//  JobKnow
//
//  Created by admin on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface MyHrFamilyJumpViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *jumpRequest;//要跳转的链接

@end
