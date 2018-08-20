//
//  HRHomeCell.h
//  JobKnow
//
//  Created by WangJinyu on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRHomeIntroduceModel.h"

@protocol cellDelegate <NSObject>

-(void)CollectionClick:(NSIndexPath *)IndexPath;
-(void)introduceClick:(NSIndexPath *)IndexPath;

@end
@interface HRHomeCell : UITableViewCell<cellDelegate>
{
    UIImageView * bgImageV;
    
    UILabel * nameLabel;
    
    UILabel * hrRecCountLabel;
    
    UIButton * moneyBtn;
    UIImageView * feeImageV;
    UILabel * companyLabel;
    UILabel * addressLabel;
    UILabel * timeLabel;
    
    UIImageView * lineImageV;
    
    UIImageView * collectImageV;
    UILabel * collectCountLabel;
    
    UIImageView * introduceImageV;
    UILabel * introduceCountLabel;
    
    UIImageView * lookImageV;
    UILabel * lookCountLabel;
}

@property id<cellDelegate>delegate;
//@property BOOL BoolOfCollected;
@property (nonatomic)NSIndexPath * IndexPath;
-(void)configData:(HRHomeIntroduceModel *)model withIndexPath:(NSIndexPath *)IndexPaTH;
#pragma mark - 收藏改变图标,label数的加减.
- (void)changeCollectionImagewithNumber:(int)number;

@end
