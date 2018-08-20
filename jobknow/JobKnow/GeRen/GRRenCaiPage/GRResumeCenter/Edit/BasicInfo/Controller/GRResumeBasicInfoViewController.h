//
//  GRResumeBasicInfoViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonBasicInfoModel.h"
#import "KTSelectDatePicker.h"
#import "GRSingleSelectViewController.h"
#import "GRResumeEditTableViewCell.h"
#import "TPKeyboardAvoidingTableView.h"

@interface GRResumeBasicInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRResumeEditTableViewCellDelegate,GRSingleSelectViewControllerDelegate,CityDelegate>{
    KTSelectDatePicker *_datePicker;
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong) NSArray *arrat_title_0;
@property (nonatomic,strong) NSArray *arrat_title_1;

@property (nonatomic,strong) PersonBasicInfoModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath_current;

@end
