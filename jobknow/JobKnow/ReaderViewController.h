//
//  ReaderViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-2-28.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDatabase.h"
#import "ReadTableView.h"
#import "DetailView.h"

#import "allCityViewController.h"
#import "WorkDetailViewController.h"
#import "GRSelectIndustryViewController.h"

#import "GRSelectSalaryViewController.h"

//有用的
typedef enum JobClassOption
{
    JobAllWork,
    JobAllJob,
    JobSalary,
    JobArea,
    JobNature,
    jobNone
}JobItem;

/*
 1.SelectVCDelegate    是 SelectDetailViewController代理，用于待遇，职位类型等的查看和修改
 2.CityDelegate        是 allCityViewController代理
 3.ComResultDelegate   是 CompanyResultViewController的代理
 4.positonViewDelegate 是 PositionsViewController
*/

@interface ReaderViewController : BaseViewController<UITextFieldDelegate,UIScrollViewDelegate,SendRequest,CityDelegate,workDetailDelegate,detailViewDelegate,GRSelectSalaryDelegate,GRSelectIndustryViewDelegate>
{
    int num;
    
    NSMutableArray *dingyueListArray;    //详细订阅的订阅器
    
    UITextField *jobTextField;  //职位名称输入框

    
    UIScrollView *rootScrollView;
    OLGhostAlertView *ghostView;
    
    SaveJob *save;
    CityInfo *cityInfo;
    UserDatabase *db;
    NSUserDefaults *userDefaults;
    NetWorkConnection *net;
}

@property (nonatomic,strong) DetailView *detailView;


@end
