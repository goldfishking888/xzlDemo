//
//  jibenxxViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jibenxxViewController.h"
@interface jibenxxViewController ()
@end
@implementation jibenxxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"基本信息"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"基本信息"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
	self.view.backgroundColor = XZHILBJ_colour;
    [self addBackBtn];
    [self addTitleLabel:@"基本信息"];
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    myScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 46+num, iPhone_width, iPhone_height-46-num)];
    myScrollow.backgroundColor = [UIColor clearColor];
    
    myScrollow.contentSize = CGSizeMake(iPhone_width, iPhone_height-45);
    [self.view addSubview:myScrollow];
    
    
    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, iPhone_height) style:UITableViewStyleGrouped];
    myTabView.delegate =self;
    myTabView.dataSource =self;
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
    [myScrollow addSubview:myTabView];
    
    UILabel *labrl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, iPhone_width-20, 30)];
    labrl.backgroundColor =[UIColor clearColor];
    labrl.text = @"必填:填完后即可配合附件简历速投职位!";
    labrl.font = [UIFont fontWithName:Zhiti size:13];
    labrl.textColor = [UIColor darkGrayColor];
    [myScrollow addSubview:labrl];

    swith = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [swith addTarget:self action:@selector(turnoffNotification:) forControlEvents:UIControlEventValueChanged];
    
    
    //姓名
    textField01 = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 160, 44)];
    textField01.returnKeyType = UIReturnKeyDone;
    textField01.delegate = self;
    textField01.tag = 101;
    [textField01 setTextColor:[UIColor grayColor]];
    textField01.font = [UIFont systemFontOfSize:14];
    textField01.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    NSString *myNamee = [myUser valueForKey:@"personName"];
   
    textField01.placeholder = @"姓名";
    if (myNamee == nil) {
        textField01.text = @"";
    }else{
        textField01.text = [NSString stringWithFormat:@"%@",myNamee];
    }
    textField01.textAlignment = NSTextAlignmentRight;
   
    //手机号码
    textField02 = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 160, 44)];
    textField02.delegate = self;
    [textField02 setFont:[UIFont systemFontOfSize:14]];
    textField02.tag = 102;
    textField02.textColor = [UIColor grayColor];
    textField02.returnKeyType = UIReturnKeyDone;
    textField02.keyboardType = UIKeyboardTypeDefault;
    NSString *myTel = [myUser valueForKey:@"user_tel"];
    if (myTel.length == 0) {
        textField02.text = @"";
    }else{
        textField02.text = myTel;
    }
    textField02.borderStyle = UITextBorderStyleNone;
    textField02.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField02.textAlignment = NSTextAlignmentRight;
    
    //取值
    ResumeOperation *sr = [ResumeOperation defaultResume];
    leixingstr = [sr.resumeDictionary valueForKey:@"myLeix"];
    sexCode = [sr.resumeDictionary valueForKey:@"mySex"];
    if ([sexCode isEqualToString:@"2"]) {
        swith.on = NO;
        sexStr=@"女";
    }else{
        swith.on = YES;
        sexStr=@"男";
    }
    nianxianStr = [sr.resumeDictionary valueForKey:@"myWorkYear"];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:gesture];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
        UILabel *labeil = (UILabel *)[cell.contentView viewWithTag:521];
        [labeil removeFromSuperview];
        cell.accessoryView = nil;
    }
    NSArray *ary = [[NSArray alloc]initWithObjects:@"人才类型",@"姓       名",@"性       别",@"工作年限",@"手机号码", nil];
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [ary objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    UILabel *label01 = [[UILabel alloc]initWithFrame:CGRectMake(160, 12, 60, 30)];
    label01.backgroundColor = [UIColor clearColor];
    label01.textColor = [UIColor grayColor];
    label01.font = [UIFont fontWithName:Zhiti size:14];
    label01.tag = 521;
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.text = leixingstr;
    }else if (indexPath.section ==0 && indexPath.row ==1){
        [cell.contentView addSubview:textField01];
    }else if (indexPath.section ==0 && indexPath.row ==2){
        cell.accessoryView = swith;
//        if (sexStr.length>0) {
//            sexStr = [NSString stringWithFormat:@"%@",sexStr];
//           
//        }else{
//            sexStr = [NSString stringWithFormat:@"男"];
//        }
        label01.text = sexStr;
        [cell.contentView addSubview:label01];
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *newWorkY = nil;
        if ([nianxianStr integerValue]>0) {
            newWorkY = [NSString stringWithFormat:@"%@年",nianxianStr];
        }else{
            if ([nianxianStr isEqualToString:@"-2"]) {
                newWorkY= [NSString stringWithFormat:@"不限"];
            }else if ([nianxianStr isEqualToString:@"-1"]){
                newWorkY= [NSString stringWithFormat:@"在读学生"];
            }else if ([nianxianStr isEqualToString:@"0"]){
                newWorkY= [NSString stringWithFormat:@"应届毕业生"];
            }
        }
        label.text = newWorkY;
    }else if (indexPath.section ==0 && indexPath.row ==4){
        [cell.contentView addSubview:textField02];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        leixingViewController *leixing = [[leixingViewController alloc]init];
        leixing.deleat = self;
        [self.navigationController pushViewController:leixing animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        nianxianViewController *nian =[[nianxianViewController alloc]init];
        nian.deleat =self;
        [self.navigationController pushViewController:nian animated:YES];
    }
}
- (void)chuanzhi:(NSString *)str
{
    nianxianStr = [NSString stringWithFormat:@"%@",str];
    [myTabView reloadData];
}
- (void)chuanzhilv:(NSString *)str
{
    leixingstr = [NSString stringWithFormat:@"%@",str];
    [myTabView reloadData];
}
//textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==101) {
        [textField resignFirstResponder];
    }else{
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 0);
        }];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==102) {
        [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 100);
        }];
    }
}
- (void)pressLogin:(id)sender
{
    if(![self checkTelephoneNumber])//如果有网络判断是不是空号
    {
        alert.message = tipString;
        alert.position = OLGhostAlertViewPositionBottom;
        [alert show];
        return;
    }
    //判断信息完善后再提交
    if (nianxianStr.length==0 || sexStr.length==0 || textField01.text.length==0|| textField02.text.length==0 ||leixingstr.length==0) {
        alert.message = @"请完善信息";
        alert.position = OLGhostAlertViewPositionBottom;
        [alert show];
    
    }else{
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self resquext];
    } 
}
- (void)turnoffNotification:(id)sender
{
    UISwitch *swith2 = (UISwitch *)sender;
    BOOL setting  = [swith2 isOn];
    if (setting) {
        sexStr = @"男";
        sexCode = @"1";
    }else
    {
        sexStr = @"女";
        sexCode = @"2";
    }
    [myTabView reloadData];
}
//网络请求
- (void)resquext
{
    NetWorkConnection *net = [[NetWorkConnection alloc]init];
    net.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI,jiben1);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"1",@"flag",leixingstr,@"talent_type",textField01.text,@"userName",sexCode,@"userSex",nianxianStr,@"work_years",textField02.text,@"userMobile",@"0",@"UserResumeNameOpen",nil];
//    [net sendRequestURLStr:url ParamDic:param Method:@"GET"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"信息完善Dic====%@",resultDic);
        NSString *strr = [resultDic valueForKey:@"error"];
        if ([strr integerValue]==0) {
            //基本信息保存成功
            ResumeOperation *st = [ResumeOperation defaultResume];
            [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"jibenxinxi"];
            [st setObject:[NSString stringWithFormat:@"%@",nianxianStr] forKey:@"myWorkYear"];
            [st setObject:[NSString stringWithFormat:@"%@",textField01.text] forKey:@"myName"];
            [st setObject:[NSString stringWithFormat:@"%@",textField02.text] forKey:@"myTel"];
            [st setObject:[NSString stringWithFormat:@"%@",sexCode] forKey:@"mySex"];
            [st setObject:[NSString stringWithFormat:@"%@",leixingstr] forKey:@"myLeix"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:textField01.text forKey:@"personName"];
            [user setObject:textField02.text forKey:@"user_tel"];
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
        //基本信息保存成功
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"jibenxinxi"];
        [st setObject:[NSString stringWithFormat:@"%@",nianxianStr] forKey:@"myWorkYear"];
        [st setObject:[NSString stringWithFormat:@"%@",textField01.text] forKey:@"myName"];
        [st setObject:[NSString stringWithFormat:@"%@",textField02.text] forKey:@"myTel"];
        [st setObject:[NSString stringWithFormat:@"%@",sexStr] forKey:@"mySex"];
        [st setObject:[NSString stringWithFormat:@"%@",leixingstr] forKey:@"myLeix"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:textField01.text forKey:@"personName"];
        [user setObject:textField02.text forKey:@"user_tel"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//隐藏键盘的方法
-(void)hidenKeyboard
{
    [textField02 resignFirstResponder];
    [textField01 resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        myScrollow.contentOffset = CGPointMake(0, 0);
    }];
}
- (BOOL)checkTelephoneNumber
{
    if (textField02.text.length == 0) {//判断是否为空
        tipString = @"手机号码不能为空";
        return NO;
    }
    //判断是否是11位
    if (textField02.text.length != 11) {
        tipString = @"手机号码格式错误，请输入真实有效的信息";
        return NO;
    }
    
    NSString *number = textField02.text ;
//    NSArray *telArray = [NSArray arrayWithObjects:@"134",@"135",@"144",@"136",@"137",@"138",@"139",@"147",@"150",@"170",@"151",@"152",@"157",@"158",@"159",@"182",@"183",@"184",@"187",@"188",@"130",@"131",@"132",@"156",@"185",@"186",@"145",@"133",@"153",@"180",@"181",@"189", nil];
//    
//    //判断手机前三位
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    if([phoneTest evaluateWithObject:number]){
        return YES;
    }
    else
    {
        tipString = @"手机号码格式错误，请输入真实有效的信息";
        return NO;
    }
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
