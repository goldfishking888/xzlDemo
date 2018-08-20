//
//  KuaijieView.h
//  JobKnow
//
//  Created by Zuo on 13-8-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ASINetworkQueue.h"
#import <UIKit/UIKit.h>
#import "JobDetailInfo.h"
#import "RTLabel.h"
#import "UserDatabase.h"

@protocol KuaijieDelegate
@optional
-(void)kuaijieViewSelected:(JobModel *)model;
@end

@interface KuaijieView : UIView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SendRequest>
{
    BOOL isClick;
    
    NSInteger num;
    NSInteger index;
    NSInteger myTag;//当前点击的button的tag值
    NSString *titleStr;
    
    NSMutableArray *dataArray;
    
    RTLabel *addLabel;
    RTLabel *allLabel;
    UIButton *bianjiBtn;
    
    UIScrollView *myScroView;
    UITableView *myTableView;

    UserDatabase *db;
    NetWorkConnection *net;
    NSUserDefaults *userDefaults;
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
}

@property(nonatomic,strong)NSString *cityStr;
@property(nonatomic,strong)NSString *cityCodeStr;
@property(nonatomic,assign)id <KuaijieDelegate>delegate;

@end