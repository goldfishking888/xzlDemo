//
//  ReadTableView.h
//  JobsGather
//
//  Created by faxin sun on 13-2-16.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "GRBookerModel.h"
#import "myButton.h"
#import "UserDatabase.h"

@protocol ReadTableViewDelegate <NSObject>
@optional
- (void)readTableBeginDownload;//前两个代理方法用来展示和关闭网络加载
- (void)readTableEndDownload;//结束下载，主要用来开始和关闭loadView
- (void)readTableViewChange:(GRBookerModel *)model;//进入职位查看界面的方法
@end

@interface ReadTableView : UITableView <SendRequest,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger index;
    
    NSInteger today;
    
    NSInteger total;

    RTLabel *addLabel;//已设置的订阅器
    
    RTLabel *todayLabel;//详细职位订阅器
    
    UIButton *btn_edit;//编辑按钮
    
    RTLabel*totalLabel;
    
    UserDatabase *db;
    
    GRBookerModel *myModel;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
}

@property (nonatomic, assign) BOOL isAlter;     //用来判断是否处于修改状态

@property (nonatomic, assign) NSInteger tableViewHeight;    //tableViewHeight最后得到的是tableView的高度

@property (nonatomic, strong) NSMutableArray *dataArray;    //数据源

@property (nonatomic, strong) myButton *alterBtn;           //修改按钮

@property (nonatomic, strong) ReadTableView *readTV;

@property (nonatomic, assign) id<ReadTableViewDelegate>readDelegate;

/*
    1.用来显示cell右侧（今日新增，累计新增）的数据
 
    2.传入的参数是今日新增和累计新增的数量。
 
    3.返回的是label
 */

- (UILabel *)labelForCell:(NSString *)count Total:(NSString *)total backViewFrame:(CGRect)backViewFrame;

/*
 
 
*/

- (CGPoint)setLabelCenterX:(CGFloat)x Y:(CGFloat)y;

/*
 
 
 */
- (CGFloat)textLableHeightWithString:(NSString *)str Width:(CGFloat)width;//得到cell的高度

@end
