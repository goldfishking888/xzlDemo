//
//  HR_HomeAddView.m
//  JobKnow
//
//  Created by WangJinyu on 15/8/6.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_HomeAddView.h"
@interface HR_HomeAddView()
{
    UIImageView* btnBg;
    
}

@property (strong, nonatomic) NSArray* titleArr;
@property (strong, nonatomic) NSArray* imagesArr;
@end
@implementation HR_HomeAddView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.37);
        
        _titleArr = [NSArray arrayWithObjects:@"全城职位",@"我的HR圈", nil];
        //_imagesArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"connection_main_company"],[UIImage imageNamed:@"connection_main_connection"],[UIImage imageNamed:@"connection_main_group"],nil];
        
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    UIImage* bgImage = [UIImage imageNamed:@"pop_bg2"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:25 topCapHeight:30];
    
    btnBg = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 60, -7.7, 120, 37*2 + 5)];
    btnBg.userInteractionEnabled = YES;
    btnBg.image = bgImage;
    [self addSubview:btnBg];
    
    for (int i = 0; i<2; i++) {
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(2.5,7.7+36*i, 120, 36.5)];
        [btnBg addSubview:btn];
        btn.tag = i+10086;
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(2, 36.5, 110, 0.5)];
        line.image = [UIImage imageNamed:@"page_category_line"];
        line.backgroundColor = RGBA(152, 167, 160, 1);
        if (i == 1) {
            
        }
        else
        {
            [btn addSubview:line];
        }
        //标题
//        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.font = [UIFont systemFontOfSize:14];
//        titleLabel.textColor = [UIColor blackColor];
//        titleLabel.text = _titleArr[i];
//        [btn addSubview:titleLabel];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _signalBtn.tag = 1;
    
    self.hidden = YES;
}
-(void)occlusion:(UIButton*)sender
{
    NSLog(@"哎呀");
}
-(void)chose:(UIButton*)sender
{
    _signalBtn.tag = 1;
    
    if (sender.tag - 10086 == 0) {
        NSLog(@"点击了全城职位");
        
    }else //if (sender.tag - 10086 == 1)
    {
        NSLog(@"点击了我的HR圈职位");
        
    }
    self.hidden = YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
