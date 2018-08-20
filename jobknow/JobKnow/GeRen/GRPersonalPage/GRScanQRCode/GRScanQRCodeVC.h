//
//  GRScanQRCodeVC.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"

@interface GRScanQRCodeVC : BaseViewController

@property (nonatomic,strong) OLGhostAlertView *ghostView;

@property (nonatomic,copy) NSString *usertype;//@"2":个人 @"3":猎手

@property (nonatomic,copy) NSString *title_str;//

@property (nonatomic,copy) NSString *content_str;//
@end
