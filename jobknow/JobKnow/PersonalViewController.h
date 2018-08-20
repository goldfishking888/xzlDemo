//
//  PersonalViewController.h
//  JobKnow
//
//  Created by Zuo on 14-3-25.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "InfoPerfectViewController.h"
@interface PersonalViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,BackColor>
{
    UITableView *mytableView;
}
@end
