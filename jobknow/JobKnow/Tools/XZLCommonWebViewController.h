//
//  XZLCommonWebViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/29.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"

@interface XZLCommonWebViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic,strong) NSString *titleStr;

@end
