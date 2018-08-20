//
//  PositionViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol posVCDelegate<NSObject>
- (void)changePosition:(NSString *)positionStr;
@end

@interface PositionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    
    NSMutableArray *dataArray;
    
    UITableView *_tableView;
}

@property (nonatomic,assign)id<posVCDelegate>delegate;

@end
