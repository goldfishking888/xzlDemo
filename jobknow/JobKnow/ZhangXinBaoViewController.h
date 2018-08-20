//
//  ZhangXinBaoViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-25.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"

@interface ZhangXinBaoViewController : BaseViewController<UIWebViewDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate>
{
    int num;
    
    NSString *urlStr;
    
    UIButton *_shareBtn;
    
    UIWebView *_webView;
    
    MBProgressHUD *loadView;
}

@property (nonatomic,strong)NSMutableArray *dataArray;

@end
