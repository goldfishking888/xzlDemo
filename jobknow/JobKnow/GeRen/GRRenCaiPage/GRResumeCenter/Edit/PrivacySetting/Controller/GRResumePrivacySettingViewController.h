//
//  GRResumePrivacySettingViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "GRResumePrivacyModel.h"
#import "ResumePrivacySettingTableViewCell.h"
#import "TPKeyboardAvoidingTableView.h"

@interface GRResumePrivacySettingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,ResumePrivacySettingTableViewCellDelegate>{
    BOOL isHide;//是否隐藏更多设置 默认0隐藏 1显示
    int sectionCount;//section数量
    UIButton *btn_hide;
    NSString *hideBtnString;
}

@property (nonatomic,strong) TPKeyboardAvoidingTableView * tableView;

@property (nonatomic,strong) UIView *tableView_Footer;

@property (nonatomic,strong) GRResumePrivacyModel *model;

@end
