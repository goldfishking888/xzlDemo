//
//  DetailView.h
//  JobKnow
//
//  Created by Zuo on 14-2-11.
//  Copyright (c) 2014年 lxw. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "UserDatabase.h"
#import "ReadTableView.h"

@protocol detailViewDelegate <NSObject>
@optional
- (void)detailViewChange:(NSString *)str  andBOOL:(BOOL)isEmpty;    //进入不同的界面
- (void)detailViewChange2:(JobModel *)model;                        //这个方法的作用是进入选择的职位查看界面
@end

@interface DetailView : UIView<SendRequest,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ReadTableViewDelegate>
{
    int num;
    
    NSString *textFieldStr;
    
    NSArray *selectListArray;//存放地区，行业，职业，待遇四个字符串
    
    UserDatabase *db;
    
    NSUserDefaults *userDefaults;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    
    NetWorkConnection *net;
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,assign)BOOL isEmpty;

@property(nonatomic,strong)NSString *optionString;//有用

@property(nonatomic,strong)UITextField *jobTextField;

@property(nonatomic,strong)UIImageView *searchImage;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)ReadTableView *readTV;

@property(nonatomic,assign)id<detailViewDelegate>delegate;

@end
