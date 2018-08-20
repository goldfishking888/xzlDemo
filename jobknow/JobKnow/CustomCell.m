//
//  CustomCell.m
//  JobKnow
//
//  Created by wangjinyu on 15/8/3.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "CustomCell.h"

 
@interface CustomCell ()
{
    UIButton*shoucang;
    BOOL _isY;
}

@end




@implementation CustomCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
        
    {
        //视图
        UIView *hrView=[[UIView alloc]initWithFrame:CGRectMake(5, 0, [[UIScreen mainScreen] bounds].size.width-10, 150)];
        
        hrView.backgroundColor=[UIColor whiteColor];
        
        //黄绿红蓝横线
        UIView*yh=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-10, 2)];
        
        yh.backgroundColor=[UIColor yellowColor];
        
        [hrView addSubview:yh];
        //职位名称
        self.zhiwei=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 20)];
        
    self.zhiwei.text=@"信息技术专员";
        
        [hrView addSubview:self.zhiwei];
        
        //公司名称
        self.gongsi=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, 200, 15)];
        
        self.gongsi.font=[UIFont systemFontOfSize:13];
        
        self.gongsi.text=@"青岛奇客创想信息科技有限公司";
        
        self.gongsi.textColor=[UIColor grayColor];
       
        [hrView addSubview:self.gongsi];
        
        //地点
        self.place=[[UILabel alloc]initWithFrame:CGRectMake(20, 70, 80, 15)];
        self.place.font=[UIFont systemFontOfSize:13];
        
        self.place.text=@"青岛";
        
        self.place.textColor=[UIColor grayColor];
        
        [hrView addSubview:self.place];
        //人数
        self.renshu=[[UILabel alloc]initWithFrame:CGRectMake(80+20, 70, 15, 15)];
        
        self.renshu.font=[UIFont systemFontOfSize:13];
        
        self.renshu.text=@"2";
        
        self.renshu.textColor=[UIColor grayColor];
        
        [hrView addSubview:self.renshu];
        
        //人
         self.ren=[[UILabel alloc]initWithFrame:CGRectMake(80+35, 70, 15, 15)];
        
         self.ren.font=[UIFont systemFontOfSize:13];
        
        self.ren.text=@"人";
        
        self.ren.textColor=[UIColor grayColor];
        
        [hrView addSubview:self.ren];
        
       //人民币
        self.imageViewhr=[[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-90-10, 20, 20, 20)];
        self.imageViewhr.image=[UIImage imageNamed:@"bonus_job_list"];
        
        [hrView addSubview:self.imageViewhr];
        
        //money
        self.money=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70-10, 0, 70, 60)];
        self.money.text=@"1000-1499元";
        self.money.textColor=[UIColor orangeColor];
        self.money.numberOfLines=0;
        
        self.money.font=[UIFont systemFontOfSize:13];
        
        
        
       self.Yuan=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70-10+60, 25, 70, 15)];
        self.Yuan.text=@"元";
        self.Yuan.textColor=[UIColor orangeColor];
        self.Yuan.numberOfLines=0;
        
        self.Yuan.font=[UIFont systemFontOfSize:13];
        
        
        
        [hrView addSubview:self.money];
        [hrView addSubview:self.Yuan];
        
        
        //时间
        self.time=[[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-10)-80, 70, 80, 10)];
        
        self.time.text=@"2015-07-02";
        
        self.time.font=[UIFont systemFontOfSize:13];
        
        
        self.time.textColor=[UIColor grayColor];
        
        [hrView addSubview:self.time];
        
        //横线
        UIView *hengxian=[[UIView alloc]initWithFrame:CGRectMake(20, 100, [[UIScreen mainScreen] bounds].size.width-40, 1)];
        
        hengxian.backgroundColor=[UIColor grayColor];
        hengxian.alpha=0.2;
        [hrView addSubview:hengxian];
        
        //收藏
       shoucang=[[UIButton alloc]initWithFrame:CGRectMake(30, 110, 20, 20)];
        
        [  shoucang setBackgroundImage:[UIImage imageNamed:@"hr_fav_n"] forState:UIControlStateNormal];
        
        
        [shoucang addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
        
        self.labshoucang=[[UILabel alloc]initWithFrame:CGRectMake(55, 115, 40, 15)];
        
        self.labshoucang.text=@"收藏";
        
        self.labshoucang.textColor=[UIColor grayColor];
        self.labshoucang.font=[UIFont systemFontOfSize:13];
      
        [hrView addSubview:  shoucang];
        [hrView addSubview:self.labshoucang];
        //推荐
        UIButton *tuijian=[[UIButton alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-10)/2-10, 110, 20, 20)];
        
        [tuijian setBackgroundImage:[UIImage imageNamed:@"hr_refer"] forState:UIControlStateNormal];
        
        
        
        self.labtuijian=[[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width-10)/2+10, 115, 40, 15)];
        
        self.labtuijian.text=@"推荐";
        
        [tuijian addTarget:self action:@selector(tuijian) forControlEvents:UIControlEventTouchUpInside];
        self.labtuijian.textColor=[UIColor grayColor];
        self.labtuijian.font=[UIFont systemFontOfSize:13];
        
        [hrView addSubview:tuijian];
        [hrView addSubview:self.labtuijian];
        
        //查看
        
        UIButton *chakan=[[UIButton alloc]initWithFrame:CGRectMake( [[UIScreen mainScreen] bounds].size.width-70 , 110, 20, 20)];
        
        [chakan setBackgroundImage:[UIImage imageNamed:@"hr_view"] forState:UIControlStateNormal];
        
        self.labchakan=[[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-50+5 , 110+3, 40, 15)];
        
        self.labchakan.text=@"查看";
        
        [chakan addTarget:self action:@selector(chakan) forControlEvents:UIControlEventTouchUpInside];
        self.labchakan.textColor=[UIColor grayColor];
        self.labchakan.font=[UIFont systemFontOfSize:13];
        
        [hrView addSubview:chakan];
        [hrView addSubview:self.labchakan];
        
        hrView.backgroundColor=[UIColor whiteColor];
        [self addSubview:hrView];
        
    }
    return self;
    
}
//收藏
-(void)shoucang{
     if (!_isY) {  //yes
        
        self.model.favNum+=1;
        [shoucang setBackgroundImage:[UIImage imageNamed:@"hr_fav_y"] forState:UIControlStateNormal];
        _isY=!_isY;
        HR_HomeViewController *homevc = [[HR_HomeViewController alloc]init];
//        HrHomeVC *homevc=[[HrHomeVC alloc]init];
        
        //[homevc shuaxinbiao];
        
        
        NSLog(@"%ld",self.model.favNum);
    }else{
        
         self.model.favNum-=1;
        
          [  shoucang setBackgroundImage:[UIImage imageNamed:@"hr_fav_n"] forState:UIControlStateNormal];
        _isY=!_isY;
        
        HR_HomeViewController *homevc = [[HR_HomeViewController alloc]init];
//        HrHomeVC *homevc=[[HrHomeVC alloc]init];
        
        //[homevc shuaxinbiao];
        NSLog(@"%ld",self.model.favNum);
    }
}

-(void)tuijian
{
    NSLog(@"推荐了");
}
-(void)chakan
{
    NSLog(@"查看了");
}

@end
