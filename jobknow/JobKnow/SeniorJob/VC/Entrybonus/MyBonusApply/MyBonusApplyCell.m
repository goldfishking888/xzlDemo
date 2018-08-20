//
//  MyBonusApplyCell.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "MyBonusApplyCell.h"
#define font1 14
#define font2 12
@implementation MyBonusApplyCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, iPhone_width - 20, 105)];
    bgImageV.image = [UIImage imageNamed:@"shape_middle_normal"];
    [self.contentView addSubview:bgImageV];
    
    UILabel * circleLabel = [MyControl createLableFrame:CGRectMake(-5, 40, 10, 10) font:10 title:nil];
    circleLabel.layer.borderColor = [RGBA(180, 180, 180, 1)CGColor];
    circleLabel.layer.borderWidth = 0.5;
    circleLabel.layer.cornerRadius = circleLabel.frame.size.width / 2;
    circleLabel.layer.masksToBounds = YES;
    circleLabel.backgroundColor = RGBA(243, 243, 243, 1);
    [bgImageV addSubview:circleLabel];
    
    UILabel * circleLabel1 = [MyControl createLableFrame:CGRectMake(-5, 40, 5, 10) font:10 title:nil];
    circleLabel1.backgroundColor = RGBA(243, 243, 243, 1);
    [bgImageV addSubview:circleLabel1];
    
    UILabel * circle1 = [MyControl createLableFrame:CGRectMake(bgImageV.frame.size.width - 5, circleLabel.frame.origin.y, 10, 10) font:10 title:nil];
    circle1.layer.borderColor = [RGBA(180, 180, 180, 1)CGColor];
    circle1.layer.borderWidth = 0.5;
    circle1.layer.cornerRadius = circle1.frame.size.width / 2;
    circle1.layer.masksToBounds = YES;
    circle1.backgroundColor = RGBA(243, 243, 243, 1);
    [bgImageV addSubview:circle1];
    
    UILabel * circle2 = [MyControl createLableFrame:CGRectMake(bgImageV.frame.size.width, circleLabel.frame.origin.y, 5, 10) font:10 title:nil];
    circle2.backgroundColor = RGBA(243, 243, 243, 1);
    [bgImageV addSubview:circle2];

    titleLabel = [MyControl createLableFrame:CGRectMake(15, 15, 200, font1) font:font1 title:@"产品经理"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:font1];
    [bgImageV addSubview:titleLabel];
    
    stateLabel = [MyControl createLableFrame:CGRectMake(bgImageV.frame.size.width - 80, titleLabel.frame.origin.y, 65, font1) font:font1 title:@"提现成功"];
    [stateLabel setTextColor:[UIColor orangeColor]];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont boldSystemFontOfSize:font1];
    [bgImageV addSubview:stateLabel];
    
    lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, circleLabel.frame.origin.y + circleLabel.frame.size.width / 2, bgImageV.frame.size.width - 30, 0.5)];
    lineImageV.backgroundColor = RGBA(110, 110, 110, 1);
    [bgImageV addSubview:lineImageV];
    
    entryCompanyLabel = [MyControl createLableFrame:CGRectMake(titleLabel.frame.origin.x, lineImageV.frame.origin.y + 10, bgImageV.frame.size.width - 30, font2) font:font2 title:@"入职公司:青岛奇客创想信息科技有限公司"];
    entryCompanyLabel.textColor = RGBA(110, 110, 110, 1);
    entryCompanyLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:entryCompanyLabel];
    
    entryTimeLabel = [MyControl createLableFrame:CGRectMake(titleLabel.frame.origin.x, entryCompanyLabel.frame.origin.y + entryCompanyLabel.frame.size.height + 5, 150, font2) font:font2 title:@"入职时间:2015-09-10"];
    entryTimeLabel.textAlignment = NSTextAlignmentLeft;
    entryTimeLabel.textColor = RGBA(110, 110, 110, 1);
    [bgImageV addSubview:entryTimeLabel];
    
    //
    entryMoneyLabel = [MyControl createLableFrame:CGRectMake(bgImageV.frame.size.width - 70, entryTimeLabel.frame.origin.y - 2, 55, font1) font:font1 title:@"1280元"];
    entryMoneyLabel.textAlignment = NSTextAlignmentRight;
    entryMoneyLabel.font = [UIFont boldSystemFontOfSize:font1];
    entryMoneyLabel.textColor = [UIColor orangeColor];
    [bgImageV addSubview:entryMoneyLabel];
    
    entryExplanationLabel = [MyControl createLableFrame:CGRectMake(entryTimeLabel.frame.origin.x, entryTimeLabel.frame.origin.y + entryTimeLabel.frame.size.height + 5, 200, font2) font:font2 title:@"奖金申请审核中"];
    entryExplanationLabel.textColor = RGBA(110, 110, 110, 1);
    entryExplanationLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:entryExplanationLabel];
}
-(void)configData:(MyBonusApplyModel *)model
{
    titleLabel.text = model.jobName;
    /*账单状态
     0:奖金申请审核中--未付款   -----申请中
     1：官方支付账单--已付款     ----申请通过
     2：奖金申请失败--未付款 --申请失败
     3：提交入职证明审核中--未付款-----申请中
     4：提交入职资料审核失败        --申请失败
     5：提交入职证明审核通过--未付款  -----申请通过
     6：奖金申请通过--未付款         -----申请通过
     7 入职满月,可提现             -----申请通过
     */
    //    if(status == 0)
    //        return "奖金申请审核中";
    //    if(status == 1)
    //        return "奖金已发放";
    //    if(status == 2)
    //        return "申请失败";
    //    if(status == 3)
    //        return "入职证明审核中";
    //    if(status == 4)
    //        return "入职证明审核失败";
    //    if(status == 5)
    //        return "等待入职满月发放奖金";
    //    if(status == 6)
    //        return "等待入职满月发放奖金";
    //    if(status == 7)
    //        return "入职满月，可提现";
    //    if(status == 8)
    //        return "奖金提现中";
    //    return "入职奖金-详情";
    NSString * state = [NSString stringWithFormat:@"%@",model.bounsStatus];
    if ([state isEqualToString:@"0"])
    {
        entryExplanationLabel.text = @"奖金申请审核中";
    }else if ([state isEqualToString:@"1"])
    {//官方支付账单
        entryExplanationLabel.text = @"奖金已发放";
    }else if ([state isEqualToString:@"2"])
    {//申请失败
        entryExplanationLabel.text = @"申请失败";
    }else if ([state isEqualToString:@"3"])
    {//入职证明审核中
        entryExplanationLabel.text = @"入职证明审核中";
    }
    else if ([state isEqualToString:@"4"])
    {//入职证明审核失败
        entryExplanationLabel.text = @"入职证明审核失败";
    }else if ([state isEqualToString:@"5"])
    {//等待入职满月发放奖金
        entryExplanationLabel.text = @"等待入职满月发放奖金";
    }else if ([state isEqualToString:@"6"])
    {//奖金申请通过 等待入职满月发放奖金
        entryExplanationLabel.text = @"等待入职满月发放奖金";
    }else if ([state isEqualToString:@"7"])
    {//入职满月，可提现
        entryExplanationLabel.text = @"入职满月,可提现";
    }
    else if ([state isEqualToString:@"8"])
    {//奖金提现中
        entryExplanationLabel.text = @"奖金提现中";
    }
    if ([state isEqualToString:@"0"] || [state isEqualToString:@"3"]) {
        //申请中
        stateLabel.text = @"申请中";
        stateLabel.textColor = [UIColor orangeColor];
    }
    else if ([state isEqualToString:@"2"] || [state isEqualToString:@"4"])
    {
        //申请失败
        stateLabel.text = @"申请失败";
        stateLabel.textColor = RGBA(110, 110, 110, 1);
    }
    else
    {//申请通过
        stateLabel.text = @"申请通过";
        stateLabel.textColor = RGBA(87, 196, 53, 1);
    }
    
    entryCompanyLabel.text = [NSString stringWithFormat:@"入职公司:%@",model.companyName];
    entryTimeLabel.text = [NSString stringWithFormat:@"入职日期:%@",model.entryDate];
    entryMoneyLabel.text = [NSString stringWithFormat:@"%@元",model.bounsPrice];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
