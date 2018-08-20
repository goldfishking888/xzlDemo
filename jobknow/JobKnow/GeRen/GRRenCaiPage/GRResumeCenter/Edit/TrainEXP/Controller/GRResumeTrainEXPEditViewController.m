//
//  GRResumeTrainEXPEditViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeTrainEXPEditViewController.h"
#import "GRReadModel.h"
#import "GRResumeJobEXPEditIntroTableViewCell.h"

#import "XZLPickerTool.h"//年月选择器

@interface GRResumeTrainEXPEditViewController ()

@property (nonatomic,strong) UIView *footerView;

@end

@implementation GRResumeTrainEXPEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"编辑培训经历"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
}

-(void)initData{
    _arrat_title_0 = @[@"培训机构",@"培训地点",@"开始时间",@"结束时间",@"培训证书",@"培训内容"];
    if(!_model){
        _model = [TrainEXPModel new];
        
    }else{
        isHasDeleteBtn = YES;
    }
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
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
        [label_title setTitle:@"删除此培训经历" forState:UIControlStateNormal];
        [label_title addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:label_title];
    }
    return  _footerView;
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if([NSString isNullOrEmpty:_model.train_name]){
        ghostView.message = @"请输入培训机构";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.train_city]){
        ghostView.message = @"请输入培训地点";
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
    if([NSString isNullOrEmpty:_model.train_cer]){
        ghostView.message = @"请输入培训证书";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.train_intro]){
        ghostView.message = @"请输入培训内容";
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
    [paramDic setValue:_model.train_id forKey:@"id"];
    [paramDic setValue:@"resume_train" forKey:@"table"];
    
    NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
    [workDic setValue:_model.resumeId.length>0?_model.resumeId:_resume_id forKey:@"rid"];
    [workDic setValue:_model.train_cer forKey:@"certificate"];
    [workDic setValue:_model.date_start forKey:@"start_at"];
    [workDic setValue:_model.date_end forKey:@"end_at"];
    [workDic setValue:_model.train_city forKey:@"addr"];
    [workDic setValue:_model.train_name forKey:@"institute"];
    [workDic setValue:_model.train_intro forKey:@"describe"];
    
    [paramDic setValue:[workDic toJSONString] forKey:@"data"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/update/resume_train"];
    if ([_model.train_id isNullOrEmpty]) {
        url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/add/resume_train"];
    }
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                ghostView.message = @"保存成功";
                [ghostView show];
                [self performSelector:@selector(popView) withObject:nil afterDelay:1];
                return ;
            }
        }
        
        NSLog(@"register_do %@",@"fail");
        ghostView.message = @"保存失败";
        [ghostView show];
    } failure:^(NSError *error) {
        ghostView.message = @"保存失败";
        [ghostView show];
    }];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 删除此条培训经历
-(void)clickFooter:(UIButton *)btn{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.resumeId forKey:@"rid"];
    [paramDic setValue:_model.train_id forKey:@"id"];
    [paramDic setValue:@"resume_train" forKey:@"table"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/delete/resume_train"];
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
                //培训机构
                [cell setTextFieldValue:_model.train_name DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //培训地点
                [cell setTextFieldValue:_model.train_city DefaultValue:@"请输入"];
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
                //培训证书
                [cell setTextFieldValue:_model.train_cer DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            
            case 5:
            {
                //性质
                
                GRResumeJobEXPEditIntroTableViewCell *cell7 = [[GRResumeJobEXPEditIntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ss"];
                cell7.backgroundColor = [UIColor whiteColor];
                cell7.accessoryType=UITableViewCellAccessoryNone;
                cell7.selectionStyle = UITableViewCellSelectionStyleNone;
                cell7.delegate = self;
                cell7.indexPath = indexPath;
                cell7.hasNOCountLimit = YES;
                [cell7 setTitleValue:_arrat_title_0[indexPath.row]];
                [cell7 setContent:_model.train_intro placeHolder:@"请逐条写明您的培训内容，最多1000字。"];
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
    if (indexPath.row == 5) {
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

            default:
                break;
        }
    }
}

#pragma mark- GRResumeEditTableViewCellDelegate cell输入文字后代理
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _model.train_name = stringValue;
    }else if (indexPath.row == 1){
        _model.train_city = stringValue;
    }else if (indexPath.row == 4){
        _model.train_cer = stringValue;
    }else if (indexPath.row == 5){
        _model.train_intro = stringValue;
    }
}

#pragma mark -GRResumeJobEXPEditIntroTableViewCellDelegate
- (void)contentDidChangeTo:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    _model.train_intro = stringValue;
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
