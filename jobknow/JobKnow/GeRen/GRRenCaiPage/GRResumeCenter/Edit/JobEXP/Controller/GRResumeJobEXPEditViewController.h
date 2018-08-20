//
//  GRResumeJobEXPEditViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkEXPModel.h"
#import "GRResumeEditTableViewCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GRSingleSelectViewController.h"
#import "GRMultiSelectViewController.h"
#import "GRResumeJobEXPEditIntroTableViewCell.h"

@interface GRResumeJobEXPEditViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRResumeEditTableViewCellDelegate,GRSingleSelectViewControllerDelegate,GRMultiSelectViewControllerDelegate,GRResumeJobEXPEditIntroTableViewCellDelegate>{
    OLGhostAlertView *ghostView;
    BOOL isHasDeleteBtn;
}


@property (nonatomic,strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong) NSArray *arrat_title_0;
@property (nonatomic,strong) WorkEXPModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath_current;

@property (nonatomic,strong) NSString *resume_id;

@end
