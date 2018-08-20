//
//  GRBookPositionListViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/23.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "GRBookerModel.h"
#import "GRCityInfoNumsModel.h"
@interface GRBookPositionListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

// tableView
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)GRBookerModel *model;

@property(nonatomic,strong) GRCityInfoNumsModel *model_cityInfo;

@property(nonatomic,strong) NSMutableArray *array_model_booker;

@property(nonatomic) BOOL isFromRegister;

@end
