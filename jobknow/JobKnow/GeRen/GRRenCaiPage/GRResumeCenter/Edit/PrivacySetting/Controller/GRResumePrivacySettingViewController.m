//
//  GRResumePrivacySettingViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumePrivacySettingViewController.h"
#define kImageSelected [UIImage imageNamed:@"reg_author_checked"]
#define kImageNoSelected [UIImage imageNamed:@"reg_author_normal"]
#define kImageDelete [UIImage imageNamed:@"resume_edit_delete"]

#import "ResumePrivacySettingTableViewCell.h"
#import "ResumeShieldCompany.h"

#define ContactMeString @"随时都可以联系我"

@interface GRResumePrivacySettingViewController ()

@end

@implementation GRResumePrivacySettingViewController{
//    BOOL isShowContactTime;//是否显示添加自定义时间输入框
    BOOL isShowAddCompany;//是否显示添加企业关键字输入框
    
    OLGhostAlertView * ghostView;
    
    NSString *name;
}

-(void)viewWillAppear:(BOOL)animated{
    [self requestSettings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"隐私设置"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
    
    
}

-(void)initData{
    isHide = YES;
    sectionCount = 3;
    name = _model.name;
    if(!_model){
        _model = [GRResumePrivacyModel new];
    }
    hideBtnString = @"∨ 显示更多设置";
//    isShowContactTime = NO;
    isShowAddCompany = NO;
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
}

-(void)initTableView{
    
    
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight  - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = RGB(242, 242, 242);
    _tableView.tableFooterView = self.tableView_Footer;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

-(UIView *)tableView_Footer{
    if (_tableView_Footer ==nil) {
        _tableView_Footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenHeight, 57)];
        _tableView_Footer.backgroundColor = [UIColor whiteColor];
        
        btn_hide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,kMainScreenWidth, _tableView_Footer.frame.size.height)];
        [btn_hide.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn_hide setTitle:hideBtnString forState:UIControlStateNormal];
        [btn_hide setTitleColor:RGB(155, 155, 155) forState:UIControlStateNormal];
        [btn_hide.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn_hide addTarget:self action:@selector(footerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tableView_Footer addSubview:btn_hide];
    }
    return  _tableView_Footer;
}

#pragma mark-获取设置信息
-(void)requestSettings{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.resume_id forKey:@"resume_id"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                _model = [[GRResumePrivacyModel alloc] initWithDictionary:dataDic];
                _model.name = name;
                [_tableView reloadData];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"设置简历联系时间失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"设置简历联系时间失败";
        [ghostView show];
        
    }];
    
}

#pragma mark - 点击保存
-(void)onClickRightBtn:(UIButton *)sender
{
    NSLog(@"点击右边调到方法");
    [self.view endEditing:YES];
    if (_model.myContactTime.length==0) {
        if (![_model.contactTime isEqualToString:@"0"]) {
//            _model.myContactTime = ContactMeString;
            [self requestSetContactTime:ContactMeString];
            ghostView.message = @"自定义联系时间不能为空";
            [ghostView show];
            return;
        }
        
    }
    ghostView.message = @"保存成功";
    [ghostView show];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)requestChanges{
//    
//    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//    NSString *tokenStr = kTestToken;
//    [paramDic setValue:tokenStr forKey:@"token"];
//    
//    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"subscribe"];
//    [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//            NSNumber *error_code = responseObject[@"error_code"];
//            if (error_code.intValue == 0) {
//                
//            }
//        }else{
//            NSLog(@"register_do %@",@"fail");
//        }
//    } failure:^(NSError *error) {
//        ghostView.message = @"网络出现问题，请稍后重试";
//        [ghostView show];
//        
//    }];
//    
//}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2){
        if (isShowAddCompany) {
            return _model.resumeShieldCompanyKeysArray.count+1;
        }
        if (_model.resumeShieldCompanyKeysArray) {
            return _model.resumeShieldCompanyKeysArray.count;
        }
        return 0;
    }else if (section == 3){
        return 3;
    }else if (section == 4){
        if ([_model.contactTime isEqualToString:@"1"]) {
            return 3;
        }
        return 2;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    ResumePrivacySettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ResumePrivacySettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;

    [cell setModel:_model indexPath:indexPath];
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.imageView_icon.image = kImageSelected;

            if (![NSString isNullOrEmpty:_model.nameShow]) {
                if ([_model.nameShow isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageNoSelected;
                }
            }
            _model.name = [NSString isNullOrEmpty:_model.name]?@"未设置":_model.name;
            
            cell.label_title.text = _model.name;
        }else if (indexPath.row == 1){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.nameShow]) {
                if ([_model.nameShow isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = [NSString stringWithFormat:@"%@先生/女士",[_model.name substringToIndex:1]];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.imageView_icon.image = kImageSelected;
            if (![NSString isNullOrEmpty:_model.resumeAvailable]) {
                if ([_model.resumeAvailable isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageNoSelected;
                }
            }
            
            cell.label_title.text = @"职业顾问可见";
        }else if (indexPath.row == 1){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.resumeAvailable]) {
                if ([_model.resumeAvailable isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"仅自己可见";
        }
    }else if (indexPath.section == 2){
//        if (isShowAddCompany) {
//            
//        }
        if (indexPath.row == _model.resumeShieldCompanyKeysArray.count) {
            cell.imageView_icon.image = nil;
            cell.label_title.hidden = YES;
            cell.tf_title.hidden = NO;
//            [cell.tf_title becomeFirstResponder];
        }else{
            cell.imageView_icon.image = kImageDelete;
            ResumeShieldCompany *model =_model.resumeShieldCompanyKeysArray[indexPath.row];
            cell.label_title.text = model.company_name;
        }

    }else if (indexPath.section == 3){
        //联系方式
        if (indexPath.row == 0) {
            cell.imageView_icon.image = kImageSelected;
            if (![NSString isNullOrEmpty:_model.contactAvailable]) {
                if (![_model.contactAvailable isEqualToString:@"0"]) {
                    cell.imageView_icon.image = kImageNoSelected;
                }
            }
            
            cell.label_title.text = @"显示全部联系方式";
        }else if (indexPath.row == 1){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.contactAvailable]) {
                if ([_model.contactAvailable isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"只显示手机";
        }else if (indexPath.row == 2){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.contactAvailable]) {
                if ([_model.contactAvailable isEqualToString:@"2"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"只显示邮箱";
        }
    }else if (indexPath.section == 4){
        //联系方式
        if (indexPath.row == 0) {
            cell.imageView_icon.image = kImageSelected;
            if (![NSString isNullOrEmpty:_model.contactTime]) {
                if (![_model.contactTime isEqualToString:@"0"]) {
                    cell.imageView_icon.image = kImageNoSelected;
                }
            }
            
            cell.label_title.text = ContactMeString;
        }else if (indexPath.row == 1){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.contactTime]) {
                if ([_model.contactTime isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"自定义";
            cell.view_line.hidden = YES;
        }else if (indexPath.row == 2){
            if(![NSString isNullOrEmpty:_model.myContactTime]){
                cell.imageView_icon.image = kImageDelete;
                cell.label_title.text = _model.myContactTime;
            }else{
                cell.imageView_icon.image = nil;
                cell.label_title.hidden = YES;
                cell.tf_title.hidden = NO;
                [cell.tf_title becomeFirstResponder];
            }
            
            cell.view_line.hidden = YES;
        }
    }else if (indexPath.section == 5){
        //联系方式
        if (indexPath.row == 0) {
            cell.imageView_icon.image = kImageSelected;
            if (![NSString isNullOrEmpty:_model.salary]) {
                if (![_model.salary isEqualToString:@"0"]) {
                    cell.imageView_icon.image = kImageNoSelected;
                }
            }
            
            cell.label_title.text = @"显示";
        }else if (indexPath.row == 1){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.salary]) {
                if ([_model.salary isEqualToString:@"1"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"隐藏";
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    if (indexPath.section == 0) {
        
    }
    
    return 56;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    viewH.backgroundColor = [UIColor whiteColor];
    
    UIView *viewtag = [[UIView alloc] initWithFrame:CGRectMake(24, 15, 4, 20)];
    viewtag.backgroundColor = RGB(255, 163, 29);
    [viewH addSubview:viewtag];
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(42, 17, 100, 16)];
    label_title.textAlignment = NSTextAlignmentLeft;
    label_title.font = [UIFont systemFontOfSize:16];
    label_title.textColor =RGB(74, 74, 74);
    [viewH addSubview:label_title];
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(18, 51, kMainScreenWidth-18, 1)];
    view_line.backgroundColor = RGB(239, 239, 239);
    [viewH addSubview:view_line];
    
    if (section==0) {
        label_title.text = @"简历显示名称";
    }else if (section == 1){
        label_title.text = @"简历可见性";
    }else if (section == 2){
        label_title.text = @"简历可见性";
        
        [view_line setFrame:CGRectMake(18, 51, kMainScreenWidth-18, 1)];
        view_line.backgroundColor = RGB(239, 239, 239);
        [viewH addSubview:view_line];
        
        UILabel *label_content = [[UILabel alloc] initWithFrame:CGRectMake(22, 66, kMainScreenWidth-22, 14)];
        label_content.numberOfLines = 0;
        label_content.lineBreakMode = RTTextLineBreakModeWordWrapping;
        label_content.textColor = RGB(155, 155, 155);
        [label_content setText:@"设置屏蔽后，含有该关键词的企业都无法看到您的简历"];
        label_content.font = [UIFont systemFontOfSize:14];
        if (isScreenIPhone6Below) {
            label_content.font = [UIFont systemFontOfSize:12];
        }
        [viewH addSubview:label_content];
    }else if (section == 3){
        label_title.text = @"联系方式";
    }else if (section == 4){
        label_title.text = @"建议联系时间";
    }else if (section == 5){
        label_title.text = @"以往薪资";
    }
    return viewH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
        return 80;
    }
    return 50;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    viewH.backgroundColor = RGB(242, 242, 242);
    
    if (section==2) {
        [viewH setFrame:CGRectMake(0, 0, kMainScreenWidth, 66)];
        
        UIButton *btn_addCompany = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 56)];
        [btn_addCompany addTarget:self action:@selector(addCompangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_addCompany setTitleColor:RGB(255, 146, 4) forState:UIControlStateNormal];
        [btn_addCompany setTitle:@"+ 添加屏蔽企业" forState:UIControlStateNormal];
        btn_addCompany.backgroundColor = [UIColor whiteColor];
        btn_addCompany.tag = section;
        [viewH addSubview:btn_addCompany];
        
    }
    
    return viewH;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 66;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    switch (indexPath.section) {
        case 0:
            [self requestSetNameType:indexPath];
            break;
        case 1:
            [self requestSetResumeAvailable:indexPath];
            break;
        case 2:
            {
                [self deleteCompany:indexPath];
            }
            break;
        case 3:
            [self requestSetContactAvailable:indexPath];
            break;
        case 4:
            if (indexPath.row==0) {
                _model.contactTime = @"0";
                [self requestSetContactTime:ContactMeString];
            }else if (indexPath.row==1) {
                _model.contactTime = @"1";
                if (_model.myContactTime.length>0) {
                    [self requestSetContactTime:_model.myContactTime];
                }
                
            }
            break;
        case 5:
            [self requestSetSalaryAvailable:indexPath];
            break;
            
        default:
            break;
    }
    
    [_tableView reloadData];
    
}

#pragma mark-点击Header的编辑按钮触发代理方法
-(void)footerBtnClicked:(UIButton *)sender{
    isHide = !isHide;
    if (isHide) {
        sectionCount = 3;
        hideBtnString = @"∨ 显示更多设置";
    }else{
        sectionCount = 6;
        hideBtnString = @"∧ 隐藏更多设置";
    }
    [btn_hide setTitle:hideBtnString forState:UIControlStateNormal];
    [_tableView reloadData];
}

#pragma mark - 点击添加企业屏蔽关键字
-(void)addCompangBtnClicked:(UIButton *)sender
{
    isShowAddCompany = YES;
    [_tableView reloadData];
    NSLog(@"点击右边调到方法");
}



#pragma mark- ResumePrivacySettingTableViewCellDelegate cell的Textfield完成输入
- (void)confirmTimeTFWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        if ([stringValue isNullOrEmpty]) {
            return;
        }
        if (indexPath.row == 99) {
            _model.myContactTime = stringValue;
        }else{
           [self requestSetContactTime:stringValue];
        }
        
    }else if(indexPath.section == 2) {
        [self requestAddCompany:stringValue];
    }
    
}

#pragma mark- ResumePrivacySettingTableViewCellDelegate cell的前置删除按钮点击事件
- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [self requestDeleteCompany:indexPath];
    }else if(indexPath.section == 4) {
        [self requestSetContactTime:@""];
    }
}

#pragma mark-设置简历薪资显示方法
-(void)requestSetSalaryAvailable:(NSIndexPath *)indexPath{
    NSString *type = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:type forKey:@"pass_salary"];
    [paramDic setValue:_model.resume_id forKey:@"resume_id"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/pass_salary"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                _model.salary = type;
                [_tableView reloadData];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"设置简历薪资显示失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"设置简历薪资显示失败";
        [ghostView show];
    }];
}

#pragma mark-设置简历联系方式显示方法
-(void)requestSetContactAvailable:(NSIndexPath *)indexPath{
    NSString *type = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:type forKey:@"contact_type"];
    [paramDic setValue:_model.resume_id forKey:@"resume_id"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/contact"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                _model.contactAvailable = type;
                [_tableView reloadData];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"设置简历联系方式显示失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"设置简历联系方式显示失败";
        [ghostView show];
    }];
}

#pragma mark-设置简历可见性方法
-(void)requestSetResumeAvailable:(NSIndexPath *)indexPath{
    NSString *type = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:type forKey:@"visibility_type"];
    [paramDic setValue:_model.resume_id forKey:@"resume_id"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/resume"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                _model.resumeAvailable = type;
                [_tableView reloadData];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"设置简历可见性失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"设置简历可见性失败";
        [ghostView show];
    }];
}

#pragma mark-设置简历显示名称方法
-(void)requestSetNameType:(NSIndexPath *)indexPath{
    NSString *type = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:type forKey:@"name_type"];
    [paramDic setValue:_model.resume_id forKey:@"resume_id"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/name"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                _model.nameShow = type;
                [_tableView reloadData];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"设置简历显示名称失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"设置简历显示名称失败";
        [ghostView show];
    }];
}


#pragma mark-设置简历联系时间方法
-(void)requestSetContactTime:(NSString *)string{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:string forKey:@"contact_date_text"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/contact_date"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
//                NSDictionary *dataDic = responseObject[@"data"];
                if ([string isEqualToString:ContactMeString]) {
                    _model.contactTime = @"0";
                }else if(string.length == 0){
//                    _model.contactTime = @"0";
                    _model.myContactTime = @"";
                }else{
                    _model.contactTime = @"1";
                    _model.myContactTime = string;
                }

                [_tableView reloadData];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"设置简历联系时间失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"设置简历联系时间失败";
        [ghostView show];
        
    }];
}

#pragma mark-添加屏蔽企业方法
-(void)requestAddCompany:(NSString *)com_name{
    if (com_name.length == 0) {
        return;
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:com_name forKey:@"company_name"];
    [paramDic setValue:_model.resume_id forKey:@"resume_id"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/save_shield_company"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                NSMutableArray *array = [NSMutableArray arrayWithArray:_model.resumeShieldCompanyKeysArray];
                ResumeShieldCompany *model = [[ResumeShieldCompany alloc] initWithDictionary:dataDic[@"companys"]];
                [array addObject:model];
                _model.resumeShieldCompanyKeysArray = array;
                isShowAddCompany = NO;
                [_tableView reloadData];
            }
        }else{
            ghostView.message = @"添加屏蔽企业失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"添加屏蔽企业失败";
        [ghostView show];
        
    }];
    
}


#pragma mark-删除屏蔽企业方法
-(void)deleteCompany:(NSIndexPath *)indexPath{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_model.resumeShieldCompanyKeysArray];
    
    [array removeObjectAtIndex:indexPath.row];
    _model.resumeShieldCompanyKeysArray = array;
    [_tableView reloadData];
}
#pragma mark-删除屏蔽企业方法//待pc改成传企业id
-(void)requestDeleteCompany:(NSIndexPath *)indexPath{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    ResumeShieldCompany *model = _model.resumeShieldCompanyKeysArray[indexPath.row];
    [paramDic setValue:model.com_id forKey:@"id"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/privacy/del_shield_company"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
//                NSDictionary *dataDic = responseObject[@"data"];
                [self deleteCompany:indexPath];
            }
        }else{
            ghostView.message = @"删除屏蔽企业失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"删除屏蔽企业失败";
        [ghostView show];
        
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
