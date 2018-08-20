//
//  GRResumeBasicInfoViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRResumeBasicInfoViewController.h"

#import "GRResumeEditTableViewCell.h"

#import "GRReadModel.h"
#import "GRSingleSelectViewController.h"

@interface GRResumeBasicInfoViewController ()

@end

@implementation GRResumeBasicInfoViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"基本信息"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
    [_tableView reloadData];
    // Do any additional setup after loading the view.
}

-(void)initData{
    _arrat_title_0 = @[@"姓  名",@"性  别",@"出生日期",@"现居住地",@"婚姻状况",@"户  口",@"学  历",@"政治面貌",@"工作性质",@"工作年限"];
    _arrat_title_1 = @[@"联系电话",@"联系邮箱",@"身份证号码"];
    if(!_model){
        _model = [PersonBasicInfoModel new];
    }
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

-(void)initTableView{
    
    _tableView = [[TPKeyboardAvoidingTableView  alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight  - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = RGB(242, 242, 242);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if([NSString isNullOrEmpty:_model.name]){
        ghostView.message = @"请输入姓名";
        [ghostView show];
        return;
    }else{
        if (_model.name.length>5) {
            ghostView.message = @"姓名五个字符以内";
            [ghostView show];
            return;
        }
    }
    if([NSString isNullOrEmpty:_model.gender]){
        ghostView.message = @"请选择性别";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.birthday]){
        ghostView.message = @"请输入出生日期";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.city]){
        ghostView.message = @"请选择现居住地";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.marriage]){
        ghostView.message = @"请选择婚姻状况";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.qulification]){
        ghostView.message = @"请选择学历";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.workYears]){
        ghostView.message = @"请选择工作年限";
        [ghostView show];
        return;
    }
//    if([NSString isNullOrEmpty:_model.tel]){
//        ghostView.message = @"请输入联系电话";
//        [ghostView show];
//        return;
//    }
    if([NSString isNullOrEmpty:_model.email]){
        ghostView.message = @"请输入联系邮箱";
        [ghostView show];
        return;
    }
    
    [self saveingRequest];
}

#pragma mark- 保存修改网络请求
-(void)saveingRequest{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.resumeId forKey:@"id"];
    [paramDic setValue:_model.name forKey:@"name"];
    [paramDic setValue:_model.genderCode forKey:@"sex"];
    [paramDic setValue:_model.birthday forKey:@"birthday"];
    [paramDic setValue:_model.age forKey:@"age"];
    [paramDic setValue:_model.city forKey:@"now_city"];
    [paramDic setValue:_model.cityCode forKey:@"now_city_code"];
    [paramDic setValue:_model.marriageCode forKey:@"marriage"];
    [paramDic setValue:_model.household forKey:@"household"];
    [paramDic setValue:_model.household_code forKey:@"household_code"];
    [paramDic setValue:_model.qulification forKey:@"degree"];
    [paramDic setValue:_model.qulificationCode forKey:@"cdegree_code"];
    [paramDic setValue:_model.political forKey:@"political"];
    [paramDic setValue:_model.workNatureCode forKey:@"work_nature"];
    [paramDic setValue:_model.workYearsCode forKey:@"work_years"];

    [paramDic setValue:_model.email forKey:@"email"];
    [paramDic setValue:_model.IDNum forKey:@"idcard"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/base/update"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                ghostView.message = @"保存成功";
                [ghostView show];
                [self performSelector:@selector(popView) withObject:nil afterDelay:1];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"保存失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"保存失败";
        [ghostView show];
    }];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 10;//测试
    }else if (section == 1){
        return 3;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    GRResumeEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
//    if (!cell) {
        cell = [[GRResumeEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell setTitleValue:_arrat_title_0[indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                //姓名
                [cell setTextFieldValue:_model.name DefaultValue:@"请填写"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //性别
                [cell setLabelValue:_model.gender DefaultValue:@"请选择"];
            }
                break;
            case 2:
            {
                //出生日期
                [cell setLabelValue:_model.birthday DefaultValue:@"请选择"];
            }
                break;
            case 3:
            {
                //现居住地
                [cell setLabelValue:_model.city DefaultValue:@"请选择"];
            }
                break;
            case 4:
            {
                //婚姻状况
                [cell setLabelValue:_model.marriage DefaultValue:@"请选择"];
            }
                break;
            case 5:
            {
                //户口
                [cell setLabelValue:_model.household DefaultValue:@"请选择"];
            }
                break;
            case 6:
            {
                //学历
                [cell setLabelValue:_model.qulification DefaultValue:@"请选择"];
            }
                break;
            case 7:
            {
                [cell setTextFieldValue:_model.political DefaultValue:@"请填写"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 8:
            {
                [cell setLabelValue:_model.workNature DefaultValue:@"请选择"];
                
            }
                break;
            case 9:
            {
                [cell setLabelValue:_model.workYears DefaultValue:@"请选择"];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        [cell setTitleValue:_arrat_title_1[indexPath.row]];
        switch (indexPath.row) {
            case 0:
                [cell setLabelValue:_model.tel DefaultValue:@""];
                break;
            case 1:
                [cell setTextFieldValue:_model.email DefaultValue:@"请填写"];
                break;
            case 2:
                [cell setTextFieldValue:_model.IDNum DefaultValue:@"请填写"];
                break;
                
            default:
                break;
        }
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    return 56;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
//    viewH.backgroundColor = [UIColor whiteColor];
//    return viewH;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    _indexPath_current = indexPath;
    GRReadModel *model = [[GRReadModel alloc] init];
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 1:
            {
                model.name = _model.gender;
                model.code = _model.genderCode;
                [self selectGender:indexPath Model:model];
            }
                break;
            case 2:
            {
                [self selectDate];
            }
                break;
            case 3:
            {
                [self selectCity];
            }
                break;
            case 4:
            {
                model.name = _model.marriage;
                model.code = _model.marriageCode;
                [self selectMarriage:indexPath Model:model];
            }
                break;
            case 5:
            {
                [self selectCity];
            }
                break;
            case 6:
            {
                model.name = _model.qulification;
                model.code = _model.qulificationCode;
                [self selectQualification:indexPath Model:model];
            }
                break;
            case 8:
            {
                model.name = _model.workNature;
                model.code = _model.workNatureCode;
                [self selectWorkNature:indexPath Model:model];
            }
                break;
            case 9:
            {
                model.name = _model.workYears;
                model.code = _model.workYearsCode;
                [self selectWorkYears:indexPath Model:model];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark- 选择日期
- (void)selectDate
{
    _datePicker = [[KTSelectDatePicker alloc] initWithMaxDate:[NSDate date] minDate:[XZLUtil changeStrToDate:@"1970-01-01"] currentDate:[XZLUtil changeStrToDate:_model.birthday?_model.birthday:@"1990-01-01"] datePickerMode:UIDatePickerModeDate];
    __weak typeof(self) weakSelf = self;
    [_datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _model.birthday = [weakSelf changeDateToStr:selectedDate];
        NSString *age = [NSString stringWithFormat:@"%ld",(long)[self ageWithDateOfBirth:selectedDate]];
        _model.age = age;
        [_tableView reloadData];
    }];
}

- (NSString *)changeDateToStr:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStrf = [formatter stringFromDate:date];
    return dateStrf;
}

- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

#pragma mark- 选择城市
-(void)selectCity{
    allCityViewController *allCityVC=[[allCityViewController alloc]init];
    allCityVC.delegate=self;
    if (_indexPath_current.row ==3) {
        allCityVC.city_selected = _model.city;
    }else if (_indexPath_current.row ==5) {
        allCityVC.city_selected = _model.household;
    }
//    allCityVC.isMultiSelect = YES;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName{
    if (_indexPath_current.row ==3) {
        _model.city = cityName;
        _model.cityCode = cityCode;
    }else if (_indexPath_current.row ==5) {
        _model.household = cityName;
        _model.household_code = cityCode;
    }
    
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark- 选择性别
-(void)selectGender:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMGender;
    edu.titleString = @"选择性别";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择婚姻状况
-(void)selectMarriage:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMMarriage;
    edu.titleString = @"婚姻状况";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择学历
-(void)selectQualification:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMEduQualification;
    edu.titleString = @"选择学历";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择工作性质
-(void)selectWorkNature:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMWorkCrop;
    edu.titleString = @"工作性质";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择工作年限
-(void)selectWorkYears:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMWorkYears;
    edu.titleString = @"工作年限";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理
-(void)onSelectEduQualificationWithModel:(GRReadModel *)model_selected{
    _model.qulification = model_selected.name;
    _model.qulificationCode = model_selected.code;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)onSelectWorkYearsWithModel:(GRReadModel *)model_selected{
    _model.workYears = model_selected.name;
    _model.workYearsCode = model_selected.code;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)onSelectWorkCropWithModel:(GRReadModel *)model_selected{
    _model.workNature = model_selected.name;
    _model.workNatureCode = model_selected.code;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)onSelectMarriageWithModel:(GRReadModel *)model_selected{
    _model.marriage = model_selected.name;
    _model.marriageCode = model_selected.code;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)onSelectGenderWithModel:(GRReadModel *)model_selected{
    _model.gender = model_selected.name;
    _model.genderCode = model_selected.code;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - GRResumeEditTableViewCellDelegate cell的输入框代理
-(void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            _model.name = stringValue;
        }else if (indexPath.row == 7){
            _model.political = stringValue;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            _model.tel = stringValue;
        }else if (indexPath.row == 1){
            _model.email = stringValue;
        }else if (indexPath.row == 2){
            _model.IDNum = stringValue;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
