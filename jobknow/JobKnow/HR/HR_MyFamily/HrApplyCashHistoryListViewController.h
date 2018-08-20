//
//  HrApplyCashHistoryListViewController.h
//  JobKnow
//
//  Created by admin on 15/8/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface HrApplyCashHistoryListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UIScrollView *_mainScrollView;
    UITableView *_listTableView;
    NSMutableArray *_dataArray;//提现记录数据Array
    MBProgressHUD *_progressView;//小菊花
    UIView *_noDataView;//无数据时显示的界面
}


@end


@interface HrApplyCashHistoryListCell : UITableViewCell

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *stateDetailLabel;

-(id)initCashHistoryListCellWithReuserIdentifier:(NSString *)reuserId;
@end