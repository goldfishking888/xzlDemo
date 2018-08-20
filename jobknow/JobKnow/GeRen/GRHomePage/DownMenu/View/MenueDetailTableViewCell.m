//
//  MenueDetailTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MenueDetailTableViewCell.h"
#import "MenuDataModel.h"

@implementation MenueDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *label_name = [[UILabel alloc] initWithFrame:CGRectMake(17, 19, (kMainScreenWidth-34)/2, 14)];
        label_name.tag = 11;
        label_name.font = [UIFont systemFontOfSize:14];
        label_name.textColor = RGB(74, 74, 74);
        label_name.textAlignment = NSTextAlignmentLeft;
//        label_name.text = @"产品经理+青岛+IT/互联网2222";
        [self addSubview:label_name];
        
        
        UILabel *label_corp = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-54-85, 19, 85, 13)];
        label_corp.tag = 12;
        label_corp.font = [UIFont systemFontOfSize:13];
        label_corp.textColor = RGB(155, 155, 155);
        label_corp.text = @"今日新增9条";
        label_corp.textAlignment = NSTextAlignmentRight;
        [self addSubview:label_corp];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-33, 15, 18.5, 13)];
        [btn setImage:[UIImage imageNamed:@"book_selected"] forState:UIControlStateSelected];
        [btn setImage:nil forState:UIControlStateNormal];
        btn.tag = 13;
        [self addSubview:btn];
        
       
        
    }
    return self;
}

-(void)setModel:(MenuDataModel *)model{
    
    UILabel *name = (UILabel *)[self viewWithTag:11];
    [name setText:model.title];
    
    UILabel *count = (UILabel *)[self viewWithTag:12];
    [count setText:[NSString stringWithFormat:@"今日新增%@条",model.nums]];
    
    UIButton *btn = (UIButton *)[self viewWithTag:13];
    [btn setSelected:model.isSelectedItem];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
