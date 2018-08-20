//
//  jiaoyu2ViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-5.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jiaoyu2ViewController.h"
#import "More.h"
#import "MajorViewController.h"
#import "ProvinceViewController.h"
@interface jiaoyu2ViewController ()

@end

@implementation jiaoyu2ViewController
@synthesize majorStr,schoolStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _moreArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"添加教育信息"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"添加教育信息"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
	self.view.backgroundColor = XZHILBJ_colour;
    //简历上下滑动
    myScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height-44)];
    myScrollow.delegate = self;
    myScrollow.backgroundColor = [UIColor clearColor];
    CGFloat myHeight;
    myHeight= iPhone_height+1;
    myScrollow.contentSize = CGSizeMake(320, myHeight);
    [self.view addSubview:myScrollow];
    [self addBackBtn];
    [self addTitleLabel:@"添加教育信息"];
    
    dateStr = @"";
    schoolStr = @"";
    majorCode = @"";
    xueliStr = @"";
    companyName.text = @"";
    zhuanyeField.text = @"";
        
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-70, 0+num, 70, 44);
    [registBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [registBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [registBtn addTarget:self action:@selector(pressSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, iPhone_width, iPhone_height) style:UITableViewStyleGrouped];
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    UIView *tvBg = [[UIView alloc] initWithFrame:_myTableView.frame];
    [tvBg setBackgroundColor:XZHILBJ_colour];
    _myTableView.backgroundView = tvBg;
    _myTableView.scrollEnabled = NO;
    [myScrollow addSubview:_myTableView];
    NSArray *more = [NSArray arrayWithObjects:@"毕业时间",@"学       校",@"",@"学       历",@"专       业",@"",@"海外学习",nil];
    _selects = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    NSMutableArray *zu = [NSMutableArray array];
    for (NSInteger i = 0; i < more.count; i++)
    {
        More *m = [[More alloc] init];
        
        m.moreName = [more objectAtIndex:i];
        [zu addObject:m];
        switch (i)
        {
            case 3:
                [_moreArray addObject:zu];
                zu = [NSMutableArray array];
                break;
            case 5:
                [_moreArray addObject:zu];
                zu = [NSMutableArray array];
                break;
            case 6:
                [_moreArray addObject:zu];
                zu = [NSMutableArray array];
                break;   
                
        }
    }

    /////////////////////////////通知///////////////////////////////
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeName:) name:@"u_name" object:nil];
    
    //未录入的大学名称
    companyName = [[UITextField alloc]initWithFrame:CGRectMake(20, 3, iPhone_width - 70, 44)];
    companyName.returnKeyType = UIReturnKeyDone;
    companyName.delegate = self;
    companyName.tag = 11;
    companyName.text = @"";
    [companyName setTextColor:[UIColor grayColor]];
    companyName.font = [UIFont fontWithName:Zhiti size:14];
    companyName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    companyName.placeholder = @"未录入您的大学,请在此输入";
    companyName.textAlignment = NSTextAlignmentRight;
    //未录入的专业名称
    zhuanyeField = [[UITextField alloc]initWithFrame:CGRectMake(20, 3, iPhone_width-70, 44)];
    zhuanyeField.returnKeyType = UIReturnKeyDone;
    zhuanyeField.delegate = self;
    zhuanyeField.text = @"";
    zhuanyeField.tag = 12;
    [zhuanyeField setTextColor:[UIColor grayColor]];
    zhuanyeField.font = [UIFont fontWithName:Zhiti size:14];
    zhuanyeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    zhuanyeField.placeholder = @"未录入您的专业,请在此输入";
    zhuanyeField.textAlignment = NSTextAlignmentRight;
    
    NSString *sa = @"0";
    if (self.eduDic.count > 0) {
        dateStr = [self.eduDic valueForKey:@"graduate_time"];
        xueliStr = [self.eduDic valueForKey:@"degree"];
        majorCode = [self.eduDic valueForKey:@"major"];
        eduid = [self.eduDic valueForKey:@"id"];
        majorStr = [self.eduDic valueForKey:@"major_str"];
        schoolStr = [self.eduDic valueForKey:@"school"];
        zhuanyeField.text = [self.eduDic valueForKey:@"self_w"];
        companyName.text = [self.eduDic valueForKey:@"self_sw"];
        sa = [self.eduDic valueForKey:@"study_abroad"];
    }
    
    
    swith = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [swith addTarget:self action:@selector(turnoffNotification:) forControlEvents:UIControlEventValueChanged];
    if ([sa integerValue] == 0) {
        swith.on = NO;
    }else
    {
        swith.on = YES;
    }
}
#pragma mark-添加教育信息保存按钮方法
- (void)pressSave:(id)sender
{
    if (![self checkEducation]) {
        alert.message = tipStr;
        [alert show];
        return;
    }
    paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"user_education",@"table",dateStr,@"graduate_time",xueliStr,@"degree", nil];
    if (majorCode.length > 0) {
        [paramters setObject:majorCode forKey:@"major"];
        [paramters setObject:@"" forKey:@"self_w"];
    }else
    {
        [paramters setObject:@"" forKey:@"major_str"];
        [paramters setObject:zhuanyeField.text forKey:@"self_w"];
    }
    
    if (schoolStr.length > 0) {
        [paramters setObject:schoolStr forKey:@"school"];
        [paramters setObject:@"" forKey:@"self_sw"];
    }else
    {
        [paramters setObject:@"" forKey:@"school"];
        [paramters setObject:companyName.text forKey:@"self_sw"];
    }
    
    if (swith.on) {
        [paramters setObject:@"1" forKey:@"study_abroad"];
    }else
    {
        [paramters setObject:@"0" forKey:@"study_abroad"];
    }
    if (eduid.length > 0) {
        [paramters setObject:eduid forKey:@"id"];
    }else{
        [paramters setObject:@"" forKey:@"id"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kSaveEducation);
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:paramters urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
    NSString *resume = [resultDic valueForKey:@"error"];
    if ([resume integerValue] == 0) {
        NSArray *educationArray = [NSArray arrayWithArray:[resultDic valueForKey:@"data"]];
        [jiaoyu2ViewController jsonEducation:educationArray];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        alert.message = @"保存失败";
        [alert show];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    alert.message = @"保存失败";
    [alert show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
+ (NSArray *)jsonEducation:(NSArray *)educationArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in educationArray) {
        NSString *endTime = [dic valueForKey:@"graduate_time"];
        NSString *degree = [dic valueForKey:@"degree"];
        NSString *eduid = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"id"]];
        NSString *major_code = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"major"]];
        NSString *major_str = [dic valueForKey:@"major_str"];
        NSString *university = [dic valueForKey:@"school"];
        NSString *self_w = [dic valueForKey:@"self_w"];
        NSString *self_sw = [dic valueForKey:@"self_sw"];
        NSString *study_abroad = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"study_abroad"]];
        
        NSMutableDictionary *edudic = [NSMutableDictionary dictionaryWithObjectsAndKeys:endTime,@"graduate_time",major_code,@"major",eduid,@"id",study_abroad,@"study_abroad",major_str,@"major_str",university,@"school", nil];
        if (self_w.length > 0) {
            [edudic setObject:self_w forKey:@"self_w"];
        }
        if (self_sw.length > 0) {
            [edudic setObject:self_sw forKey:@"self_sw"];
        }
        if (degree.length > 0) {
            [edudic setObject:degree forKey:@"degree"];
        }
        [array addObject:edudic];
    }
    ResumeOperation *resume = [ResumeOperation defaultResume];
    [resume setObject:array forKey:EducationKey];
    if (array.count > 0) {
        [resume setObject:@"完整" forKey:@"education"];
    }else
    {
        [resume setObject:@"不完整" forKey:@"education"];
    }
    return array;
}


- (BOOL)checkEducation
{
    if (dateStr.length == 0) {
        tipStr = @"请填写毕业时间";
        return NO;
    }else if (schoolStr.length == 0 && companyName.text.length == 0)
    {
        tipStr = @"请填写学校";
        return NO;
    }else if (xueliStr.length == 0)
    {
        tipStr = @"请填写学历";
        return NO;
    }else if (majorStr.length == 0 && zhuanyeField.text.length == 0)
    {
        tipStr = @"请填写专业";
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section ==1){
        return 2;
    }else{
        return 1;
    }
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
        UILabel *labeilll = (UILabel *)[cell.contentView viewWithTag:521];
        [labeilll removeFromSuperview];
        cell.accessoryView = nil;
    }
    More *m = [[_moreArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = m.moreName;
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
        label.text = dateStr;
    }
    else if(indexPath.row == 1 && indexPath.section == 0)
    {
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.text = schoolStr;
    }else if (indexPath.section ==0 && indexPath.row ==2){
        [cell.contentView addSubview:companyName];
        
    }
    else if(indexPath.row == 3 && indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *str=[self changeCode:xueliStr];
        label.text = str;
    }
    else if (indexPath.section == 1&& indexPath.row == 0)
    {
        label.text = majorStr;
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1&& indexPath.row == 1){
        [cell.contentView addSubview:zhuanyeField];
    }
    else if (indexPath.section == 2&& indexPath.row == 0)
    {
         cell.accessoryView = swith;
        if (swith.on) {
            label01.text = @"是";
        }else
        {
            label01.text = @"否";
        }
        [cell.contentView addSubview:label01];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self selectDate];
    }
    else if(indexPath.row == 1 && indexPath.section == 0)
    {
        ProvinceViewController *pro = [[ProvinceViewController alloc]init];
        [self.navigationController pushViewController:pro animated:YES];
    }else if(indexPath.row == 3 && indexPath.section == 0)
    {
        xueliViewController *xueli = [[xueliViewController alloc]init];
        xueli.selectDelegate = self;
        [self.navigationController pushViewController:xueli animated:YES];
    }
    else if (indexPath.section == 1&& indexPath.row == 0)
    {
        //NSLog(@"专业");
        MajorViewController *majorVC = [[MajorViewController alloc] init];
        [self.navigationController pushViewController:majorVC animated:YES];
    }else if (indexPath.section == 1&& indexPath.row == 1){
       
    }
    else if (indexPath.section == 2&& indexPath.row == 0)
    {
        NSLog(@"海外学习");
    }
    
}
//textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==11) {
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
    if (textField.tag == 12) {
        [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 200);
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 12)
    {
        if (majorCode.length > 0) {
            majorCode = @"";
            majorStr = @"";
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
            UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:path];
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:520];
            label.text = @"";
        }
    }
    else if (textField.tag == 11)
    {
        if (schoolStr.length > 0) {
            schoolStr = @"";
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
            UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:path];
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:520];
            label.text = @"";
        }
    }
    return YES;
}

//选择日期
- (void)selectDate
{

    _datePicker = [[KTSelectDatePicker alloc] initWithMaxDate:[NSDate date] minDate:[XZLUtil changeStrToDate:@"1970-01-01"] currentDate:[NSDate date] datePickerMode:UIDatePickerModeDate];
    __weak typeof(self) weakSelf = self;
    [_datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        dateStr = [weakSelf changeDateToStr:selectedDate];
        [_myTableView reloadData];
    }];
    
}

- (NSString *)changeDateToStr:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString *dateStrf = [formatter stringFromDate:date];
    return dateStrf;
}
- (void)changeName:(id)sender
{
    NSNotification *notification = (NSNotification *)sender;
    NSString *str = [notification.userInfo valueForKey:@"uname"];
    if (str.length > 0) {
        schoolStr = str;
        companyName.text = @"";
    }
    NSString *majorName = [notification.userInfo valueForKey:@"name"];
    if (majorName.length > 0) {
        zhuanyeField.text = @"";
        majorStr = majorName;
        majorCode = [notification.userInfo valueForKey:@"code"];
    }
    [_myTableView reloadData];
}
//根据学历编码返回名字
-(NSString *)changeCode:(NSString *)xueliCode
{
    NSString *name = nil;
    switch ([xueliCode integerValue]) {
        case 0:
         name = @"不限";
         break;
        case 10:
            name = @"初中";
            break;
        case 11:
            name = @"高中";
            break;
        case 12:
            name = @"中技";
            break;
        case 13:
            name = @"中专";
            break;
        case 14:
            name = @"大专";
            break;
        case 15:
            name = @"本科";
            break;
        case 16:
            name = @"硕士";
            break;
        case 17:
            name = @"博士";
            break;
        case 18:
            name = @"博士后";
            break;
        case 99:
            name = @"其他";
            break;
        default:
            break;
    }
    
    
    
    return name;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)turnoffNotification:(id)sender
{
    [_myTableView reloadData];
}
- (void)selectValueToUp:(NSString *)select
{
    xueliStr = [NSString stringWithFormat:@"%@",select];
    [_myTableView reloadData];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"u_name" object:nil];
}
@end
