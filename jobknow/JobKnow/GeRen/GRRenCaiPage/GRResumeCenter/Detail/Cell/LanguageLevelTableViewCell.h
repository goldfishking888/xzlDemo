//
//  LanguageLevelTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LanguageLevelModel;
@protocol LanguageLevelTableViewCellDelegate <NSObject>
@optional
- (void)editLanguageLevelItem:(LanguageLevelModel *)model IndexPath:(NSIndexPath *)indexPath;
@end

@interface LanguageLevelTableViewCell : UITableViewCell

@property (nonatomic,strong) LanguageLevelModel *model;

@property (nonatomic,assign) id<LanguageLevelTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic) NSInteger type;//一共4种,0第一个有下分割线,1没有分割线上下间距小,2有分割线上小下大,3第一个无下分割线

@end
