//
//  TrainEXPTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "TrainEXPTableViewCell.h"
#import "TrainEXPModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 14
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:14]

@implementation TrainEXPTableViewCell{
    UILabel *label_name;//项目名称
    UILabel *label_date;//时间
    UILabel *label_city;//培训地点
    UILabel *label_cer;//培训证书
    UILabel *label_intro_title;//培训内容title
    UILabel *label_intro_content;//培训内容content
    
    UIButton *btn_edit;
    
    UIView *view_line;//分割线
    
    UIView *ball_outter;
    UIView *ball_inner;
    UIView *line_vertical;
    UIView *line_vertical_upper;//可选，当type =2,3时
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    label_name = [UILabel new];
    label_name.textAlignment = NSTextAlignmentLeft;
    label_name.textColor = RGB(0, 0, 0);
    label_name.font = [UIFont systemFontOfSize:16];
    label_name.numberOfLines = 0;
    [self.contentView addSubview:label_name];
    
    label_date = [UILabel new];
    label_date.textAlignment = NSTextAlignmentLeft;
    label_date.textColor = kTextColor;
    label_date.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:label_date];
    
    label_city = [UILabel new];
    label_city.textAlignment = NSTextAlignmentLeft;
    label_city.textColor = kTextColor;
    label_city.font = kTextFont;
    [self.contentView addSubview:label_city];
    
    label_cer = [UILabel new];
    label_cer.textAlignment = NSTextAlignmentLeft;
    label_cer.textColor = kTextColor;
    label_cer.font = kTextFont;
    label_cer.numberOfLines = 0;
    [self.contentView addSubview:label_cer];
    
    label_intro_title = [UILabel new];
    label_intro_title.textAlignment = NSTextAlignmentLeft;
    label_intro_title.textColor = RGB(170, 170, 170);
    label_intro_title.font = kTextFont;
    [self.contentView addSubview:label_intro_title];
    
    label_intro_content = [UILabel new];
    label_intro_content.textAlignment = NSTextAlignmentLeft;
    label_intro_content.textColor = kTextColor;
    label_intro_content.font = kTextFont;
    label_intro_content.numberOfLines = 0;
    [self.contentView addSubview:label_intro_content];
    
    btn_edit = [UIButton new];
//    btn_edit.backgroundColor = [UIColor yellowColor];
    [btn_edit setImage:[UIImage imageNamed:@"resume_edit_btn"] forState:UIControlStateNormal];
    [btn_edit addTarget:self action:@selector(onClickBtnEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn_edit];
    
    view_line = [UIView new];
    view_line.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:view_line];
    
    ball_outter = [UIView new];
    mViewBorderRadius(ball_outter, 7, 1, [UIColor clearColor]);
    ball_outter.backgroundColor = RGB(253,222,182);
    [self.contentView addSubview:ball_outter];
    
    ball_inner = [UIView new];
    mViewBorderRadius(ball_inner, 4, 1, [UIColor clearColor]);
    ball_inner.backgroundColor = RGB(255,146,4);
    [ball_outter addSubview:ball_inner];
    
    line_vertical = [UIView new];
    line_vertical.backgroundColor = RGB(247,247,247);
    [self.contentView addSubview:line_vertical];
    
    line_vertical_upper = [UIView new];
    line_vertical_upper.backgroundColor = RGB(247,247,247);
    [self.contentView addSubview:line_vertical_upper];
    
    label_name.sd_layout.widthIs(kMainScreenWidth - 41 *2).heightIs(16).topSpaceToView(self.contentView, 5).leftSpaceToView(self.contentView,41).autoHeightRatio(0);
    
    btn_edit.sd_layout.widthIs(24).heightIs(26).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 21);
    
    label_date.sd_layout.widthIs(kMainScreenWidth - 41 *2).heightIs(15).topSpaceToView(label_name, kMargTB).leftSpaceToView(self.contentView,41);
    
    label_city.sd_layout.widthIs(kMainScreenWidth - 41 -25).heightIs(kHeightLabel).topSpaceToView(label_date, kMargTB).leftSpaceToView(self.contentView,41).autoHeightRatio(0);
    
    label_cer.sd_layout.widthIs(kMainScreenWidth - 41 -25).heightIs(kHeightLabel).topSpaceToView(label_city, kMargTB).leftSpaceToView(self.contentView,41).autoHeightRatio(0);
    
    label_intro_title.sd_layout.widthIs(kMainScreenWidth - 41 -25).heightIs(kHeightLabel).topSpaceToView(label_cer, kMargTB).leftSpaceToView(self.contentView,41).autoHeightRatio(0);
    
    label_intro_content.sd_layout.widthIs(kMainScreenWidth - 41 -25).heightIs(kHeightLabel).topSpaceToView(label_intro_title, kMargTB).leftSpaceToView(self.contentView,41).autoHeightRatio(0);
    
    view_line.sd_layout.widthIs(kMainScreenWidth - 41).heightIs(1).topSpaceToView(label_intro_content, kMargTB).leftSpaceToView(self.contentView,41);
    
    ball_outter.sd_layout.widthIs(14).heightIs(14).topSpaceToView(self.contentView, 9).leftSpaceToView(self.contentView,18);
    
    ball_inner.sd_layout.widthIs(8).heightIs(8).topSpaceToView(ball_outter, 3).leftSpaceToView(ball_outter,3);
    
}

-(void)setType:(NSInteger)type{
    _type= type;
    
    if(_type == 0){
        line_vertical.sd_layout.widthIs(3).topSpaceToView(ball_outter, 0).leftSpaceToView(self.contentView,24).bottomEqualToView(label_intro_content);
    }else if(_type == 1){
        line_vertical.sd_layout.widthIs(3).topSpaceToView(ball_outter, 0).leftSpaceToView(self.contentView,24).bottomEqualToView(self.contentView);
    }else if(_type == 2){
        line_vertical_upper.sd_layout.widthIs(3).heightIs(9).topSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView,24);
        line_vertical.sd_layout.widthIs(3).topSpaceToView(ball_outter, 0).leftSpaceToView(self.contentView,24).bottomEqualToView(self.contentView);
    }else if(_type == 3){
        line_vertical_upper.sd_layout.widthIs(3).heightIs(9).topSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView,24);
        line_vertical.sd_layout.widthIs(3).topSpaceToView(ball_outter, 0).leftSpaceToView(self.contentView,24).bottomEqualToView(label_intro_content);
    }
    
}

-(void)setModel:(TrainEXPModel *)model{
    _model = model;
    label_name.text = [NSString stringWithFormat:@"%@",_model.train_name];
    label_date.text = [NSString stringWithFormat:@"%@ - %@",_model.date_start,_model.date_end];
    label_city.text = [NSString stringWithFormat:@"培训地点：%@",_model.train_city];
    label_cer.text = [NSString stringWithFormat:@"培训证书：%@",_model.train_cer];
    label_intro_title.text = @"培训内容";
    label_intro_content.text = [NSString stringWithFormat:@"%@",_model.train_intro];
    [self setupAutoHeightWithBottomView:view_line bottomMargin:18];
    
}

-(void)onClickBtnEdit:(UIButton *)sender
{
    NSLog(@"点击了培训经验编辑按钮");
    if(_delegate&&[_delegate respondsToSelector:@selector(editTrainEXPItem:IndexPath:)]){
        [_delegate editTrainEXPItem:_model IndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    // Configure the view for the selected state
}

@end
