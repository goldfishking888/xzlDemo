//
//  ProjectEXPTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectEXPModel;
@protocol ProjectEXPTableViewCellDelegate <NSObject>
@optional
- (void)editProjectEXPItem:(ProjectEXPModel *)model IndexPath:(NSIndexPath *)indexPath;
@end

@interface ProjectEXPTableViewCell : UITableViewCell

@property (nonatomic,strong) ProjectEXPModel *model;

@property (nonatomic) NSInteger type;//一共四种0,1,2,3

@property (nonatomic,assign) id<ProjectEXPTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
