//
//  HR_JobCollectionViewController.h
//  JobKnow
//
//  Created by Suny on 15/8/16.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRHomeIntroduceModel.h"
#import "HR_JobDetailVC.h"

@interface HR_JobCollectionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SendRequest>
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
    
    
    NetWorkConnection*net;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    
    UILabel *navTitle;
    
    NSString *jobSortId;
    
    BOOL isOtherPage;
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)BOOL isJianzhi;//判断职位是否是兼职
@property(nonatomic,assign)BOOL detail;   //详细与否

@property (nonatomic, strong) UILabel *contact;
@property (nonatomic, strong) UILabel *contactPerson;
@property (nonatomic, strong) UILabel *tel;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *netAddress;
@property (nonatomic, strong) UILabel *email;


@end
