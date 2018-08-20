//
//  HRCollectionCell.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HRCollectionModel.h"

@protocol HRCollectionCellDelegate <NSObject>

-(void)CollectionClick:(NSIndexPath *)IndexPath;
-(void)introduceClick:(NSIndexPath *)IndexPath;

@end
@interface HRCollectionCell : UITableViewCell<HRCollectionCellDelegate>
{
    UIImageView * bgImageV;
    
    UILabel * nameLabel;
    
//    UILabel * hrRecCountLabel;
    
    UILabel * label_income;
    UILabel * label_isfast;
    UILabel * salaryLab;
    UILabel * companyLabel;
    UILabel * addressLabel;
    UILabel * timeLabel;
    
    UIImageView * bottomImageV;
    
    UIImageView * collectImageV;
    UILabel * collectCountLabel;
    
    UIImageView * introduceImageV;
    UILabel * introduceCountLabel;
    
    UIImageView * lookImageV;
    UILabel * lookCountLabel;
}

@property id<HRCollectionCellDelegate>delegate;
//@property BOOL BoolOfCollected;
@property (nonatomic)NSIndexPath * IndexPath;
-(void)configData:(HRCollectionModel *)model withIndexPath:(NSIndexPath *)IndexPaTH;
#pragma mark - 收藏改变图标,label数的加减.
- (void)changeCollectionImagewithNumber:(int)number;
@end
