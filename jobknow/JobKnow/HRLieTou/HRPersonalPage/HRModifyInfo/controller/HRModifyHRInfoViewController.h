//
//  HRModifyHRInfoViewController.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/30.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "HRBasicInfoModel.h"
#import "GRResumeEditTableViewCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GRSingleSelectViewController.h"

@interface HRModifyHRInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRResumeEditTableViewCellDelegate,GRSingleSelectViewControllerDelegate,CityDelegate>
{
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong) NSArray *arrat_title_0;
@property (nonatomic,strong) NSArray *arrat_title_1;

@property (nonatomic,strong) HRBasicInfoModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath_current;

@end
