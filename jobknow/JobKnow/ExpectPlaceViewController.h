//
//  ExpectPlaceViewController.h
//  JobKnow
//
//  Created by liuxiaowu on 13-9-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "AlreadyTableView.h"
#import "EditReader.h"

@interface ExpectPlaceViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AlreadyDelegate,UIAlertViewDelegate>
{
    EditReader *edit;
    OLGhostAlertView *alert;
    UIButton *selectBtn;
    UIImageView *arrowView;
    int num;
}
@property (nonatomic, strong) AlreadyTableView *alreadyTV;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) NSArray *placeArray;

@end
