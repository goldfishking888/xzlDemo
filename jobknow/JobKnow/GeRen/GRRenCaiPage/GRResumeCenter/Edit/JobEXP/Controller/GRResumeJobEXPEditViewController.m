//
//  GRResumeJobEXPEditViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeJobEXPEditViewController.h"
#import "GRReadModel.h"
#import "GRResumeJobEXPEditIntroTableViewCell.h"

#import "XZLPickerTool.h"//年月选择器

@interface GRResumeJobEXPEditViewController ()

@property (nonatomic,strong) UIView *footerView;
@end

@implementation GRResumeJobEXPEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"编辑工作经验"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
}

-(void)initData{
    _arrat_title_0 = @[@"公司名称",@"职位名称",@"开始时间",@"结束时间",@"公司性质",@"公司行业"
                       ,@"公司规模"
                       ,@"月        薪",@"工作内容"];
    if(!_model){
        _model = [WorkEXPModel new];

    }else{
        isHasDeleteBtn = YES;
    }
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

-(void)initTableView{
    
    
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight  - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//    view.backgroundColor = [UIColor whiteColor];
//    _tableView.tableHeaderView = view;
    if (isHasDeleteBtn) {
        _tableView.tableFooterView = self.footerView;
    }
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

-(UIView *)footerView{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44+30*2)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *label_title = [[UIButton alloc] initWithFrame:CGRectMake(21, 30, kMainScreenWidth-21*2, 44)];
        mViewBorderRadius(label_title, 22, 1, RGB(216, 216, 216));
        [label_title.titleLabel setFont:[UIFont systemFontOfSize:16]] ;
        [label_title setTitleColor:RGB(255, 146, 4) forState:UIControlStateNormal];
        [label_title setTitleColor:RGB(216, 216, 216) forState:UIControlStateHighlighted];
        [label_title setTitle:@"删除此工作经验" forState:UIControlStateNormal];
        [label_title addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:label_title];
    }
    return  _footerView;
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if([NSString isNullOrEmpty:_model.company]){
        ghostView.message = @"请输入公司名称";
        [ghostView show];
        return;
    }else{
        if (_model.company.length>30) {
            ghostView.message = @"公司名称30个字符以内";
            [ghostView show];
            return;
        }
    }
    if([NSString isNullOrEmpty:_model.position]){
        ghostView.message = @"请输入职位名称";
        [ghostView show];
        return;
    }else{
        if (_model.position.length>10) {
            ghostView.message = @"职位名称10个字符以内";
            [ghostView show];
            return;
        }
    }
    if([NSString isNullOrEmpty:_model.date_start]){
        ghostView.message = @"请选择开始时间";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.date_end]){
        ghostView.message = @"请选择结束时间";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.company_nature]){
        ghostView.message = @"请选择公司性质";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.industry]){
        ghostView.message = @"请选择公司行业";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.company_scale]){
        ghostView.message = @"请选择公司规模";
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
    [paramDic setValue:_model.resumeId.length>0?_model.resumeId:_resume_id forKey:@"rid"];
    [paramDic setValue:_model.workEXP_Id forKey:@"id"];
    [paramDic setValue:@"resume_work" forKey:@"table"];
    
    NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
    [workDic setValue:_model.resumeId.length>0?_model.resumeId:_resume_id forKey:@"rid"];
    [workDic setValue:_model.company forKey:@"company"];
    [workDic setValue:_model.industry forKey:@"trade"];
    [workDic setValue:_model.industry_code forKey:@"trade_code"];
    [workDic setValue:_model.position forKey:@"job"];
    [workDic setValue:_model.position_code forKey:@"job_code"];
    [workDic setValue:_model.company_nature forKey:@"type"];
    [workDic setValue:_model.company_scale forKey:@"size"];
    [workDic setValue:_model.salary forKey:@"salary"];
    [workDic setValue:_model.salary_code forKey:@"salary_code"];
    [workDic setValue:_model.date_start forKey:@"start_at"];
    [workDic setValue:_model.date_end forKey:@"end_at"];
    [workDic setValue:_model.work_intro forKey:@"describe"];
    
    [paramDic setValue:[workDic toJSONString] forKey:@"data"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/update/resume_work"];
    if ([_model.workEXP_Id isNullOrEmpty]) {
        url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/add/resume_work"];
    }
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

#pragma mark- 删除此条工作内容
-(void)clickFooter:(UIButton *)btn{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.resumeId forKey:@"rid"];
    [paramDic setValue:_model.workEXP_Id forKey:@"id"];
    [paramDic setValue:@"resume_work" forKey:@"table"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/delete/resume_work"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                ghostView.message = @"操作成功";
                [ghostView show];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"操作失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"操作失败";
        [ghostView show];
    }];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
                //公司名称
                [cell setTextFieldValue:_model.company DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //职位名称
                [cell setTextFieldValue:_model.position DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 2:
            {
                //开始时间
                [cell setLabelValue:_model.date_start DefaultValue:@"请选择"];
            }
                break;
            case 3:
            {
                //结束时间
                [cell setLabelValue:_model.date_end DefaultValue:@"请选择"];
            }
                break;
            case 4:
            {
                //性质
                [cell setLabelValue:_model.company_nature DefaultValue:@"请选择"];
            }
                break;
            case 5:
            {
                //行业
                [cell setLabelValue:_model.industry DefaultValue:@"请选择"];
            }
                break;
            case 6:
            {
                //规模
                [cell setLabelValue:_model.company_scale DefaultValue:@"请选择"];
            }
                break;
            case 7:
            {
                //月薪
                [cell setLabelValue:_model.salary DefaultValue:@"请选择"];
            }
                break;
            case 8:
            {
                //性质
                
                GRResumeJobEXPEditIntroTableViewCell *cell7 = [[GRResumeJobEXPEditIntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ss"];
                cell7.backgroundColor = [UIColor whiteColor];
                cell7.accessoryType=UITableViewCellAccessoryNone;
                cell7.selectionStyle = UITableViewCellSelectionStyleNone;
                cell7.delegate = self;
                cell7.indexPath = indexPath;
                cell7.maxCount = 500;
                [cell7 setTitleValue:_arrat_title_0[indexPath.row]];
                [cell7 setContent:_model.work_intro placeHolder:@"请逐条写明您的工作内容。最少10字，最多500字。"];
                return cell7;
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.row == 8) {
        return 218;
    }
    return 56;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
//    viewH.backgroundColor = [UIColor whiteColor];
//    return viewH;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 44+20;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44+20)];
//    viewH.backgroundColor = [UIColor whiteColor];
//    
//    UIButton *label_title = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 16)];
//    [label_title.titleLabel setFont:[UIFont systemFontOfSize:16]] ;
//    [label_title setTitleColor:RGB(255, 146, 4) forState:UIControlStateNormal];
//    [label_title setTitleColor:RGB(216, 216, 216) forState:UIControlStateHighlighted];
//    label_title.tag = section;
//    [label_title setTitle:@"删除此工作经验" forState:UIControlStateNormal];
//    [label_title addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
//    [viewH addSubview:label_title];
//    
//    return viewH;
//    
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    GRReadModel *model = [[GRReadModel alloc] init];
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            
            case 2:
            {
                [self selectDate:_model.date_start withTillNow:NO IndexPath:indexPath];
            }
                break;
            case 3:
            {
                [self selectDate:_model.date_end withTillNow:YES IndexPath:indexPath];
            }
                break;
            case 4:
            {
                model.name = _model.company_nature;
                model.code = _model.company_nature_code;
                [self selectCorpNature:indexPath Model:model];
            }
                break;
            case 5:
            {
                model.name = _model.industry;
                model.code = _model.industry_code;
                if (!model.code) {
                    if (model.name) {
                        model.code = [XZLUtil getindustryCodeWithindustry:model.name];
                    }
                }
                [self multiSelectIndustry:indexPath Model:model];
            }
                break;
            case 6:
            {
                model.name = _model.industry;
                model.code = _model.industry_code;
                [self selectCorpScale:indexPath Model:model];
            }
                break;
            case 7:
            {
                model.name = _model.salary;
                model.code = _model.salary_code;
                [self selectSalary:indexPath Model:model];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark- GRResumeEditTableViewCellDelegate cell输入文字后代理
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _model.company = stringValue;
    }else if (indexPath.row == 1){
        _model.position = stringValue;
    }
}

#pragma mark- 选择日期

-(void)selectDate:(NSString *)dateSelected withTillNow:(BOOL)withTillNow IndexPath:(NSIndexPath *)indexPath{
    NSString *string = @"";
    if (withTillNow) {
        string = _model.date_end;
    }else{
        string = _model.date_start;
    }
    [XZLPickerTool showYearAndMonthWithIsEnd:withTillNow dateStringSelected:string didSelectBlock:^(NSString *strValue) {
        if (withTillNow) {
            _model.date_end = strValue;
        }else{
            _model.date_start = strValue;
        }
        [_tableView reloadData];
    }];
}

#pragma mark- 选择行业
-(void)multiSelectIndustry:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRMultiSelectViewController *edu = [[GRMultiSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = MultiSelectENUMIndustry;
    edu.titleString = @"公司行业";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 公司规模
-(void)selectCorpScale:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMCorpScale;
    edu.titleString = @"公司规模";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 选择月薪
-(void)selectSalary:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMSalary;
    edu.titleString = @"月  薪";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark- 公司性质
-(void)selectCorpNature:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMCorpNature;
    edu.titleString = @"公司性质";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理

- (void)onSelectCorpScaleWithModel:(GRReadModel *)model_selected{
    _model.company_scale = model_selected.name;
    _model.company_scale_code = model_selected.code;
    [_tableView reloadData];
}

- (void)onSelectCorpNatureWithModel:(GRReadModel *)model_selected{
    _model.company_nature = model_selected.name;
    _model.company_nature_code = model_selected.code;
    [_tableView reloadData];
}

- (void)onSelectSalaryWithModel:(GRReadModel *)model_selected{
    _model.salary = model_selected.name;
    _model.salary_code = model_selected.code;
    [_tableView reloadData];
}

#pragma mark - GRMultiSelectViewControllerDelegate多选选择VC代理
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
    _model.industry = str_name;
    _model.industry_code = str_code;
    [_tableView reloadData];
}

#pragma mark -GRResumeJobEXPEditIntroTableViewCellDelegate
- (void)contentDidChangeTo:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    _model.work_intro = stringValue;
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
