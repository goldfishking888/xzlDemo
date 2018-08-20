//
//  PositionRecommandCell.m
//  FreeChat
//
//  Created by WangJinyu on 7/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "PositionRecommandCell.h"

@interface PositionRecommandCell ()
{
    UIView *upLine;
    UIView *downLine;
    UIImageView *icon;
    
    UIView *bgView;
//    UILabel *nameLabel;
    UIImageView *sexImageView;
    UILabel *ageLabel;
    UILabel *dateLabel;
    UILabel *professionLabel;
    UIImageView *arrowImageView;
    
    UIImageView *statusImageView;
}

@end

@implementation PositionRecommandCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        upLine = [[UIView alloc] init];
        icon = [[UIImageView alloc] init];
        bgView = [[UIView alloc] init];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.tag = 10;
        sexImageView = [[UIImageView alloc] init];
        ageLabel = [[UILabel alloc] init];
        dateLabel = [[UILabel alloc] init];
        professionLabel = [[UILabel alloc] init];
        arrowImageView = [[UIImageView alloc] init];
        statusImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:upLine];
        [self.contentView addSubview:icon];
        [self.contentView addSubview:bgView];
        [bgView addSubview:nameLabel];
        [bgView addSubview:sexImageView];
        [bgView addSubview:ageLabel];
        [bgView addSubview:dateLabel];
        [bgView addSubview:professionLabel];
        [bgView addSubview:arrowImageView];
        [bgView addSubview:statusImageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UILabel *nameLabel = (UILabel *)[self viewWithTag:10];
    
    self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    CGRect frame = CGRectMake(18, 0, 1, 27);
    upLine.frame = frame;
    upLine.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
    
    if ([self.isDownLine isEqualToString:@"1"])
    {
        downLine = [[UIView alloc] init];
        frame = CGRectMake(18, 37, 1, 34);
        downLine.frame = frame;
        downLine.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
        [self.contentView addSubview:downLine];
    }
    
    frame = CGRectMake(13, 27, 10, 10);
    icon.frame = frame;
    icon.image = [UIImage imageNamed:@"hrcircle_resume_recomm_person.png"];
    
    frame = CGRectMake(26, 0, 286, 64);
    bgView.frame = frame;
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    
    frame = CGRectMake(5, 15, 50, 12);
    nameLabel.frame = frame;
    //nameLabel.backgroundColor = [UIColor greenColor];
    nameLabel.text = self.dataDic[@"name"];
    nameLabel.numberOfLines = 1;
    
    nameLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [nameLabel sizeToFit];
    
    frame = CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 1, 16, 11, 11);
    sexImageView.frame =frame;
    if ([self.dataDic[@"sex"] isEqualToString:@"男"])
    {
        sexImageView.image = [UIImage imageNamed:@"v6_0_freshman_group_member_male.png"];
    }
    else
    {
        sexImageView.image = [UIImage imageNamed:@"v6_0_freshman_group_member_female.png"];
    }
    
    frame = CGRectMake(sexImageView.frame.origin.x + sexImageView.frame.size.width + 1, 15, 50, 12);
    ageLabel.frame = frame;
    
    ageLabel.text = [NSString stringWithFormat:@"%@", self.dataDic[@"age"]];
    ageLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    ageLabel.font = [UIFont systemFontOfSize:12];
    
    
    frame = CGRectMake(126, 15, 137, 12);
    dateLabel.frame = frame;
    dateLabel.text = self.dataDic[@"recommendDate"];
    dateLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.textAlignment = NSTextAlignmentRight;
    
    frame = CGRectMake(5, 37, 100, 12);
    professionLabel.frame = frame;
    professionLabel.text = [NSString stringWithFormat:@"工作%@年", self.dataDic[@"workYear"]];
    professionLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    professionLabel.font = [UIFont systemFontOfSize:10];
    
    frame = CGRectMake(bgView.frame.size.width - 20, 22, 20, 20);
    arrowImageView.frame = frame;
    arrowImageView.image = [UIImage imageNamed:@"arrow_gray_right.png"];
    
    frame = CGRectMake(bgView.frame.size.width - 70, 7, 50, 50);
    statusImageView.frame = frame;
    if ([self.dataDic[@"recommendState"] isEqualToString:@"1"])
    {
        statusImageView.image = [UIImage imageNamed:@"hrcircle_resume_look.png"];
    }
    else if ([self.dataDic[@"recommendState"] isEqualToString:@"2"])
    {
        statusImageView.image = [UIImage imageNamed:@"hrcircle_resume_deliver.png"];
    }
    else if ([self.dataDic[@"recommendState"] isEqualToString:@"3"])
    {
        statusImageView.image = [UIImage imageNamed:@"hrcircle_resume_audition.png"];
    }
    else if ([self.dataDic[@"recommendState"] isEqualToString:@"4"])
    {
        statusImageView.image = [UIImage imageNamed:@"hrcircle_resume_fail.png"];
    }
    else if ([self.dataDic[@"recommendState"] isEqualToString:@"5"])
    {
        statusImageView.image = [UIImage imageNamed:@"hrcircle_resume_entry.png"];
    }
    else if ([self.dataDic[@"recommendState"] isEqualToString:@"6"])
    {
        statusImageView.image = [UIImage imageNamed:@"hrcircle_resume_leave.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
