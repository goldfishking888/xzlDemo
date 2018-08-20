//
//  SourceViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SourceDelegate
- (void)selectSource:(NSString *)source;
@end
@interface SourceViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) id <SourceDelegate>sourceDelegate;
@property (nonatomic,strong)NSMutableArray *list;
@end
