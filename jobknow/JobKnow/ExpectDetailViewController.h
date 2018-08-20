//
//  ExpectDetailViewController.h
//  JobKnow
//
//  Created by liuxiaowu on 13-9-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "AlreadyTableView.h"
#import "EditReader.h"

@interface ExpectDetailViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate,AlreadyDelegate>
{
    EditReader *edit;
    OLGhostAlertView *alert;
    UIButton *selectBtn;
    UIImageView *arrowView;
    int num;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AlreadyTableView *alreadyTV;
@property (nonatomic, strong) NSArray *cityArray;
@end
