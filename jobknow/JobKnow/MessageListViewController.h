//
//  MessageListViewController.h
//  JobKnow
//
//  Created by admin on 14-4-21.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest>
{
    UITableView *_tableView;
    NSMutableArray *_messageArray;
    int _num;
}

@property (nonatomic) BOOL isFromHr;// 是否是由Hr相关功能跳转过来
@end
