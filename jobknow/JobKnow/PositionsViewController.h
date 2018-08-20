//
//  PositionsViewController.h
//  JobsGather
//
//  Created by faxin sun on 12-11-23.
//  Copyright (c) 2012年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyTableView.h"

@protocol positonViewDelegate <NSObject>
@optional
- (void)positonViewChange;
@end

@interface PositionsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AlreadyDelegate>
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
@property(nonatomic,strong)AlreadyTableView *alreadyTV;
@property(nonatomic,strong)id<positonViewDelegate>delegate;

@end
