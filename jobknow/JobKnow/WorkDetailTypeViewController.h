//
//  WorkDetailTypeViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol workDetailVCDelegate<NSObject>
- (void)changeworkDetail:(NSString *)workDetail;
@end

@interface WorkDetailTypeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    
    UITableView *_tableView;
}

@property (nonatomic,strong) NSString *jobItem;//职位类别

@property (nonatomic,strong) NSArray *dataArray;//tableview数据源

@property (nonatomic,strong)id<workDetailVCDelegate>delegate;

@end
