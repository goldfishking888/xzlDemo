//
//  CompanyIntroduce.h
//  JobKnow
//
//  Created by faxin sun on 13-3-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"
#import "PositionModel.h"
#import "ContactView.h"
#import "JobDetailView.h"

@interface CompanyIntroduce : ContactView <JobDetailViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)BOOL isDownLoad;

@property(nonatomic,assign)NSInteger count; //count记录屏幕下方的cell的个数(地址，地图等)

@property(nonatomic,assign)NSInteger natureHeight;//属性高度
@property(nonatomic,assign)NSInteger industryHeight;//行业高度
@property(nonatomic,assign)NSInteger introductionHeight;//企业简介高度

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableDictionary *companyDic;

@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)PositionModel *positionModel;

@property(nonatomic,strong) CustomLabel *companyName;
@property(nonatomic,strong) CustomLabel *companyNature;
@property(nonatomic,strong) CustomLabel *companyIndustry;
@property(nonatomic,strong) CustomLabel *companySize;
@property(nonatomic,strong) CustomLabel *companyIntroduce;

@property(nonatomic,assign) id <JobDetailVDelegate> delegate;

- (id)initWithFrame:(CGRect)frame  withModel:(PositionModel *)model;
@end
