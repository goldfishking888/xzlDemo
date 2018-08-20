//
//  AppDelegate.m
//  JobKnow
//
//  Created by faxin sun on 13-2-28.
//  Copyright (c) 2013年 lxw. All rights reserved.

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "FuwuznViewController.h"
#import "SinaWeibo.h"
#import "WBShareKit.h"
#import "BaiduMobStat.h"
#import "sdkAuth.h"
#import "MobClick.h"
#import "WXApi.h"
#import "JPUSHService.h"

#import "Config.h"
#import "UserDatabase.h"
#import "NetWorkConnection.h"
#import "ZhangXinBaoViewController.h"

#import "HR_HomeViewController.h"
#import "SaveCount.h"
#import "LeftSlideViewController.h"
#import "HRLeftMenuViewController.h"



//**启动广告相关**
#import "XHLaunchAdManager.h"
#import "XHLaunchAd.h"
#import "Network.h"
#import "LaunchAdModel.h"
//**启动广告相关**

//#import "BMKMapManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "Harpy.h"

#import "BPush.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AlipaySDK/AlipaySDK.h>


#import <UMSocialCore/UMSocialCore.h>
//#import "HR_JobDetailVC.h"


#define UmengAppkey @"51a304545270157994000015"

#define BaiduMapAppkey @"bnzuIpNY2HaNH468byxx4IwO"

BMKMapManager* _mapManager;

@implementation AppDelegate

- (void)initData
{
    _cityArray=[[NSMutableArray alloc]init];
    
    _hotCityArray=[[NSMutableArray alloc]init];
    
    _dataArray=[[NSMutableArray alloc]init];
    
    alert = [[UIAlertView alloc] initWithTitle:@"网络不可用" message:@"请检查网络，无网络时无法查看最新信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Fabric 崩溃收集
    [Fabric with:@[[Crashlytics class]]];
    
    [self initUMSocialData]; //初始化友盟数据
    
    //baidumap
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiduMapAppkey generalDelegate:self];
    
    if (!ret) {
        NSLog(@"百度地图manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    [application setStatusBarHidden:NO]; //以下两行代码的作用是设置标题栏字体颜色

    
    // 百度统计
    BaiduMobStat *mobStat = [BaiduMobStat defaultStat]; //设置数据统计
    [mobStat startWithAppId:@"3a6da92633"];
    mobStat.enableExceptionLog= NO;     //设置是否启用应用崩溃日志手机的功能
    mobStat.channelId = @"AppStore";    //频道
    mobStat.logSendWifiOnly = NO;      //只有在wifi状态下才会发送
    mobStat.logSendInterval = 1;/*为应用更高精度的统计日志发送间隔选择，最小间隔为1小时，最大间隔为1天*/
    mobStat.sessionResumeInterval = 60;
    
//    ASIDownloadCache *cache=[[ASIDownloadCache alloc]init]; //设置缓存
//    self.myCache=cache;
//    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [pathArr objectAtIndex:0];
//    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resourcejob"]];
//    [self.myCache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];//设置缓存策略
    
    //检测网络,设置完成之后，一旦网络连接状态发生改变，就会调用reachabilityChanged:方法
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    reachAbility = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachAbility startNotifier];
    
    //注册检测AppStore审核状态、最新版本通知，该通知在个人版、HR首页viewwillappear回调里发起
    [self setASCheckVersionEanbled:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNoti:) name:@"AppStoreCheck" object:@1];
    
    //注册消息推送
    //初始化百度推送
    [self initBaiduPushWithapplication:application FinishLaunchingOptions:launchOptions];
 
    //设置根视图
    [self  initWhenInstalled];
    [self SetRootVC:[XZLUserInfoTool getGRStatus]];
    //更新用户信息
    [XZLUserInfoTool updateUserInfo];
    
    
    [self.window makeKeyAndVisible];
    
//    //新版本检测
//    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
//    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
//    //选择更新
//    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
//    [[Harpy sharedInstance] checkVersion];
    
    return YES;
}

//初始化百度推送
-(void)initBaiduPushWithapplication:(UIApplication *)application FinishLaunchingOptions:(NSDictionary *)launchOptions{
    // iOS10 下需要使用新的 API
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];

        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"bnzuIpNY2HaNH468byxx4IwO" pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:NO isDebug:YES];
    // 禁用地理位置推送 需要再绑定接口前调用。
    
    [BPush disableLbs];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


-(void)checkNoti:(NSNotification *)noti{
    NSNumber *num = noti.object;
    if ([num  isEqual: @1]) {
        [self setASCheckVersionEanbled:true];
    }else{
        [self setASCheckVersionEanbled:false];
    }
}

-(void)setASCheckVersionEanbled:(BOOL)enable{
    //先默认开启
    
    if (enable) {
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        [paramDic setValue:@"1" forKey:@"fromPlatform"];
        
        NSString * url = [NSString stringWithFormat:@"%@%@",KAPPAPI,kAppCheck];
        
        [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject){
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"responseObject is %@",responseObject);
                NSNumber *error_code = responseObject[@"error_code"];
                if ([error_code isEqualToNumber:@0]) {
                    NSDictionary *dic = responseObject[@"data"];
                    NSString *currentAppVersion = [kAppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                    if (currentAppVersion.length == 2) {
                        currentAppVersion = [currentAppVersion stringByAppendingString:@"0"];
                    }
                    //最新版本号
                    NSString *webVersion = [dic[@"version_number"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    //iOS审核状态 1审核中 0非审核
                    NSNumber *numStatus = dic[@"version_status"];
                    //iOS审核版本号
                    NSString *stringIncheckVersion = [dic[@"version_status_incheck"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    //                    NSNumber *numStatus = @0;
                    if (stringIncheckVersion.length == 2) {
                        stringIncheckVersion = [stringIncheckVersion stringByAppendingString:@"0"];
                    }
                    //是否强制更新（需配合最新版本号使用）
                    NSNumber *numForce = dic[@"version_force"];
                    //                    NSNumber *numForce = @0;
                    //新版本功能
                    NSString *version_mark = dic[@"version_remark"];
                    version_mark = [version_mark stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
                    version_mark = [version_mark stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];
                    //Itunes地址
                    NSString *version_url = dic[@"version_url"];
                    
                    //默认不开启审核，根据审核中版本号及审核状态联合判断是否修改审核状态
                    //提交审核时，修改version_status_incheck 为待审核的版本号，修改version_status 为1
                    //审核成功后，修改version_number为最新版本（审核成功的版本），version_status_incheck无需修改，修改version_status 为0，如需强制更新修改version_force为1
                    [mUserDefaults setValue:[NSString stringWithFormat:@"%@",@"0"] forKey:HideForCheck];
                    if (stringIncheckVersion.integerValue==currentAppVersion.integerValue) {
                        [mUserDefaults setValue:[NSString stringWithFormat:@"%@",numStatus] forKey:HideForCheck];
                    }
                    if([XZLUtil isLogin] == YES) {
                        NSString *userName =[mUserDefaults valueForKey:@"company_email"];
                        if (userName&&userName.length>0&&[userName respondsToSelector:@selector(isEqualToString:)]&&[userName isEqualToString:AccountForCheck]) {
                            [mUserDefaults setValue:HideForCheck_Value forKey:HideForCheck];
                        }
                    }
                    
                    //最新版本>本地版本
                    if (webVersion.integerValue>currentAppVersion.integerValue) {
                    
                        if (numForce.integerValue == 1) {
                            //当前版本需要强制更新
                            
                            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:[NSString stringWithFormat:@"新版本%@",dic[@"version_number"]]
                                                                                   icon:nil
                                                                                message:version_mark
                                                                        leftActionTitle:@"立即升级"
                                                                       rightActionTitle:nil
                                                                         animationStyle:SRAlertViewAnimationNone
                                                                      selectActionBlock:^(SRAlertViewActionType actionType) {
                                                                          NSLog(@"%zd", actionType);
                                                                          NSString *encodedValue = [version_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                                          NSURL *url = [[NSURL alloc] initWithString:encodedValue];
                                                                          [[UIApplication sharedApplication ] openURL: url];
                                                                          [XZLUtil exitApplication];
                                                                      }];
                            alertView.blurEffect = NO;
                            [alertView show];
                        }else{
                            //当前版本不需要强制更新
                            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:[NSString stringWithFormat:@"新版本%@",dic[@"version_number"]]
                                                                                   icon:nil
                                                                                message:version_mark
                                                                        leftActionTitle:@"取消"
                                                                       rightActionTitle:@"立即升级"
                                                                         animationStyle:SRAlertViewAnimationNone
                                                                      selectActionBlock:^(SRAlertViewActionType actionType) {
                                                                          NSLog(@"%zd", actionType);
                                                                          if (actionType!=0) {
                                                                              NSString *encodedValue = [version_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                                              NSURL *url = [[NSURL alloc] initWithString:encodedValue];
                                                                              [[UIApplication sharedApplication ] openURL: url];
                                                                          }
                                                                      }];
                            alertView.blurEffect = NO;
                            [alertView show];

                        }
                    }
                    
                }else{
                    
                }
            }else{
            }
        }failure:^(NSError *error){
            NSLog(@"error is %@",error);
        }];
        
    }else{
        //关闭
        [mUserDefaults setValue:[NSString stringWithFormat:@"%@",@"0"] forKey:HideForCheck];
    }
    
}

- (void)SetRootVC:(NSString *)GRstatus{
    
    if (![XZLUserInfoTool isLogin]) {
        loginRootVC = [[XZLLoginVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginRootVC];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
        return;
    }
   
    if ([GRstatus isEqualToString:@"0"]) {
        GRRootVC = [[GRRootViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:GRRootVC];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    }else if ([GRstatus isEqualToString:@"1"]){
        HRRootVC = [[HRRootTabBarViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:HRRootVC];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    //XZLLoginVC * rootVC = [[XZLLoginVC alloc]init];
    }
}



- (void)initWhenInstalled
{
    
    if ([self isFirstBoot]) {
        ////        FuwuznViewController *fuwu = [[FuwuznViewController alloc]init];
        ////        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fuwu];
        ////        [nav setNavigationBarHidden:YES];
        ////        self.window.rootViewController = nav;
        //
        //        //初次登录从本地读取所有code json文件到userdefault
        [XZLCodeFileTool resetAllCode];
    }
    [XZLCodeFileTool checkCodeVersions];

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


//注册deviceToken失败

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取deviceToken失败--%@",error);
    SaveCount *save=[SaveCount standerDefault];
    save.deviceToken = @"getDeviceTokenErrornononononono";
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"The Device token is:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        //        [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
        
        NSLog(@"Method: %@\n%@",BPushRequestMethodBind,result);
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            [mUserDefaults setValue:result[@"channel_id"] forKey:@"BChannelId"];
            [mUserDefaults setValue:result[@"user_id"] forKey:@"BUserId"];
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
    
    NSString *deviceTokenStr = [[NSString alloc] initWithFormat:@"%@",deviceToken];
    
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0,72)] substringWithRange:NSMakeRange(1,71)];
    
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"截取后的deviceToken，deviceTokenStr=====%@",deviceTokenStr);
    
    [[NSUserDefaults standardUserDefaults]setValue:deviceTokenStr forKey:@"deviceToken"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    SaveCount *save=[SaveCount standerDefault];
    
    save.deviceToken = deviceTokenStr;
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //    if (application.applicationState == UIApplicationStateActive) {
    //        [self setSixinCount:@"1"];
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
    //        [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
    //        [JPUSHService resetBadge];
    //    }
    //    // IOS 7 Support Required
    //    [JPUSHService handleRemoteNotification:userInfo];
    //    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"********** iOS7.0之后 background **********");
    if (application.applicationState == UIApplicationStateActive) {
        [self setSixinCount:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:@1];
        [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
    }
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"backgroud : %@",userInfo);
    //    XZLPMDetailModel *model = [XZLPMDetailModel modelWithJSON:[userInfo valueForKey:@"json"]];
    
    if (application.applicationState == UIApplicationStateInactive||application.applicationState == UIApplicationStateBackground){
        
        //        XZLPMListViewController *list = [[XZLPMListViewController alloc] init];
        //        [((UINavigationController *)self.window.rootViewController) pushViewController:list animated:YES];
    }
    
}

//即将进入后台

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

//程序进入后台

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

//程序即将进入激活状态
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetHRLoginOtherLoginView" object:nil];
}

//程序已经进入激活状态
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
    NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badgeNum > 0) {
        [self setSixinCount:[NSString stringWithFormat:@"%ld",(long)badgeNum]];
        [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
        [JPUSHService resetBadge];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HUDDismissNotification" object:nil userInfo:nil];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            return YES;
        }

    }
    
    
    return  result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:resultDic];
                                
                
            }];
            
        }
        return YES;

    }
    return result;
}


//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//    
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            NSNumber *resultStatus = resultDic[@"resultStatus"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:resultDic];
//            
//        }];
//        return YES;
//    }
//
//    return  YES;
//}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *string =[url absoluteString];
    
    if ([string hasPrefix:@"tencent100832444"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}

#pragma mark 功能函数

- (void)initUMSocialData//初始化友盟数据
{
//    [UMSocialData openLog:NO];
//    
//    [UMSocialData setAppKey:UmengAppkey];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"raisesintro/raisesUrl?"];
//    
//    //设置微信AppID和url地址
//    [UMSocialWechatHandler setWXAppId:@"wx8840f26e9334b3d6" appSecret:@"ce674a092091c98ce9006939ce05170d" url:urlStr];
//    
//    //打开新浪微博的sso开关
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    
//    //打开腾讯微博sso开关，设置回调地址
//    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/sina2/callback"];
//    [UMSocialQQHandler setSupportWebView:YES];
//    //设置分享到qq空间和手机qq的应用ID，和分享url链接
//    [UMSocialQQHandler setQQWithAppId:@"1104693989" appKey:@"BKvIzaKgUsoareJC" url:urlStr];
//    
//    [MobClick startWithAppkey:UmengAppkey];
//    
//    
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToTencent]];
    
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAppkey];
    
    [self configUSharePlatforms];
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8840f26e9334b3d6" appSecret:@"ce674a092091c98ce9006939ce05170d" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104693989"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1130844880"  appSecret:@"bfc073e08ee61244407ef5b454d3f0d1" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

    
}

- (BOOL)judgmentLogin//判断是否已经登录
{
    
    BOOL isLogin = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginNew"]] isEqualToString:@"0"];
    if( kUserTokenStr!= nil && ![kUserTokenStr isEqual: @""] && isLogin){
        return YES;
    }
    else{
        return NO;
    }
    //    NSUserDefaults *AppUD = [NSUserDefaults standardUserDefaults];
    //
    //    NSString *pwd = [AppUD valueForKey:@"passWord"];
    //
    //    if(pwd.length>0)
    //    {
    //        return YES;
    //    }else
    //    {
    //        return NO;
    //    }
}

#pragma mark 监听网络

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    [self showNet:status];
}

//检查当前网络状态，无网络的时候提示

- (void)showNet:(NetworkStatus)status
{
    Net *net = [Net standerDefault];
    
    //NSLog(@"showNet..................");
    
    switch (status) {
            
        case NotReachable:
        {
            net.status = NotReachable;
            
            [alert show];
            
        }
            //NSLog(@"-----------无网络");
            break;
            
        case ReachableViaWiFi:
            
            net.status = ReachableViaWiFi;
            
            [alert dismissWithClickedButtonIndex:0 animated:NO];
            
            //NSLog(@"-----------wifi");
            
            break;
            
        default:
            
            net.status = ReachableViaWWAN;
            
            //NSLog(@"-----------手机网络");
            
            [alert dismissWithClickedButtonIndex:0 animated:NO];
            
            break;
    }
}


#pragma mark - JPush


- (void)initJPush:(NSDictionary *)launchOptions{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (application.applicationState == UIApplicationStateActive) {
        [self setSixinCount:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
        NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
        [UIApplication sharedApplication].applicationIconBadgeNumber= 0;
        [JPUSHService resetBadge];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark 设置未读私信数量
- (void)setSixinCount:(NSString *)count{
    NSString *userUid = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"userUid"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mUserDefaults valueForKey:@"SixinCount"]];
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
        [dic setValue:count forKey:userUid];
    }else{
        NSString *original_count = [dic valueForKey:userUid];
        if (!original_count||[original_count isEqual:@""]||[original_count isEqual:@"0"]) {
            [dic setValue:count forKey:userUid];
        }else{
            NSInteger totalCount = ((NSString *)[dic valueForKey:userUid]).integerValue + count.integerValue;
            [dic setValue:[NSString stringWithFormat:@"%ld",(long)totalCount] forKey:userUid];
        }
    }
    [mUserDefaults setObject:dic forKey:@"SixinCount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetSiXinCount" object:nil];
}

#pragma mark - 判读APP是否第一次启动
- (BOOL)isFirstBoot
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"firstLaunch"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        return YES;
    }
    
    return NO;
}

@end
