//
//  HR_MyResumeRecRewardCell.m
//  JobKnow
//
//  Created by Suny on 15/8/28.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_MyResumeRecRewardCell.h"
#define topHeight 20

@interface HR_MyResumeRecRewardCell ()
{
    UIImageView *upImageView;
    UIImageView *bottomImageView;
    UILabel *nameLabel;
    UILabel *statusLabel;
    UILabel *companyLabel;
    UILabel *posLabel;
    UILabel *dateLabel;
    UILabel *priceLabel;
}

@end

@implementation HR_MyResumeRecRewardCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        upImageView = [[UIImageView alloc] init];
        bottomImageView = [[UIImageView alloc] init];
        nameLabel = [[UILabel alloc] init];
        statusLabel = [[UILabel alloc] init];
        companyLabel = [[UILabel alloc] init];
        posLabel = [[UILabel alloc] init];
        dateLabel = [[UILabel alloc] init];
        priceLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:upImageView];
        [self.contentView addSubview:bottomImageView];
        [upImageView addSubview:nameLabel];
        [upImageView addSubview:statusLabel];
        [bottomImageView addSubview:companyLabel];
        [bottomImageView addSubview:posLabel];
        [bottomImageView addSubview:dateLabel];
        [bottomImageView addSubview:priceLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSArray *imageArray = @[@"hr_item_bonus_green.png", @"hr_item_bonus_orange.png", @"hr_item_bonus_blue.png", @"hr_item_bonus_gray.png", @"hr_item_bonus_pink.png", @"hr_item_bonus_gray.png"];
    //    NSArray *statusArray = @[@"提现中", @"已发放", @"可提现", @"发放失败，已离职", @"提现成功", @""];
    
    self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    CGRect frame;
    
    frame = CGRectMake(8, topHeight, self.frame.size.width - 16, 45);
    upImageView.frame = frame;
    upImageView.image = [[UIImage imageNamed:imageArray[2]] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    frame = CGRectMake(8, 46+topHeight, self.frame.size.width - 16, 61);
    bottomImageView.frame = frame;
    bottomImageView.image = [[UIImage imageNamed:@"hr_item_bonus_bottom.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    frame = CGRectMake(15, 0, 100, 45);
    nameLabel.frame = frame;
    nameLabel.text = self.dataDic[@"resumeName"];
    nameLabel.textColor = RGBA(92, 92, 92, 1);
    nameLabel.font = [UIFont systemFontOfSize:12];
    
    frame = CGRectMake(115, 0, upImageView.frame.size.width - 135, 45);
    statusLabel.frame = frame;
    statusLabel.text = self.dataDic[@"text"];
    statusLabel.textColor = RGBA(255, 146, 4, 1);
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:12];
    
    frame = CGRectMake(15, 15, 200, 17);
    companyLabel.frame = frame;
    companyLabel.text = [NSString stringWithFormat:@"公司:%@", self.dataDic[@"companyName"]];
    companyLabel.textColor = RGBA(153, 153, 153, 1);
    companyLabel.font = [UIFont systemFontOfSize:12];
    
    frame = CGRectMake(15, 32, 200, 17);
    posLabel.frame = frame;
    posLabel.text = [NSString stringWithFormat:@"职位:%@", self.dataDic[@"jobName"]];
    posLabel.textColor = RGBA(153, 153, 153, 1);
    posLabel.font = [UIFont systemFontOfSize:12];
    
//    frame = CGRectMake(15, 49, 200, 17);
//    dateLabel.frame = frame;
//    dateLabel.text = [NSString stringWithFormat:@"入职时间:%@", [self.dataDic[@"joinJobTime"] componentsSeparatedByString:@" "][0]];
//    dateLabel.textColor = RGBA(153, 153, 153, 1);
//    dateLabel.font = [UIFont systemFontOfSize:12];
    
    frame = CGRectMake(215, 32, upImageView.frame.size.width - 235, 17);
    priceLabel.frame = frame;
    priceLabel.text = [NSString stringWithFormat:@"￥%@", self.dataDic[@"money"]];
    priceLabel.textColor = RGBA(255, 146, 4, 1);
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:12];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
