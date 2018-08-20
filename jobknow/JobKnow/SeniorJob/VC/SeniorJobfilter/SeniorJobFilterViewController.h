//
//  SeniorJobFilterViewController.h
//  JobKnow
//
//  Created by Suny on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "SeniorConditionDetailViewController.h"
#import "PositionsViewController.h"
#import "WorkDetailViewController.h"
#import "JobNameViewController.h"


@protocol SeniorJobFilterDelegate
- (void)finishSelect;
@end

@interface SeniorJobFilterViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,SeniorConditionDelegate,positonViewDelegate,workDetailDelegate,JobNameViewDelegate>
{
    NSInteger index;
    NSInteger num;
    UIScrollView *mySrollView;
    BOOL isHangYeEmpty;
    BOOL isZhiWeiEmpty;
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<SeniorJobFilterDelegate>delegate;

@end
