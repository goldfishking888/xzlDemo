//
//  ResumeFilterView.h
//  JobKnow
//
//  Created by Suny on 15/8/7.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRJobSortModel.h"

@protocol ResumeFilterViewDelegate <NSObject>
@optional
- (void)resumeFilterViewChange:(HRJobSortModel *)model_JobSort;
@end

@interface ResumeFilterView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger num;
    NSMutableArray *dataArray;
    
    UITableView *myTableView;
}

@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,assign)id<ResumeFilterViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)array;
@end
