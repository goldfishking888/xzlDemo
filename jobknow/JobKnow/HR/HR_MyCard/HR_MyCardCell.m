//
//  HR_MyCardCell.m
//  JobKnow
//
//  Created by WangJinyu on 14/08/2015.
//  Copyright (c) 2015 lxw. All rights reserved.
//

#import "HR_MyCardCell.h"

@interface HR_MyCardCell ()
{
    UIImageView *icon;
    UILabel *titleLabel;
    UILabel *contentLabel;
    UIView *line1;
    UIView *line2;
    int height;
}

@end

@implementation HR_MyCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        icon = [[UIImageView alloc] init];
        titleLabel = [[UILabel alloc] init];
        contentLabel = [[UILabel alloc] init];
        line1 = [[UIView alloc] init];
        line2 = [[UIView alloc] init];
        
        [self.contentView addSubview:icon];
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:contentLabel];
        [self.contentView addSubview:line1];
        [self.contentView addSubview:line2];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    CGRect frame;
    
    
    if (![self.titleStr isEqualToString:@"电话"] && ![self.titleStr isEqualToString:@"固话"] && ![self.titleStr isEqualToString:@"邮箱"])
    {
                //取得文字的整体宽高等值
                CGSize textSize = [self.contentStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        
                //把高度返回给_textHeight,记录下来
                height = (textSize.width /(self.frame.size.width - 85) + 1) * textSize.height;
        
        frame = CGRectMake(23, (self.frame.size.height - 12) / 2, 12, 12);
        icon.frame = frame;
        icon.image = [UIImage imageNamed:self.iconStr];
        
        frame = CGRectMake(40, (self.frame.size.height - 12) / 2, 30, 12);
        titleLabel.frame = frame;
        titleLabel.text = self.titleStr;
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = RGBA(144, 144, 144, 1);
        
        frame = CGRectMake(70, 15, self.frame.size.width - 85,height);
                           //self.frame.size.height - 30);
        contentLabel.frame = frame;
        contentLabel.text = self.contentStr;
        contentLabel.numberOfLines = 0;
        if (self.frame.size.height == 40)
        {
            contentLabel.textAlignment = NSTextAlignmentRight;
        }
        contentLabel.textColor = RGBA(92, 92, 92, 1);
        contentLabel.font = [UIFont systemFontOfSize:11];
        
        if ([self.isLast isEqualToString:@"0"])
        {
            if ([self.isOrage isEqualToString:@"0"])
            {
                frame = CGRectMake(40, self.frame.size.height - 1, 220, 1);
                line1.frame = frame;
                line1.backgroundColor = RGBA(225, 225, 225, 1);
                [self.contentView addSubview:line1];
            }
            else
            {
                frame = CGRectMake(23, self.frame.size.height - 1, 235, 1);
                line2.frame = frame;
                line2.backgroundColor = RGBA(247, 147, 30, 1);
                [self.contentView addSubview:line2];
            }
        }
    }
    else
    {
        frame = CGRectMake(23, 20, 12, 12);
        icon.frame = frame;
        icon.image = [UIImage imageNamed:self.iconStr];
        
        frame = CGRectMake(40, 20, 30, 12);
        titleLabel.frame = frame;
        titleLabel.text = self.titleStr;
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = RGBA(144, 144, 144, 1);
        
        if ([self.isLast isEqualToString:@"0"])
        {
            if ([self.isOrage isEqualToString:@"0"])
            {
                frame = CGRectMake(40, 41, 220, 1);
                line1.frame = frame;
                line1.backgroundColor = RGBA(225, 225, 225, 1);
                [self.contentView addSubview:line1];
            }
            else
            {
                frame = CGRectMake(23, 41, 235, 1);
                line2.frame = frame;
                line2.backgroundColor = RGBA(247, 147, 30, 1);
                [self.contentView addSubview:line2];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
