//
//  HR_OtherJobListView.h
//  JobKnow
//
//  Created by Suny on 15/8/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ContactView.h"
#import "HRHomeIntroduceModel.h"
#import "ContactView.h"
#import "EGORefreshTableFooterView.h"

@protocol HR_OtherJobListViewDelegate

//进入职位查看界面
- (void)checkOtherJob:(NSMutableArray *)otherArray otherIndex:(NSInteger)index  AndJianzhi:(BOOL)jianzhi;

//修改postBtn的标题
-(void)changePostBtn:(NSString *)title;

@end

@interface HR_OtherJobListView : ContactView <UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,SendRequest>
{
    BOOL  reloading;
    NSInteger num;
    
    
    NSString * allCount;
//    myButton *collectBtn;
    
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
@property(nonatomic,strong)HRHomeIntroduceModel *positionInfo;

@property(nonatomic,strong)UITableView *myTableView;

@property(nonatomic,strong)NetWorkConnection *net;
@property(nonatomic,strong)EGORefreshTableFooterView *refreshFooterView;
@property(nonatomic,assign)id <HR_OtherJobListViewDelegate> otherDelegate;

-(id)initWithFrame:(CGRect)frame withModel:(HRHomeIntroduceModel *)model;
-(void)setFooterView;
-(void)removeFooterView;

@end
