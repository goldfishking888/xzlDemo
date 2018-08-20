//
//  myTableCellapp.m
//  JobKnow
//
//  Created by Zuo on 13-11-22.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "myTableCellapp.h"

@implementation myTableCellapp

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                self.appRect=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,65)];
                self.appRect.backgroundColor=[UIColor whiteColor];
                [self.contentView addSubview:self.appRect];
                //其他应用推荐
                self.appImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 45, 45)];
                [self.contentView addSubview:self.appImgView];
        
                self.appName = [[UILabel alloc]initWithFrame:CGRectMake(57, 7, 200, 20)];
                self.appName.font = [UIFont systemFontOfSize:14];
                self.appName.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:self.appName];
        
                self.appJiesao = [[UILabel alloc]initWithFrame:CGRectMake(57, 32, 249, 25)];
                self.appJiesao.backgroundColor = [UIColor clearColor];
                self.appJiesao.font = [UIFont systemFontOfSize:13];
                self.appJiesao.textColor = [UIColor grayColor];
                [self.contentView addSubview:self.appJiesao];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
