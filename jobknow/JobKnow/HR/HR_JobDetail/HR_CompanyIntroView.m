//
//  HR_CompanyIntroView.m
//  JobKnow
//
//  Created by Suny on 15/8/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
// HR圈的职位详情里面的公司介绍

#import "HR_CompanyIntroView.h"
#import "CustomButton.h"
#import "CustomLabel.h"

#define cell_inner_space 12
#define cell_title_content_space 65

@implementation HR_CompanyIntroView

@synthesize myTableView=_myTableView;
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame  withModel:(HRHomeIntroduceModel *)info
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _isDownLoad=NO;
        
        _count=0;
        
        _positionModel=info;
        
        _natureHeight=45;//公司性质cell的高度
        _industryHeight=45;//行业cell的高度
        _introductionHeight=45;//公司介绍cell的高度
        
        //职位名称
        _companyName = [[CustomLabel alloc]labelinitWithText2:_positionModel.companyName X:cell_inner_space Y:2];
        _companyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        _companyName.textColor = [UIColor redColor];
        _companyName.backgroundColor = [UIColor clearColor];
        [self addSubview:_companyName];
        
        NSLog(@"_companyName height in CompanyIntroduce is %f",_companyName.frame.size.height);
        
        _dataArray=[NSMutableArray arrayWithObjects:_positionModel.email,_positionModel.companyWeb,_positionModel.companyAddress,nil];
        
        _dataArray1=[NSMutableArray arrayWithObjects:@"邮箱",@"网址",@"地址",nil];
        
        _dataArray2=[[NSMutableArray alloc]init];
        
        NSLog(@"_dataArray count is %d",[_dataArray count]);
        
        for (int i=0;i<[_dataArray count];i++) {
            NSString *str=[_dataArray objectAtIndex:i];
            NSString *str2=[_dataArray1 objectAtIndex:i];
            if (![str isEqualToString:@""]) {
                _count++;
                [_dataArray2 addObject:str2];
            }
        }
        
        NSLog(@"companyDic is %@",_companyDic);
        
        if (IOS7){
            _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,_companyName.frame.size.height+5,iPhone_width,iPhone_height) style:UITableViewStyleGrouped];
        }else
        {
            _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,_companyName.frame.size.height+5,iPhone_width,iPhone_height) style:UITableViewStylePlain];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,1)];
            label.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
            [_myTableView addSubview:label];
        }
        
        _myTableView.backgroundColor=XZHILBJ_colour;
        _myTableView.backgroundView=nil;
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        [self addSubview:_myTableView];
        
    }
    return self;
}

#pragma mark UITableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    
    return _count+3;
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
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            
            //公司性质
            UILabel*companyNatureLab = [[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10,50,30)];
            companyNatureLab.font =[UIFont  systemFontOfSize:13];
            companyNatureLab.backgroundColor = [UIColor clearColor];
            companyNatureLab.text =@"性质:";
            [cell.contentView addSubview:companyNatureLab];
            
            if (_isDownLoad){
                
                NSString *text=[_companyDic valueForKey:@"companyNature"];
                
                if ([text isEqualToString:@""]){
                    text=@"无";
                }
                
                _companyNature=[[CustomLabel alloc]labelinitWithText:text X:50 Y:10];
                _companyNature.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:_companyNature];
            }
            
        }else if (indexPath.row==1)
        {
            
            //行业
            UILabel*companyIndustryLab = [[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10,iPhone_width-165,30)];
            companyIndustryLab.font =[UIFont  systemFontOfSize:13];
            companyIndustryLab.backgroundColor = [UIColor clearColor];
            companyIndustryLab.text =@"行业:";
            [cell.contentView addSubview:companyIndustryLab];
            
            if (_isDownLoad){
                NSString *text=[_companyDic valueForKey:@"companyIndustry"];
                if ([text length]>20) {
                    text=[text substringToIndex:19];
                    text=[text stringByAppendingString:@"···"];
                }
                if([text isEqualToString:@""])
                {
                    text=@"无";
                }
                _companyIndustry=[[CustomLabel alloc]labelinitWithText:text X:50 Y:10];
                _companyIndustry.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:_companyIndustry];
            }
            
        }else if (indexPath.row==2)
        {
            //企业详情
            UILabel*companyDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10, iPhone_width - 165,30)];
            companyDetailLab.font =[UIFont  systemFontOfSize:13];
            companyDetailLab.backgroundColor = [UIColor clearColor];
            companyDetailLab.text =@"企业详情:";
            [cell.contentView addSubview:companyDetailLab];
            if (_isDownLoad) {
                [companyDetailLab  removeFromSuperview];
                NSString *text=[_companyDic valueForKey:@"companyIntroduction"];
                
                NSLog(@"text in CompanyIntroduce is %@",text);
                
                _companyIntroduce=[[CustomLabel alloc]labelinitWithText:text X:cell_inner_space Y:5];
                _companyIntroduce.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:_companyIntroduce];
            }
        }
        
    }else
    {
        
        if (indexPath.row==0) {
            
            //联系方式
            self.contact = [[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10,200,30)];
            self.contact.backgroundColor = [UIColor clearColor];
            self.contact.text = @"联系方式";
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
            self.contactPerson=[[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10,iPhone_width,30)];
            self.contactPerson.text=@"联系人：";
            self.contactPerson.font = [UIFont systemFontOfSize:13];
            self.contactPerson.backgroundColor = [UIColor clearColor];
            
            //联系人label
            UILabel *contactPersonLab =[[UILabel alloc] initWithFrame:CGRectMake(cell_title_content_space,10,iPhone_width - cell_title_content_space,30)];
            contactPersonLab.font = [UIFont systemFontOfSize:13];
            contactPersonLab.textColor=RGBA(40, 100, 210, 1);
            contactPersonLab.backgroundColor=[UIColor clearColor];
            
            if ([_positionModel.linkMan isEqualToString:@""]){
                contactPersonLab.text=@"人事部";
            }else{
                contactPersonLab.text= _positionModel.linkMan;
            }
            
            [cell.contentView addSubview:self.contactPerson];
            [cell.contentView addSubview:contactPersonLab];
            
        }else if(indexPath.row==2)
        {
            
            //联系电话
            self.tel = [[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10, 50, 30)];
            self.tel.backgroundColor = [UIColor clearColor];
            self.tel.font = [UIFont systemFontOfSize:13];
            self.tel.text = @"电    话:";
            
            //电话号码
            NSString *companyTel=@"";
            if ([_positionModel.companyTel isEqualToString:@""]){
                companyTel=@"企业未公开";
            }else
            {
                companyTel=_positionModel.companyTel;
            }
            
            //联系电话
            CustomButton *telephoneBtn = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(cell_title_content_space, 10, iPhone_width - cell_title_content_space, 30) title:companyTel fontNum:13];
            telephoneBtn.backgroundColor=[UIColor clearColor];
            [telephoneBtn addTarget:self action:@selector(telephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.tel];
            [cell.contentView addSubview:telephoneBtn];
            
        }else
        {
            NSString *str=[_dataArray2 objectAtIndex:indexPath.row-3];
            
            if ([str isEqualToString:@"邮箱"]) {
                //邮箱
                self.email = [[UILabel alloc] initWithFrame:CGRectMake(cell_inner_space,10, 50, 30)];
                self.email.backgroundColor = [UIColor clearColor];
                self.email.font = [UIFont systemFontOfSize:13];
                self.email.text =@"邮    箱:";
                CustomButton *emailBtn = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(cell_title_content_space, 10, iPhone_width - cell_title_content_space, 30) title:_positionModel.email fontNum:13];
                emailBtn.tag = 14;
                [emailBtn addTarget: self action:@selector(emailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.email];
                [cell.contentView addSubview:self.email];
                [cell.contentView addSubview:emailBtn];
                
            }else if ([str isEqualToString:@"网址"])
            {
                
                //网址
                self.netAddress = [[UILabel alloc]initWithFrame:CGRectMake(cell_inner_space,10,50,30)];
                self.netAddress.backgroundColor = [UIColor clearColor];
                self.netAddress.shadowOffset = CGSizeMake(-20, -20);
                [self.netAddress setBackgroundColor:[UIColor clearColor]];
                self.netAddress.text = @"网    址:";
                self.netAddress.font = [UIFont systemFontOfSize:13];
                NSString *btnTitle = [self string2Json2:_positionModel.companyWeb];
                NSString *strUrl = [btnTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                CustomButton *customBtn3 = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(cell_title_content_space, 10, iPhone_width - cell_title_content_space, 30) title:strUrl fontNum:13];
                customBtn3.tag = 13;
                [customBtn3 addTarget: self action:@selector(internetClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.netAddress];
                [cell.contentView addSubview:customBtn3];
            }else if ([str isEqualToString:@"地址"])
            {
                self.address = [[UILabel alloc]initWithFrame:CGRectMake(cell_inner_space,10,50, 30)];
                self.address.backgroundColor = [UIColor clearColor];
                self.address.text = @"地    址:";
                self.address.font = [UIFont systemFontOfSize:13];
                
                CustomButton *customBtn2 = [CustomButton customButtonInitWithButtonType:UIButtonTypeCustom frame:CGRectMake(cell_title_content_space, 10,iPhone_width - cell_title_content_space - 30,30) title:_positionModel.companyAddress fontNum:13];
                customBtn2.backgroundColor=[UIColor clearColor];
                customBtn2.tag = 12;
                customBtn2.titleLabel.numberOfLines = 0;
                customBtn2.titleLabel.textAlignment = NSTextAlignmentLeft;
                [customBtn2 addTarget: self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:self.address];
                [cell.contentView addSubview:customBtn2];
            }
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            
            if (_natureHeight<45) {
                _natureHeight=45;
            }
            
            return _natureHeight;
            
        }else if(indexPath.row ==1)
        {
            return 45;
            
        }else if (indexPath.row==2)
        {
            if (_introductionHeight<45) {
                _introductionHeight=45;
            }
            
            NSLog(@"_introductionHeight in CompanyIntroduce is %d",_introductionHeight);
            
            return _introductionHeight+50;
        }
        
    }
    
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7){
        return 5;
    }
    
    return 0;
}

#pragma mark 联系方式中各种按钮事件

//百度搜索
- (void)baiduClick:(id)sender
{
    NSLog(@"百度搜索被点击。。。。");
    
    [_delegate baidu:_positionModel.companyName andTag:@"百度"];
    
}

//电话联系
-(void)telephoneBtnClick:(id)sender
{
    NSLog(@"电话联系。。。。。。");
    
    UIButton *btn=(UIButton *)sender;
    
    [_delegate telephone:btn.titleLabel.text];
}

//发送邮件
- (void)emailBtnClick:(id)sender
{
    NSLog(@"发送邮件。。。。。");
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    NSString *telNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_tel"];
    NSString *copyString = [[NSString alloc] initWithFormat:@"您好，我在小职了（www.xzhiliao.com）看到了贵公司%@发布的招聘职位：%@，特此应聘！我的联系电话是：%@",_positionModel.companyName,_positionModel.jobName,telNum];
    paste.string = copyString;
    
    UIButton *btn=(UIButton *)sender;
    [_delegate email:btn.titleLabel.text];
}

//网址
-(void)internetClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    NSLog(@"网址。。。。。。。is %@",btn.titleLabel.text);
    
    [_delegate baidu:btn.titleLabel.text andTag:@"网址"];
}

//地址
-(void)addressBtnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [_delegate address:btn.titleLabel.text];
}

-(NSString *)string2Json2:(NSString *)jsonString{
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r"withString:@"\\r"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n"withString:@"&"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\t"withString:@"\\t"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\f"withString:@"\\f"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\"withString:@"\\\\"];
    return jsonString;
}

@end
