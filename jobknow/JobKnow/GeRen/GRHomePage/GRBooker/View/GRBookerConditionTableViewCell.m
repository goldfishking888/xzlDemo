//
//  GRBookerConditionTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRBookerConditionTableViewCell.h"
#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 15
#define kTextColor RGB(74, 74, 74)
#define kTextColorDefault RGB(204, 203, 203)
#define kTextFont [UIFont systemFontOfSize:14]

#define kCellHeight 51
#define kLabelTitleWidth 60

@implementation GRBookerConditionTableViewCell{
    UILabel *label_title;//cell标题
    UIView *view_line;//分割线
    
    UILabel *label_value;//label值
    UITextField *tf_value;//tf值
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    label_title = [UILabel new];
    label_title.textAlignment = NSTextAlignmentLeft;
    label_title.textColor = kTextColor;
    label_title.font = kTextFont;
    [self.contentView addSubview:label_title];
    
    label_value = [UILabel new];
    label_value.textAlignment = NSTextAlignmentRight;
    label_value.textColor = kTextColorDefault;
    label_value.font = kTextFont;
    [self.contentView addSubview:label_value];
    
    tf_value = [UITextField new];
    tf_value.backgroundColor = RGB(239, 239, 239);
    tf_value.textAlignment = NSTextAlignmentLeft;
    tf_value.textColor = kTextColor;
    tf_value.font = kTextFont;
    tf_value.delegate = self;
    tf_value.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf_value.returnKeyType = UIReturnKeyDone;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    leftView.backgroundColor = [UIColor whiteColor];
    tf_value.leftView = leftView;
    tf_value.leftViewMode = UITextFieldViewModeAlways;
    
    [self.contentView addSubview:tf_value];
    
    view_line = [UIView new];
    view_line.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:view_line];
    
    [label_title setFrame:CGRectMake(28, 0, kLabelTitleWidth, kCellHeight)];
    [label_value setFrame:CGRectMake(kLabelTitleWidth+28+10, 0, kMainScreenWidth-kLabelTitleWidth-28-10 -44, kCellHeight)];
    [tf_value setFrame:CGRectMake(116, 8, kMainScreenWidth-kLabelTitleWidth-28-32 -25, 32)];
    mViewBorderRadius(tf_value, 16, 1, [UIColor clearColor]);
    //    tf_value.backgroundColor = [UIColor greenColor];
    [view_line setFrame:CGRectMake(28, kCellHeight-1, kMainScreenWidth-28, 1)];
}

-(void)setTitleValue:(NSString *)labelValue{
    
    label_title.text = [NSString stringWithFormat:@"%@",labelValue];
}

-(void)setLabelValue:(NSString *)labelValue DefaultValue:(NSString *)defaultValue{
    tf_value.hidden = YES;
    label_value.hidden = NO;
    
    if ([NSString isNullOrEmpty:labelValue]) {
        label_value.text = [NSString stringWithFormat:@"%@",defaultValue];
        label_value.textColor = kTextColorDefault;
        return;
    }
    
    label_value.text = [NSString stringWithFormat:@"%@",labelValue];
    label_value.textColor = kTextColor;
}

-(void)setTextFieldValue:(NSString *)labelValue DefaultValue:(NSString *)defaultValue{
    if (!labelValue) {
        labelValue = @"";
    }
    label_value.hidden = YES;
    tf_value.hidden = NO;
    
    tf_value.text = [NSString stringWithFormat:@"%@",labelValue];
    tf_value.placeholder = defaultValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(editCellWithStringValue:IndexPath:)]) {
        [self.delegate editCellWithStringValue:tf_value.text IndexPath:_indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)setSepLineHidden:(BOOL)hidden{
    view_line.hidden = hidden;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
