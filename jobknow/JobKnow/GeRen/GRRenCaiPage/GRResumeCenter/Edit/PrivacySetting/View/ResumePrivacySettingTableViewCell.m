//
//  ResumePrivacySettingTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "ResumePrivacySettingTableViewCell.h"
#import "GRResumePrivacyModel.h"
#import "LanguageLevelModel.h"


#define kMargLR 21
//#define kMargTB 15
#define kHeightLabel 56
#define kTextColor RGB(74, 74, 74)
#define kTextFont [UIFont systemFontOfSize:15]
#define CellHeight 56


@implementation ResumePrivacySettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    _label_title = [UILabel new];
    _label_title.textAlignment = NSTextAlignmentLeft;
    _label_title.textColor = kTextColor;
    _label_title.font = kTextFont;
    [self.contentView addSubview:_label_title];
    [_label_title setFrame:CGRectMake(53, 0, kMainScreenWidth-53, CellHeight)];
    
    _imageView_icon = [UIImageView new];
    _imageView_icon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLeftImageView)];
    [_imageView_icon addGestureRecognizer:tap];
    [self.contentView addSubview:_imageView_icon];
    [_imageView_icon setFrame:CGRectMake(kMargLR, 18, 20, 20)];
    
    _view_line = [[UIView alloc] initWithFrame:CGRectMake(22, 55, kMainScreenWidth-18, 1)];
    _view_line.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:_view_line];
    
    _tf_title = [UITextField new];
    _tf_title.textAlignment= NSTextAlignmentLeft;
    _tf_title.textColor = kTextColor;
    _tf_title.font = kTextFont;
    _tf_title.returnKeyType = UIReturnKeyDone;
    _tf_title.delegate = self;
    mViewBorderRadius(_tf_title, 3, 1, RGB(255, 163, 29));
    _tf_title.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:_tf_title];
    [_tf_title setFrame:CGRectMake(53, 10, kMainScreenWidth-53-21, CellHeight-10*2)];


}

-(void)setModel:(GRResumePrivacyModel *)model indexPath:(NSIndexPath *)indexPath{
    if(indexPath.section!=2){
        if (indexPath.section == 4&&indexPath.row == 2) {
            _imageView_icon.userInteractionEnabled = YES;
        }else{
            _imageView_icon.userInteractionEnabled = NO;
        }
        
    }else{
        _imageView_icon.userInteractionEnabled = YES;
    }
    _model = model;
    _indexPath = indexPath;
    
    _label_title.text = @"";
    _imageView_icon.image = nil;
    _view_line.hidden = NO;
    _label_title.hidden = NO;
    _tf_title.text = @"";
    
    if (indexPath.section == 2) {
        _tf_title.placeholder = @"请输入您想要屏蔽的公司的关键字";
    }else if (indexPath.section == 4){
        _tf_title.placeholder = @"比如18点至21点，周末节假日全天";
    }
    _tf_title.hidden = YES;
}

-(void)setModelLanEdit:(LanguageLevelModel *)model indexPath:(NSIndexPath *)indexPath{
//    _model = model;
    _indexPath = indexPath;
    
    _label_title.text = @"";
    _imageView_icon.image = nil;
    _view_line.hidden = NO;
    _label_title.hidden = NO;
    _tf_title.text = @"";
    _tf_title.hidden = YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (_delegate&&[_delegate respondsToSelector:@selector(confirmTimeTFWithStringValue:IndexPath:)]) {
        [_delegate confirmTimeTFWithStringValue:textField.text IndexPath:_indexPath];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_delegate&&[_delegate respondsToSelector:@selector(confirmTimeTFWithStringValue:IndexPath:)]) {
        [_delegate confirmTimeTFWithStringValue:textField.text IndexPath:_indexPath];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",string);
    if (_delegate&&[_delegate respondsToSelector:@selector(confirmTimeTFWithStringValue:IndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:99 inSection:4];
        [_delegate confirmTimeTFWithStringValue:[textField.text stringByAppendingString:string] IndexPath:indexPath];
    }
    return YES;
}

- (void)onClickLeftImageView{
    if(_indexPath.section == 2 ||_indexPath.section == 4){
        if (_delegate&&[_delegate respondsToSelector:@selector(deleteCellWithIndexPath:)]) {
            [_delegate deleteCellWithIndexPath:_indexPath];
        }
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
