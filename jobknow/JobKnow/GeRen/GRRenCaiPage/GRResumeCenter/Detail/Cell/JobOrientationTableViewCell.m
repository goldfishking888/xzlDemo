//
//  JobOrientationTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "JobOrientationTableViewCell.h"
#import "JobOrientationModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 14
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:14]

@implementation JobOrientationTableViewCell{

    UILabel *label_job;//期望职业
    UILabel *label_industry;//期望行业
    UILabel *label_city;//期望工作地区
    UILabel *label_salary;//期望薪资
    UILabel *label_status;//目前状态
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    label_job = [UILabel new];
    label_job.textAlignment = NSTextAlignmentLeft;
    label_job.textColor = kTextColor;
    label_job.font = kTextFont;
    [self.contentView addSubview:label_job];
    
    label_industry = [UILabel new];
    label_industry.textAlignment = NSTextAlignmentLeft;
    label_industry.textColor = kTextColor;
    label_industry.font = kTextFont;
    [self.contentView addSubview:label_industry];
    
    label_city = [UILabel new];
    label_city.textAlignment = NSTextAlignmentLeft;
    label_city.textColor = kTextColor;
    label_city.font = kTextFont;
    [self.contentView addSubview:label_city];
    
    label_salary = [UILabel new];
    label_salary.textAlignment = NSTextAlignmentLeft;
    label_salary.textColor = kTextColor;
    label_salary.font = kTextFont;
    [self.contentView addSubview:label_salary];
    
    label_status = [UILabel new];
    label_status.textAlignment = NSTextAlignmentLeft;
    label_status.textColor = kTextColor;
    label_status.font = kTextFont;
    [self.contentView addSubview:label_status];

    
    label_job.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
    
    label_industry.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_job, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_city.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_industry, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_salary.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_city, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
    label_status.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(label_salary, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    
}


-(void)setModel:(JobOrientationModel *)model{
    _model = model;
    label_job.text = [NSString stringWithFormat:@"期望职位：%@",_model.expect_job];
    label_industry.text = [NSString stringWithFormat:@"期望行业：%@",_model.expect_industry];
    label_city.text = [NSString stringWithFormat:@"期望工作地区：%@",_model.expect_city];
    label_salary.text = [NSString stringWithFormat:@"期望月薪：%@",_model.expect_salary];
    label_status.text = [NSString stringWithFormat:@"目前状态：%@",_model.status];
    //***********************高度自适应cell设置步骤************************
    [self setupAutoHeightWithBottomView:label_status bottomMargin:kMargTB];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
