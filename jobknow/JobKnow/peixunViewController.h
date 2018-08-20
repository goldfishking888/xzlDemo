//
//  peixunViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface peixunViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest>
{
    UITableView *myTabView;
    NSMutableArray *whereAry;
    NSMutableArray *contentAry;
    NSMutableArray *bookAry;
    NSMutableArray *idAry;
    MBProgressHUD *loadView;
}
@end
