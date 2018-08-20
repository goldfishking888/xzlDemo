//
//  PurchaseViewController.h
//  JobKnow
//
//  Created by Apple on 14-8-7.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "allCViewController.h"
#import "WorkExperienceViewController.h"
#import "PositionViewController.h"
#import "DegreeViewController.h"
#import "WorkDetailTypeViewController.h"

@class TipButton;

@interface PurchaseViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,ChuancityDelegate,degreeDelegate,workExperienceDelegate,posVCDelegate,workDetailVCDelegate>
{
    int num;
    
    NSInteger count;
    
    NSString *cityStr;//城市字符串
    
    NSString *degreeStr;//学历
    
    NSString *experienceStr;//工作经验
    
    NSString *industryStr;//行业类别
    
    NSString *jobTypeStr;//职业类别
    
    NSMutableArray *_wordsArray;
    
    UIButton *submitBtn;    //提交资格审核按钮
    
    TipButton *tipBtn;      //显示性别男女
    
    TipButton *tipBtn2;
    
    UITableView *_tableView;
    
    UIScrollView *_scrollView;
    
    OLGhostAlertView *ghostView;
    
    MBProgressHUD *loadView;
}

@end