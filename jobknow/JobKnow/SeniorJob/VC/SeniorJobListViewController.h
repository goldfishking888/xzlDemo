//
//  SeniorJobListViewController.h
//  JobKnow
//
//  Created by Suny on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "EGOViewCommon.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ICSDrawerController.h"
#import "myButton.h"

#import "XZLLocaRead.h"

#import "SeniorJobFilterViewController.h"
#import "SeniorCityModel.h"
#import "SeniorCityListViewController.h"

@interface SeniorJobListViewController : BaseViewController<ICSDrawerControllerChild,ICSDrawerControllerPresenting,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SendRequest,EGORefreshTableDelegate,UIAlertViewDelegate,SeniorJobFilterDelegate,SeniorCityListDelegate>
{
    NSInteger currentPage; //当前页
    NSInteger pageCount;   //总页数
    NSInteger eachTotalCount;   //总页数
    
    NSInteger currentPage_other; //其他当前页
    NSInteger pageCount_other;   //其他总页数
    
    NSInteger all;
    NSInteger today;
    
    NSInteger num;
    
    NSMutableArray *dataArray;//简历数据源
    NSMutableArray *dataArray_jobSort;//jobSort数据源
    NSMutableArray *selectArray;//被选中的职业。
//    UserDatabase *db;
    
    
    NetWorkConnection*net;
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    
//    ResumeFilterView *resumeView;   //简历筛选视图
    
    UILabel *navTitle;
    
    NSString *jobSortId;
    
    BOOL isOtherPage;
    
    BOOL detail;
    
    myButton *detailBtn;//详细按钮
    myButton *shoucangBtn;//屏幕下方的收藏按钮
    UILabel *labels;
    UILabel *detailLab;
    
    BOOL isFilterSearch;
    
    NSString *cityStr;
    NSString *cityCode;
    
    NSString *seniorJob_AllCounts;
    NSString *seniorJob_bonus;
}
@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)myButton *selectBtn;//筛选按钮

@property(nonatomic,assign)NSInteger page;

//@property(nonatomic,strong)JobModel *model;
//
//
@property(nonatomic,strong)RTLabel *totalLabel;//所有订阅器今日新增，累计新增
@property(nonatomic,strong)RTLabel *todayLabel;//当前订阅器今日新增，累计新增

@property(nonatomic, weak) ICSDrawerController *drawer;

@end
