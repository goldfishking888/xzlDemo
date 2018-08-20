//
//  MyBonusApplyDetailVC.h
//  JobKnow
//
//  Created by WangJinyu on 15/9/9.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "MyBonusApplyModel.h"
#import "Bonus_JobDetailVCViewController.h"
@interface MyBonusApplyDetailVC : BaseViewController
{
    SeniorJobDetailModel *positionModel;
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong)NSString * bonusState;
@property (nonatomic,strong)MyBonusApplyModel * NewModel;
@end
