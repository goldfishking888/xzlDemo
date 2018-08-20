//
//  TradeViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlreadyTableView.h"
@interface TradeViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,AlreadyDelegate,UIAlertViewDelegate>
{
    UIImageView *jiantou;
    UILabel *fenshu;
    OLGhostAlertView *alert;
}
//备份比较
@property (nonatomic, strong) NSMutableArray *saveArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *jobsArray;//选择行业
//@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) AlreadyTableView *alreadyTV;//已选择行业


@end
