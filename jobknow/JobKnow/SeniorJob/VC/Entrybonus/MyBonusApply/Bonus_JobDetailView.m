//
//  Bonus_JobDetailView.m
//  JobKnow
//
//  Created by Suny on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "Bonus_JobDetailView.h"
#import "PositionModel.h"
#import "CustomButton.h"
#import "JobSeeViewController.h"
#define Labelfont [UIFont systemFontOfSize:14]

#define jobDetail(type,value) [[NSString alloc] initWithFormat:@"%@：%@",type,value]

#define cell_inner_space 12

@implementation Bonus_JobDetailView
@synthesize delegate;
@synthesize height;
@synthesize myTableView;

- (id)initWithFrame:(CGRect)frame WithJobDetail:(SeniorJobDetailModel *)model
{
    self = [super initWithFrame:frame];
    if (self){
        
        //得到数据源
        _positionModel=model;
        _count=0;
        height=0;
        _requireHeight=0;
        
        /*
         1.联系人
         2.电话
         3.邮箱
         4.网址
         5.地址
         */
        _dataArray=[NSMutableArray arrayWithObjects:_positionModel.email,_positionModel.curl,_positionModel.addr,nil];
        
        _dataArray1=[NSMutableArray arrayWithObjects:@"邮箱",@"网址",@"地址",nil];
        
        //_dataArray2
        _dataArray2=[[NSMutableArray alloc]init];
        
        for (int i=0;i<[_dataArray count];i++) {
            NSString *str=[_dataArray objectAtIndex:i];
            NSString *str2=[_dataArray1 objectAtIndex:i];
            if (![str isEqualToString:@""]) {
                _count++;
                [_dataArray2 addObject:str2];
            }
        }
        
        UIImageView  *feeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(cell_inner_space ,7, 40, 16)];
        feeImageV.image = [UIImage imageNamed:@"ic_senior"];
        [self addSubview:feeImageV];
        //职位名称
        
        _jobName = [[CustomLabel alloc]labelinitWithText2:_positionModel.jobName X:cell_inner_space +40 Y:2];
        _jobName.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        _jobName.textColor = [UIColor redColor];
        _jobName.backgroundColor = [UIColor clearColor];
        _jobName.numberOfLines = 0;
        _jobName.lineBreakMode = NSLineBreakByWordWrapping;
        //        [_jobName sizeToFit];
        [self addSubview:_jobName];
        
        NSLog(@"_jobName.frame.size.height is %f",_jobName.frame.size.height);
        
        
        height=height+_jobName.frame.size.height;
        
        //求出职位需求的高度，然后根据得到的高度设置相应的cell的高度
        NSString *text = [[NSString alloc]initWithFormat:@"%@",_positionModel.required];
        
        CGSize autoSize = CGSizeMake(iPhone_width, MAXFLOAT);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
        
        //_requireHeight的作用是用于设置显示require的cell的高度
        NSLog(@"职位需求的高度_requireHeight。。。。。。。。。。。 is %f",size.height);
        
        _requireHeight=size.height;
        
        //自己算下tableview高度

        height = 45*10 +_requireHeight +5 +76;
        index_default = 1;
       
        
        if (IOS7) {
            
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,_jobName.frame.size.height+5,iPhone_width,height) style:UITableViewStyleGrouped];
            
        }else
        {
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,_jobName.frame.size.height+5,iPhone_width,height) style:UITableViewStylePlain];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,1)];
            label.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
            [myTableView addSubview:label];
            
        }
        
        myTableView.backgroundColor=XZHILBJ_colour;
        myTableView.backgroundView=nil;
        myTableView.delegate=self;
        myTableView.dataSource=self;
        [self  addSubview:myTableView];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,iPhone_width, height);
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(performDelete) userInfo:nil repeats:NO];
    }
    return self;
}

- (void)resetDataArray:(SeniorJobDetailModel *)model{

}

-(void)performDelete
{
    NSLog(@"height in performDelete is %d",height);
    [self.delegate changeScreenHeight:height];
}

#pragma mark UITableView代理方法的实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (index_default ==1) {
            return 6;
        }
        return 5;
    }else
    {
        return _count+3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views=[cell.contentView subviews];
        for (UIView *v in views){
            [v removeFromSuperview];
        }
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        if (indexPath.row==4) {
            //薪资待遇
            RTLabel *label_rec =  [[RTLabel alloc] initWithFrame:CGRectMake(5,17,iPhone_width - 150,30)];
            label_rec.font = Labelfont;
            label_rec.backgroundColor = [UIColor clearColor];
            NSString *salaryStr = [NSString stringWithFormat:@"%@：<font color='#f76806'>%@元</font>",@"入职奖金",@"700-2000"];//_positionModel.bouns
            label_rec.text=salaryStr;
            [cell.contentView addSubview:label_rec];
            
            UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
            jiantou.frame = CGRectMake(300, 15, 15, 15);
            [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:jiantou];
//            if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isPayVip"]] isEqualToString:@"1"]){
//                [jiantou setHidden:YES];
//            }
        }else if (indexPath.row==0) {
            
            //发布日期
            _pubDateLab = [[UILabel alloc] initWithFrame:CGRectMake(5,10, iPhone_width - 165, 30)];
            _pubDateLab.font = Labelfont;
            _pubDateLab.backgroundColor = [UIColor clearColor];
            _pubDateLab.text = jobDetail(@"发布日期",_positionModel.pubDate);
            
            
            //学历要求
            _degreeLab = [[UILabel alloc] initWithFrame:CGRectMake(165,10, iPhone_width - 150, 30)];
            _degreeLab.font = Labelfont;
            _degreeLab.backgroundColor = [UIColor clearColor];
            _degreeLab.text = jobDetail(@"学历要求",_positionModel.degree);
            [self addSubview:_degreeLab];
            
            [cell.contentView addSubview:_pubDateLab];
            [cell.contentView addSubview:_degreeLab];
            
        }else if(indexPath.row==1)
        {
            //截止日期
            _finishDateLab = [[UILabel alloc] initWithFrame:CGRectMake(5,10, iPhone_width - 160, 30)];
            _finishDateLab.font = Labelfont;
            _finishDateLab.backgroundColor = [UIColor clearColor];
            _finishDateLab.text = jobDetail(@"截止日期",_positionModel.enddate);
            
            //招聘人数
            _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(165,10, iPhone_width - 165, 30)];
            _numberLab.font = Labelfont;
            _numberLab.backgroundColor = [UIColor clearColor];
            _numberLab.text=jobDetail(@"招聘人数",_positionModel.num);
            
            [cell.contentView addSubview:_finishDateLab];
            [cell.contentView addSubview:_numberLab];
            
            
        }else if(indexPath.row==2)
        {
            //工作地点
            _areaLab = [[UILabel alloc] initWithFrame:CGRectMake(5,10, iPhone_width - 165, 30)];
            _areaLab.font = Labelfont;
            _areaLab.backgroundColor = [UIColor clearColor];
            _areaLab.text = jobDetail(@"工作地点", _positionModel.workArea);
            
            //工作经验
            _workExperienceLab =  [[UILabel alloc] initWithFrame:CGRectMake(165,10, iPhone_width - 165, 30)];
            _workExperienceLab.backgroundColor = [UIColor clearColor];
            _workExperienceLab.text = jobDetail(@"工作经验",_positionModel.workYears);
            _workExperienceLab.font = Labelfont;
            
            [cell.contentView addSubview:_areaLab];
            [cell.contentView addSubview:_workExperienceLab];
            
        }else if(indexPath.row==3)
        {
            
            //薪资待遇
            _salaryLab =  [[RTLabel alloc] initWithFrame:CGRectMake(5,17,iPhone_width - 150,30)];
            _salaryLab.font = Labelfont;
            _salaryLab.backgroundColor = [UIColor clearColor];
            NSString *salaryStr=[NSString stringWithFormat:@"%@：<font color='#f76806'>%@</font>",@"薪资待遇",_positionModel.salary];
            _salaryLab.text=salaryStr;
            [self addSubview:_salaryLab];
            
            //年龄要求
            _yearLab =  [[UILabel alloc] initWithFrame:CGRectMake(165,10, iPhone_width - 150, 30)];
            _yearLab.backgroundColor = [UIColor clearColor];
            _yearLab.text = jobDetail(@"年龄要求",_positionModel.age);
            _yearLab.font = Labelfont;
            [self addSubview:_yearLab];
            
            [cell.contentView addSubview:_salaryLab];
            [cell.contentView addSubview:_yearLab];
            
        }else if(indexPath.row==5)
        {
            
            _jobDescription = [[UILabel alloc] initWithFrame:CGRectMake(0,0, iPhone_width, 30)];
            _jobDescription.text = @" 职位描述";
            _jobDescription.backgroundColor = [UIColor clearColor];
            [_jobDescription setFont:[UIFont boldSystemFontOfSize:16]];
            
            NSString *text = [[NSString alloc]initWithFormat:@"%@",_positionModel.required];
            
            _require = [[CustomLabel alloc]labelinitWithText:text X:10 Y:30];
            _require.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:_jobDescription];
            [cell.contentView addSubview:_require];
            
            NSInteger requireHeigh=_require.frame.size.height;
            
            NSLog(@"requireHeigh in indexPath.row==4 is %d",requireHeigh);
            
            //小灯泡
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5,requireHeigh+35, 20, 20)];
            imgView.image = [UIImage imageNamed:@"job_detail_from_img.png"];
            
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(28,requireHeigh+35, iPhone_width, 30)];
            tipLabel.textColor = RGBA(40, 100, 210, 1);
            tipLabel.text = @"联系时请说是在小职了看到的，以提高求职效率!";
            tipLabel.font = [UIFont systemFontOfSize:13];
            tipLabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:imgView];
            [cell.contentView addSubview:tipLabel];
        }
        
    }else
    {
        
        if (indexPath.row==0) {
            
            //联系方式
            self.contact = [[UILabel alloc] initWithFrame:CGRectMake(0,10,200,30)];
            self.contact.backgroundColor = [UIColor clearColor];
            self.contact.text = @" 联系方式";
            [self.contact setFont:[UIFont boldSystemFontOfSize:16]];
            
            //添加百度搜索按钮
            UIButton *baiduBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
            baiduBtn01.frame = CGRectMake(270,10, 40, 40);
            baiduBtn01.tag = 51;
            [baiduBtn01 addTarget:self action:@selector(baiduClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *baiduBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            baiduBtn.frame = CGRectMake(280,10, 23, 23);
            baiduBtn.tag = 51;
            [baiduBtn setBackgroundImage:[UIImage imageNamed:@"baidu.png"] forState:UIControlStateNormal];
            [baiduBtn setBackgroundImage:[UIImage imageNamed:@"baidu1.png"] forState:UIControlStateHighlighted];
            [baiduBtn addTarget:self action:@selector(baiduClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:self.contact];
            [cell.contentView addSubview:baiduBtn01];
            [cell.contentView addSubview:baiduBtn];
            
        }else if(indexPath.row==1)
        {
            
            //联系人
            self.contactPerson=[[UILabel alloc] initWithFrame:CGRectMake(5,10,iPhone_width,30)];
            self.contactPerson.text=@"联系人：";
            self.contactPerson.font = [UIFont systemFontOfSize:13];
            self.contactPerson.backgroundColor = [UIColor clearColor];
            
            //联系人label
            UILabel *contactPersonLab =[[UILabel alloc] initWithFrame:CGRectMake(59,10,iPhone_width,30)];
            contactPersonLab.font = [UIFont systemFontOfSize:13];
            contactPersonLab.textColor=RGBA(40, 100, 210, 1);
            contactPersonLab.backgroundColor=[UIColor clearColor];
            if ([_positionModel.linkman isEqualToString:@""]){
                contactPersonLab.text=@"人事部";
            }else{
                contactPersonLab.text= _positionModel.linkman;
            }
            
            [cell.contentView addSubview:self.contactPerson];
            [cell.contentView addSubview:contactPersonLab];
            
        }else if(indexPath.row==2)
        {
            
            //联系电话
            self.tel = [[UILabel alloc] initWithFrame:CGRectMake(5,10, 50, 30)];
            self.tel.backgroundColor = [UIColor clearColor];
            self.tel.font = [UIFont systemFontOfSize:13];
            self.tel.text = @"电    话:";
            
            //电话号码
            NSString *companyTel=@"";
            if ([_positionModel.mobile isEqualToString:@""]){
                companyTel=@"企业未公开";
            }else
            {
                companyTel=_positionModel.mobile;
            }
            
            //联系电话
            CustomButton *telephoneBtn = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(59, 10, iPhone_width - 100, 30) title:companyTel fontNum:13];
            telephoneBtn.backgroundColor=[UIColor clearColor];
            [telephoneBtn addTarget:self action:@selector(telephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.tel];
            [cell.contentView addSubview:telephoneBtn];
            
        }else
        {
            NSString *str=[_dataArray2 objectAtIndex:indexPath.row-3];
            
            if ([str isEqualToString:@"邮箱"]) {
                //邮箱
                self.email = [[UILabel alloc] initWithFrame:CGRectMake(5,10, 50, 30)];
                self.email.backgroundColor = [UIColor clearColor];
                self.email.font = [UIFont systemFontOfSize:13];
                self.email.text =@"邮    箱:";
                CustomButton *emailBtn = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(60, 10, iPhone_width - 60, 30) title:_positionModel.email fontNum:13];
                emailBtn.tag = 14;
                [emailBtn addTarget: self action:@selector(emailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.email];
                [cell.contentView addSubview:emailBtn];
                
            }else if ([str isEqualToString:@"网址"])
            {
                //网址
                self.netAddress = [[UILabel alloc]initWithFrame:CGRectMake(5,10,50,30)];
                self.netAddress.backgroundColor = [UIColor clearColor];
                self.netAddress.shadowOffset = CGSizeMake(-20, -20);
                [self.netAddress setBackgroundColor:[UIColor clearColor]];
                self.netAddress.text = @"网    址:";
                self.netAddress.font = [UIFont systemFontOfSize:13];
                NSString *btnTitle = [self string2Json2:_positionModel.curl];
                NSString *strUrl = [btnTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                CustomButton *netBtn = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(60, 10, iPhone_width - 60, 30) title:strUrl fontNum:13];
                netBtn.tag = 13;
                [netBtn addTarget: self action:@selector(internetClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.netAddress];
                [cell.contentView addSubview:netBtn];
            }else if ([str isEqualToString:@"地址"])
            {
                self.address = [[UILabel alloc]initWithFrame:CGRectMake(5,10,50, 30)];
                self.address.backgroundColor = [UIColor clearColor];
                self.address.text = @"地    址:";
                self.address.font = [UIFont systemFontOfSize:13];
                
                CustomButton *addressBtn= [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(58, 10,iPhone_width - 58,30) title:_positionModel.addr fontNum:13];
                addressBtn.backgroundColor=[UIColor clearColor];
                addressBtn.tag = 12;
                addressBtn.titleLabel.numberOfLines = 0;
                addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                [addressBtn addTarget: self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:self.address];
                [cell.contentView addSubview:addressBtn];
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4&&indexPath.section == 0 &&index_default == 1) {
//        if ([[NSString stringWithFormat:@"%@",_positionModel.issenior] isEqualToString:@"1"]) {
            [delegate toRuzhiJiangjinJieshao];
//        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==5) {
            
            height+=_requireHeight+10;
            return _requireHeight+100;
        }
    }
    
    height+=45;
    return 45;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7)
        return 1;
    
    return 0;
}

#pragma mark- 联系方式中各种按钮事件

//百度搜索
- (void)baiduClick:(id)sender
{
    NSLog(@"百度搜索被点击。。。。");
    
    [delegate baidu:_positionModel.cname andTag:@"百度"];
    
}

//电话联系
-(void)telephoneBtnClick:(id)sender
{
    NSLog(@"电话联系。。。。。。");
    
    UIButton *btn=(UIButton *)sender;
    
    [delegate telephone:btn.titleLabel.text];
}

//发送邮件
- (void)emailBtnClick:(id)sender
{
    NSLog(@"发送邮件。。。。。");
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    NSString *telNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_tel"];
    NSString *copyString = [[NSString alloc] initWithFormat:@"您好，我在小职了（www.xzhiliao.com）看到了贵公司%@发布的招聘职位：%@，特此应聘！我的联系电话是：%@",_positionModel.cname,_positionModel.jobName,telNum];
    paste.string = copyString;
    
    UIButton *btn=(UIButton *)sender;
    [delegate email:btn.titleLabel.text];
}

//网址
- (void)internetClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    NSLog(@"网址。。。。。。。is %@",btn.titleLabel.text);
    
    [delegate baidu:btn.titleLabel.text andTag:@"网址"];
}

//地址
-(void)addressBtnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [delegate address:btn.titleLabel.text];
}

//字符串过滤
- (NSString *)string2Json2:(NSString *)jsonString{
    
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r"withString:@"\\r"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n"withString:@"&"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\t"withString:@"\\t"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r\n"withString:@"\\r\\n"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\f"withString:@"\\f"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\"withString:@"\\\\"];
    
    return jsonString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
