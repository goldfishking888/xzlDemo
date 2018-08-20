//
//  HrSelectCircleViewController.h
//  JobKnow
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol HrSelectCircleDelegate <NSObject>

- (void)didSelectCircleWithSelectArray:(NSMutableArray *)selectTradeArray cityName:(NSString *)cityName;

@end

@interface HrSelectCircleViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) id<HrSelectCircleDelegate> delegate;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSMutableArray *selectArray;//HRTradeModel

@end
