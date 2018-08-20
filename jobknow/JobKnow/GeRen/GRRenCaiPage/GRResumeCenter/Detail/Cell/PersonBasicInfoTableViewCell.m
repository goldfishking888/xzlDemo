//
//  PersonBasicInfoTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "PersonBasicInfoTableViewCell.h"
#import "PersonBasicInfoModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 14
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:14]

@implementation PersonBasicInfoTableViewCell{
    UILabel *label_binfo;//名字下方基本信息一栏
    UIView *view_line;//分割线
    
    UILabel *label_tel;//电话
    UILabel *label_email;//邮箱
    UILabel *label_marriage;//婚姻
    UILabel *label_from;//籍贯
    UILabel *label_political;//政治面貌
    UILabel *label_work;//工作性质
    UILabel *label_IDNum;//身份证号
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    label_binfo = [UILabel new];
    label_binfo.textAlignment = NSTextAlignmentLeft;
    label_binfo.textColor = kTextColor;
    label_binfo.font = kTextFont;
    [self.contentView addSubview:label_binfo];
    
    label_tel = [UILabel new];
    label_tel.textAlignment = NSTextAlignmentLeft;
    label_tel.textColor = kTextColor;
    label_tel.font = kTextFont;
    [self.contentView addSubview:label_tel];
    
    label_email = [UILabel new];
    label_email.textAlignment = NSTextAlignmentLeft;
    label_email.textColor = kTextColor;
    label_email.font = kTextFont;
    [self.contentView addSubview:label_email];
    
    label_marriage = [UILabel new];
    label_marriage.textAlignment = NSTextAlignmentLeft;
    label_marriage.textColor = kTextColor;
    label_marriage.font = kTextFont;
    [self.contentView addSubview:label_marriage];
    
    label_from = [UILabel new];
    label_from.textAlignment = NSTextAlignmentLeft;
    label_from.textColor = kTextColor;
    label_from.font = kTextFont;
    [self.contentView addSubview:label_from];
    
    label_political = [UILabel new];
    label_political.textAlignment = NSTextAlignmentLeft;
    label_political.textColor = kTextColor;
    label_political.font = kTextFont;
    [self.contentView addSubview:label_political];
    
    label_work = [UILabel new];
    label_work.textAlignment = NSTextAlignmentLeft;
    label_work.textColor = kTextColor;
    label_work.font = kTextFont;
    [self.contentView addSubview:label_work];
    
    label_IDNum = [UILabel new];
    label_IDNum.textAlignment = NSTextAlignmentLeft;
    label_IDNum.textColor = kTextColor;
    label_IDNum.font = kTextFont;
    [self.contentView addSubview:label_IDNum];
    
    view_line = [UIView new];
    view_line.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:view_line];
    
    
    label_binfo.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
    
    view_line.sd_layout.widthIs(kMainScreenWidth - kMargLR).heightIs(1).topSpaceToView(label_binfo, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_tel.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(view_line, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_email.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_tel, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_marriage.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_email, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_from.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_marriage, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_political.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_from, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_work.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_political, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_IDNum.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_work, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
}


-(void)setModel:(PersonBasicInfoModel *)model{
    _model = model;
    NSString *gender = @"未设置";
    label_binfo.text = [NSString stringWithFormat:@"%@ | %@岁 | 现居 %@ | %@工作经验",_model.gender,_model.age,_model.city,_model.workYears];
    label_tel.text = [NSString stringWithFormat:@"电  话：%@",_model.tel];
    label_email.text = [NSString stringWithFormat:@"邮  箱：%@",_model.email];
    label_marriage.text = [NSString stringWithFormat:@"婚姻状况：%@",_model.marriage];
    label_from.text = [NSString stringWithFormat:@"户  口：%@",_model.household];
    label_political.text = [NSString stringWithFormat:@"政治面貌：%@",_model.political];
    label_work.text = [NSString stringWithFormat:@"工作性质：%@",_model.workNature];
    label_IDNum.text = [NSString stringWithFormat:@"身份证号：%@",_model.IDNum];
    //***********************高度自适应cell设置步骤************************
    [self setupAutoHeightWithBottomView:label_IDNum bottomMargin:kMargTB];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
