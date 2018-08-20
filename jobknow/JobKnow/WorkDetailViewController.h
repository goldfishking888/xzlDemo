//
//  WorkDetailViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-1-28.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyTableView.h"

@protocol workDetailDelegate <NSObject>
@optional
-(void)workDetailChange;
@end

@interface WorkDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AlreadyDelegate>
{
    int num;
    
    NSString *firstLiveStr;//职业名称，作为参数传给jobNameVC
    NSArray *detailJobArray;//当前职业下的职位数组，作为参数传给jobNameVC
    
    NSMutableArray *dataArray;//下一级别界面的
    NSMutableArray *firstLiveArray;//当前职位选项界面的数据源
    
    UILabel *scoreLabel;
    UIImageView *jiantouImage;
    OLGhostAlertView *ghostView;
}

@property(nonatomic,assign)BOOL isEmpty;

@property(nonatomic,strong) NSMutableDictionary *recordDic;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) AlreadyTableView *alreadyTV;
@property(nonatomic,strong) id<workDetailDelegate>delegate;

@end