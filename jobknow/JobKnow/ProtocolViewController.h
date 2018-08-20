//
//  ProtocolViewController.h
//  JobKnow
//
//  Created by Zuo on 14-1-23.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface ProtocolViewController : BaseViewController<UIWebViewDelegate>
{
    int num;
}
@property(nonatomic,strong)UIWebView *webView;
@end
