//
//  ProvinceViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-6-20.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *provinceArray;
@end
