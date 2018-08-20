//
//  InterestsHobbiesTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "InterestsHobbiesTableViewCell.h"
#import "InterestsHobbiesModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 14
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:14]

@implementation InterestsHobbiesTableViewCell{
    UILabel *label_content;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    label_content = [UILabel new];
    label_content.textAlignment = NSTextAlignmentLeft;
    label_content.textColor = RGB(0, 0, 0);
    label_content.font = kTextFont;
    label_content.numberOfLines = 0;
    [self.contentView addSubview:label_content];
    label_content.sd_layout.widthIs(kMainScreenWidth - kMargLR *2).heightIs(kHeightLabel).topSpaceToView(self.contentView, 2).leftSpaceToView(self.contentView,kMargLR).autoHeightRatio(0);
}

-(void)setModel:(InterestsHobbiesModel *)model{
    _model = model;
    label_content.text = [NSString stringWithFormat:@"%@",_model.content];
    [self setupAutoHeightWithBottomView:label_content bottomMargin:kMargTB];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
