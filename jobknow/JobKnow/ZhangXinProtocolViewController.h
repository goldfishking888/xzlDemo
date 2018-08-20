//
//  ZhangXinProtocolViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface ZhangXinProtocolViewController : BaseViewController<UIWebViewDelegate>
{
    int num;
    
    MBProgressHUD *loadView;
}
@property(nonatomic,strong)UIWebView *webView;
@end
