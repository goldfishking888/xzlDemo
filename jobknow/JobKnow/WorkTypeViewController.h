//
//  WorkTypeViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface WorkTypeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    int num;
    
    NSString *firstLiveStr;
    
    NSMutableArray *firstLiveArray;
    
    NSMutableArray *dataArray;
    
    NSArray *detailJobArray;//当前职业下的职位数组，作为参数传给jobNameVC
    
    UITableView *_tableView;
}
@end
