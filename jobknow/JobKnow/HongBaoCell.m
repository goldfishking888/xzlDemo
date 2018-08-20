//
//  HongBaoCell.m
//  JobKnow
//
//  Created by Apple on 14-7-29.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "HongBaoCell.h"

@implementation HongBaoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
      
        _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,10,60,60)];
        _priceLabel.backgroundColor=[UIColor clearColor];
        _priceLabel.textColor=XZhiL_colour;
        _priceLabel.font=[UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:_priceLabel];
        
        _daijinLabel=[[UILabel alloc]initWithFrame:CGRectMake(70,10,200,30)];
        _daijinLabel.backgroundColor=[UIColor clearColor];
        _daijinLabel.font=[UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_daijinLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(70,50,200,30)];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.font=[UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_dateLabel];
        
        _tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(272,30,50,30)];
        _tipLabel.textAlignment=NSTextAlignmentLeft;
        _tipLabel.backgroundColor=[UIColor clearColor];
        _tipLabel.font=[UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_tipLabel];
    }
    
    return self;
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
