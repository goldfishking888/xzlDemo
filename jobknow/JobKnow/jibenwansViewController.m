//
//  jibenwansViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jibenwansViewController.h"
#define  jianlijiben @"api/resume_manage/basic_info_set?"
#define   allJianli @"api/resume_manage/resume/resume_info?" //所有简历信息

@interface jibenwansViewController ()

@end

@implementation jibenwansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil];
        _emailArray=[NSMutableArray array];
        _emailArray=[NSMutableArray arrayWithObjects:@"@163.com",@"@126.com",@"@qq.com",@"@sina.com",@"@sina.cn",@"@vip.sina.com",@"@sohu.com",@"@yahoo.com",@"@hotmail.com",@"@gmail.com",@"@189.com",@"@139.com",@"@wo.com",@"@21.com", nil];
        tipString=[[NSString alloc]init];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"基本信息完善"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"基本信息完善"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
	self.view.backgroundColor = XZHILBJ_colour;
    [self addBackBtn];
    [self addTitleLabel:@"基本信息完善"];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];

   
   
    
    
    //简历上下滑动
    myScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    myScrollow.delegate = self;
    myScrollow.backgroundColor = [UIColor clearColor];
    CGFloat myHeight;
    myHeight= iPhone_height+1;
    myScrollow.contentSize = CGSizeMake(320, myHeight);
    [self.view addSubview:myScrollow];
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    //pressLogin
    [registBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    UIButton *residBtn01 =[UIButton buttonWithType:UIButtonTypeCustom];
    residBtn01.frame = CGRectMake(250, 0, 70, 44);
    [residBtn01 addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:residBtn01];
    
    myTabView =[[UITableView alloc]initWithFrame:CGRectMake(0, 8, iPhone_width, iPhone_height-5) style:UITableViewStyleGrouped];
    myTabView.dataSource =self;
    myTabView.delegate = self;
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
    [myScrollow addSubview:myTabView];
    //电子邮箱
    companyName = [[UITextField alloc]initWithFrame:CGRectMake(20, 3, iPhone_width - 70, 44)];
    companyName.returnKeyType = UIReturnKeyDone;
    companyName.delegate = self;
    companyName.tag = 11;
    [companyName setTextColor:[UIColor grayColor]];
    companyName.font = [UIFont systemFontOfSize:14];
    companyName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    companyName.textAlignment = NSTextAlignmentRight;
    companyName.keyboardType = UIKeyboardTypeURL;
    //取值
    ResumeOperation *sr = [ResumeOperation defaultResume];
    NSDictionary *stee = [sr.resumeDictionary valueForKey:@"jbws"];
    if (stee.count>0) {
        ztStr = [NSString stringWithFormat:@"%@",[stee valueForKey:@"userHuntState"]];
        dateStr = [NSString stringWithFormat:@"%@",[stee valueForKey:@"userBrith"]];
        yxStr = [NSString stringWithFormat:@"%@",[stee valueForKey:@"cur_salary"]];
        companyName.text = [NSString stringWithFormat:@"%@",[stee valueForKey:@"userEmail"]];
        cityStr = [NSString stringWithFormat:@"%@",[stee valueForKey:@"userLocal"]];
        hunyuStr = [NSString stringWithFormat:@"%@",[stee valueForKey:@"userMarriage"]];
        cityCode = [NSString stringWithFormat:@"%@",[stee valueForKey:@"userLocalCode"]];
    }
    NSLog(@"获取到的字典stee%@",stee);
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *ary = [NSArray arrayWithObjects:@"求职状态",@"出生日期",@"现居住地",@"当前月薪",@"婚育情况",@"电子邮箱", nil];
    cell.textLabel.text = [ary objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    if (indexPath.section==0 && indexPath.row==1) {
        if (dateStr.length>0) {
            label.text = [NSString stringWithFormat:@"%@",dateStr];
        }else{
            label.text = @"";
        }
    }else if (indexPath.section==0 && indexPath.row==0) {
        if (ztStr.length>0) {
            label.text=[self changeCode:ztStr ty:@"zt"];
        }else{
            label.text = @"";
        }
    }else if (indexPath.section==0 && indexPath.row==3) {
        if (yxStr.length>0) {
            label.text =[self changeCode:yxStr ty:@"yx"];
        }else{
            label.text = @"";
        }
    }else if (indexPath.section==0 && indexPath.row==4) {
        if (hunyuStr.length>0) {
             label.text =[self changeCode:hunyuStr ty:@"hy"];
        }else{
            label.text = @"";
        }
    } else if (indexPath.section==0 && indexPath.row ==2) {
        if ([cityStr isEqualToString:@"(null)"]||cityStr.length==0) {
            label.text = @"";
        }else{
            label.text = [NSString stringWithFormat:@"%@",cityStr];
        }
    } else if (indexPath.section ==0 && indexPath.row ==5){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:companyName];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        jiben2ViewController *jiben = [[jiben2ViewController alloc]init];
        jiben.myType = [NSString stringWithFormat:@"zhuangtai"];
         jiben.deleat =self;
        [self.navigationController pushViewController:jiben animated:YES];
    }
    else if(indexPath.row == 3 && indexPath.section == 0)
    {
        jiben2ViewController *jiben = [[jiben2ViewController alloc]init];
        jiben.myType = [NSString stringWithFormat:@"yuexin"];
         jiben.deleat =self;
        [self.navigationController pushViewController:jiben animated:YES];
    }else if(indexPath.row == 4 && indexPath.section == 0)
    {
        jiben2ViewController *jiben = [[jiben2ViewController alloc]init];
        jiben.deleat =self;
        jiben.myType = [NSString stringWithFormat:@"hunyu"];
        [self.navigationController pushViewController:jiben animated:YES];
    }else if(indexPath.row == 1 && indexPath.section == 0)
    {
        [self selectDate];
    }else if (indexPath.section==0 && indexPath.row ==2) {
        allCViewController *allcity = [[allCViewController alloc]init];
        allcity.delegate =self;
        [self.navigationController pushViewController:allcity animated:YES];
    }
   
}
//UItextField 的代理方法
//textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==11) {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 0);
        }];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 150);
        }];
    }
}

//选择日期
- (void)selectDate
{
    _datePicker = [[KTSelectDatePicker alloc] initWithMaxDate:[NSDate date] minDate:[XZLUtil changeStrToDate:@"1970-01-01"] currentDate:[NSDate date] datePickerMode:UIDatePickerModeDate];
    __weak typeof(self) weakSelf = self;
    [_datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        dateStr = [weakSelf changeDateToStr:selectedDate];
        [myTabView reloadData];
    }];
}

- (NSString *)changeDateToStr:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStrf = [formatter stringFromDate:date];
    return dateStrf;
}
//实现代理方法
- (void)chuanzhi:(NSString *)str ty:(NSString *)type
{
    if ([type isEqualToString:@"zhuangtai"]) {
        ztStr = [NSString stringWithFormat:@"%@",str];
    }else if ([type isEqualToString:@"yuexin"]) {
        yxStr = [NSString stringWithFormat:@"%@",str];
    }else if ([type isEqualToString:@"hunyu"]) {
        hunyuStr = [NSString stringWithFormat:@"%@",str];
    }
    [myTabView reloadData];
}
- (void)chuanCity:(NSString *)city cityCode:(NSString *)code
{
    cityStr = [NSString stringWithFormat:@"%@",city];
    cityCode = [NSString stringWithFormat:@"%@",code];
    [myTabView reloadData];
}
- (void)pressLogin:(id)sender
{
    if(![self checkEmailNumber])//如果当前邮箱是不是可靠邮箱
    {
        NSLog(@"DSFSDF.DFSDSFSDFA2 _tipString is %@",tipString);
        alert.message = tipString;
        alert.position = OLGhostAlertViewPositionBottom;
        [alert show];
        return;
    }
    if (hunyuStr.length>1||[hunyuStr isEqualToString:@""]) {
        hunyuStr = @"0";
    }
    //判断信息完善后再提交
    if (ztStr.length==0 || dateStr.length==0 || cityStr.length==0|| yxStr.length==0 ||hunyuStr.length==0 || companyName.text.length ==0) {
        alert.message = @"请完善信息";
        alert.position = OLGhostAlertViewPositionBottom;
        [alert show];
    }else{
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self resquext];
    }
}
-(void)backUp:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//网络请求
- (void)resquext
{
    NetWorkConnection *net = [[NetWorkConnection alloc]init];
    net.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI,jiben1);
    NSLog(@"cityCode==%@",cityCode);
    NSDictionary *para = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"0",@"flag",ztStr,@"userHuntState",dateStr,@"userBrith",cityCode,@"userLocal",yxStr,@"cur_salary",hunyuStr,@"userMarriage",companyName.text,@"userEmail",nil];
//    [net sendRequestURLStr:url ParamDic:para Method:@"GET"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:para urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"信息完善Dic====%@",resultDic);
        NSString *strr = [resultDic valueForKey:@"error"];
        if ([strr integerValue]==0) {
            //基本信息提交完成
            ResumeOperation *st = [ResumeOperation defaultResume];
            [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve-jiben"];
            [st setObject:[NSString stringWithFormat:@"%@",cityStr] forKey:@"myHome"];//居住地
            [self.deleate chuanonDic:resultDic];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];

}
- (void)requestTimeOut
{
    [loadView hide:YES];
}
- (void)receiveDataFail:(NSError *)error
{
    [loadView hide:YES];
}
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    NSDictionary *reslult = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSString *strr = [reslult valueForKey:@"error"];
    if ([strr integerValue]==0) {
        //基本信息提交完成
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve-jiben"];
        [st setObject:[NSString stringWithFormat:@"%@",cityStr] forKey:@"myHome"];//居住地
        [self.deleate chuanonDic:reslult];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//根据编码返回字符串
-(NSString *)changeCode:(NSString *)xinziCode ty:(NSString*)type
{
    NSString *name = nil;
    if ([type isEqualToString:@"zt"]) {
        switch ([xinziCode integerValue]) {
            case 1:
                name = @"紧急,一个月内";
                break;
            case 2:
                name = @"一般,三个月内";
                break;
            case 3:
                name = @"拟求职,三个月以上";
                break;
            case 4:
                name = @"观望好的机会可以考虑";
                break;
            case 5:
                name = @"行业了解中暂不考虑换工作";
                break;
            default:
                break;
        }
    }else if ([type isEqualToString:@"yx"]){
        switch ([xinziCode integerValue]) {
            case 10:
                name = @"面议";
                break;
            case 99:
                name = @"1000以下";
                break;
            case 101:
                name = @"1000-1199";
                break;
            case 121:
                name = @"1200-1499";
                break;
            case 151:
                name = @"1500-1799";
                break;
            case 181:
                name = @"1800-1999";
                break;
            case 201:
                name = @"2000-2499";
                break;
            case 251:
                name = @"2500-2999";
                break;
            case 301:
                name = @"3000-3499";
                break;
            case 351:
                name = @"3500-3999";
                break;
            case 401:
                name = @"4000-4499";
                break;
            case 451:
                name = @"4500-4999";
                break;
            case 501:
                name = @"5000-5999";
                break;
            case 601:
                name = @"6000-6999";
                break;
            case 701:
                name = @"7000-7999";
                break;
            case 801:
                name = @"8000-8999";
                break;
            case 901:
                name = @"9000-9999";
                break;
            case 1001:
                name = @"10000-11999";
                break;
            case 1201:
                name = @"12000-14999";
                break;
            case 1501:
                name = @"15000-19999";
                break;
            case 2001:
                name = @"20000-24999";
                break;
            case 2501:
                name = @"25000-29999";
                break;
            case 3001:
                name = @"30000-39999";
                break;
            case 4001:
                name = @"40000-49999";
                break;
            case 5001:
                name = @"50000-79999";
                break;
            case 8001:
                name = @"80000-99999";
                break;
            case 10001:
                name = @"100000以上";
                break;
            default:
                break;
        }
    }else if ([type isEqualToString:@"hy"]){
        switch ([xinziCode integerValue]) {
            case 0:
                name = @"保密";
                break;
            case 1:
                name = @"未婚";
                break;
            case 2:
                name = @"已婚";
                break;
            case 3:
                name = @"离异";
                break;
            case 4:
                name = @"已婚已育";
                break;
           
            default:
                break;
        }
    }
        return name;
}

//检测邮箱
-(BOOL)checkEmailNumber
{
    NSString *emailStr=companyName.text;
    
    NSString *emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if([emailTest evaluateWithObject:emailStr]){
        return YES;
    }
    
    tipString=@"请输入正确格式邮箱!";
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
