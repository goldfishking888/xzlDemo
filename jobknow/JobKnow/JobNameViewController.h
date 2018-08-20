//
//  JobNameViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-1-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyTableView.h"

@protocol JobNameViewDelegate <NSObject>
@optional
- (void)JobNameViewChange;
@end

@interface JobNameViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,AlreadyDelegate>
{
    int num;
    UILabel *scoreLabel;
    UIImageView *jiantouImage;
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong) NSString *jobItem;//职位类别
@property (nonatomic,strong) NSArray *dataArray;//tableview数据源
@property (nonatomic,strong) UITableView *myTableView;//tableView

@property (nonatomic,strong) AlreadyTableView *alreadyTV;

@property (nonatomic,strong) id<JobNameViewDelegate>delegate;

@end