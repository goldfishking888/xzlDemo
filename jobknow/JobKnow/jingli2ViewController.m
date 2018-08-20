//
//  jingli2ViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jingli2ViewController.h"
#import "EditReader.h"
@interface jingli2ViewController ()

@end

#define jobKey @"job"

#define instroyKey @"instroy"

#define jobNameKey @"jobName"

#define instroyNameKey @"instroyName"
#define companyKey @"companyName"

#define startKey @"startTime"
#define endTime @"endTime"

#define descrip @"descrip"

@implementation jingli2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    if (_workDic.count == 0) {
        jobString = [EditReader jobStr];
        if ([jobString isEqualToString:@"选择职业"]) {
            jobString = nil;
        }
        [myTabView reloadData];
    }else
    {
        [_workDic removeAllObjects];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [companyName resignFirstResponder];
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"工作经历2"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作经历2"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
    [self addBackBtn];
    [self addTitleLabel:@"工作经历"];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46+num, iPhone_width, iPhone_height-46-num)style:UITableViewStyleGrouped];
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
    myTabView.delegate =self;
    myTabView.dataSource =self;
    [self.view addSubview:myTabView];
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-70, 0+num, 70, 44);
    [registBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [registBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    //pressLogin
    [registBtn addTarget:self action:@selector(pressSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    //工作经历——公司名称
    companyName = [[UITextField alloc]initWithFrame:CGRectMake(110, 3, iPhone_width - 155, 44)];
    companyName.returnKeyType = UIReturnKeyDone;
    companyName.delegate = self;
    companyName.tag = 11;
    [companyName setTextColor:[UIColor grayColor]];
    companyName.font = [UIFont systemFontOfSize:14];
    companyName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    companyName.textAlignment = NSTextAlignmentRight;
    if (_workDic.count > 0) {
        companyName.text = [_workDic valueForKey:@"companyName"];
        destring = [_workDic valueForKey:@"job_description"];
        labelCount = [NSString stringWithFormat:@"已录入%d字",destring.length];
        dateStr = [_workDic valueForKey:@"startTime"];
        dateStr02 = [_workDic valueForKey:@"endTime"];
        jobString = [_workDic valueForKey:@"positionClass_str"];
        _workId = [_workDic valueForKey:@"id"];
    }
    
    jobcode = [_workDic valueForKey:@"positionClass"];
    NSArray *names = [jobString componentsSeparatedByString:@","];
    NSArray *codes = [jobcode componentsSeparatedByString:@","];
    
    EditReader *edit = [EditReader standerDefault];
    [edit.jobArray removeAllObjects];
    if (codes.count == names.count) {
        for (NSInteger i = 0; i<codes.count; i++) {
            jobRead *j = [[jobRead alloc] init];
            j.name = [names objectAtIndex:i];
            j.code = [codes objectAtIndex:i];
            [edit.jobArray addObject:j];
        }
    }
    NSLog(@"gongzuoms-----------------%@",edit.jobArray);
}
- (void)pressSave:(id)sender
{
    if (![self checkInfo]) {
        alert.message = tipString;
        [alert show];
        return;
    }
    
    NSMutableDictionary*paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"user_work",@"table",companyName.text,@"companyName",[EditReader jobCode]?[EditReader jobCode]:jobcode,@"positionClass",destring,@"job_desc",dateStr,@"startTime",dateStr02,@"endTime", nil];
    
    if (_workId.length > 0) {
        [paramters setObject:_workId forKey:@"id"];
    }else{
        [paramters setObject:@"" forKey:@"id"];
    }
    
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kSaveEducation);
    
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:paramters urlString:urlString];
    
    __weak  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [request setCompletionBlock:^{
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *resume = [resultDic valueForKey:@"error"];
        if ([resume integerValue] == 0) {
            NSArray *resultArray = [resultDic valueForKey:@"data"];
            ResumeOperation *resume = [ResumeOperation defaultResume];
            if (![resultArray isKindOfClass:[NSNull class]]) {
                [resume setObject:resultArray forKey:WorkExperience];
            }else{
                resultArray = [[NSArray alloc] init];
                [resume setObject:resultArray forKey:WorkExperience];
            }
            if (resultArray.count > 0) {
                [resume setObject:@"完整" forKey:@"workExperience"];
            }else
            {
                [resume setObject:@"不完整" forKey:@"workExperience"];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
}

- (void)jobDescription:(id)sender
{
    NSString *job = (NSString *)sender;
    destring = job;
}

- (BOOL)checkInfo
{
    if (companyName.text.length == 0) {
        tipString = @"请填写公司名称";
        return NO;
    }
    if (dateStr.length == 0) {
        tipString = @"请填写职位类别";
        return NO;

    }
    if (dateStr.length == 0) {
        tipString = @"请填写开始时间";
        return NO;
    }
    if (dateStr02.length == 0) {
        tipString = @"请填写结束时间";
        return NO;
    }
    if (destring.length == 0) {
        tipString = @"请填写工作描述";
        return NO;
    }
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
    
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
        UILabel *labei = (UILabel *)[cell.contentView viewWithTag:521];
        [labei removeFromSuperview];
        cell.accessoryView = nil;
    }
    NSArray *ary = [[NSArray alloc]initWithObjects:@"公司名称",@"职位类别",@"开始时间",@"结束时间", nil];
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
    [cell.contentView addSubview:label];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell.contentView addSubview:companyName];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if(indexPath.row == 1 && indexPath.section == 0)
    {
        label.text = jobString;
    }else if (indexPath.section ==0 && indexPath.row ==2){
      
        label.text = dateStr;
    }
    else if(indexPath.row == 3 && indexPath.section == 0)
    {        
         label.text = dateStr02;
    }
    else if (indexPath.section == 1&& indexPath.row == 0)
    {        cell.textLabel.text = @"工作描述";
        if (labelCount) {
            label.text = [NSString stringWithFormat:@"%@",labelCount];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        JobItemViewController *jobVC = [[JobItemViewController alloc] init];
        jobVC.enter = NO;
        [self.navigationController pushViewController:jobVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row ==2)
    {
        start = YES;
        [self selectDate];
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        start = NO;
        [self selectDate];
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        //工作描述
        pingjiaViewController *pingjia =[[pingjiaViewController alloc]init];
        pingjia.trpe = [NSString stringWithFormat:@"miao"];
        pingjia.deleat =self;
        pingjia.contentString = destring;
        [self.navigationController pushViewController:pingjia animated:YES];
    }
}
//选择日期
- (void)selectDate
{
    _datePicker = [[KTSelectDatePicker alloc] initWithMaxDate:[NSDate date] minDate:[XZLUtil changeStrToDate:@"1970-01-01"] currentDate:[NSDate date] datePickerMode:UIDatePickerModeDate];
    __weak typeof(self) weakSelf = self;
    [_datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        if (start) {
            dateStr = [weakSelf changeDateToStr:selectedDate];
        }else
        {
            dateStr02 = [weakSelf changeDateToStr:selectedDate];
        }
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

//textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==11) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        
    }
}
//俩代理方法
- (void)wanzhengFou:(NSString *)str{}
- (void)miashuZiShu:(NSString *)str destring:(NSString *)des
{
    destring = des;
    labelCount = [NSString stringWithFormat:@"已录入%@字",str];
    [myTabView reloadData];
}
- (void)pressLogin:(id)sender
{
    NSLog(@"保存");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
