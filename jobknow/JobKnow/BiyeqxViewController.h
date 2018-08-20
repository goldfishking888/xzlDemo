//
//  BiyeqxViewController.h
//  JobKnow
//
//  Created by Zuo on 14-3-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface BiyeqxViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mytableView;
    NSArray *titleArray1 ;
    int num;
}
@end
