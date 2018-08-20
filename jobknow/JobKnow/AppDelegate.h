//
//  AppDelegate.h
//  JobKnow
//
//  Created by faxin sun on 13-2-28.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@class HomeViewController;


#import "ASIHTTPRequest/ASIDownloadCache.h"
#import "WXApi.h"
#import "sdkCall.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件
//5.0使用
#import "XZLLoginVC.h"
#import "GRRootViewController.h"
#import "HRRootTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,WXApiDelegate,TencentSessionDelegate,BMKGeneralDelegate,CLLocationManagerDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>
{
    Reachability *reachAbility;
    
    XZLLoginVC * loginRootVC;
    
    GRRootViewController *GRRootVC;
    
    HRRootTabBarViewController * HRRootVC;
    
    UIAlertView *alert;
}

@property(nonatomic,strong)NSString *urlStr;

@property(nonatomic,strong)NSMutableArray *cityArray;       //存放的是城市信息

@property(nonatomic,strong)NSMutableArray *hotCityArray;    //热门城市信息

@property(nonatomic,strong)NSMutableArray *dataArray;       //数据源，用来显示今日新增职位的数据源

@property(nonatomic,strong)UIWindow *window;

@property (nonatomic,strong)ASIHTTPRequest *request;

@property(nonatomic,strong)ASIDownloadCache *myCache;

- (void)initUMSocialData;
- (void)setRootVC;

- (void)showNet:(NetworkStatus)status;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) CLLocationManager *locationManager;

//5.0以后
- (void)SetRootVC:(NSString *)GRstatus;

//更新 用户信息
-(void)updateUserInfo;
@end
