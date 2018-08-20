//
//  Bonus_JobDetailView.h
//  JobKnow
//
//  Created by Suny on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ContactView.h"
#import "RTLabel.h"
#import "ContactView.h"
#import "SeniorJobDetailModel.h"


@protocol Bonus_JobDetailViewDelegate<NSObject>
@optional
-(void)changeScreenHeight:(NSInteger)height;    //改变scrollView的大小

-(void)baidu:(NSString *)urlStr andTag:(NSString *)tag;//百度搜索方法
-(void)telephone:(NSString *)telephoneStr;          //电话
-(void)email:(NSString *)emailStr;                  //email
-(void)address:(NSString *)addressStr;              //地图
-(void)toRuzhiJiangjinJieshao;
@end

@interface Bonus_JobDetailView : ContactView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    int index_default;
}

@property(nonatomic,assign)NSInteger height;
@property(nonatomic,assign)NSInteger requireHeight;

@property(nonatomic,assign)NSInteger count;//count记录最下面5个选项（网址，邮箱等）总共有几个。

@property(nonatomic,strong)SeniorJobDetailModel *positionModel;

@property(nonatomic,strong)CustomLabel *jobName;//工作名称

@property(nonatomic,strong)UILabel *areaLab;      //工作地点
@property(nonatomic,strong)RTLabel *salaryLab;    //薪资待遇
@property(nonatomic,strong)UILabel *pubDateLab;   //发布日期
@property(nonatomic,strong)UILabel *finishDateLab;//截止日期

@property(nonatomic,strong)UILabel *degreeLab;    //学历要求
@property(nonatomic,strong)UILabel *numberLab;    //招聘人数
@property(nonatomic,strong)UILabel *workExperienceLab;//工作经验
@property(nonatomic,strong)UILabel *yearLab;      //年龄要求

@property(nonatomic,strong)UILabel *jobDescription;//职位描述标题(四个大字
@property(nonatomic,strong)CustomLabel *require; //职位描述细节)

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArray1;

/*1.邮箱2.网址3.地址*/
@property(nonatomic,strong)NSMutableArray *dataArray2;//存放的是字符串

@property(nonatomic,strong)UITableView *myTableView;

@property(nonatomic,assign)id <Bonus_JobDetailViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithJobDetail:(SeniorJobDetailModel *)model;
- (void)resetDataArray:(SeniorJobDetailModel *)model;
@end
