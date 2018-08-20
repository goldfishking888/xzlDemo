//
//  UnivercityNameViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol univercityDelegate
- (void)selectUnivercityName:(NSString *)name;
@end
@interface UnivercityNameViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) id <univercityDelegate> nameDelegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic ,strong) NSMutableArray *school;
@property (nonatomic ,assign) int num;
@end
