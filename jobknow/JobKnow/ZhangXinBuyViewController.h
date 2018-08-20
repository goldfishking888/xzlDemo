//
//  ZhangXinBuyViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "myButton.h"
@interface ZhangXinBuyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    
    NSString *nameStr;
    
    myButton *firstBtn;
    
    myButton *secondBtn;
    
    myButton *thirdBtn;
    
    UIButton *buyBtn;
    
    UITableView *_tableView;
}

@property (nonatomic ,strong)NSString *gainStr;

@end
