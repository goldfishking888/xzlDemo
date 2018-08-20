//
//  ZhangXinCell.m
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ZhangXinCell.h"
#import "myButton.h"
#import "RTLabel.h"
@implementation ZhangXinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _nameLabel=[[RTLabel alloc]initWithFrame:CGRectMake(50,15,80,40)];
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.font=[UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _increaseLabel=[[RTLabel alloc]initWithFrame:CGRectMake(140,15,80,40)];
        _increaseLabel.backgroundColor=[UIColor clearColor];
        _increaseLabel.font=[UIFont systemFontOfSize:15];
        _increaseLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_increaseLabel];
        
        _priceLabel=[[RTLabel alloc]initWithFrame:CGRectMake(iPhone_width-60,15,50,40)];
        _priceLabel.backgroundColor=[UIColor clearColor];
        _priceLabel.textColor=XZhiL_colour;
        _priceLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_priceLabel];
    }
    
    return self;
}

- (void)setTitleForLabel:(NSString *)first andSecond:(NSString *)second andThird:(NSString *)third
{
    _nameLabel.text=first;
    
    _increaseLabel.text=second;
    
    _priceLabel.text=third;
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
