//
//  CustomSetCell.m
//  JobKnow
//
//  Created by Mathias on 15/7/9.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "CustomSetCell.h"

@implementation CustomSetCell
//自定义单元格，要重写下面这个方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
           UIView *views=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ([[UIScreen mainScreen] bounds].size.width)-20, 40)];
    
    
    self.imageViews=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    self.labels=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
    
    self.labels.font=[UIFont systemFontOfSize:13];
    [views addSubview:self.imageViews];
    [views addSubview:self.labels];
    
        views.backgroundColor=[UIColor whiteColor];
    
    [self addSubview:views];
    
        
        
        
        
        
        
    }
    return self;
}



@end
