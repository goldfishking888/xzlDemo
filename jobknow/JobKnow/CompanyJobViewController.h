//
//  CompanyJobViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-6-24.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeType.h"
@interface CompanyJobViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger more;
    ActivetView *tip;
}

@property (nonatomic, strong) CodeType *codet;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *companyArray;

@end
