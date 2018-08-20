//
//  RecommendedRecordView.m
//  FreeChat
//
//  Created by WangJinyu on 7/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "RecommendedRecordView.h"

@interface RecommendedRecordView ()
{
    UIImageView *icon;
    UILabel *titleLabel;
    UILabel *recommendLabel;
    UILabel *priceLabel;
    UIImageView *arrowImageView;
    UIView *lineView;
}

@end

@implementation RecommendedRecordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)dic WithIsLine:(NSString *)isLine
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!icon) {
            icon = [[UIImageView alloc] initWithFrame:CGRectMake(16.5, 20, 10, 10)];
            [self addSubview:icon];
        }
        
        icon.image = [UIImage imageNamed:@"hrcircle_resume_recomm_pos.png"];
        
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 18, 200, 14)];
            [self addSubview:titleLabel];
        }
        
        titleLabel.text = dic[@"jobName"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
        
        
        if (!recommendLabel) {
            recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 34, 200, 10)];
            [self addSubview:recommendLabel];
        }
        
        recommendLabel.font = [UIFont systemFontOfSize:10];
        recommendLabel.text = [NSString stringWithFormat:@"推荐%@人", dic[@"recommendPersons"]];
        recommendLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
       
        
        if (!priceLabel) {
            priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 18, 75, 14)];
            [self addSubview:priceLabel];
        }
        
        priceLabel.text = [NSString stringWithFormat:@"￥%@", dic[@"jobMoney"]];
        priceLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:146 / 255.0 blue:4 / 255.0 alpha:1];
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.textAlignment = NSTextAlignmentRight;
        
        if (!arrowImageView) {
            arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 15, 20, 20)];
            [self addSubview:arrowImageView];
        }
        
        arrowImageView.image = [UIImage imageNamed:@"arrow_gray_right.png"];
       
        
        if ([isLine isEqualToString:@"1"])
        {
            if (!lineView) {
                lineView = [[UIView alloc] initWithFrame:CGRectMake(47, self.frame.size.height - 1, self.frame.size.width - 53, 1)];
                [self addSubview:lineView];
            }
            
            lineView.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
            
        }
        
    }
    return self;
}


@end
