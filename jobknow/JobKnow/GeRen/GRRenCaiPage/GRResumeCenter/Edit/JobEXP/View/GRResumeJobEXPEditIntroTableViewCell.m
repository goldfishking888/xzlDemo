//
//  GRResumeJobEXPEditIntroTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeJobEXPEditIntroTableViewCell.h"

#define W(x) kScreenWidth*(x)/320.0
#define H(y) kScreenHeight*(y)/568.0
#define kMargLR 19
#define kMargTB 15
#define kHeightLabel 15
#define kTextColor RGB(74, 74, 74)
#define kTextColorDefault RGB(204, 203, 203)
#define kTextFont [UIFont systemFontOfSize:15]

#define kCellHeight 56
#define kLabelTitleWidth 95

//#define MaxCount 200

@implementation GRResumeJobEXPEditIntroTableViewCell{
    UILabel *label_title;//cell标题
    UIView *view_back;//
    UITextView *tv_content;
    UITextView *placeHolderLabel;
    UILabel *label_count;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    if (!_maxCount) {
        _maxCount = 200;
    }
    
    label_title = [UILabel new];
    label_title.textAlignment = NSTextAlignmentLeft;
    label_title.textColor = kTextColor;
    label_title.font = kTextFont;
    [self.contentView addSubview:label_title];
    
    view_back = [UIView new];
    view_back.backgroundColor = RGB(247, 247, 247);
    [self.contentView addSubview:view_back];
    
    placeHolderLabel = [UITextView new];
    placeHolderLabel.textColor = RGB(204, 203, 203);
    placeHolderLabel.font = kTextFont;
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.delegate = self;
    placeHolderLabel.returnKeyType = UIReturnKeyDone;
    [view_back addSubview:placeHolderLabel];
    
    tv_content = [UITextView new];
    tv_content.textColor = kTextColor;
    tv_content.font = kTextFont;
    tv_content.delegate = self;
    tv_content.backgroundColor = [UIColor clearColor];
    tv_content.returnKeyType = UIReturnKeyDone;
    [view_back addSubview:tv_content];
    
    label_count = [UILabel new] ;
    label_count.text = [NSString stringWithFormat:@"0/0"];
    label_count.textColor = RGB(170, 170, 170);
    label_count.font = [UIFont systemFontOfSize:15];
    label_count.textAlignment = NSTextAlignmentRight;
    [view_back addSubview:label_count];
    
    [label_title setFrame:CGRectMake(25, 0, kLabelTitleWidth, kCellHeight)];
    [view_back setFrame:CGRectMake(20, 50, kMainScreenWidth-20*2, 168)];
    [placeHolderLabel setFrame:CGRectMake(10, 10, view_back.width-10*2, view_back.height-36-10)];
    [tv_content setFrame:CGRectMake(10, 10, view_back.width-10*2, view_back.height-36-10)];
    [label_count setFrame:CGRectMake(view_back.width-17-80, view_back.height-34, 80, 28)];

}

-(void)setTitleValue:(NSString *)labelValue{
    
    label_title.text = [NSString stringWithFormat:@"%@",labelValue];
}

-(void)setContent:(NSString *)content placeHolder:(NSString *)value{
    label_count.text = [NSString stringWithFormat:@"%d/%ld",content.length,(long)_maxCount];
    
    if (_hasNOCountLimit) {
        label_count.hidden = YES;
        [tv_content setFrame:CGRectMake(10, 10, view_back.width-10*2, view_back.height-10*2)];
    }
    
    tv_content.text = [NSString stringWithFormat:@"%@",content];
    if ([tv_content.text isNullOrEmpty]) {
        placeHolderLabel.text = [NSString stringWithFormat:@"%@",value];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        placeHolderLabel.hidden = YES;
    }else{
        placeHolderLabel.hidden = NO;
    }
    label_count.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)textView.text.length,(long)_maxCount];
    if([self.delegate respondsToSelector:@selector(contentDidChangeTo:IndexPath:)]) {
        [self.delegate contentDidChangeTo:tv_content.text IndexPath:_indexPath];
    }
}

//该方法预留，打开该方法将键盘return变为点击收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }

    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location <_maxCount) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
