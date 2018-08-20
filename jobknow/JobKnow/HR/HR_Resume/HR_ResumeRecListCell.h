//
//  HR_ResumeRecListCell.h
//  JobKnow
//
//  Created by Suny on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRReumeModel.h"
#import "EGOImageView.h"

@protocol HR_ResumeRecListCellDelegate <NSObject>
@optional
- (void)chooseBtnClickInRow:(NSIndexPath *)indexPath;
- (void)addResumePriceFromRec:(HRReumeModel *)resumeModel IndexPath:(NSIndexPath *)indexPath;
@end

@interface HR_ResumeRecListCell : UITableViewCell
{
    UIButton *btn_all;
}
-(void)setModel:(HRReumeModel *)model;

@property (nonatomic,assign) id<HR_ResumeRecListCellDelegate>delegate;

@property(nonatomic,strong) HRReumeModel *resumeModel;

@property (nonatomic,strong) NSIndexPath *indexPath_fromList;

@end
