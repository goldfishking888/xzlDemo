//
//  GRResumeProjectEXPEditViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"

#import "ProjectEXPModel.h"
#import "GRResumeEditTableViewCell.h"
#import "GRResumeJobEXPEditIntroTableViewCell.h"
#import "TPKeyboardAvoidingTableView.h"


@interface GRResumeProjectEXPEditViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,GRResumeEditTableViewCellDelegate,GRResumeJobEXPEditIntroTableViewCellDelegate>{
    OLGhostAlertView *ghostView;
    BOOL isHasDeleteBtn;
}


@property (nonatomic,strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong) NSArray *arrat_title_0;
@property (nonatomic,strong) ProjectEXPModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath_current;
@property (nonatomic,strong) NSString *resume_id;

@end
