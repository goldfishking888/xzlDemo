//
//  RecommendProcessCell.m
//  FreeChat
//
//  Created by WangJinyu on 6/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "RecommendProcessCell.h"

@interface RecommendProcessCell ()
{
    UIView *frameView;
    UILabel *statusLabel;
    UILabel *dateLabel;
}

@end

@implementation RecommendProcessCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        frameView = [[UIView alloc] init];
        statusLabel = [[UILabel alloc] init];
        dateLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:frameView];
        [frameView addSubview:statusLabel];
        [frameView addSubview:dateLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    CGRect frame;
    
    frame = CGRectMake(35, 0, self.frame.size.width - 70, 65);
    frameView.frame = frame;
    frameView.backgroundColor = [UIColor whiteColor];
    frameView.layer.borderColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1].CGColor;
    frameView.layer.borderWidth = 1;
    frameView.layer.cornerRadius = 5;
    frameView.clipsToBounds = YES;
    
    frame = CGRectMake(0, 15, frameView.frame.size.width, 12);
    statusLabel.frame = frame;
    statusLabel.text = self.dataDic[@"name"];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:12];
    if ([self.isOrange isEqualToString:@"1"])
    {
        statusLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:146 / 255.0 blue:4 / 255.0 alpha:1];
    }
    else
    {
        statusLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    }
    
    frame = CGRectMake(0, 38, frameView.frame.size.width, 12);
    dateLabel.frame = frame;
    dateLabel.text = self.dataDic[@"time"];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    
    if ([self.isLine isEqualToString:@"1"])
    {
        UIView *circleView = [[UIView alloc] init];
        frame = CGRectMake((self.frame.size.width - 10) / 2, 82.5, 10, 10);
        circleView.frame = frame;
        circleView.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
        circleView.layer.cornerRadius = 5;
        circleView.clipsToBounds = YES;
        [self.contentView addSubview:circleView];
        
        UIView *lineView1 = [[UIView alloc] init];
        frame = CGRectMake(self.frame.size.width / 2, 65, 1, 17.5);
        lineView1.frame =frame;
        lineView1.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
        [self.contentView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc] init];
        frame = CGRectMake(self.frame.size.width / 2, 92.5, 1, 17.5);
        lineView2.frame = frame;
        lineView2.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
        [self.contentView addSubview:lineView2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
