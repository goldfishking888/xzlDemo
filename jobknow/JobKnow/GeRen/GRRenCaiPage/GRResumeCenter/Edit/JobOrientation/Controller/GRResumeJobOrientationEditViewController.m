//
//  GRResumeJobOrientationEditViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeJobOrientationEditViewController.h"
#import "GRResumeEditTableViewCell.h"

#import "GRReadModel.h"
#import "GRSingleSelectViewController.h"

@interface GRResumeJobOrientationEditViewController ()

@end

@implementation GRResumeJobOrientationEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"职业意向"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
    [_tableView reloadData];
    // Do any additional setup after loading the view.
}

-(void)initData{
    _arrat_title_0 = @[@"期望职业",@"期望行业",@"期望工作地点",@"期望月薪",@"目前状态"];
    if(!_model){
        _model = [JobOrientationModel new];
        _model.expect_job = @"";
        _model.expect_job_code = @"";
        _model.expect_industry = @"";
        _model.expect_industry_code = @"";
        _model.expect_city = @"";
        _model.expect_city_code = @"";
        _model.expect_salary = @"";
        _model.expect_salary_code = @"";
        _model.status = @"";
        _model.status_code = @"";
    }
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

-(void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight  - 64) style:UITableViewStyleGrouped];
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
    
    if([NSString isNullOrEmpty:_model.expect_job]){
        ghostView.message = @"请选择期望职业";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.expect_industry]){
        ghostView.message = @"请选择期望行业";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.expect_city]){
        ghostView.message = @"请选择期望工作地点";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.expect_salary]){
        ghostView.message = @"请选择期望月薪";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.status]){
        ghostView.message = @"请选择目前状态";
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

    [paramDic setValue:_model.expect_city forKey:@"hope_area"];
    [paramDic setValue:_model.expect_city_code forKey:@"hope_area_code"];
    [paramDic setValue:_model.expect_job forKey:@"hope_job"];
    [paramDic setValue:_model.expect_job_code forKey:@"hope_job_code"];
    [paramDic setValue:_model.expect_industry forKey:@"hope_trade"];
    [paramDic setValue:_model.expect_industry_code forKey:@"hope_trade_code"];
    [paramDic setValue:_model.expect_salary forKey:@"hope_salary"];
    [paramDic setValue:_model.expect_salary_code forKey:@"hope_salary_code"];
    [paramDic setValue:_model.status_code forKey:@"now_status"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/job_intention/update"];
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
        return _arrat_title_0.count;//测试
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    GRResumeEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        cell = [[GRResumeEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell setTitleValue:_arrat_title_0[indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                //期望职业
                [cell setLabelValue:_model.expect_job DefaultValue:@"请选择"];
            }
                break;
            case 1:
            {
                //期望行业
                [cell setLabelValue:_model.expect_industry DefaultValue:@"请选择"];
            }
                break;
            case 2:
            {
                //期望城市
                [cell setLabelValue:_model.expect_city DefaultValue:@"请选择"];
            }
                break;
            case 3:
            {
                //期望薪资
                [cell setLabelValue:_model.expect_salary DefaultValue:@"请选择"];
            }
                break;
            case 4:
            {
                //目前状况
                [cell setLabelValue:_model.status DefaultValue:@"请选择"];
            }
                break;
                
            default:
                break;
        }
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
            case 0:
            {
                model.name = _model.expect_job;
                model.code = _model.expect_job_code;
                [self multiSelectPosition:indexPath Model:model];
            }
                break;
            case 1:
            {
                model.name = _model.expect_industry;
                model.code = _model.expect_industry_code;
                [self multiSelectIndustry:indexPath Model:model];
            }
                break;
            case 2:
            {
                [self selectCity];
            }
                break;
            case 3:
            {
                model.name = _model.expect_salary;
                model.code = _model.expect_salary_code;
                [self selectSalary:indexPath Model:model];
            }
                break;
            case 4:
            {
                model.name = _model.status;
                model.code = _model.status_code;
                [self selectNowStatus:indexPath Model:model];
            }
                break;
                       default:
                break;
        }
    }
}

#pragma mark- 选择职业
-(void)multiSelectPosition:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRMultiSelectViewController *edu = [[GRMultiSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = MultiSelectENUMPosition;
    edu.titleString = @"期望职业";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择行业
-(void)multiSelectIndustry:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRMultiSelectViewController *edu = [[GRMultiSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = MultiSelectENUMIndustry;
    edu.titleString = @"期望行业";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择城市
-(void)selectCity{
    allCityViewController *allCityVC=[[allCityViewController alloc]init];
    allCityVC.delegate=self;
    allCityVC.city_selected = _model.expect_city;
    allCityVC.isMultiSelect = YES;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName{
    _model.expect_city = cityName;
    _model.expect_city_code = cityCode;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark- 选择月薪
-(void)selectSalary:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMSalary;
    edu.titleString = @"期望月薪";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择职位
-(void)selectPosition:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMPosition;
    edu.titleString = @"期望职业";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择状态
-(void)selectNowStatus:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMNowStatus;
    edu.titleString = @"目前状态";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理

- (void)onSelectSalaryWithModel:(GRReadModel *)model_selected{
    _model.expect_salary = model_selected.name;
    _model.expect_salary_code = model_selected.code;
    [_tableView reloadData];
}

- (void)onSelectNowStatusWithModel:(GRReadModel *)model_selected{
    _model.status = model_selected.name;
    _model.status_code = model_selected.code;
    [_tableView reloadData];
}

#pragma mark - GRMultiSelectViewControllerDelegate多选选择VC代理
-(void)onMultiSelectPositionWithArray:(NSMutableArray *)array_selected{
    NSString *str_name = @"";
    NSString *str_code = @"";
    for (GRReadModel *model in array_selected) {
        str_name = [str_name stringByAppendingString:[NSString stringWithFormat:@"%@,",model.name]];
        str_code = [str_code stringByAppendingString:[NSString stringWithFormat:@"%@,",model.code]];
        
    }
    if (str_name.length>0) {
        str_name = [str_name substringToIndex:str_name.length-1];
    }if (str_code.length>0) {
        str_code = [str_code substringToIndex:str_code.length-1];
    }
    _model.expect_job = str_name;
    _model.expect_job_code = str_code;
    [_tableView reloadData];
}

-(void)onMultiSelectIndustryWithArray:(NSMutableArray *)array_selected{
    NSString *str_name = @"";
    NSString *str_code = @"";
    for (GRReadModel *model in array_selected) {
        str_name = [str_name stringByAppendingString:[NSString stringWithFormat:@"%@,",model.name]];
        str_code = [str_code stringByAppendingString:[NSString stringWithFormat:@"%@,",model.code]];
    }
    if (str_name.length>0) {
        str_name = [str_name substringToIndex:str_name.length-1];
    }if (str_code.length>0) {
        str_code = [str_code substringToIndex:str_code.length-1];
    }
    
    
    _model.expect_industry = str_name;
    _model.expect_industry_code = str_code;
    [_tableView reloadData];
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
