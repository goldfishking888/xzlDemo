//
//  MyBonusApplyCell.h
//  JobKnow
//
//  Created by WangJinyu on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBonusApplyModel.h"
@interface MyBonusApplyCell : UITableViewCell
{
    UIImageView * bgImageV;
    UILabel * titleLabel;
    UILabel * stateLabel;
    UIImageView * lineImageV;
    UILabel * entryCompanyLabel;
    UILabel * entryTimeLabel;
    UILabel * entryMoneyLabel;
    UILabel * entryExplanationLabel;

}
-(void)configData:(MyBonusApplyModel *)model;
@end
