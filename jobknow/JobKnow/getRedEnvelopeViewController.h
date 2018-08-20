//
//  getRedEnvelopeViewController.h
//  JobKnow
//
//  Created by Apple on 14-8-5.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface getRedEnvelopeViewController : BaseViewController<UIWebViewDelegate>
{
    int num;
    
    UIWebView *_webView;
    
    MBProgressHUD *loadView;
}

@property (nonatomic,strong)NSString *shareURL;

@property (nonatomic,strong)NSString *getString;

@end
