//
//  SeniorConditionDetailViewController.h
//  JobKnow
//
//  Created by Suny on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "jobRead.h"
typedef enum SeniorConditionType
{
    SeniorSelectHangye,
    SeniorSelectZhiye,
    SeniorSelectPaiLieFangshi,
    SeniorSelectWorkExp,
    SeniorSelectEduExp,
    SeniorSelectCompanyType
}SeniorConditionItem;

@protocol SeniorConditionDelegate <NSObject>
- (void)selectValueToUp:(jobRead *)select;
@end

@interface SeniorConditionDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger iosHeight;
    NSArray *showArray;
    NSArray *codeArray;
}

@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, strong) NSArray *codeArray;
@property (nonatomic, assign) id<SeniorConditionDelegate> delegate;
@property (nonatomic, assign) SeniorConditionItem selectOption;
@property (nonatomic, strong) UITableView *tableView;

@end
