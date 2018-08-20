//
//  HR_HomeViewController.h
//  JobKnow
//
//  Created by WangJinyu on 15/7/31.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_HomeViewController.h"
#import "XHPathCover.h"
#import "HR_ResumeList.h"
#import "HR_JobDetailVC.h"
#import "HRHomeCell.h"
#import "HR_ResumeRecommendListViewController.h"
#import "HR_CompanyVipViewController.h"
#import "DCPicScrollView.h"

#define HeaderImageRefresh @"headerImageRefresh" //头像刷新通知

@interface HR_HomeViewController : UIViewController<cellDelegate,UIAlertViewDelegate,HR_JobDetailVCCollectDelegate>
{
    OLGhostAlertView * ghostView;
    NSIndexPath *current_index;
    UIView *introView_back;
    int headerHeight;
    UIView * bgView;//tableviewheader
    DCPicScrollView  *bannerView ;
}
//@property (nonatomic, assign) BOOL head;
@property (nonatomic, strong) XHPathCover *pathCover;
@property (strong, nonatomic) UIButton* signalBtn;
//刷新表
@property (nonatomic,assign) int num;

@end
