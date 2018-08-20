//
//  GRPreBookViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/9/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "GRBookerModel.h"
#import "GRSingleSelectViewController.h"
#import "GRMultiSelectViewController.h"
#import "GRBookerConditionTableViewCell.h"

@interface GRPreBookViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRSingleSelectViewControllerDelegate,GRMultiSelectViewControllerDelegate,CityDelegate,GRBookerConditionTableViewCellDelegate>

// tableView
@property(nonatomic,strong)UITableView *tableView;
// UITextField
@property(nonatomic,strong) UITextField *tf_pname;
// 订阅条件model
@property(nonatomic,strong) GRBookerModel *model;

@property (nonatomic,strong) UIView *view_Booker;

@end
