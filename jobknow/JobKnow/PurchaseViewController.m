//
//  PurchaseViewController.m
//  JobKnow
//
//  Created by Apple on 14-8-7.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "PurchaseViewController.h"

#import "TipLabel.h"

#import "TipButton.h"

#import "allCViewController.h"
#import "DegreeViewController.h"
#import "WorkExperienceViewController.h"

#import "PositionViewController.h"
#import "WorkTypeViewController.h"
#import "ZhangXinBaoViewController.h"
#import "ZhangXinBuyViewController.h"

#import "TestLabel.h"

@interface PurchaseViewController ()

@end

@implementation PurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 
    if (self) {
    
    }
    
    return self;
}

- (void)initData
{
    num=ios7jj;
    
    count=0;
    
    _wordsArray = [NSMutableArray arrayWithObjects:@"现居住地",@"性别",@"学历",@"工作经验",@"行业类别",@"职业类别",nil];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor=XZhiL_colour2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"大数据涨薪评测"];
    
    [self initData];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height)];
    
    if (iPhone_5Screen) {
    
        _scrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height+20);
    }else
    {
        _scrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height+100);
    }
    
    [self.view addSubview:_scrollView];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(11,10,2,130)];
    lab1.backgroundColor=XZhiL_colour;

    TestLabel *testLabel=[[TestLabel alloc]initWithFrame:CGRectMake(5,10,iPhone_width,60)];
    [testLabel setDot:[UIImage imageNamed:@"bluedot"] andFrame:CGRectMake(0,10,15,15)];
    [testLabel setLabelFrame:CGRectMake(25,0,280,30) AndText:@"1.不同人适合的涨薪宝产品不同。"];

    TestLabel *testLabel2=[[TestLabel alloc]initWithFrame:CGRectMake(5,50,iPhone_width,60)];
    [testLabel2 setDot:[UIImage imageNamed:@"bluedot"] andFrame:CGRectMake(0,11,15,15)];
    [testLabel2 setLabelFrame:CGRectMake(25,0,280,40) AndText:@"2.小职了大数据平台“将根据你的6项指标计算出适合的涨薪幅度”"];
    
    TestLabel *testLabel3=[[TestLabel alloc]initWithFrame:CGRectMake(5,100,iPhone_width,60)];
    [testLabel3 setDot:[UIImage imageNamed:@"bluedot"] andFrame:CGRectMake(0,11,15,15)];
    [testLabel3 setLabelFrame:CGRectMake(25,0,280,40) AndText:@"3。大数据结果显示约38%的人无法享受涨薪宝服务，请原谅。"];

    //添加UITableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,120,iPhone_width,70*6) style:UITableViewStyleGrouped];
    _tableView.bounces=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setBackgroundColor:XZHILBJ_colour];
    [_tableView setBackgroundView:nil];
    [_scrollView addSubview:_tableView];
    
    [_scrollView addSubview:lab1];
    [_scrollView addSubview:testLabel];
    [_scrollView addSubview:testLabel2];
    [_scrollView addSubview:testLabel3];
    
    submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor=[UIColor clearColor];
    if (IOS7) {
        submitBtn.frame = CGRectMake(10,430,300,40);
    }else
    {
        submitBtn.frame = CGRectMake(10,465,300,40);
    }
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"提交资格审核" forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交资格审核" forState:UIControlStateHighlighted];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    
    tipBtn=[[TipButton alloc]initWithFrame:CGRectMake(80,199,60,45)];
    tipBtn.tag=101;
    tipBtn.isClicked=YES;
    tipBtn.isChoosen=YES;
    
    [tipBtn setImage:[UIImage imageNamed:@"dotselect.png"] AndFrame:CGRectMake(0,8,30,30) AndText:@"男" AndFrame2:CGRectMake(40,13,20,20)];
    [tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:tipBtn];
    
    tipBtn2=[[TipButton alloc]initWithFrame:CGRectMake(200,199,60,45)];
    tipBtn2.tag=102;
    [tipBtn2 addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tipBtn2 setImage:[UIImage imageNamed:@"dotnoselect.png"] AndFrame:CGRectMake(0,8,30,30) AndText:@"女" AndFrame2:CGRectMake(40,13,20,20)];
    [_scrollView addSubview:tipBtn2];
}

#pragma mark UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
        
    }else
    {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(130,8,130,30)];
    lab.backgroundColor=[UIColor clearColor];
    lab.font=[UIFont systemFontOfSize:13.5];
    lab.textColor=[UIColor grayColor];
    lab.textAlignment=NSTextAlignmentRight;
    
    switch (indexPath.row) {
            
        case 0:

            lab.text=cityStr;
            break;
            
        case 2:
            lab.text=degreeStr;
            break;
        case 3:
            lab.text=experienceStr;
            break;
        case 4:
            lab.text=industryStr;
            break;
        case 5:
            lab.text=jobTypeStr;
            break;
        default:
            break;
    }
    
    [cell.contentView addSubview:lab];
    
    cell.textLabel.text=[_wordsArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor grayColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row==1) {
   
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) {
        
        allCViewController *allCVC=[[allCViewController alloc]init];
        allCVC.delegate=self;
        [self.navigationController pushViewController:allCVC animated:YES];
        
    }else if (indexPath.row==2)
    {
        DegreeViewController *degreeVC=[[DegreeViewController alloc]init];
        
        degreeVC.delegate=self;
        
        [self.navigationController pushViewController:degreeVC animated:YES];
        
    }else if (indexPath.row==3)
    {
        WorkExperienceViewController *workVC=[[WorkExperienceViewController alloc]init];
        workVC.delegate=self;
        [self.navigationController pushViewController:workVC animated:YES];
        
    }else if (indexPath.row == 4)
    {
        PositionViewController *positionVC=[[PositionViewController alloc]init];
        positionVC.delegate=self;
        [self.navigationController pushViewController:positionVC animated:YES];
        
    }else if(indexPath.row==5)
    {
        //进入职业类别
        WorkTypeViewController *workTypeVC=[[WorkTypeViewController alloc]init];
        [self.navigationController pushViewController:workTypeVC animated:YES];
    }
}

#pragma mark 按钮响应事件

//性别点击按钮
- (void)tipBtnClick:(id)sender
{
    TipButton *btn=(TipButton *)sender;
    
    if (btn.isChoosen==YES) {
        return;
    }
    
    
    if (btn.tag==101) {
        
        TipButton *btn2=(TipButton *)[_scrollView viewWithTag:102];
        
        btn2.isClicked=btn.isClicked;
        
        btn.isClicked=!btn.isClicked;
        
        btn.isChoosen=YES;
        
        btn2.isChoosen=NO;
        
    }else
    {
        TipButton *btn2=(TipButton *)[_scrollView viewWithTag:101];
        
        btn2.isClicked=btn.isClicked;
        
        btn.isClicked=!btn.isClicked;
        
        btn.isChoosen=YES;
        
        btn2.isChoosen=NO;
    }
    
    for (int i=101;i<=102;i++) {
        
        TipButton *btn=(TipButton *)[_scrollView viewWithTag:i];
        
        if (btn.isClicked) {
            
            [btn setImage2:[UIImage imageNamed:@"dotselect.png"]];
        }else
        {
            
            [btn setImage2:[UIImage imageNamed:@"dotnoselect.png"]];
        }
    }
}

//提交资格审核
- (void)submitBtnClick:(id)sender
{
    Net *net= [Net standerDefault];
    
    if (net.status!=NotReachable) {
        
        if (![self checkAllCondition]) {
            
            ghostView.message=@"请先完善信息";
            [ghostView show];
            return;
        }else
        {
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr, @"userToken",IMEI,@"userImei",cityStr,@"city",experienceStr,@"experience",industryStr,@"industry",nil];
            
            NSString *str=kCombineURL(KXZhiLiaoAPI,SubmentCheck);
            
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:str];
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
            
            [request setTimeOutSeconds:15];
            
            request.delegate=self;
            
            [request startAsynchronous];
        }
        
    }else
    {
        ghostView.message=@"请检查网络!";
        [ghostView show];
        return;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic is %@",resultDic);
    
    NSString *errorStr=[resultDic valueForKey:@"error"];
    
    NSString *gains;
    
    if (errorStr&&errorStr.integerValue==0) {
        gains=[resultDic valueForKey:@"gains"];
    }else
    {
        gains=@"10";
    }
    
    ZhangXinBuyViewController *zhangxinBuyVC=[[ZhangXinBuyViewController alloc]init];
    zhangxinBuyVC.gainStr=gains;
    [self.navigationController pushViewController:zhangxinBuyVC animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    
    ZhangXinBuyViewController *zhangxinBuyVC=[[ZhangXinBuyViewController alloc]init];
    zhangxinBuyVC.gainStr=@"10";
    [self.navigationController pushViewController:zhangxinBuyVC animated:YES];
}

#pragma mark 代理方法实现

//现居住地的代理方法
- (void)chuanCity:(NSString *)city cityCode:(NSString *)code
{
    cityStr=city;
    
    [_tableView reloadData];
}

//学历
- (void)changeDegree:(NSString *)degree
{
    degreeStr=degree;
    
    [_tableView reloadData];
}

//工作年限的代理方法
- (void)changeworkExperience:(NSString *)experience
{
    experienceStr=experience;
    
    [_tableView reloadData];
}

- (void)chuanzhi:(NSString *)str
{
    experienceStr=str;
    
    [_tableView reloadData];
}

//行业类别
- (void)changePosition:(NSString *)positionStr
{
    industryStr=positionStr;
    
    [_tableView reloadData];
}

- (void)changeworkDetail:(NSString *)workDetail
{
    jobTypeStr=workDetail;
    
    [_tableView reloadData];
}

#pragma mark 功能函数

//判断是否所有的内容都填写了

- (BOOL)checkAllCondition
{
    if (cityStr.length==0||experienceStr.length==0||degreeStr.length==0||industryStr.length==0||jobTypeStr.length==0)
    {
        return NO;
    }
    
    return YES;
}

//返回
- (void)backUp:(id)sender
{
    ZhangXinBaoViewController *zhangxinVC = [[ZhangXinBaoViewController alloc] init];
    
    [self.navigationController pushViewController:zhangxinVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
