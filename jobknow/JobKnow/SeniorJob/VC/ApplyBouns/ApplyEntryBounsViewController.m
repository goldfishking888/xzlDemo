//
//  ApplyEntryBounsViewController.m
//  JobKnow
//
//  Created by Jiang on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ApplyEntryBounsViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "HRSelectCityViewController.h"
#import "SelectCompanyViewController.h"
#import "BounsJobListViewController.h"
#import "IQActionSheetPickerView.h"
#import "XZLUtil.h"

#define TFTag 1627
#define LabelTag 1628
#define TextFieldOfCell(row) ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] viewWithTag:1627])

#define LabelOfCell(row) ((UILabel *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] viewWithTag:1628])

@interface ApplyEntryBounsViewController ()<UITableViewDelegate,UITableViewDataSource,HRSelectCityDelegate,SelectCompanyDelegate,BounsJobListDelegate,IQActionSheetPickerViewDelegate>{
    
    TPKeyboardAvoidingScrollView *_scrollView;
    UITableView *_tableView;
    NSArray *_titleArray;// tableView的左title数组
    OLGhostAlertView *_ghost;
    NSMutableDictionary *_paramsDic;//城市和公司信息（cityCode,cityName,pid,companyName,jid,fee,bouns,seniorPercent,salary）
    NSMutableArray *_jobListArray;// 企业的入职奖金职位
}

@end

@implementation ApplyEntryBounsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"申请入职奖金"];
    
    _titleArray = @[@"申请人",@"公司城市",@"公司名称",@"奖金职位",@"职位薪资",@"入职时间",@"入职薪资",@"联系方式"];
    _paramsDic = [NSMutableDictionary dictionary];
    _jobListArray = [NSMutableArray array];
    
    _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, ios7jj+44, iPhone_width, iPhone_height-ios7jj-44)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setBackgroundColor:XZHILBJ_colour];
    [self.view addSubview:_scrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,10, iPhone_width-20, 44*8)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView.layer setCornerRadius:10];
    [_tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tableView.layer setBorderWidth:0.5];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_scrollView addSubview:_tableView];
    
    UIButton *applyButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _tableView.frame.origin.y+_tableView.frame.size.height+15, 300, 40)];
    [applyButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [applyButton setBackgroundColor:[UIColor orangeColor]];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton.layer setCornerRadius:8];
    [applyButton addTarget:self action:@selector(applyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:applyButton];
    
    NSString *tipStr = @"温馨提示1：如果您的入职奖金申请通过小职了审核，工作人员将在您入职满一个月后即时发放入职奖金。\n温馨提示2：实际入职奖金以您的实际入职薪资为准。";
    CGSize size = [tipStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 300) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, applyButton.frame.origin.y+applyButton.frame.size.height+10, 300, size.height+10)];
    [tipLabel setFont:[UIFont systemFontOfSize:14]];
    [tipLabel setTextColor:[UIColor orangeColor]];
    [tipLabel setNumberOfLines:0];
    [tipLabel setText:tipStr];
    [_scrollView addSubview:tipLabel];
    
    [_scrollView setContentSize:CGSizeMake(iPhone_width, tipLabel.frame.origin.y + tipLabel.frame.size.height)];
    
    _ghost = [[OLGhostAlertView alloc] initWithTitle:nil message:@"" timeout:3 dismissible:YES];
    [_ghost setPosition:OLGhostAlertViewPositionCenter];
    
    // 初始化公司城市
    NSString *cityCode = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"cityCode"]];
    NSString *cityName = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"cityName"]];
    [_paramsDic setValue:cityCode forKey:@"cityCode"];
    [_paramsDic setValue:cityName forKey:@"cityName"];
}

#pragma mark - 提交申请

- (void)applyButtonClick{
    NSString *username= TextFieldOfCell(0).text;
    NSString *localcity = [NSString stringWithFormat:@"%@",_paramsDic[@"cityCode"]?_paramsDic[@"cityCode"]:@""];
    NSString *pid = [NSString stringWithFormat:@"%@",_paramsDic[@"pid"]?_paramsDic[@"pid"]:@""];
    NSString *jid = [NSString stringWithFormat:@"%@",_paramsDic[@"jid"]?_paramsDic[@"jid"]:@""];
    NSString *fee = [NSString stringWithFormat:@"%@",_paramsDic[@"fee"]?_paramsDic[@"fee"]:@""];
    NSString *bouns = [NSString stringWithFormat:@"%@",_paramsDic[@"bouns"]?_paramsDic[@"bouns"]:@""];
    NSString *seniorPercent = [NSString stringWithFormat:@"%@",_paramsDic[@"seniorPercent"]?_paramsDic[@"seniorPercent"]:@""];
    NSString *salary = [NSString stringWithFormat:@"%@",_paramsDic[@"salary"]?_paramsDic[@"salary"]:@""];
    NSString *entrydate= [XZLUtil changeDateToStr:[XZLUtil changeStringToDate:LabelOfCell(5).text withFormatter:@"yyyy年MM月dd日"]];
    NSString *joinSalary = TextFieldOfCell(6).text;
    NSString *mobile = TextFieldOfCell(7).text;
    
    if (username.length == 0) {
        _ghost.message = @"请输入姓名申请人";
        [_ghost show];
        return;
    }else if (localcity.length == 0) {
        _ghost.message = @"请选择公司城市";
        [_ghost show];
        return;
    }else if (pid.length == 0) {
        _ghost.message = @"请选择公司名称";
        [_ghost show];
        return;
    }else if (jid.length == 0) {
        _ghost.message = @"请选择奖金职位";
        [_ghost show];
        return;
    }else if (entrydate.length == 0) {
        _ghost.message = @"请选择入职时间";
        [_ghost show];
        return;
    }else if (joinSalary.length == 0) {
        _ghost.message = @"请输入入职薪资";
        [_ghost show];
        return;
    }else if ([XZLUtil isValidateNumber:joinSalary] == NO) {
        _ghost.message = @"请输入准确的入职薪资";
        [_ghost show];
        return;
    }else if (mobile.length == 0) {
        _ghost.message = @"请输入联系方式";
        [_ghost show];
        return;
    }else if ([XZLUtil isValidateMobile:mobile] == NO) {
        _ghost.message = @"请输入正确的联系方式";
        [_ghost show];
        return;
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",localcity,@"localcity",pid,@"pid",jid,@"jid",joinSalary,@"joinSalary",fee,@"fee",username,@"username",bouns,@"bouns",entrydate,@"entrydate",salary,@"salary",seniorPercent,@"seniorPercent",mobile,@"mobile",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/senior/apply_bouns?"];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseString isEqualToString:@"please login"] == NO) {
            NSError *error;
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString * errorStr = [NSString stringWithFormat:@"%@",resultDic[@"error"]];
            // 0：提交申请成功 2：超出奖金申请有效期 3：提交申请失败
            if ([errorStr isEqualToString:@"0"] == YES) {
                
                _ghost.message = @"提交申请成功";
                [_ghost show];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([errorStr isEqualToString:@"2"] == YES) {
                
                _ghost.message = @"超出奖金申请有效期";
                [_ghost show];
                
            }else{
                
                _ghost.message = @"提交申请失败";
                [_ghost show];
                
            }
        }
    }];
    [request setFailedBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _ghost.message = @"网络连接失败，请稍后重试";
        [_ghost show];
    }];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - 获取企业的入职奖金职位
- (void)requeBounsJobListWithPid:(NSString *)pid companyName:(NSString *)companyName{

    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pid,@"jid",companyName,@"cname",@"0",@"page",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/senior/job_list?"];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([request.responseString isEqualToString:@"please login"] == NO) {
            NSError *error;
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString * errorStr = [NSString stringWithFormat:@"%@",resultDic[@"error"]];
            if ([errorStr isEqualToString:@"0"] == YES) {
                NSArray * listArray = resultDic[@"data_list"];
                _jobListArray = [NSMutableArray arrayWithArray:listArray];
                if ([_jobListArray count] == 0) {
                    _ghost.message = @"该公司暂无入职奖金职位";
                    [_ghost show];
                }else{
                    //
                }
            }
        }
    }];
    [request setFailedBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _ghost.message = @"网络连接失败，请稍后重试";
        [_ghost show];
    }];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

#pragma mark - HRSelectCityDelegate

- (void)didSelectWithCityCode:(NSString *)cityCode cityName:(NSString *)cityName{
    
    NSLog(@"code = %@；name = %@",cityCode,cityName);
    UILabel *cityLabel = LabelOfCell(1);
    [cityLabel setText:cityName];
    
    // 选择城市后，重置参数dic
    [_paramsDic removeAllObjects];
    [_paramsDic setValue:cityCode forKey:@"cityCode"];
    [_paramsDic setValue:cityName forKey:@"cityName"];
    UILabel *companyLabel = LabelOfCell(2);
    [companyLabel setText:@""];
    UILabel *jobLabel = LabelOfCell(3);
    [jobLabel setText:@""];
    UILabel *salaryLabel = LabelOfCell(4);
    [salaryLabel setText:@""];
}

#pragma mark - SelectCompanyDelegate

- (void)selectCompanyWithPid:(NSString *)pid companyName:(NSString *)name{
    
    NSLog(@"pid = %@；companyName = %@",pid,name);
    [_paramsDic setValue:pid forKey:@"pid"];
    [_paramsDic setValue:name forKey:@"companyName"];
    UILabel *companyLabel = LabelOfCell(2);
    [companyLabel setText:name];
    
    [_jobListArray removeAllObjects];// 重新选择公司，则清空上一个公司的入职奖金职位数组
    [_paramsDic setValue:@"" forKey:@"jid"];// 重新选择公司，清空已经选择的奖金职位信息
    [_paramsDic setValue:@"" forKey:@"fee"];
    [_paramsDic setValue:@"" forKey:@"bouns"];
    [_paramsDic setValue:@"" forKey:@"salary"];
    [_paramsDic setValue:@"" forKey:@"seniorPercent"];
    UILabel *jobLabel = LabelOfCell(3);
    [jobLabel setText:@""];
    UILabel *salaryLabel = LabelOfCell(4);
    [salaryLabel setText:@""];
    
    [self requeBounsJobListWithPid:pid companyName:name];
    
}

#pragma mark - BounsJobListDelegate
- (void)didSelectBounsJob:(NSDictionary *)jobDic{

    NSLog(@"jobDic = %@",jobDic);
    [_paramsDic setValue:[NSString stringWithFormat:@"%@",jobDic[@"jid"]] forKey:@"jid"];
    [_paramsDic setValue:[NSString stringWithFormat:@"%@",jobDic[@"fee"]] forKey:@"fee"];
    [_paramsDic setValue:[NSString stringWithFormat:@"%@",jobDic[@"bouns"]] forKey:@"bouns"];
    [_paramsDic setValue:[NSString stringWithFormat:@"%@",jobDic[@"salary"]] forKey:@"salary"];
    [_paramsDic setValue:[NSString stringWithFormat:@"%@",jobDic[@"seniorPercent"]] forKey:@"seniorPercent"];
    UILabel *jobLabel = LabelOfCell(3);
    [jobLabel setText:[NSString stringWithFormat:@"%@",jobDic[@"jobName"]]];
    UILabel *salaryLabel = LabelOfCell(4);
    [salaryLabel setText:[NSString stringWithFormat:@"%@",jobDic[@"salary"]]];
    
}

#pragma mark - IQActionSheetPickerViewDelegate

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date{
    NSString *dateStr = [XZLUtil changeDateToString:date withFormatter:@"yyyy年MM月dd日"];
    UILabel *dateLabel = LabelOfCell(5);
    [dateLabel setText:dateStr];
}

- (void)actionSheetPickerViewDidCancel:(IQActionSheetPickerView *)pickerView{
     NSLog(@"cancel");
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    UILabel *ttlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [ttlLabel setText:_titleArray[indexPath.row]];
    [ttlLabel setTextColor:[UIColor darkGrayColor]];
    [ttlLabel setFont:[UIFont systemFontOfSize:15]];
    [ttlLabel setTextAlignment:NSTextAlignmentCenter];
    [cell addSubview:ttlLabel];
    if (row == 0) {// 申请人
        
        UITextField *valueTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 300-90-7, 30)];
        [valueTF setPlaceholder:@"请输入申请人姓名"];
        [valueTF setTextAlignment:NSTextAlignmentRight];
        [valueTF setTextColor:[UIColor grayColor]];
        [valueTF setBackgroundColor:XZHILBJ_colour];
        [valueTF setFont:[UIFont systemFontOfSize:15]];
        [valueTF.layer setCornerRadius:4];
        valueTF.tag = TFTag;
        [cell addSubview:valueTF];
        
    }else if (row == 1){// 公司城市
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 300-90-30, 44)];
        label.tag = LabelTag;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setText:[NSString stringWithFormat:@"%@",_paramsDic[@"cityName"]?_paramsDic[@"cityName"]:@""]];
        [cell addSubview:label];
    
    }else if (row == 2){// 公司名称
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 300-90-30, 44)];
        label.tag = LabelTag;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:label];
    
    }else if (row == 3){// 奖金职位
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 300-90-30, 44)];
        label.tag = LabelTag;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:label];
    
    }else if (row == 4){// 职位薪资
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 300-90-30, 44)];
        label.tag = LabelTag;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:label];
        
    }else if (row == 5){// 入职时间
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 300-90-30, 44)];
        label.tag = LabelTag;
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:label];
        
    }else if (row == 6){// 入职薪资
        
        UITextField *valueTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 300-90-7, 30)];
        [valueTF setPlaceholder:@"请输入准确的入职薪资"];
        [valueTF setTextAlignment:NSTextAlignmentRight];
        [valueTF setTextColor:[UIColor grayColor]];
        [valueTF setBackgroundColor:XZHILBJ_colour];
        [valueTF setFont:[UIFont systemFontOfSize:15]];
        [valueTF.layer setCornerRadius:4];
        valueTF.tag = TFTag;
        valueTF.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:valueTF];
        
    }else if (row == 7){// 联系方式
        
        UITextField *valueTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 300-90-7, 30)];
        [valueTF setPlaceholder:@"请输入联系方式"];
        [valueTF setTextAlignment:NSTextAlignmentRight];
        [valueTF setTextColor:[UIColor grayColor]];
        [valueTF setBackgroundColor:XZHILBJ_colour];
        [valueTF setFont:[UIFont systemFontOfSize:15]];
        [valueTF.layer setCornerRadius:4];
        valueTF.tag = TFTag;
        valueTF.text = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"user_tel"]];
        valueTF.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:valueTF];
    
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, 300, 0.5)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:lineView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    int row = indexPath.row;
    if (row == 0) {
        // 申请人
    }else if (row == 1){// 公司城市
    
        HRSelectCityViewController *vc = [[HRSelectCityViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (row == 2){// 公司名称
        NSString *cityCode = _paramsDic[@"cityCode"]?_paramsDic[@"cityCode"]:@"";
        if (cityCode.length == 0) {
            _ghost.message = @"请先选择公司城市";
            [_ghost show];
            return;
        }
        SelectCompanyViewController *vc = [[SelectCompanyViewController alloc] init];
        vc.delegate = self;
        vc.cityCode = cityCode;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (row == 3){// 奖金职位
        if([_jobListArray count] == 0){
            _ghost.message = @"该公司暂无入职奖金职位";
            [_ghost show];
            return;
        }
        BounsJobListViewController *vc = [[BounsJobListViewController alloc] init];
        vc.jobList = _jobListArray;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (row == 4){// 职位薪资
        
        
    }else if (row == 5){// 入职时间
        
        IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:nil delegate:self];
        picker.actionSheetPickerStyle = IQActionSheetPickerStyleDatePicker;
        picker.minimumDate = [XZLUtil addToStartDate:[NSDate date] withYear:0 month:0 day:-20 hour:0 minute:0 second:0];
        picker.maximumDate = [XZLUtil addToStartDate:[NSDate date] withYear:0 month:0 day:30 hour:0 minute:0 second:0];
        UILabel *dateLabel = LabelOfCell(5);
        if (dateLabel.text.length > 0) {
            NSDate *oldDate = [XZLUtil changeStringToDate:dateLabel.text withFormatter:@"yyyy年MM月dd日"];
            picker.date = oldDate;
        }
        [picker show];
        
    }else if (row == 6){// 入职薪资
        
    }else if (row == 7){// 联系方式
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
