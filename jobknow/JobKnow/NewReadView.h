//
//  NewReadView.h
//  JobKnow
//
//  Created by Apple on 14-4-1.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobModel.h"

@protocol NewReadDelegate <NSObject>
@optional
- (void)readView:(JobModel *)model;
@end

@interface NewReadView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *realArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)id<NewReadDelegate>delegate;

@end
