//
//  LanguageLevelTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LanguageLevelTableViewCell.h"
#import "LanguageLevelModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 15
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:15]

@implementation LanguageLevelTableViewCell{
    UILabel *label_name;//语言和等级
    UILabel *label_l;//语言和等级
    UILabel *label_level;//语言和等级
    UIButton *btn_edit;//编辑按钮
    UIView *view_line;//分割线
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
    label_name.font = kTextFont;
//    label_name.numberOfLines = 0;
    [self.contentView addSubview:label_name];
    
    btn_edit = [UIButton new];
//    btn_edit.backgroundColor = [UIColor yellowColor];
    [btn_edit setImage:[UIImage imageNamed:@"resume_edit_btn"] forState:UIControlStateNormal];
    [btn_edit addTarget:self action:@selector(onClickBtnEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn_edit];
    
    view_line = [UIView new];
    view_line.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:view_line];
    
    label_name.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
    
    btn_edit.sd_layout.widthIs(15).heightIs(16).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 21);
    
    view_line.sd_layout.widthIs(kMainScreenWidth - kMargLR).heightIs(1).topSpaceToView(label_name, kMargTB/3).leftSpaceToView(self.contentView,kMargLR);

    
    
}

-(void)setType:(NSInteger)type{
    _type= type;
    
    if(_type == 0){
        label_name.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
        
        btn_edit.sd_layout.widthIs(24).heightIs(26).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 21);
        
        view_line.sd_layout.widthIs(kMainScreenWidth - kMargLR).heightIs(1).topSpaceToView(label_name, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    }else if(_type == 1){
        label_name.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
        
        btn_edit.sd_layout.widthIs(24).heightIs(26).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 21);
        
        view_line.hidden = YES;
    }else if(_type == 2){
        label_name.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
        
        btn_edit.sd_layout.widthIs(24).heightIs(26).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 21);
        
        view_line.sd_layout.widthIs(kMainScreenWidth - kMargLR).heightIs(1).topSpaceToView(label_name, kMargTB).leftSpaceToView(self.contentView,kMargLR);
    }else if(_type == 3){
        label_name.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR);
        
        btn_edit.sd_layout.widthIs(24).heightIs(26).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 21);
        
    }
        
}

-(void)setModel:(LanguageLevelModel *)model{
    _model = model;
    label_name.text = [NSString stringWithFormat:@"%@ | %@",_model.l_name,_model.l_level];
    
//    NSMutableAttributedString *strB = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@",_model.l_name,_model.l_level]];
//    
//    [strB addAttribute:NSForegroundColorAttributeName value:RGB(216, 216, 216) range:NSMakeRange(_model.l_name.length,3)];
//    
//    label_name.attributedText = strB;
    if(_type== 0||_type == 2){
        [self setupAutoHeightWithBottomView:view_line bottomMargin:18];
    }else{
        [self setupAutoHeightWithBottomView:label_name bottomMargin:2];
    }
    
}

-(void)onClickBtnEdit:(UIButton *)sender{
    NSLog(@"点击了语言能力编辑按钮");
    if(_delegate&&[_delegate respondsToSelector:@selector(editLanguageLevelItem:IndexPath:)]){
        [_delegate editLanguageLevelItem:_model IndexPath:_indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
//    [super setSelected:selected animated:animated];
}

@end
