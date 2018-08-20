//
//  JumpWebViewController.h
//  JobKnow
//
//  Created by Jiang on 15/9/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "ApplyEntryBounsViewController.h"
#import "SeniorJobListViewController.h"
#import "SeniorJobRightViewController.h"

@interface JumpWebViewController : BaseViewController

@property (nonatomic, strong) NSString *jumpRequest;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@property (nonatomic) BOOL isFromNodataApplyList;
@end
