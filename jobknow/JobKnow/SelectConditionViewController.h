//
//  SelectConditionViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionDetailViewController.h"

@protocol SelectDelegate
- (void)finishSelect;
@end

@interface SelectConditionViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,ConditionDelegate>
{
    NSInteger index;
    NSInteger num;
    UIScrollView *mySrollView;
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) id<SelectDelegate>delegate;

@end
