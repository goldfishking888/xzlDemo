//
//  waiyu2ViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "waiyu3ViewController.h"
@protocol cLangue <NSObject>
@optional
-(void)changeLangue:(NSArray*)arry;
@end
@interface waiyu2ViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,chuanDeleat,SendRequest>
{
    UITableView *myTableView;
    NSString *shuiping;
    NSString *waiyupz;
    MBProgressHUD *loadView;
    OLGhostAlertView * alert;
}
@property (nonatomic,retain)NSString *myType;
@property (nonatomic,retain)NSString *waiyu;
@property (nonatomic,retain)NSString *jibie;
@property (nonatomic,retain)NSString *myID;
@property (nonatomic,retain)id<cLangue>deleat;

@end
