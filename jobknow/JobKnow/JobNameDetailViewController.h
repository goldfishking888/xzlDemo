//
//  JobNameDetailViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-2-26.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyTableView.h"
@interface JobNameDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,AlreadyDelegate>
{
    NSMutableDictionary *jobDictionary;
    UIImageView *jiantou;
    UILabel *fenshu;
    OLGhostAlertView *alert;
    int num;
}
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) UITableView *tableView;
//选择的职业数据
@property (nonatomic, strong) NSMutableArray *jobSelectArray;
@property (nonatomic, strong) AlreadyTableView *alreadyTV;
@end
