//
//  GRSelectSalaryViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol GRSelectSalaryDelegate <NSObject>
@optional
- (void)onSelectSalary;
@end

@interface GRSelectSalaryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int num;
    NSMutableArray *saveArray;  //保存选中的数据，jobRead
    NSMutableArray *dataArray;  //tableview的数据源
    UILabel *scoreLabel;
    UIImageView *jiantouImage;
    OLGhostAlertView *ghostView;
}

@property(nonatomic,assign)BOOL isEmpty;

@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong) id<GRSelectSalaryDelegate>delegate;

@end
