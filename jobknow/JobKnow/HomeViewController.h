//
//  HomeViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-2-28.
//  Copyright (c) 2013年 lxw. All rights reserved.

#import <UIKit/UIKit.h>
#import "UserDatabase.h"

@class UserDatabase;

@class LoginViewController;

@class ASINetworkQueue;

@class ReaderViewController;

#import "allCityViewController.h"

#import "NewReadView.h"

#import "XZLLocaRead.h"

#import "ICSDrawerController.h"

#import "SeniorJobListViewController.h"

#import "SeniorJobRightViewController.h"

@interface HomeViewController : BaseViewController <SendRequest,UIScrollViewDelegate,CityDelegate,NewReadDelegate,CLLocationManagerDelegate>
{
    int num;

    NSString *cityStr;
    
    NSMutableArray *hotCityArray;
    
    UIButton *cityBtn;       //城市按钮
    
    UIButton *sxBtn;        //私信新增职位数
    
    UIButton *readCountBtn;    //订阅器新增职位数
    
    UIButton *positionBigDataBtn; //职位大数据今日新增职位数
    
    UIButton *sixinCountBtn; //职位大数据今日新增职位数
    
    UserDatabase *db;
    
    OLGhostAlertView *ghostView;
    
    NSUserDefaults *userDefaults;
    
    MBProgressHUD *loadView;
    
    UILabel *titleLabel_1;
    UILabel *titleLabel_2;
}

@property(nonatomic,strong)ASINetworkQueue *netWorkQueue;


@property (strong, nonatomic) CLLocationManager *locationManager;

@end