//
//  UpdateOrderViewController.h
//  JobKnow
//
//  Created by admin on 14-7-30.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateOrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) NSDictionary * Pub_dic;
@end
