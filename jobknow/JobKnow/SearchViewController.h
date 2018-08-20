//
//  SearchViewController.h
//  JobKnow
//
//  Created by Zuo on 14-1-23.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myButton.h"
#import "allCityViewController.h"
#import "PositionsViewController.h"
#import "SelectDetailViewController.h"
#import "ScanningViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CityDelegate,positonViewDelegate,SelectVCDelegate,SendRequest,ScanningViewDelegate,UIActionSheetDelegate>
{
    NSDictionary *paramDic;//网络下载时用到
    UserDatabase *db;
    NSInteger num;
    OLGhostAlertView *ghostView;
}

@property(nonatomic,assign)BOOL isEmpty;


@property(nonatomic,assign)BOOL isClick;
@property(nonatomic,assign)BOOL isInsert;//判断当前model是否已经在数据库中

@property(nonatomic,assign)NSInteger btnHeight;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)NSString *option;//（职位类别，薪水，教育等）
@property(nonatomic,strong)NSMutableArray *selectArray; //
@property(nonatomic,strong)NSMutableArray *selectArray2;//

@property(nonatomic,strong)NSMutableArray *dataArray; //存放的数据是职位查看的结果。
@property(nonatomic,strong)NSMutableArray *dataArray2;//存放字符串

@property(nonatomic,strong)UILabel *_titleLabel;

@property (nonatomic,strong) UIImageView *searchImage;

@property(nonatomic,strong)UIButton *bianjiBtn;
@property(nonatomic,strong)UIScrollView *myScrollView;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UITableView *myTableView2;
@property(nonatomic,strong)UITextField *jobTextField;  //职位名称输入框

@property(nonatomic,strong)SearchModel *searchModel;

@end
