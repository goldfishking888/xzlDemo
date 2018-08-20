//
//  JobItemViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "JobNameDetailViewController.h"
#import "AlreadyTableView.h"
@interface JobItemViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,AlreadyDelegate,UIAlertViewDelegate>
{
    UIImageView *jiantou;
    UILabel *fenshu;
    OLGhostAlertView *alert;
    int num;
}
@property (nonatomic, assign) BOOL enter;//yes，编辑订阅器进入，no，简历
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AlreadyTableView *alTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *detailJob;
@end
