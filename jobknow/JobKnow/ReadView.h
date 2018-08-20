//
//  ReadView.h
//  JobKnow
//
//  Created by liuxiaowu on 13-8-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDatabase.h"

@class jobModel;

@protocol ReadViewDelegate <NSObject>
@optional
- (void)readViewChange:(jobModel *)model1;
@end

@interface ReadView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger num;
    UserDatabase *db;
    NSMutableArray *dataArray;

    UITableView *myTableView;
}

@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,assign)id<ReadViewDelegate>delegate;
@end



