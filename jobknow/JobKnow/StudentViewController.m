//
//  StudentViewController.m
//  JobKnow
//
//  Created by Zuo on 14-3-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "StudentViewController.h"
#import "MyTableCell.h"
#import "ProvinceViewController.h"
#import "MajorViewController.h"
#import "OLGhostAlertView.h"
@interface StudentViewController ()

@end

@implementation StudentViewController
    MBProgressHUD *loadView;
NSString *_tipString;
@synthesize majorStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        num = ios7jj;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"就业分析"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"就业分析"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
//    [self addTitleLabel:@"学生基本信息"];
    [self addTitleLabel:@"就业分析"];
    majorCode = @"";
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(saveStuInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource =self;
    mytableView.backgroundView = nil;
    [self.view addSubview:mytableView];
    
    //姓名
    textField01 = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 160, 44)];
    textField01.returnKeyType = UIReturnKeyNext;
    textField01.delegate = self;
    textField01.tag = 101;
    [textField01 setTextColor:[UIColor grayColor]];
    textField01.font = [UIFont systemFontOfSize:14];
    textField01.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    NSString *myNamee = [myUser valueForKey:@"userName"];
    textField01.placeholder = @"姓名";
    if (myNamee == nil) {
        textField01.text = @"";
    }else{
        textField01.text = [NSString stringWithFormat:@"%@",myNamee];
    }
    textField01.textAlignment = NSTextAlignmentRight;
    
    //院系
    textField02 = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 160, 44)];
    textField02.delegate = self;
    [textField02 setFont:[UIFont systemFontOfSize:14]];
    textField02.tag = 102;
    textField02.textColor = [UIColor grayColor];
    textField02.returnKeyType = UIReturnKeyDone;
    textField02.placeholder = @"院系";
    textField02.borderStyle = UITextBorderStyleNone;
    textField02.keyboardType = UIKeyboardTypeAlphabet;
    textField02.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField02.textAlignment = NSTextAlignmentRight;
    
    //学号
    textField03 = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 160, 44)];
    textField03.delegate = self;
    [textField03 setFont:[UIFont systemFontOfSize:14]];
    textField03.tag = 103;
    textField03.textColor = [UIColor grayColor];
    textField03.returnKeyType = UIReturnKeyDone;
    textField03.placeholder = @"学号";
    textField03.borderStyle = UITextBorderStyleNone;
    textField03.keyboardType = UIKeyboardTypeAlphabet;
    textField03.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField03.textAlignment = NSTextAlignmentRight;
    
    //性别
    swith = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [swith addTarget:self action:@selector(turnoffNotification:) forControlEvents:UIControlEventValueChanged];
    //取值
    ResumeOperation *sr = [ResumeOperation defaultResume];
    sexCode = [sr.resumeDictionary valueForKey:@"mySex"];
    if ([sexCode isEqualToString:@"0"]) {
        swith.on = NO;
        sexStr=@"女";
    }else{
        swith.on = YES;
        sexStr=@"男";
    }
    //电话
    textField04 = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 160, 44)];
    textField04.delegate = self;
    [textField04 setFont:[UIFont systemFontOfSize:14]];
    textField04.tag = 104;
    textField04.textColor = [UIColor grayColor];
    textField04.returnKeyType = UIReturnKeyDone;
    textField04.placeholder = @"电话";
    textField04.borderStyle = UITextBorderStyleNone;
    textField04.keyboardType = UIKeyboardTypeNumberPad;
    textField04.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField04.textAlignment = NSTextAlignmentRight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeName:) name:@"u_name" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setByqx:) name:@"jyfx_byqx" object:nil];
    
    [self getStuInfo];
}

- (void)changeName:(id)sender
{
    NSNotification *notification = (NSNotification *)sender;
    NSString *str = [notification.userInfo valueForKey:@"uname"];
    if (str.length > 0) {
        schoolStr = str;
    }
    NSString *majorName = [notification.userInfo valueForKey:@"name"];
    if (majorName.length > 0) {
        zhuanyeField.text = @"";
        majorStr = majorName;
        majorCode = [notification.userInfo valueForKey:@"code"];
    }
    [mytableView reloadData];
}

- (void)setByqx:(id)sender
{
    NSNotification *notification = (NSNotification *)sender;
    NSString *str = [notification.userInfo valueForKey:@"byqx"];
    if (str.length > 0) {
        biyeqxStr = str;
    }
    [mytableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray1 = [NSArray arrayWithObjects:@"姓名",@"学校",@"院系",@"专业",@"学号",@"性别",@"联系电话",@"生源地",@"毕业去向",nil];
    static NSString *identifier = @"Cell";
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell.contentView addSubview:textField01];
    }else if (indexPath.section ==0 && indexPath.row ==1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.text = schoolStr;
    //院系
    }else if (indexPath.section ==0 && indexPath.row ==2){
        [cell.contentView addSubview:textField02];
     //专业
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        label.text = majorStr;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section ==0 && indexPath.row==6){
        //电话
        [cell.contentView addSubview:textField04];
    }else if (indexPath.section ==0 && indexPath.row ==4){
        //学号
         [cell.contentView addSubview:textField03];
    }else if (indexPath.section ==0 && indexPath.row ==5){
        //性别
        cell.accessoryView = swith;
        CGRect r = label.frame;
        r.origin.x -= 50;
        label.frame = r;
        label.text = sexStr;
        [cell.contentView addSubview:label];
    }else if (indexPath.section ==0 && indexPath.row ==7){
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([cityStr isEqualToString:@"(null)"]||cityStr.length==0) {
            label.text = @"";
        }else{
            label.text = [NSString stringWithFormat:@"%@",cityStr];
        }
    }else if (indexPath.section ==0 && indexPath.row ==8){
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.text = biyeqxStr;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labname.frame =CGRectMake(15, 15, 290, 20);
    cell.labname.text = [titleArray1 objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==1) {
        ProvinceViewController *pro = [[ProvinceViewController alloc]init];
        [self.navigationController pushViewController:pro animated:YES];
        //专业
    }else if(indexPath.section==0&&indexPath.row==3){
        MajorViewController *majorVC = [[MajorViewController alloc] init];
        [self.navigationController pushViewController:majorVC animated:YES];
    }else if (indexPath.section==0&&indexPath.row==7){
        allCViewController *allcity = [[allCViewController alloc]init];
        allcity.delegate =self;
        [self.navigationController pushViewController:allcity animated:YES];
    }else if (indexPath.section==0 && indexPath.row==8){
    BiyeqxViewController *biye = [[BiyeqxViewController alloc]init];
    [self.navigationController pushViewController:biye animated:YES];
    }
}
//textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==101) {
        [textField resignFirstResponder];
    }else{
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            mytableView.contentOffset = CGPointMake(0, 0);
        }];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==102) {
        [UIView animateWithDuration:0.3 animations:^{
            mytableView.contentOffset = CGPointMake(0, 100);
        }];
    }else if (textField.tag==103){
        [UIView animateWithDuration:0.3 animations:^{
            mytableView.contentOffset = CGPointMake(0, 150);
        }];
    }else if (textField.tag==104){
        [UIView animateWithDuration:0.3 animations:^{
            mytableView.contentOffset = CGPointMake(0, 230);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)chuanCity:(NSString *)city cityCode:(NSString *)code
{
    cityStr = [NSString stringWithFormat:@"%@",city];
    cityCode = [NSString stringWithFormat:@"%@",code];
    [mytableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        sexCode = @"0";
    }
    [mytableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"u_name" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jyfx_byqx" object:nil];
}

-(void)getStuInfo{
    
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    flag = @"getStuInfo";
//    _netWork = [[NetWorkConnection alloc] init];
//    _netWork.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI, kGetStuInfo);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
//    [_netWork sendRequestURLStr:url ParamDic:param Method:@"GET"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        if (resultDic&&[resultDic count]>0){
            
            //姓名
            textField01.text = [resultDic valueForKey:@"userName"];
            //学校
            schoolStr = [resultDic valueForKey:@"userSchool"];
            //院系
            textField02.text = [resultDic valueForKey:@"userFaculty"];
            
            //专业
            //        NSIndexPath *index2 =  [NSIndexPath indexPathForItem:2 inSection:0];
            //        UITableViewCell *cell2 = [mytableView cellForRowAtIndexPath:index2];
            //        cell2.textLabel.text = [resultDic valueForKey:@"userMajor"];
            majorCode  = [resultDic valueForKey:@"userMajor"];
            majorStr = [resultDic valueForKey:@"userMajor_str"];
            //学号
            textField03.text = [resultDic valueForKey:@"userStunum"];
            //性别
            sexCode = [resultDic valueForKey:@"userSex"];
            if ([sexCode isEqualToString:@"0"]) {
                swith.on = NO;
                sexStr=@"女";
            }else{
                swith.on = YES;
                sexStr=@"男";
            }
            //联系电话
            NSString * tPn =[resultDic valueForKey:@"userPhone"];
            textField04.text = [tPn isEqualToString:@"0"]?@"":tPn;
            //生源地
            cityCode = [resultDic valueForKey:@"userStuSource"];
            cityStr = [resultDic valueForKey:@"userStuSource_str"];
            //毕业去向
            biyeqxStr = [resultDic valueForKey:@"userGradTo"];
            [mytableView reloadData];
        }

    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}

-(void)saveStuInfo{
    if (![self resultWithTip]) {
        
        OLGhostAlertView *olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
        olalterView.position = OLGhostAlertViewPositionCenter;
        olalterView.message = _tipString;
        [olalterView show];
        return;
    }else{
    flag = @"saveStuInfo";
    _netWork = [[NetWorkConnection alloc] init];
    _netWork.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI, kSaveStuInfo);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",
        @"",@"abroadSource",
        textField03.text,@"userStunum",
        textField01.text,@"userName",
        schoolStr,@"userSchool",
        textField02.text,@"userFaculty",
        majorCode,@"userMajor",
        sexCode,@"userSex",
        textField04.text,@"userPhone",
        cityCode,@"userStuSource",
        biyeqxStr,@"userGradTo",
        nil];

        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            [loadView setHidden:YES];
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *strr = [resultDic valueForKey:@"error"];
            if ([strr integerValue]==0) {
                
                OLGhostAlertView *olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
                olalterView.position = OLGhostAlertViewPositionCenter;
                olalterView.message =@"修改成功";
                [olalterView show];
                //基本信息保存成功
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
        }];
        [request startAsynchronous];
    }
}

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];//解析数据
    NSLog(@"resultDic in StudentViewController is %@",resultDic);
        
    if([@"saveStuInfo" isEqual:flag]){
        NSString *strr = [resultDic valueForKey:@"error"];
        if ([strr integerValue]==0) {

            OLGhostAlertView *olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
            olalterView.position = OLGhostAlertViewPositionCenter;
            olalterView.message =@"修改成功";
            [olalterView show];
            //基本信息保存成功
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if ([@"getStuInfo" isEqual:flag] && resultDic&&[resultDic count]>0){
        
        //姓名
        textField01.text = [resultDic valueForKey:@"userName"];
        //学校
        schoolStr = [resultDic valueForKey:@"userSchool"];
        //院系
        textField02.text = [resultDic valueForKey:@"userFaculty"];
        
        //专业
//        NSIndexPath *index2 =  [NSIndexPath indexPathForItem:2 inSection:0];
//        UITableViewCell *cell2 = [mytableView cellForRowAtIndexPath:index2];
//        cell2.textLabel.text = [resultDic valueForKey:@"userMajor"];
        majorCode  = [resultDic valueForKey:@"userMajor"];
        majorStr = [resultDic valueForKey:@"userMajor_str"];
        //学号
        textField03.text = [resultDic valueForKey:@"userStunum"];
        //性别
        sexCode = [resultDic valueForKey:@"userSex"];
        if ([sexCode isEqualToString:@"0"]) {
            swith.on = NO;
            sexStr=@"女";
        }else{
            swith.on = YES;
            sexStr=@"男";
        }
        //联系电话
        NSString * tPn =[resultDic valueForKey:@"userPhone"];
        textField04.text = [tPn isEqualToString:@"0"]?@"":tPn;
        //生源地
        cityCode = [resultDic valueForKey:@"userStuSource"];
        cityStr = [resultDic valueForKey:@"userStuSource_str"];
        //毕业去向
        biyeqxStr = [resultDic valueForKey:@"userGradTo"];
        [mytableView reloadData];
    }
            [loadView hide:YES];
}

//电话号码
- (BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return  [phoneTest evaluateWithObject:mobile];
}
- (BOOL)resultWithTip{
    if (![self checkString:textField01.text length:8])
    {
        _tipString = @"姓名格式错误，请输入真实有效的信息";
        return NO;
    }
    
    if (schoolStr.length == 0)
    {
        _tipString = @"请选择学校";
        return NO;
    }
    
    if (textField02.text.length == 0)
    {
        _tipString = @"请填写院系名称";
        return NO;
    }
    
    if (textField03.text.length == 0)
    {
        _tipString = @"请填写学号";
        return NO;
    }
    
    if (majorStr.length == 0)
    {
        _tipString = @"请选择专业";
        return NO;
    }
    
    if (sexStr.length == 0)
    {
        _tipString = @"请选择性别";
        return NO;
    }
    
    if (![self isValidateMobile:textField04.text])
    {
        _tipString = @"手机号码格式错误，请输入真实有效的信息";
        return NO;
    }
    if (cityStr.length == 0)
    {
        _tipString = @"请选择生源地";
        return NO;
    }
    if (biyeqxStr.length == 0)
    {
        _tipString = @"请选择毕业去向";
        return NO;
    }
    return  YES;
    
}
- (BOOL)checkString:(NSString *)str length:(NSInteger)l
{
    NSString * regex = [[NSString alloc] initWithFormat:@"^[\u4e00-\u9fa5]{2,%d}$",l];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
@end
