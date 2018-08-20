//
//  DegreeViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-29.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol degreeDelegate<NSObject>
- (void)changeDegree:(NSString *)degree;
@end

@interface DegreeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    
    NSArray *_showArray;
    
    UITableView *_tableView;
}

@property(nonatomic,assign)id<degreeDelegate>delegate;

@end