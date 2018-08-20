//
//  JobSeeViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-4.
//  Copyright (c) 2013年 lxw. All rights reserved.

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "ReadView.h"
#import "JobModel.h"
#import "PositionModel.h"
#import "ReaderViewController.h"
#import "SelectConditionViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "JobReaderDetailViewController.h"

//判断从哪个页面进入
typedef enum jobReadEnter
{
    jobReadEnterHome=0,//主页进入
    jobReadEnterRead,//详细订阅
    jobReadEnterCompany,//企业订阅
    jobReadEnterFast,//快捷订阅
    jobReadEnterJianzhi//兼职订阅
}jobReadEnterItem;

//筛选和非筛选
typedef enum differentSearch
{
    normalSearch,
    choiceSearch
}positionSearchItem;

@interface JobSeeViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,SelectDelegate,UIScrollViewDelegate,SendRequest,EGORefreshTableDelegate,ReadViewDelegate,UIAlertViewDelegate,JobReaderDetailVCDelegate>
{
    
    BOOL detail;//判断明细
    BOOL _reloading;//下拉刷新中判断刷新状态
    BOOL isHeader;  //判断是否是EGOHeader
    
    NSInteger all;
    NSInteger today;
    
    NSInteger num;
    NSInteger page; //下载过程中的页数，page参数
    
    NSInteger count;
    
    NSInteger positionCount;
    
    NSString *jobString;//头部标题
    
    NSString *allCount;
    
    NSMutableArray *dataArray;//数据源，里面存放的是positionModel
    NSMutableArray *selectArray;//被选中的职业。
    UserDatabase *db;
    
    //显示标题的label
    UILabel *titleLabelx;
    UILabel *titleLabely;
    RTLabel *cityLabel;
    
    myButton *detailBtn;//详细按钮
    
    UIButton *deliveryBtn;//投递按钮
    UILabel *deliveryLab;
    
    myButton *shoucangBtn;//屏幕下方的收藏按钮
    UILabel *labels;
    
    myButton *collectBtn; //屏幕左方的收藏按钮
    
    UIButton*postBtn;     //投递按钮
    
    ReadView *bookView;   //订阅器视图
    
    NetWorkConnection*net;
    EGORefreshTableHeaderView*_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
}

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)JobModel *model;

@property(nonatomic,assign)jobReadEnterItem enterItem;//判断是哪一种订阅器,从哪一个界面进入

@property(nonatomic,assign)positionSearchItem searchItem;//判断是筛选还是非筛选

@property(nonatomic,strong)RTLabel *totalLabel;//所有订阅器今日新增，累计新增
@property(nonatomic,strong)RTLabel *todayLabel;//当前订阅器今日新增，累计新增
@property(nonatomic,strong)myButton *selectBtn;//筛选按钮

//显示数据的tableView
@property(nonatomic,strong)UITableView *tableView;
@end