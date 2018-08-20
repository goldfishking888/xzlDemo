//
//  WorkEXPTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkEXPModel;
@protocol WorkEXPTableViewCellDelegate <NSObject>
@optional
- (void)editWorkEXPItem:(WorkEXPModel *)model IndexPath:(NSIndexPath *)indexPath;
@end

@interface WorkEXPTableViewCell : UITableViewCell

@property (nonatomic,strong) WorkEXPModel *model;

@property (nonatomic) NSInteger type;//一共四种0,1,2,3

@property (nonatomic,assign) id<WorkEXPTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
