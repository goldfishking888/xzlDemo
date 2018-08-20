//
//  CompanyResultViewController.h
//  JobKnow
//
//  Created by Apple on 14-3-19.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "allCityViewController.h"
#import "UserDatabase.h"

@protocol ComResultDelegate <NSObject>
@optional
- (void)comResultChange;
@end

@interface CompanyResultViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SendRequest,CityDelegate>
{
    int num;
    
    NSInteger page;//记录当前页数
    NSInteger count;//记录订阅了几个职位
    NSString *textFieldStr;
    
    NSMutableArray *dataArray;
    UITextField*newTextfield;
    
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
    NetWorkConnection *net;
    
    NSUserDefaults *userDefaults;
    UserDatabase *db;
}

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *cityBtn;
@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,strong)UITableView *resultTableView;

@property (nonatomic,strong)UIImageView*searchImage;

@property(nonatomic,assign)id<ComResultDelegate>delegate;

@end
