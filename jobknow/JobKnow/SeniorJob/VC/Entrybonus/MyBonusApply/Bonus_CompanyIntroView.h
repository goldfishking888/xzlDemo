//
//  Bonus_CompanyIntroView.h
//  JobKnow
//
//  Created by Suny on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ContactView.h"
#import "CustomLabel.h"
#import "HRHomeIntroduceModel.h"
#import "ContactView.h"
#import "Bonus_JobDetailView.h"
#import "SeniorJobDetailModel.h"

@interface Bonus_CompanyIntroView : ContactView <Bonus_JobDetailViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)BOOL isDownLoad;

@property(nonatomic,assign)NSInteger count; //count记录屏幕下方的cell的个数(地址，地图等)

@property(nonatomic,assign)NSInteger natureHeight;//属性高度
@property(nonatomic,assign)NSInteger industryHeight;//行业高度
@property(nonatomic,assign)NSInteger introductionHeight;//企业简介高度

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;

@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)SeniorJobDetailModel *positionModel;

@property(nonatomic,strong) CustomLabel *companyName;
@property(nonatomic,strong) CustomLabel *companyNature;
@property(nonatomic,strong) CustomLabel *companyIndustry;
@property(nonatomic,strong) CustomLabel *companyIntroduce;

@property(nonatomic,assign) id <Bonus_JobDetailViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame  withModel:(SeniorJobDetailModel *)model;

@end
