//
//  HR_ResumeListCell.h
//  JobKnow
//
//  Created by Suny on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRReumeModel.h"
#import "EGOImageView.h"

@protocol HR_ResumeListCellDelegate <NSObject>
@optional
- (void)addResumePrice:(HRReumeModel *)resumeModel IndexPath:(NSIndexPath *)indexPath;
@end

@interface HR_ResumeListCell : UITableViewCell

-(void)setModel:(HRReumeModel *)model;

@property(nonatomic,assign) id<HR_ResumeListCellDelegate>delegate;

@property(nonatomic,strong) HRReumeModel *resumeModel;

@property(nonatomic,strong) NSIndexPath *indexPath;

@end
