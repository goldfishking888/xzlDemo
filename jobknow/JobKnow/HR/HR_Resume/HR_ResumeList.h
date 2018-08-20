//
//  HR_ResumeList.h
//  JobKnow
//
//  Created by Suny on 15/8/3.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HR_ResumeListCell.h"
#import "HR_ResumeDetail.h"
#import "ResumeFilterView.h"
#import "HR_ResumeAdd.h"

#import "HR_ResumeShareTool.h"
#import "AppDelegate.h"
#import "HR_ResumePriceEdit.h"
#import "WebViewController.h"

@interface HR_ResumeList : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SendRequest,UIAlertViewDelegate,ResumeFilterViewDelegate,HR_ResumeListCellDelegate,HR_ResumePriceEditDelegate>
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
    
    NSString *resumeLink;
    float height_HeaderView;
    UILabel *label_ResumeCount;
    int resumeCount;
    int resumeCount_limit;
    
    UIView *introView_back;
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,assign)NSInteger page;

-(void)addModelWithModel:(HRReumeModel *)model;

@end
