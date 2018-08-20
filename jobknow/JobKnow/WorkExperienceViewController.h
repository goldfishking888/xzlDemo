//
//  WorkExperienceViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol workExperienceDelegate<NSObject>
- (void)changeworkExperience:(NSString *)experience;
@end

@interface WorkExperienceViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    int num;
    
    NSArray *_showArray;
    
    UITableView *_tableView;
}

@property (nonatomic,strong)id<workExperienceDelegate>delegate;

@end
