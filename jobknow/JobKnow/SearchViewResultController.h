//
//  SearchViewResultController.h
//  JobKnow
//
//  Created by Apple on 14-3-26.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDatabase.h"
#import "RTLabel.h"
#import "myButton.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "SelectConditionViewController.h"

//筛选和非筛选
typedef enum RequestItem
{
    requestNormal,
    requestShuaixuan
}requestItem;

@interface SearchViewResultController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,SendRequest,SelectDelegate>
{
    
    BOOL detail;//判断明细
    BOOL _reloading;//下拉刷新中判断刷新状态
    BOOL isHeader;  //判断是否是EGOHeader
    
    NSInteger today;//本条订阅器今日新增
    NSInteger all;//本条订阅器累计新增
    NSInteger iosHeight;
    NSInteger page; //下载过程中的页数，page参数
    
    NSInteger positionCount;
    
    NSString *jobString;//头部标题
    
    NSString *allCount;
    
    NSMutableArray *selectArray;//被选中的职业。
    
    UserDatabase *db;
    
    UILabel *titleLabelx;
    UILabel *titleLabely;
    RTLabel *cityLabel;
    
    UIButton *detailBtn;//详细按钮
    
    UIButton *deliveryBtn;//投递按钮
    UILabel *deliveryLab;
    
    UIButton *shoucangBtn;//收藏按钮1
    UILabel *labels;
    
    myButton *collectBtn;//收藏按钮2
    
    UIButton*postBtn;   //投递按钮
    
    NetWorkConnection*net;
    EGORefreshTableHeaderView*_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
}

//页面
@property(nonatomic,assign)NSInteger page;
//网页请求的model
@property(nonatomic,strong)SearchModel *model;
//数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
//标题
@property(nonatomic,strong)NSString *titleStr;
//今日新增
@property(nonatomic,strong)NSString *todayStr;
//累计新增
@property(nonatomic,strong)NSString *totalStr;

//总共有多少个职位
@property(nonatomic,strong)NSString *allCountStr;

//判断是筛选还是非筛选
@property(nonatomic,assign)requestItem item;

@property (nonatomic, strong) RTLabel *totalLabel;

@property (nonatomic, strong) RTLabel *allLabel;

@property (nonatomic, strong) UIButton *selectBtn;//筛选按钮

@property (nonatomic, strong) UITableView *tableView;

@end