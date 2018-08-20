//
//  XZLJobVC.h
//  XzlEE
//
//  Created by ralbatr on 14-9-22.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import "BaseViewController.h"
#import "OLGhostAlertView.h"
#import "XZLAlreadyTableView.h"
#import "XZLsaveJob.h"


@protocol XZLjobVCDelegate <NSObject>

- (void)getjobstr:(NSString *)jobstr;

@end

@interface XZLJobVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,XZLAlreadyDelegate>
{
    NSMutableArray *saveArray;  //保存选中的数据，jobRead
    NSMutableArray *dataArray;  //tableview的数据源
    UILabel *scoreLabel;
    UIImageView *jiantouImage;
    OLGhostAlertView *ghostView;
    NSString *getjoblabel;

    NSIndexPath *checkedIndexPath;



}

@property (nonatomic, strong) UITableView*jobTableView;

@property (nonatomic,strong) XZLAlreadyTableView *alreadyTV;


@property (nonatomic, weak) id<XZLjobVCDelegate> delegate;

@property (nonatomic, assign) BOOL isCompany;



@end
