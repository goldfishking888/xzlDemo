//
//  XZLNewPMListCell.m
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "XZLNewPMListCell.h"

@implementation XZLNewPMListCell
{
    UIImageView *headImageView;
    UIButton *countBtn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 9, 50, 50)];
        headImageView.layer.cornerRadius = 5;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        countBtn.frame = CGRectMake(43, 2, 13, 13);
        [self addSubview:countBtn];
    }
    return self;
}

- (void)setModelData:(XZLPMListModel *)model
{
    UIImage *headImage = [UIImage imageNamed:@"company_logo"];
    //获取头像
    if (model.portrait && model.portrait.length > 0) {
        [headImageView setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:headImage];
    }else
    {
        headImageView.image = headImage;
    }
    //未读数量
    if ([model.unRead isEqualToString:@"1"]) {
        countBtn.hidden = NO;
        [countBtn setTitle:[NSString stringWithFormat:@"%@",@""]  forState:UIControlStateNormal];
        [countBtn setBackgroundColor:mRGBColor(251, 36, 48)];
        [countBtn.layer setCornerRadius:countBtn.frame.size.width/2];
        [countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [countBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }else{
        countBtn.hidden = YES;
    }
    NSString *msg ;
//    if ([model.type isEqualToString:@"0"]) {
//        msg = model.msg;
//    } else if ([model.type isEqualToString:@"1"]) {
//        msg = @"[图片]";
//    } else if ([model.type isEqualToString:@"2"]) {
//        msg = @"[语音]";
//    } else if ([model.type isEqualToString:@"4"]||[model.type isEqualToString:@"8"]) {
//        msg = model.msg;
//    } else{
        msg = model.content;
//    }
    
    NSString *resultStr = [model.content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    model.content = resultStr;
    NSData *data = [model.content dataUsingEncoding:NSUnicodeStringEncoding];
    //        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                               options:options
                                                    documentAttributes:nil
                                                                 error:nil];
//    textLabel.attributedText = html;
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, kMainScreenWidth-96, 25)];
    msgLabel.font = kContentFontSmall;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:msgLabel];
    [msgLabel setTextColor:[UIColor colorWithHex:0x797979 alpha:1]];
//    msgLabel.text = msg;
    msgLabel.attributedText = html;
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 155, 25)];
    nameLabel.font = kContentFontMiddle;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    nameLabel.text = model.name.length>0 ? model.name :@"未实名用户";
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 100, 5, 90, 25)];
    dateLabel.font = kContentFontMiddle;
    [self.contentView addSubview:dateLabel];
    dateLabel.text = [XZLUtil stringBecomeTime:model.created_time];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [dateLabel setTextColor:[UIColor colorWithHex:0x797979 alpha:1]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 67, kMainScreenWidth,1)];
    lineView.backgroundColor = RGBA(216, 216, 220, 1);
    [self.contentView addSubview:lineView];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
