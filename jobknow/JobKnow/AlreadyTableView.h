//
//  AlreadyTableVIew.h
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobRead.h"

@protocol AlreadyDelegate

@optional
-(void)removeSelected:(jobRead *)job;
-(void)removeSelectedJob:(NSDictionary *)dic;
@end

@interface AlreadyTableView : UITableView <AlreadyDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger *btnTag;
}

@property (nonatomic, assign) BOOL readJob;
@property (nonatomic, strong) NSMutableArray *selectArray;//tableView的数据源
@property (nonatomic, assign) id <AlreadyDelegate> AlreadyDelegate;

@end