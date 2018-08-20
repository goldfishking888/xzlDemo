//
//  ZhangXinCell.h
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "myButton.h"
#import "RTLabel.h"

@interface ZhangXinCell : UITableViewCell

@property(nonatomic,strong)myButton *sureBtn;
@property(nonatomic,strong)RTLabel *nameLabel;
@property(nonatomic,strong)RTLabel *increaseLabel;
@property(nonatomic,strong)RTLabel *priceLabel;

- (void)setTitleForLabel:(NSString *)first andSecond:(NSString *)second andThird:(NSString *)third;

@end
