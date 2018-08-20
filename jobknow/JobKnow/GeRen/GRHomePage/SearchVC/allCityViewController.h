//
//  allCityViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-16.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "jobRead.h"
#import "RTLabel.h"
#import "UserDatabase.h"
#import "MJReverseGeocoder.h"

@protocol CityDelegate <NSObject>
@optional
- (void)sendValue:(jobRead *)city;
- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName;
@end

@interface allCityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest,UISearchBarDelegate>
{
    BOOL isFirst;
    
    int num;
    
    NSString *string;
    
    NSString  *currentTime;
    
    NSMutableArray *hotCityArray;
    
    UserDatabase *db;
    
    NSUserDefaults *userDefaults;
    
    UIView *headV;
    
    RTLabel* cnlabel3;//添加一个标签
    
    OLGhostAlertView *ghostView;
    
    MBProgressHUD *loadView;
}

@property (nonatomic,assign) BOOL change;

@property (nonatomic,strong) NSString *fromWhereStr;

@property (nonatomic,strong) NSMutableArray *wordsArray;          //字母数组

@property (nonatomic,strong) NSMutableArray *cityArray;    //城市数据

@property (nonatomic,strong) NSMutableDictionary *cityDic; //将城市分组并放入字典

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) id <CityDelegate> delegate;

@property (nonatomic,strong) NSString *city_selected;

@property (nonatomic) BOOL isMultiSelect;

@end
