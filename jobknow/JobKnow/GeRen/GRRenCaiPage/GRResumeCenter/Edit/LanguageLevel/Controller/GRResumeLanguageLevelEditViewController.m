//
//  GRResumeLanguageLevelEditViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeLanguageLevelEditViewController.h"

#import "GRResumeJobEXPEditIntroTableViewCell.h"
#import "ResumePrivacySettingTableViewCell.h"

#define kImageSelected [UIImage imageNamed:@"reg_author_checked"]
#define kImageNoSelected [UIImage imageNamed:@"reg_author_normal"]
#define kImageDelete [UIImage imageNamed:@"reg_author_normal"]

@interface GRResumeLanguageLevelEditViewController ()
@property (nonatomic,strong) UIView *footerView;
@end

@implementation GRResumeLanguageLevelEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"编辑教育经历"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
}

-(void)initData{
    _arrat_title_0 = @[@"语言"];
    if(!_model){
        _model = [LanguageLevelModel new];
        
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
        [label_title setTitle:@"删除此语言能力" forState:UIControlStateNormal];
        [label_title addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:label_title];
    }
    return  _footerView;
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if([NSString isNullOrEmpty:_model.l_name]){
        ghostView.message = @"请输入学校名称";
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
    [paramDic setValue:_model.resume_id.length>0?_model.resume_id:_resume_id forKey:@"rid"];
    [paramDic setValue:_model.l_id forKey:@"id"];
    [paramDic setValue:@"resume_languages" forKey:@"table"];
    
    NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
    [workDic setValue:_model.resume_id.length>0?_model.resume_id:_resume_id forKey:@"rid"];
    [workDic setValue:_model.l_name forKey:@"languages"];
    [workDic setValue:_model.l_level forKey:@"lang_read_write"];
    
    
    [paramDic setValue:[workDic toJSONString] forKey:@"data"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/update/resume_languages"];
    if ([_model.l_id isNullOrEmpty]) {
        url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/add/resume_languages"];
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

#pragma mark- 删除此条语言能力
-(void)clickFooter:(UIButton *)btn{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.resume_id forKey:@"rid"];
    [paramDic setValue:_model.l_id forKey:@"id"];
    [paramDic setValue:@"resume_languages" forKey:@"table"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/extend/delete/resume_languages"];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 4;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    ResumePrivacySettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ResumePrivacySettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    
    if (indexPath.section == 1){
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell setModelLanEdit:_model indexPath:indexPath];
        if (indexPath.row == 0) {
            cell.imageView_icon.image = kImageSelected;
            
            if (![NSString isNullOrEmpty:_model.l_level]) {
                if (![_model.l_level isEqualToString:@"一般"]) {
                    cell.imageView_icon.image = kImageNoSelected;
                }
            }
            cell.label_title.text = @"一般";
        }else if (indexPath.row == 1){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.l_level]) {
                if ([_model.l_level isEqualToString:@"良好"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"良好";
        }else if (indexPath.row == 2){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.l_level]) {
                if ([_model.l_level isEqualToString:@"熟练"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"熟练";
        }else if (indexPath.row == 3){
            cell.imageView_icon.image = kImageNoSelected;
            if (![NSString isNullOrEmpty:_model.l_level]) {
                if ([_model.l_level isEqualToString:@"精通"]) {
                    cell.imageView_icon.image = kImageSelected;
                }
            }
            cell.label_title.text = @"精通";
        }
    }else if (indexPath.section == 0){
        GRResumeEditTableViewCell  *cell2 = [[GRResumeEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell2.backgroundColor = [UIColor whiteColor];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.indexPath = indexPath;
        cell2.delegate = self;
        [cell2 setTitleValue:_arrat_title_0[indexPath.row]];
        [cell2 setTextFieldValue:_model.l_name DefaultValue:@"请输入"];
        cell2.accessoryType=UITableViewCellAccessoryNone;
        return cell2;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    return 56;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewBack =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 62)];
    viewBack.backgroundColor = RGB(242, 242, 242);
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 50)];
    viewH.backgroundColor = [UIColor whiteColor];
    [viewBack addSubview:viewH];
    
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
    
    if (section == 1){
        label_title.text = @"熟练程度";
        return viewBack;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 62;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    switch (indexPath.section) {
        case 1:
            if (indexPath.row==0) {
                _model.l_level = @"一般";
            }else if (indexPath.row==1) {
                _model.l_level = @"良好";
            }else if (indexPath.row==2) {
                _model.l_level = @"熟练";
            }else if (indexPath.row==3) {
                _model.l_level = @"精通";
            }
            break;
        
        default:
            break;
    }
    
    [_tableView reloadData];
    
}

#pragma mark- GRResumeEditTableViewCellDelegate cell输入文字后代理
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _model.l_name = stringValue;
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
