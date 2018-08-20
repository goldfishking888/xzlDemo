//
//  GRPreBookViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRPreBookViewController.h"
#import "GRBookerConditionTableViewCell.h"
#import "GRReadModel.h"
#import "ScanningViewController.h"
#import "GRCityInfoNumsModel.h"

#import "GRBookPositionListViewController.h"
#import "AppDelegate.h"


@interface GRPreBookViewController ()

@end

@implementation GRPreBookViewController{
    NSArray *array_title;
    GRCityInfoNumsModel *model_cityInfo;
    OLGhostAlertView *ghostView;
    MBProgressHUD *loadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHeadViewGR];
    [self addTitleLabelGR:@"订阅"];
    [self initData];
    // 初始化tableView
    [self initTableView];
}

-(void)initData{
    array_title = @[@"职位名称",@"城市",@"行业"];
    //    _dataArray = [NSMutableArray new];
    
    _model = [GRBookerModel new];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

#pragma mark -初始化tableView

- (void)initTableView {
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight -64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.view_Booker;
}

#pragma mark -选择城市后获取城市相关信息
-(void)getCityRelatedNumbersWithCityCode:(NSString *)cityCode GotoList:(BOOL)isGoToList Index:(NSIndexPath *)indexPath{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    //    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:cityCode forKey:@"city_code"];
    
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/code/city_sources"];
    [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                if (isGoToList) {
                    GRCityInfoNumsModel *model = [GRCityInfoNumsModel yy_modelWithDictionary:dataDic];
                    model_cityInfo = model;
                    GRBookPositionListViewController *vc = [GRBookPositionListViewController new];
                    vc.model = _model;
                    vc.model_cityInfo= model_cityInfo;
                    NSMutableArray *array = [NSMutableArray new];
                    [array addObject:_model];
                    vc.array_model_booker = array;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    model_cityInfo = [GRCityInfoNumsModel yy_modelWithDictionary:dataDic];
                }
                
                
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        //        ghostView.message = @"网络出现问题，请稍后重试";
        //        [ghostView show];
        
    }];
}

-(void)skip{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app SetRootVC:@"0"];
}

#pragma mark- 点击保存
-(void)onClickSaveBtn:(UIButton *)sender{
    
    [self.view endEditing:YES];

        if([NSString isNullOrEmpty:_model.bookPostName]){
            ghostView.message = @"请输入职位名称";
            [ghostView show];
            return;
        }
        if([NSString isNullOrEmpty:_model.bookLocationName]){
            ghostView.message = @"请选择城市";
            [ghostView show];
            return;
        }
        if([NSString isNullOrEmpty:_model.bookIndustryName]){
            ghostView.message = @"请选择行业";
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
    [paramDic setValue:_model.bookPostName forKey:@"position_name"];
    [paramDic setValue:_model.bookIndustryCode forKey:@"trade"];//手机企业没有
    [paramDic setValue:_model.bookLocationCode forKey:@"area"];//4表示企业
    [paramDic setValue:_model.bookSalaryCode?_model.bookSalaryCode:@"0" forKey:@"salary"];//
    //    [paramDic setValue:@"PHP" forKey:@"position_name"];
    //    [paramDic setValue:@"1100" forKey:@"trade"];//手机企业没有
    //    [paramDic setValue:@"2012" forKey:@"area"];//4表示企业
    //    [paramDic setValue:@"13" forKey:@"salary"];//
    NSLog(@"paramDic is %@",paramDic);
    //    NSDictionary *params = @{@"mobile":_phoneTF.text,@"captcha":_verifyCodeTF.text,@"version":[XZLUtil currentVersion]};
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/subscribe/create"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                GRBookerModel *model = [GRBookerModel getBookerModelWithDic:dataDic];
                [model saveOrUpdate];
                ScanningViewController *scanVC=[[ScanningViewController alloc]init];
                scanVC.model_cityInfo = model_cityInfo;
                scanVC.model_booker = model;
                NSMutableArray *arrayBooker = [NSMutableArray new];
                [arrayBooker addObject:model];
                scanVC.array_model_booker = arrayBooker;
                scanVC.isFromRegister = YES;
                [self.navigationController pushViewController:scanVC animated:YES];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];
}

-(void)reloadDatas{
    [_tableView reloadData];
}



#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array_title.count;//测试
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    GRBookerConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        cell = [[GRBookerConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell setTitleValue:array_title[indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                //职位名称
                [cell setTextFieldValue:_model.bookPostName DefaultValue:@"请输入职位名称"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //城市
                [cell setLabelValue:_model.bookLocationName DefaultValue:@"请选择"];
            }
                break;
            case 2:
            {
                //行业
                [cell setLabelValue:_model.bookIndustryName DefaultValue:@"请选择"];
            }
                break;
            case 3:
            {
                //月薪
                [cell setLabelValue:_model.bookSalaryName DefaultValue:@"请选择"];
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.section == 1) {
        return 70;
    }
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 61;
    }
    return 50 +6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50+6)];
    viewBack.backgroundColor = RGB(247, 247, 247);
    
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    viewH.backgroundColor = [UIColor whiteColor];
    [viewBack addSubview:viewH];
    
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    label.text = @"请订阅您想做的工作，我们将为您推送最合适的职位";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = RGB(74, 74, 74);
    label.backgroundColor = [UIColor clearColor];
    [viewH addSubview:label];
    
    return viewBack;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 38+44+31;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        return nil;
    }
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44+20)];
    viewH.backgroundColor = [UIColor whiteColor];
    
    UIButton *label_title = [[UIButton alloc] initWithFrame:CGRectMake(28, 38, kMainScreenWidth-28*2, 44)];
    mViewBorderRadius(label_title, 22, 1, [UIColor clearColor]);
    [label_title.titleLabel setFont:[UIFont systemFontOfSize:16]] ;
    [label_title setBackgroundColor:RGB(255, 178, 66)];
    [label_title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [label_title setTitleColor:RGB(216, 216, 216) forState:UIControlStateHighlighted];
    label_title.tag = section;
    [label_title setTitle:@"确定" forState:UIControlStateNormal];
    [label_title addTarget:self action:@selector(onClickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewH addSubview:label_title];
    
    UIButton *label_jump = [[UIButton alloc] initWithFrame:CGRectMake(0, label_title.bottom +20, kMainScreenWidth, 20)];
    [label_jump.titleLabel setFont:[UIFont systemFontOfSize:15]] ;
    [label_jump setBackgroundColor:[UIColor clearColor]];
    [label_jump setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
//    [label_jump setTitleColor:RGB(216, 216, 216) forState:UIControlStateHighlighted];
    label_title.tag = section;
    [label_jump setTitle:@"跳过订阅步骤" forState:UIControlStateNormal];
    [label_jump addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    [viewH addSubview:label_jump];
    
    return viewH;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GRReadModel *model = [[GRReadModel alloc] init];
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
                
            case 1:
            {
                [self selectCity];
            }
                break;
            case 2:
            {
                model.name = _model.bookIndustryName;
                model.code = _model.bookIndustryCode;
                [self multiSelectIndustry:indexPath Model:model];
            }
                break;

                break;
            default:
                break;
        }
    }
}


/**连接3个字符串**/

- (NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3
{
    NSString *totalString=@"";
    
    if (![NSString isNullOrEmpty:str]) {
        totalString=[totalString stringByAppendingString:str];
    }
    
    if (![NSString isNullOrEmpty:str2]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:str2];
    }
    if (![NSString isNullOrEmpty:str3]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:str3];
    }
    
    
    if ([totalString length]>=17) {
        totalString=[totalString substringToIndex:16];
    }
    
    return totalString;
}


#pragma mark- GRBookerConditionTableViewCellDelegate cell输入文字后代理
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _model.bookPostName = stringValue;
        [_tableView reloadData];
    }
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
    allCityVC.city_selected = _model.bookLocationName;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName{
    _model.bookLocationName = cityName;
    _model.bookLocationCode = cityCode;
    [_tableView reloadData];
    [self getCityRelatedNumbersWithCityCode:cityCode GotoList:NO Index:nil];
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
#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理

- (void)onSelectSalaryWithModel:(GRReadModel *)model_selected{
    _model.bookSalaryName = model_selected.name;
    _model.bookSalaryCode = model_selected.code;
    [_tableView reloadData];
}

-(void)onMultiSelectIndustryWithArray:(NSMutableArray *)array_selected{
    NSString *str_name = @"";
    NSString *str_code = @"";
    for (GRReadModel *model in array_selected) {
        str_name = [str_name stringByAppendingString:[NSString stringWithFormat:@"%@,",model.name]];
        str_code = [str_code stringByAppendingString:[NSString stringWithFormat:@"%@,",model.code]];
    }
    str_name = [str_name substringToIndex:str_name.length-1];
    str_code = [str_code substringToIndex:str_code.length-1];
    _model.bookIndustryName = str_name;
    _model.bookIndustryCode = str_code;
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
