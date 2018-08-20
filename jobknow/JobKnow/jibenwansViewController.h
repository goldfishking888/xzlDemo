//
//  jibenwansViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomSheet.h"
#import "jiben2ViewController.h"
#import "allCViewController.h"
#import "KTSelectDatePicker.h"

@protocol jbxxwsDeleat <NSObject>
- (void)chuanonDic:(NSDictionary*)dic;
@end

@interface jibenwansViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,chuancDeleat,ChuancityDelegate,UITextFieldDelegate,SendRequest>
{
     UIScrollView *myScrollow;
    UITableView *myTabView;
    KTSelectDatePicker *_datePicker;
    NSString *dateStr;  //出生日期
    NSString *ztStr;    //求职状态
    NSString *yxStr;    //月薪
    NSString *hunyuStr;  //婚育
    NSString *cityStr;  //城市
    NSString *cityCode;
    UITextField *companyName;
    MBProgressHUD *loadView;
    OLGhostAlertView *alert;
    NSString *tipString;
}
@property(nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic,assign)id<jbxxwsDeleat>deleate;
@end
