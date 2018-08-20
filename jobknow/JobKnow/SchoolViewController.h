//
//  SchoolViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-6-20.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *univercityArray;
@property (nonatomic, strong) UITableView *tableView;

@end
