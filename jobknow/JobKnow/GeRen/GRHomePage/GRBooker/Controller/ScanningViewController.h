//
//  ScanningViewController.h
//  JobKnow
//
//  Created by Zuo on 13-11-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LDProgressView.h"
#import "SearchModel.h"
#import "UserDatabase.h"
#import "GRBookerModel.h"
#import "GRCityInfoNumsModel.h"

@protocol ScanningViewDelegate<NSObject>
@optional
- (void)scanningVC;
@end

@interface ScanningViewController : BaseViewController<SendRequest,UIScrollViewDelegate>
{
    BOOL judge;  //用来判断是否正在下载数据，（如果没有现在完成不能返回订阅界面）
    
    NSInteger i;
    
    NSString *fromWhereStr;//判断是从哪个界面进入当前scanningVC的
    
    NSDictionary *resultDic;//取出发送过来的字典中的字典
    
    NSDictionary *resultDic2;//接受发送过来的字典
    
    UIScrollView *scrollview;
    
    LDProgressView *progressView;
    
    OLGhostAlertView *ghostView;
    
    NetWorkConnection *net;
    
    UserDatabase *db;
}

@property(nonatomic,strong) NSString *todayStr;
@property(nonatomic,strong) NSString *totalStr;

@property(nonatomic,strong) NSString *fromWhereStr;//判断程序是从哪个界面进入ScanningVC的。

@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) SearchModel *searchModel;

@property(nonatomic,assign) id<ScanningViewDelegate>delegate;

@property(nonatomic,strong) GRBookerModel *model_booker;

@property(nonatomic,strong) GRCityInfoNumsModel *model_cityInfo;

@property(nonatomic,strong) NSMutableArray *array_model_booker;

@property(nonatomic) BOOL isFromRegister;


@end
