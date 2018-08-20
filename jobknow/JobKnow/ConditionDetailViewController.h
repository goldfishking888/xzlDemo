//
//  ConditionDetailViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobRead.h"
typedef enum SelectConditionType
{
    SelectPublishDate,
    SelectJobYear,
    SelectEducation,
    SelectMonthSalary,
    SelectJobType,
    SelectCompanyType
}SelectItem;

@protocol ConditionDelegate <NSObject>
- (void)selectValueToUp:(jobRead *)select;
@end

@interface ConditionDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger iosHeight;
    NSArray *showArray;
    NSArray *codeArray;
}

@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, strong) NSArray *codeArray;
@property (nonatomic, assign) id<ConditionDelegate> delegate;
@property (nonatomic, assign) SelectItem selectOption;
@property (nonatomic, strong) UITableView *tableView;
@end
