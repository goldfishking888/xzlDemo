//
//  RecommendedRecordCellTableViewCell.m
//  FreeChat
//
//  Created by WangJinyu on 7/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "RecommendedRecordCell.h"
#import "RecommendedRecordView.h"

@interface RecommendedRecordCell ()
{
    UIView *bgView;
    UIImageView *icon;
    UILabel *titleLabel;
}

@end

@implementation RecommendedRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if(bgView)
            return self;
        bgView = [[UIView alloc] init];
        icon = [[UIImageView alloc] init];
        titleLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:bgView];
        [bgView addSubview:icon];
        [bgView addSubview:titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    CGRect frame;
    
    frame = CGRectMake(8, 0, self.frame.size.width - 16, self.frame.size.height - 15);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = frame;
    
    frame = CGRectMake(10, 15, 27, 27);
    icon.frame = frame;
    icon.image = [UIImage imageNamed:@"hrcircle_resume_recomm_comp.png"];
    
    frame = CGRectMake(47, 22, bgView.frame.size.width - 47, 13);
    titleLabel.frame = frame;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = self.dataDic[@"companyName"];
    titleLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    for (UIView *item in bgView.subviews) {
        if ([item isKindOfClass:[RecommendedRecordView class]]) {
            [item removeFromSuperview];
        }
        
    }
    
    for (int index = 0; index < [self.dataDic[@"jobInfo"] count]; index++)
    {
        if (index == [self.dataDic[@"jobInfo"] count] - 1)
        {
            self.isLine = @"0";
        }
        else
        {
            self.isLine = @"1";
        }
        
        RecommendedRecordView *view = [[RecommendedRecordView alloc] initWithFrame:CGRectMake(0, 43 + 65 * index, bgView.frame.size.width, 65) WithDic:self.dataDic[@"jobInfo"][index] WithIsLine:self.isLine];
        view.tag = self.viewTag + index;
        [view addTarget:self.vc action:@selector(recommendCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
