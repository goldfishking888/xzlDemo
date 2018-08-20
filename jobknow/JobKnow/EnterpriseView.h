//
//  EnterpriseView.h
//  JobsGather
//
//  Created by faxin sun on 13-2-1.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "myButton.h"
#import "UserDatabase.h"

@protocol EnterDelegate
@optional
-(void)pushTextField;//进入订阅界面的代理方法
-(void)enterpriseViewSelected:(JobModel *)model;//进入职位查看的代理方法
@end

@interface EnterpriseView : UIView <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SendRequest>
{
    NSInteger num;
    UserDatabase *db;
    
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
    NSUserDefaults *userDefaults;
}

@property (nonatomic,assign)BOOL isAlter;
@property (nonatomic,assign)NSInteger myTag;
@property (nonatomic,assign)NSInteger today;//今日条数
@property (nonatomic,assign)NSInteger total;

@property (nonatomic,strong)NSMutableArray *readArray;//数据源
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIImageView *line2;
@property (nonatomic,strong)UIImageView *searchImage;

@property (nonatomic,strong) myButton *bianjiBtn;
@property (nonatomic,strong) RTLabel *numberRTLabel;
@property (nonatomic,strong) RTLabel *jobNumbersLabel;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) NetWorkConnection *net;

@property (nonatomic,strong) UIScrollView *myScrollView;
@property (nonatomic,strong) UITableView *companyTableView;
@property (nonatomic,assign) id <EnterDelegate>delegate;
@end