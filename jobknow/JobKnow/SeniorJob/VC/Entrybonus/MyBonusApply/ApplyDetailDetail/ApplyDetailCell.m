//
//  ApplyDetailCell.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ApplyDetailCell.h"

@implementation ApplyDetailCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    circleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 16, 16)];
    circleImageV.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:circleImageV];
    
    contentLabel = [MyControl createLableFrame:CGRectMake(circleImageV.frame.origin.x + circleImageV.frame.size.width + 5, circleImageV.frame.origin.y, 240, 12) font:12 title:@""];
    contentLabel.textColor = RGBA(110, 110, 110, 1);
    [self.contentView addSubview:contentLabel];
    
    timeLabel = [MyControl createLableFrame:CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5, contentLabel.frame.size.width, 12) font:12 title:@"2015-09-09"];
    timeLabel.textColor = RGBA(110, 110, 110, 1);
    [self.contentView addSubview:timeLabel];
}
-(void)config:(NSMutableDictionary *)dic withIndexPath:(NSIndexPath *)indexpath
{
    //item_bonus_detail_pointr
    if (indexpath.row == 0) {
        circleImageV.image = [UIImage imageNamed:@"item_bonus_detail_point"];
        contentLabel.textColor = [UIColor orangeColor];
    }
    else
    {
        circleImageV.frame = CGRectMake(37, 0, 13, 13);
        circleImageV.backgroundColor = RGBA(203, 203, 203, 1);
        circleImageV.layer.cornerRadius = circleImageV.frame.size.width / 2;
        circleImageV.layer.masksToBounds = YES;
    }
     UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(circleImageV.frame.origin.x + circleImageV.frame.size.width / 2 - 0.1, circleImageV.frame.origin.y + circleImageV.frame.size.height, 0.8, 50 - circleImageV.frame.size.height)];
    lineview.backgroundColor = RGBA(203, 203, 203, 1);
    [self.contentView addSubview:lineview];
    timeLabel.text = dic[@"time"];
    
    NSString * state = [NSString stringWithFormat:@"%@",dic[@"status"]];
    if ([state isEqualToString:@"0"])
    {
        contentLabel.text = @"提交入职奖金申请";
    }else if ([state isEqualToString:@"1"])
    {//官方支付账单
        contentLabel.text = @"奖金已发放";
    }else if ([state isEqualToString:@"2"])
    {//申请失败
        contentLabel.text = @"奖金申请失败";
    }else if ([state isEqualToString:@"3"])
    {//入职证明
        contentLabel.text = @"提交入职证明";
    }
    else if ([state isEqualToString:@"4"])
    {//入职证明审核失败
        contentLabel.text = @"入职证明审核失败";
    }else if ([state isEqualToString:@"5"])
    {//等待入职满月发放奖金
        contentLabel.text = @"入职证明审核通过";
    }else if ([state isEqualToString:@"6"])
    {//奖金申请通过 等待入职满月发放奖金
        contentLabel.text = @"奖金审核通过";
    }else if ([state isEqualToString:@"7"])
    {//入职满月，可提现
        contentLabel.text = @"入职满月,可提现奖金";
    }
    else if ([state isEqualToString:@"8"])
    {//奖金提现中
        contentLabel.text = @"申请奖金提现";
    }
    else if ([state isEqualToString:@"9"])
    {//奖金提现中
        contentLabel.text = @"奖金申请审核中";
    }
    else if ([state isEqualToString:@"10"])
    {//奖金提现中
        contentLabel.text = @"入职证明审核中";
    }
    else if ([state isEqualToString:@"11"])
    {//奖金提现中
        contentLabel.text = @"等待入职满月发放奖金";
        timeLabel.text = [NSString stringWithFormat:@"预计发放时间:%@",self.applyTimeStrs];
    }
    else if ([state isEqualToString:@"12"])
    {//奖金提现中
        contentLabel.text = @"奖金提现中";
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
