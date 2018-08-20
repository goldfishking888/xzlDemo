//
//  allCViewController.h
//  JobKnow
//
//  Created by Zuo on 13-11-19.
//  Copyright (c) 2013年 zuojia. All rights reserved.
//

#import "BaseViewController.h"

@class UserDatabase;

@protocol ChuancityDelegate <NSObject>
- (void)chuanCity:(NSString *)city cityCode:(NSString *)code;
@end

@interface allCViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest>
{
    int num;
    
    UserDatabase *db;
    
    MBProgressHUD *loadView;
}

@property (nonatomic,strong) NSArray *wordsArray;

@property (nonatomic,strong) NSMutableArray *cityArray;

@property (nonatomic,strong) NSMutableDictionary *cityDic;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) id<ChuancityDelegate>delegate;//将城市分组并放入字典

@end
