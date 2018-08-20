//
//  GRResumeEduEXPEditViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "EduEXPModel.h"
#import "GRResumeEditTableViewCell.h"
#import "GRSingleSelectViewController.h"

@interface GRResumeEduEXPEditViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRResumeEditTableViewCellDelegate,GRSingleSelectViewControllerDelegate>{
    OLGhostAlertView *ghostView;
    BOOL isHasDeleteBtn;
}


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *arrat_title_0;
@property (nonatomic,strong) EduEXPModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath_current;
@property (nonatomic,strong) NSString *resume_id;

@end
