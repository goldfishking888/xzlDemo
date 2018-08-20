//
//  HR_searchResultViewController.h
//  JobKnow
//
//  Created by WangJinyu on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "HRHomeCell.h"
#import "HR_CompanyVipViewController.h"
#import "HR_JobDetailVC.h"
@interface HR_searchResultViewController : BaseViewController<cellDelegate,UIAlertViewDelegate,HR_JobDetailVCCollectDelegate>
{
    OLGhostAlertView * ghostView;
    NSIndexPath *current_index;
}
@property (nonatomic,strong)NSString * searchKeyStr;
@property (nonatomic,strong)NSString * cityCodeStr;
@end
