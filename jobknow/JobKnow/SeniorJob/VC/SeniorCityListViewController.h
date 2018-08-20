//
//  SeniorCityListViewController.h
//  JobKnow
//
//  Created by Suny on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "SeniorCityModel.h"

@protocol SeniorCityListDelegate<NSObject>
- (void)finishSelectCityWithCityCode:(NSString *)code CityName:(NSString *)cityName;
@end

@interface SeniorCityListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger num;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) id<SeniorCityListDelegate>delegate;

@end
