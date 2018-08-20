//
//  MessageCell.m
//  JobKnow
//
//  Created by faxin sun on 13-4-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "MessageCell.h"
//#import "EGOImageView.h"
#import "UIImageView+AFNetworking.h"
@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(MessageListModel *)message
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.frame = CGRectMake(40, 2, 10, 10);
        //未读数量
        if ([[NSString stringWithFormat:@"%@",message.isread] isEqualToString:@"0"]) {
            _countBtn.hidden = NO;
            [_countBtn setTitle:[NSString stringWithFormat:@"%@",@""]  forState:UIControlStateNormal];
            //        UIImage *zcbg_xmzj = [UIImage imageNamed:@"redpoint.png"];
            //        UIImage *zcbgcap_xmzj = [zcbg_xmzj stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            //        [countBtn setBackgroundImage:zcbgcap_xmzj forState:UIControlStateNormal];
            [_countBtn setBackgroundColor:[UIColor redColor]];
            [_countBtn.layer setCornerRadius:_countBtn.frame.size.width/2];
            [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_countBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        }else{
            _countBtn.hidden = YES;
        }
        
        self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 160, 20)];
        self.companyName.textColor = RGBA(40, 100, 210, 1);
        self.companyName.backgroundColor = [UIColor clearColor];
        self.companyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        NSNull *null = [NSNull null];
        if ([message.name isEqual: null]) {
            self.companyName.text = @"";
        }
        else
        {
            self.companyName.text = message.name;
        }
        
        self.messageL = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 190, 20)];
        self.messageL.textColor = [UIColor darkGrayColor];
        self.messageL.backgroundColor = [UIColor clearColor];
        self.messageL.font = [UIFont systemFontOfSize:12];
//        self.messageL.text = message.msg;
        
        if ([message.type isEqualToString:@"0"]) {
            self.messageL.text = message.msg;
        } else if ([message.type isEqualToString:@"1"]) {
            self.messageL.text = @"[图片]";
        } else if ([message.type isEqualToString:@"2"]) {
            self.messageL.text = @"[语音]";
        } else if ([message.type isEqualToString:@"4"]||[message.type isEqualToString:@"8"]) {
            self.messageL.text = message.msg;
        }else{
            self.messageL.text = message.msg;
        }
        
        self.date = [[UILabel alloc]initWithFrame:CGRectMake(222, 5, 90, 20)];
        self.date.textColor = [UIColor darkGrayColor];
        self.date.textAlignment = NSTextAlignmentRight;
        self.date.backgroundColor = [UIColor clearColor];
        self.date.font = [UIFont systemFontOfSize:12];
        if (!message.dateline||!message.dateline.length) {
            message.dateline = @"";
        }else{
            self.date.text = [message.dateline substringToIndex:11];
        }
        
  
        self.backgroundColor=[UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
  
//        EGOImageView *egoIV = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"com_head.png"]];
//        [egoIV setImageURL:[NSURL URLWithString:message.msgListhead]];
//        _head = egoIV;
        UIImageView *imageview = [[UIImageView alloc] init];
        [imageview setImageWithURL:[NSURL URLWithString:message.msgListhead] placeholderImage:[UIImage imageNamed:@"com_head.png"]];
        _head = imageview;
        [_head setFrame:CGRectMake(5, 5, 40, 40)];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,49, 320, 1)];
        nameLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        [self.contentView addSubview:_head];
        [self.contentView addSubview:self.messageL];
        [self.contentView addSubview:self.companyName];
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:_countBtn];

    }
    return self;
}

/*
- (void)secondDefaultInit:(MessageListModel *)message
{
    return;
    
    NSNull *null = [NSNull null];
    if (message.hrHead&&![message.msgListhead isEqualToString:@""]) {
        [_head setImageURL:[NSURL URLWithString:message.msgListhead]];
    }else{
        _head.image = [UIImage imageNamed:@"com_head.png"];
    }
    
    if ([message.companyName isEqual: null]||[message.companyName isEqualToString:@""]) {
        self.companyName.text = message.hrName;
    }
    else
    {
        self.companyName.text = message.companyName;
    }
    
    self.cityName.text = [[NSString alloc] initWithFormat:@"%@",message.pmnum];
    //self.date.text = [message.lastTime substringWithRange:NSMakeRange(0, 5)];
    
    self.messageL.text = message.lastMessage;
    
}*/



@end
