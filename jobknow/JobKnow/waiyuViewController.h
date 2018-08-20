//
//  waiyuViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "waiyu2ViewController.h"
@interface waiyuViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest,cLangue>
{
    UITableView *myTabView;
    NSMutableArray *myAry;
    NSMutableArray *myAry_jb;
    NSMutableArray *myAry_id;
    MBProgressHUD *loadView;
    OLGhostAlertView * alert;
}
@end
