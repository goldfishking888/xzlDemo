//
//  MajorDetailViewController.h
//  JobKnow
//
//  Created by liuxiaowu on 13-9-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface MajorDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *majorArray;
@end
