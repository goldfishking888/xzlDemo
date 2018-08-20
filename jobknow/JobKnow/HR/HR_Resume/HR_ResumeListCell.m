//
//  HR_ResumeListCell.m
//  JobKnow
//
//  Created by Suny on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeListCell.h"

#define Cell_Space 10

#define color_title [UIColor blackColor]
#define color_date RGBA(145, 145, 145, 1)
#define cell_height 80
#define cell_line RGBA(234, 234, 234, 1)

@implementation HR_ResumeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        //logo图片
        EGOImageView *logoImage=[[EGOImageView alloc] init];
//        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(10, 10, 55, 55);
        [logoImage setTag:2];
        [logoImage.layer setCornerRadius:logoImage.frame.size.width/2];
        [logoImage.layer setMasksToBounds:YES];
        [self addSubview:logoImage];
        
        
        //标题
        UILabel *titlelabel =[[UILabel alloc] initWithFrame:CGRectMake(Cell_Space*2+logoImage.frame.size.width ,10, 60 , 15)];
        titlelabel.tag=3;
        [titlelabel setText:@"未设置"];
        [titlelabel setBackgroundColor:[UIColor clearColor]];
        [titlelabel setFont:[UIFont systemFontOfSize:15]];
        [titlelabel setTextColor:color_title];
        [self addSubview:titlelabel];
        
        //性别和年龄
        UIButton *btn_gender_age = [[UIButton alloc] initWithFrame:CGRectMake(Cell_Space*2+logoImage.frame.size.width+titlelabel.frame.size.width-5 ,13, 50 , 15)];
        [btn_gender_age setImage:[UIImage imageNamed:@"hr_gender_male_small"] forState:UIControlStateNormal];
//        [btn_gender_age.imageView setFrame:CGRectMake(0, 0, 10, 10)];
        [btn_gender_age setBackgroundColor:[UIColor clearColor]];
        [btn_gender_age setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_gender_age setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [btn_gender_age setTitle:@"25岁" forState:UIControlStateNormal];
        [btn_gender_age setTitleEdgeInsets:UIEdgeInsetsMake(0,5, 0, 0)];
        [btn_gender_age.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn_gender_age setTitleColor:color_date forState:UIControlStateNormal];
        [self addSubview:btn_gender_age];
        [btn_gender_age setTag:8];
        
        //设定简历价格
//        UIButton *btn_price = [[UIButton alloc] initWithFrame:CGRectMake(iPhone_width-100-20, 12, 90, 26)];
//        [btn_price setBackgroundColor:XZhiL_colour];
//        [btn_price.layer setCornerRadius:2];
//        [btn_price.layer setMasksToBounds:YES];
//        [btn_price.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [btn_price setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn_price setTitle:@"设定简历价格" forState:UIControlStateNormal];
//        [self addSubview:btn_price];
//        [btn_price addTarget:self action:@selector(clickRsumePrice) forControlEvents:UIControlEventTouchUpInside];
//        [btn_price setTag:9];
        
        //工作年限
        UILabel *workDateLabel =[[UILabel alloc] initWithFrame:CGRectMake(Cell_Space*2+logoImage.frame.size.width, 34, 80, 14)];
        workDateLabel.tag=4;
        [workDateLabel setText:@"工作1年"];
        [workDateLabel setBackgroundColor:[UIColor clearColor]];
        [workDateLabel setFont:[UIFont systemFontOfSize:13]];
        [workDateLabel setTextColor:color_date];
        [workDateLabel setNumberOfLines:1];
        [self addSubview:workDateLabel];
        
        //日期
        UILabel *timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(iPhone_width-100-30, 55, 100, 14)];
        timeLabel.tag=5;
        [timeLabel setText:@"2015-08-03"];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:13]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        timeLabel.textColor=color_date;
        [self addSubview:timeLabel];
        
        //右箭头
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(iPhone_width-30,25, 30, 30)];
        [btn setTag:6];
        [btn setImage:[UIImage imageNamed:@"arrow_gray_right"] forState:UIControlStateNormal];
        [btn setEnabled:NO];
        [self addSubview:btn];
        
        //标题
        UILabel *positionlabel =[[UILabel alloc] initWithFrame:CGRectMake(Cell_Space*2+logoImage.frame.size.width ,55, 130 , 15)];
        positionlabel.tag=7;
        [positionlabel setText:@"人力资源"];
        [positionlabel setBackgroundColor:[UIColor clearColor]];
        [positionlabel setFont:[UIFont systemFontOfSize:13]];
        [positionlabel setTextColor:color_title];
        [self addSubview:positionlabel];
        
//        line
        UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, cell_height-1, iPhone_width, 1)];
        [view_line setTag:99];
        [view_line setBackgroundColor:cell_line];
        [self addSubview:view_line];
    }
    return self;
}

-(void)setModel:(HRReumeModel *)model{
    
    _resumeModel = model;
//    
//    //头像
    EGOImageView *logoImage =(EGOImageView *)[self viewWithTag:2];
    //姓名
    UILabel *nameLabel =(UILabel *)[self viewWithTag:3];
    //工作年限
    UILabel *workDateLabel =(UILabel *)[self viewWithTag:4];
    //日期
    UILabel *timeLabel =(UILabel *)[self viewWithTag:5];
    //右箭头
    UIButton *gzbtn =(UIButton *)[self viewWithTag:6];
    //职位
    UILabel *positionlabel = (UILabel *)[self viewWithTag:7];
    //性别年龄
    UIButton *btn_gender_age =(UIButton *)[self viewWithTag:8];
    //简历价格 简历不显示价格
    //UIButton *btn_price =(UIButton *)[self viewWithTag:9];
    
//    if (!model.resumePrice || [model.resumePrice isEqualToString:@""]) {
//        [btn_price setBackgroundColor:XZhiL_colour];
//        [btn_price.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [btn_price setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn_price setTitle:@"设定简历价格" forState:UIControlStateNormal];
//        [btn_price setEnabled:YES];
//        [btn_price setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//    }else{
//        [btn_price setBackgroundColor:[UIColor clearColor]];
//        [btn_price setTitleColor:XZhiL_colour forState:UIControlStateNormal];
//        [btn_price setTitle:[NSString stringWithFormat:@"￥%@元",model.resumePrice] forState:UIControlStateNormal];
//        [btn_price setEnabled:NO];
//        [btn_price setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    }
    
    UIView *view_line = (UIView *)[self viewWithTag:99];
    if (!view_line) {
        view_line = [[UIView alloc] init];
        
    }
    [view_line setBackgroundColor:color_view_line];
    [view_line setFrame:CGRectMake(0, cell_height-1, iPhone_width, 1)];
   
    NSLog(@"%@",model.facePath);
    if (![model.facePath isNullOrEmpty]) {
        [logoImage setImageURL:[NSURL URLWithString:model.facePath]];

    }else{
        [logoImage setImage:[UIImage imageNamed:@"hr_Resume_Avatar"]];
    }
    
    [nameLabel setFrame:CGRectMake(Cell_Space*2+logoImage.frame.size.width ,10, 60 , 15)];
    [nameLabel setText:model.name];
    [nameLabel sizeToFit];
    
    if ([model.workYear isEqualToString:@"不限"]||[model.workYear isEqualToString:@"在读学生"]||[model.workYear isEqualToString:@"应届毕业生"]||[model.workYear isEqualToString:@"在读"]) {
        [workDateLabel setText:model.workYear];
    }else if([model.workYear integerValue]<=0){
        if ([model.workYear isEqualToString:@"-2"]) {
            [workDateLabel setText:@"不限"];
        }else if ([model.workYear isEqualToString:@"-1"]){
            [workDateLabel setText:@"在读学生"];
        }else if ([model.workYear isEqualToString:@"0"]){
            [workDateLabel setText:@"应届毕业生"];
        }
    }else
        [workDateLabel setText:[NSString stringWithFormat:@"工作%@年",model.workYear]];
    
    [timeLabel setText:model.alterDate];
    
    [positionlabel setText:model.jobSortName];
    [btn_gender_age setBackgroundColor:[UIColor clearColor]];
    if ([model.sex isEqualToString:@"2"]||[model.sex isEqualToString:@"男"]) {
        [btn_gender_age setImage:[UIImage imageNamed:@"hr_gender_male_small"] forState:UIControlStateNormal];
        //        [btn_gender_age.imageView setFrame:CGRectMake(0, 0, 10, 10)];
    }else if([model.sex isEqualToString:@"1"]||[model.sex isEqualToString:@"女"]){
        [btn_gender_age setImage:[UIImage imageNamed:@"hr_gender_female_small"] forState:UIControlStateNormal];
    }
    [btn_gender_age setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    if (![[NSString stringWithFormat:@"%@",model.age] isEqualToString:@""]) {
        [btn_gender_age setTitle:[NSString stringWithFormat:@"%@岁",model.age] forState:UIControlStateNormal];
        [btn_gender_age setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }else{
        [btn_gender_age setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    }
    
    [btn_gender_age setFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+2, btn_gender_age.frame.origin.y, btn_gender_age.frame.size.width, btn_gender_age.frame.size.height)];
    
}

-(void)clickRsumePrice{
    if ([_delegate respondsToSelector:@selector(addResumePrice:IndexPath:)]) {
        [_delegate addResumePrice:_resumeModel IndexPath:_indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
