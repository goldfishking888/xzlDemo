//
//  JobFairViewController.h
//  JobsGather
//
//  Created by faxin sun on 12-11-21.
//  Copyright (c) 2012年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPInfo.h"
#import "ZPDetailViewController.h"
#import "allCityViewController.h"
@class CityInfo;
typedef enum RequestTyp
{
    requestTypeZP,
    requestTypeUnivercity,
    requestTypeOneUnivercity
}requestTypeOptio;
@interface JobFairViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,NSURLConnectionDataDelegate,SendRequest,CityDelegate>{
    
    UITableView *theTableView;
    NSMutableArray *fairsList;
    NSMutableData *receiveData;
    NSMutableArray *_univercityInfo;
    NSString *ViewTitle;
    UILabel *viewTitLabel;
    ZPInfo *single;
    NSInteger school;
    NSInteger u;//学校加载更多
    NSInteger s;//社会招聘会加载更多
    UIButton *selectUniver;
    UIButton *univerBtn;
    UIButton *societyBtn;
    //UILabel *titleLabel;
    CityInfo *myInfo;
    OLGhostAlertView *alert;
    BOOL isFirst;
    UIImageView *img;
    UILabel * cityLabel; //城市名称
    UIImageView *myImgView;
    float now_y;
    int num;
    
}
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, strong) UIButton *foot;
@property (nonatomic, copy) NSString *univercityName;
@property (nonatomic, strong) ActivetView *actView;//加载view
@property (nonatomic, assign) BOOL univercity;
@property (nonatomic, strong) NetWorkConnection *net;//网络请求
@property (nonatomic, strong) UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray *fairsList;//社会招聘会信息
@property (nonatomic, strong) NSMutableArray *univercityInfo;//学校招聘会信息
@property (nonatomic, assign) requestTypeOptio requestTypeItem;
@property (nonatomic, copy) NSString *ViewTitle;
@property (nonatomic, strong) UILabel *viewTitLabel;
@property (nonatomic, strong) NSMutableArray *univercitys;

@end
