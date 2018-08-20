//
//  GRResumeEduEXPEditViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeEduEXPEditViewController.h"
#import "GRReadModel.h"
#import "GRResumeJobEXPEditIntroTableViewCell.h"

#import "XZLPickerTool.h"//年月选择器

@interface GRResumeEduEXPEditViewController ()

@property (nonatomic,strong) UIView *footerView;

@end

@implementation GRResumeEduEXPEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"编辑教育经历"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
}

-(void)initData{
    _arrat_title_0 = @[@"学校名称",@"专  业",@"开始时间",@"结束时间",@"学  历"];
    if(!_model){
        _model = [EduEXPModel new];
        
    }else{
        isHasDeleteBtn = YES;
    }
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

-(void)initTableView{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight  - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = self.footerView;
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
        [label_title setTitle:@"删除此教育经历" forState:UIControlStateNormal];
        [label_title addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:label_title];
    }
    return  _footerView;
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if([NSString isNullOrEmpty:_model.university]){
        ghostView.message = @"请输入学校名称";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.major]){
        ghostView.message = @"请输入专业";
        [ghostView show];
        return;
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
    if([NSString isNullOrEmpty:_model.degree]){
        ghostView.message = @"请选择学历";
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
    [paramDic setValue:_model.EDUExp_Id forKey:@"id"];
    [paramDic setValue:@"resume_education" forKey:@"table"];
    
    NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
    [workDic setValue:_model.resumeId.length>0?_model.resumeId:_resume_id forKey:@"rid"];
    [workDic setValue:_model.university forKey:@"school"];
    [workDic setValue:_model.major forKey:@"major"];
    [workDic setValue:_model.major_code forKey:@"major_code"];
    [workDic setValue:_model.degree forKey:@"degree"];
    [workDic setValue:_model.degree_code forKey:@"degree_code"];
    [workDic setValue:_model.date_start forKey:@"start_at"];
    [workDic setValue:_model.date_end forKey:@"end_at"];
    
    [paramDic setValue:[workDic toJSONString] forKey:@"data"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/update/resume_education"];
    if ([_model.EDUExp_Id isNullOrEmpty]) {
        url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/add/resume_education"];
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

#pragma mark- 删除此条教育经历
-(void)clickFooter:(UIButton *)btn{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.resumeId forKey:@"rid"];
    [paramDic setValue:_model.EDUExp_Id forKey:@"id"];
    [paramDic setValue:@"resume_education" forKey:@"table"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/delete/resume_education"];
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
                //学校名称
                [cell setTextFieldValue:_model.university DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //专业
                [cell setTextFieldValue:_model.major DefaultValue:@"请输入"];
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
                //学历
                [cell setLabelValue:_model.degree DefaultValue:@"请选择"];
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.row == 7) {
        return 218;
    }
    return 56;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

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
                model.name = _model.degree;
                model.code = _model.degree_code;
                [self selectDegree:indexPath Model:model];
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
        _model.university = stringValue;
    }else if (indexPath.row == 1){
        _model.major = stringValue;
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

#pragma mark- 选择学历
-(void)selectDegree:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMEduQualification;
    edu.titleString = @"选择学历";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理

- (void)onSelectEduQualificationWithModel:(GRReadModel *)model_selected{
    _model.degree = model_selected.name;
    _model.degree_code = model_selected.code;
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
