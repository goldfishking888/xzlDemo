//
//  EduEXPTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EduEXPModel;
@protocol EduEXPTableViewCellDelegate <NSObject>
@optional
- (void)editEduEXPItem:(EduEXPModel *)model IndexPath:(NSIndexPath *)indexPath;
@end

@interface EduEXPTableViewCell : UITableViewCell

@property (nonatomic,strong) EduEXPModel *model;

@property (nonatomic) NSInteger type;//一共四种0,1,2,3

@property (nonatomic,assign) id<EduEXPTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
