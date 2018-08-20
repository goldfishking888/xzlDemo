//
//  GRBookerViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/7/26.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "GRBookerModel.h"
#import "GRBookerConditionTableViewCell.h"
#import "GRSingleSelectViewController.h"
#import "GRMultiSelectViewController.h"

@interface GRBookerViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRBookerConditionTableViewCellDelegate,GRSingleSelectViewControllerDelegate,GRMultiSelectViewControllerDelegate,CityDelegate>{
    OLGhostAlertView *ghostView;
    BOOL isEditingBooker;
    MBProgressHUD *loadView;
    GRBookerModel *myModel;//删除时暂存Model
}

@property (nonatomic,strong) UIView *view_Booker;

// tableView
@property(nonatomic,strong)UITableView *tableView;

// UITextField
@property(nonatomic,strong) UITextField *tf_pname;

// 订阅条件model
@property(nonatomic,strong) GRBookerModel *model;

@property (nonatomic, strong) NSMutableArray *dataArray;    //数据源

@end
