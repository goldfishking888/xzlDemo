//
//  CustomCell.h
//  JobKnow
//
//  Created by wangjinyu on 15/8/3.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRjobListmodel.h"

//#import "HrHomeVC.h"
#import "HR_HomeViewController.h"
@interface CustomCell : UITableViewCell
@property(nonatomic,retain)UILabel *zhiwei;
@property(nonatomic,retain)UILabel *gongsi;
@property(nonatomic,retain)UILabel *place;

@property(nonatomic,retain)UILabel *renshu;

@property(nonatomic,retain)UIImageView *imageViewhr;//￥图标
@property(nonatomic,retain)UILabel *money;



@property(nonatomic,retain)UILabel *labshoucang;//收藏

@property(nonatomic,retain)UILabel *labtuijian;//推荐

@property(nonatomic,retain)UILabel *labchakan;
@property(nonatomic,retain)UILabel *time;

@property(nonatomic,retain)UILabel *ren;
@property(nonatomic,retain)UILabel *Yuan;

@property(strong,nonatomic)HRjobListmodel *model;

@property(nonatomic,strong)HR_HomeViewController*homevc;




 
@end
