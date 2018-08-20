//
//  HR_ScanToLoginVC.h
//  JobKnow
//
//  Created by Suny on 15/12/25.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "OLGhostAlertView.h"
@interface HR_ScanToLoginVC : BaseViewController

@property (nonatomic,strong) OLGhostAlertView *ghostView;

@property (nonatomic,copy) NSString *usertype;//@"2":个人 @"3":猎手

@property (nonatomic,copy) NSString *title_str;//

@property (nonatomic,copy) NSString *content_str;//
@end
