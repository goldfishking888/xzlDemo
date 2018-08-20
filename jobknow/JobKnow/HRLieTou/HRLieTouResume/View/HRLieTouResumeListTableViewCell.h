//
//  HRLieTouResumeListTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRLieTouResumeListModel;

@interface HRLieTouResumeListTableViewCell : UITableViewCell

@property (nonatomic,strong) HRLieTouResumeListModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end
