//
//  XZLPMListViewController.h
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"

@interface XZLPMListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) BOOL hasBackBtn;

@property (strong,nonatomic) XZLNoDataView *noDateView; //没有数据，哭脸

@end
