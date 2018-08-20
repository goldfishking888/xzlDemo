//
//  GRResumeJobOrientationEditViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "JobOrientationModel.h"
#import "KTSelectDatePicker.h"
#import "GRSingleSelectViewController.h"
#import "GRMultiSelectViewController.h"
#import "GRResumeEditTableViewCell.h"

@interface GRResumeJobOrientationEditViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRResumeEditTableViewCellDelegate,GRSingleSelectViewControllerDelegate,GRMultiSelectViewControllerDelegate,CityDelegate>{
    OLGhostAlertView *ghostView;
}


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *arrat_title_0;
@property (nonatomic,strong) JobOrientationModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath_current;

@end
