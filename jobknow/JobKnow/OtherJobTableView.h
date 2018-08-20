//
//  OtherJobTableView.h
//  JobKnow
//
//  Created by faxin sun on 13-3-8.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myButton.h"
#import "PositionModel.h"
#import "ContactView.h"
#import "EGORefreshTableFooterView.h"

@protocol OtherJobDelegate

//进入职位查看界面
- (void)checkOtherJob:(NSMutableArray *)otherArray otherIndex:(NSInteger)index  AndJianzhi:(BOOL)jianzhi;

//修改postBtn的标题
-(void)changePostBtn:(NSString *)title;

@end

@interface OtherJobTableView : ContactView <UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,SendRequest>
{
    BOOL  reloading;
    NSInteger num;

    
    NSString * allCount;
    myButton *collectBtn;
    
    UITableView *myTableView;
    OLGhostAlertView *ghostView;
    EGORefreshTableFooterView *_refreshFooterView;
}

@property(nonatomic,assign)BOOL isJianzhi;//判断职位是否是兼职
@property(nonatomic,assign)BOOL detail;   //详细与否
@property(nonatomic,assign)NSInteger page;  //页数
@property(nonatomic,assign)NSInteger allcount;

@property(nonatomic,strong)NSString *cityCodeStr;

@property(nonatomic,strong)NSDictionary *otherDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)PositionModel *positionInfo;

@property(nonatomic,strong)UITableView *myTableView;

@property(nonatomic,strong)NetWorkConnection *net;
@property(nonatomic,strong)EGORefreshTableFooterView *refreshFooterView;
@property(nonatomic,assign)id <OtherJobDelegate> otherDelegate;

@property(nonatomic) BOOL *isNewAPI;//是否启用新接口(新接口返回数据格式不一样)

-(id)initWithFrame:(CGRect)frame withModel:(PositionModel *)model;
-(void)setFooterView;
-(void)removeFooterView;
@end
