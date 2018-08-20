//
//  TrainEXPTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrainEXPModel;
@protocol TrainEXPTableViewCellDelegate <NSObject>
@optional
- (void)editTrainEXPItem:(TrainEXPModel *)model IndexPath:(NSIndexPath *)indexPath;
@end

@interface TrainEXPTableViewCell : UITableViewCell

@property (nonatomic,strong) TrainEXPModel *model;

@property (nonatomic) NSInteger type;//一共四种0,1,2,3

@property (nonatomic,assign) id<TrainEXPTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
