//
//  GRPostionListTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/7/24.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRPostionListTableViewCell.h"
#import "GRPositionListModel.h"

@implementation GRPostionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *label_name = [[UILabel alloc] initWithFrame:CGRectMake(14, 22, kMainScreenWidth*3/5, 18)];
        label_name.tag = 11;
        label_name.font = [UIFont systemFontOfSize:18];
        label_name.textColor = RGB(0, 0, 0);
        label_name.textAlignment = NSTextAlignmentLeft;
        label_name.text = @"PHP开发PHP开发";
        [self addSubview:label_name];
        
        
        UILabel *label_corp = [[UILabel alloc] initWithFrame:CGRectMake(14, 57, kMainScreenWidth*2/3, 13)];
        label_corp.tag = 12;
        label_corp.font = [UIFont systemFontOfSize:13];
        label_corp.textColor = RGB(74, 74, 74);
        label_corp.text = @"青岛微众在线网络科技有限公司";
        label_corp.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label_corp];
        
        UILabel *label_income = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-116, 22, 38, 18)];
        label_income.tag = 13;
        label_income.font = [UIFont systemFontOfSize:16];
        label_income.textColor = RGB(255, 255, 255);
        label_income.textAlignment = NSTextAlignmentCenter;
        label_income.backgroundColor = RGB(252, 83, 102);
        label_income.text = @"收益";
        [self addSubview:label_income];
        
        UILabel *label_income_num = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-75, 24, 60, 15)];
        label_income_num.tag = 14;
        label_income_num.font = [UIFont systemFontOfSize:15];
        label_income_num.textColor = RGB(252, 83, 102);
        label_income_num.textAlignment = NSTextAlignmentRight;
        label_income_num.text = @"16K-39K";
        [self addSubview:label_income_num];
        
        UILabel *label_d = [[UILabel alloc] initWithFrame:CGRectMake(14, 86, kMainScreenWidth-28, 14)];
        label_d.tag = 15;
        label_d.font = [UIFont systemFontOfSize:14];
        label_d.textColor = RGB(153, 153, 153);
        label_d.textAlignment = NSTextAlignmentLeft;
        label_d.text = @"10K-12K | 青岛 | 2年经验 | 本科";
        [self addSubview:label_d];
        
    }
    return self;
}

-(void)setModel:(GRPositionListModel *)model{

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
