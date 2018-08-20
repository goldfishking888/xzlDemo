//
//  qiuzhiyxViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "PositionsViewController.h"
#import "JobItemViewController.h"
#import "jiben2ViewController.h"
typedef enum ExpectOption
{
    ExpectIndustry,
    ExpectJob,
    ExpectJobType,
    ExpectSalary,
    ExpectLocal,
    ExpectNone
}ExceptType;
@protocol qzyxDeleat <NSObject>
- (void)chuanInDic:(NSDictionary*)dic;

@end

@interface qiuzhiyxViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,chuancDeleat>
{
    UITableView *myTabView;
    NSString *xinzhi;//薪资
    NSString *leibie;//工作类型
    NSString *industry;
    NSString *job;
    NSString *local;
    NSString *localCode;
    NSString *tipString;
    ExceptType item;
    OLGhostAlertView *alertView;
}
@property (nonatomic, assign) ExceptType item;
@property (nonatomic,assign)id<qzyxDeleat>deleate;
@end
