
//
//  MyTableCell.m
//  MyTableViewCell
//
//  Created by Ibokan on 12-10-14.
//  Copyright (c) 2012年 Ibokan. All rights reserved.
//

#import "MyTableCell.h"

@implementation MyTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imagview=[[UIImageView alloc]initWithFrame:CGRectMake(12, 8, 24, 24)];
        [self.contentView addSubview:self.imagview];
        self.labname=[[UILabel alloc]initWithFrame:CGRectMake(37, 10, 290, 20)];
//        self.labname.font= [UIFont systemFontOfSize:15];
        self.labname.textColor = [UIColor darkGrayColor];
        [self.labname setFont:[UIFont fontWithName:Zhiti size:14]];
        self.labname.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.labname];
        
        
        self.la_jifen = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 60, 20)];
        self.la_jifen.textColor = [UIColor grayColor];
        self.la_jifen.font = [UIFont systemFontOfSize:14];
        [self.la_jifen setBackgroundColor:[UIColor clearColor]];
        [self.la_jifen setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.la_jifen];
        
        self.la_laiyuan = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 60, 20)];
        [self.la_laiyuan setBackgroundColor:[UIColor clearColor]];
        self.la_laiyuan.textColor = [UIColor grayColor];
        self.la_laiyuan.font = [UIFont systemFontOfSize:14];
        [self.la_laiyuan setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.la_laiyuan];
        
        self.la_riqi = [[UILabel alloc]initWithFrame:CGRectMake(220, 20, 60, 20)];
        self.la_riqi.textColor = [UIColor grayColor];
        [self.la_riqi setBackgroundColor:[UIColor clearColor]];
        self.la_riqi.font = [UIFont systemFontOfSize:14];
        [self.la_riqi setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.la_riqi];
     /*****************************简历自定义***********/
        
        self.alabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
        self.alabel.backgroundColor = [UIColor clearColor];
        self.alabel.textAlignment = NSTextAlignmentRight;
        self.alabel.textColor = [UIColor grayColor];
        self.alabel.font = [UIFont fontWithName:Zhiti size:14];
        [self.contentView addSubview:self.alabel];
   
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
