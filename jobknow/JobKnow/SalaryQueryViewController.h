//
//  SalaryQueryViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-20.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryQueryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
