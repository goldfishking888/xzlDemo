//
//  collectViewController.h
//  JobKnow
//
//  Created by Apple on 14-3-18.
//  Copyright (c) 2014年 lxw. All rights reserved.
//
//  职位收藏

#import "BaseViewController.h"
#import "JobReaderDetailViewController.h"

@interface collectViewController : BaseViewController<SendRequest,UITableViewDataSource,UITableViewDelegate,JobReaderDetailVCDelegate>
{
    BOOL detail;
    
    UIButton *mingxiBtn;
    UIButton *postBtn;
    UIButton *postBtn2;
    UILabel *detailLab;
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
    NetWorkConnection *net;
}
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,assign)id<JobReaderDetailVCDelegate>delegate;
@end
