//
//  HRSelectCityViewController.h
//  JobKnow
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "RTLabel.h"
#import "UserDatabase.h"

@protocol HRSelectCityDelegate <NSObject>

- (void)didSelectWithCityCode:(NSString *)cityCode cityName:(NSString *)cityName;

@end

@interface HRSelectCityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *wordsArray;          //字母数组 A~Z

@property (nonatomic,strong) NSMutableArray *cityArray;    //城市数据

@property (nonatomic,strong) NSMutableDictionary *cityDic; //将城市分组并放入字典

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) id <HRSelectCityDelegate> delegate;

@end
