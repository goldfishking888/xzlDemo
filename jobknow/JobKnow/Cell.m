//
//  Cell.m
//  Cell-Demo
//
//  Created by king on 13-4-10.
//  Copyright (c) 2013年 jiazuo. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width - 35, 14, 10, 10)];
        [self addSubview:self.arrowImageView];
        self.myImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12, 11, 11)];
        [self addSubview:self.myImg];
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 180, 20)];
        self.titleLabel.numberOfLines = 2;
        [self addSubview:self.titleLabel];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"cell_arrow01@2x"];
        self.myImg.image = [UIImage imageNamed:@"point_up@2x.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"cell_arrow@2x.png"];
        self.myImg.image = [UIImage imageNamed:@"point.png"];
    }
}

@end
