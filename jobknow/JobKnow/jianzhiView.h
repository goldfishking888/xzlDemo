//
//  jianzhiView.h
//  JobKnow
//
//  Created by Zuo on 13-12-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "HeadView.h"
#import "MyButton.h"
#import "UserDatabase.h"

@protocol JianzhiDelegate
@optional
-(void)jianzhiViewSelected:(JobModel *)model;//进入职位查看界面
@end

@interface jianzhiView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SendRequest,HeadViewDelegate>
{
    BOOL isClick;//判断订阅器是否处于编辑状态
    
    NSInteger num;//判断是否是iOS7，是的话num为20，否则num为0
    
    NSInteger status;
    NSInteger index;
    NSInteger currentRow;
    NSInteger currentSection;
    NSInteger myTag; //点击按钮的tag值
    
    NSString *titleStr;//每个按钮的名称
    
    NSMutableArray *dataArray;   //jianzhiView数据源
    NSMutableArray *headViewArray;//存放HeadView的数组
    
    myButton *bianjiBtn;//编辑按钮
    
    UserDatabase *db;
    NSUserDefaults *userDefaults;
    
    OLGhostAlertView *ghostView;
    MBProgressHUD *loadView;
    
    RTLabel *allReaderLabel;
    RTLabel *totalAddLabel;
}

@property(nonatomic,strong)NSString *cityStr;
@property(nonatomic,strong)NSString *cityCodeStr;

@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *myScrollView;
@property(nonatomic,assign)id<JianzhiDelegate>delegate;
@end
