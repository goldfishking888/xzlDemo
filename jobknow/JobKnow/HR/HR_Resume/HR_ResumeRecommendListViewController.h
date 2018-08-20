//
//  HR_ResumeRecommendListViewController.h
//  JobKnow
//
//  Created by Suny on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "RTLabel.h"
#import "JobModel.h"


#import "HR_ResumeRecListCell.h"
#import "HR_ResumeDetail.h"
#import "ResumeFilterView.h"
#import "HR_ResumeAdd.h"
//@class HR_ResumeAdd;

#import "HR_ResumeShareTool.h"

#import "HRHomeIntroduceModel.h"
#import "ASIFormDataRequest.h"
#import "HR_ResumePriceEdit.h"

@interface HR_ResumeRecommendListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SendRequest,UIAlertViewDelegate,ResumeFilterViewDelegate,HR_ResumeRecListCellDelegate,HR_ResumePriceEditDelegate>
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
    UserDatabase *db;
    
    
    NetWorkConnection*net;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    
    ResumeFilterView *resumeView;   //简历筛选视图
    
    UILabel *navTitle;
    
    NSString *jobSortId;
    
    BOOL isOtherPage;
    
    UIButton *btn_all ;
    
    UIButton *btn_anonymous;
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong) HRHomeIntroduceModel *model_job;
//
//
@property(nonatomic,strong)RTLabel *totalLabel;//所有订阅器今日新增，累计新增
@property(nonatomic,strong)RTLabel *todayLabel;//当前订阅器今日新增，累计新增

//显示数据的tableView
//@property(nonatomic,strong)UITableView *tableViewData;

-(void)addModelWithModel:(HRReumeModel *)model;


@end
