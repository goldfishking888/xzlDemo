//
//  SelectDetailViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-1-30.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//
#import "jobRead.h"
#import <UIKit/UIKit.h>

typedef enum jobReadType
{
    jobReadSalary, //薪资
    jobReadprope,
    jobReadPosition//职位
}jobReadType;


@protocol SelectVCDelegate <NSObject>
@optional
- (void)sendWithSelect:(jobRead *)select Option:(NSString *)option;
@end

@interface SelectDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    int num;
}

@property (nonatomic,strong)NSString *itemStr;      //判断是薪资还是工作性质
@property (nonatomic,strong)NSArray *showArray;     //薪资（或工作性质）
@property (nonatomic,strong)NSArray *codeArray;     //薪资代码（或工作性质的代码）

@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,assign)id <SelectVCDelegate> delegate;

+ (NSString *)jobReadType:(NSString *)str jobType:(jobReadType)type;

@end