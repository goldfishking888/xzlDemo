//
//  ComViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-6-24.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivetView.h"
@interface ComViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger more;
    ActivetView *tip;
    OLGhostAlertView *alert;
    int num;
}


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) NSMutableArray *companyArray;
@property (nonatomic,copy) NSString *companyName;
@end
