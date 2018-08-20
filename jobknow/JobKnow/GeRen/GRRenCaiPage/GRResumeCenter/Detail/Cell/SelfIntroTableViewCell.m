//
//  SelfIntroTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelfIntroTableViewCell.h"
#import "SelfIntroModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 14
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:14]

@implementation SelfIntroTableViewCell{
    UILabel *label_intro;//自我评价
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    label_intro = [UILabel new];
    label_intro.textAlignment = NSTextAlignmentLeft;
    label_intro.textColor = kTextColor;
    label_intro.font = kTextFont;
    label_intro.numberOfLines = 0;
    [self.contentView addSubview:label_intro];
    
    label_intro.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR).autoHeightRatio(0);
}

-(void)setModel:(SelfIntroModel *)model{
    _model = model;
    label_intro.text = [NSString stringWithFormat:@"%@",_model.intro];
    [self setupAutoHeightWithBottomView:label_intro bottomMargin:kMargTB];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
