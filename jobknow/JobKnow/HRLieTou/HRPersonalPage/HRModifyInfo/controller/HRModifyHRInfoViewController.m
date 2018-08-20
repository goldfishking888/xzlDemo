//
//  HRModifyHRInfoViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/30.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRModifyHRInfoViewController.h"

@interface HRModifyHRInfoViewController ()

@end

@implementation HRModifyHRInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"基本信息"];
    [self addRightButtonWithTitle:@"确定" Color:RGB(255, 163, 29)];
    [self initData];
    [self initTableView];
    [_tableView reloadData];
    
    // Do any additional setup after loading the view.
}

-(void)initData{
    _arrat_title_0 = @[@"姓        名",@"城        市"];
    _arrat_title_1 = @[@"公        司",@"行        业",@"职        位",@"手        机",@"固        话",@"邮        箱",@"微        信",@"QQ"];//@[@"联系电话",@"联系邮箱",@"身份证号码"];
    if(!_model){
        _model = [HRBasicInfoModel new];
    }
    NSString *cityCode = [mUserDefaults valueForKey:@"city"];
    NSString *cityStr = [XZLUtil getCityNameWithCityCode:cityCode?cityCode:@"1111"];
    _model.cityCode = cityCode;
    _model.city = cityStr;
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

-(void)initTableView{
    
    _tableView = [[TPKeyboardAvoidingTableView  alloc] initWithFrame:CGRectMake(0, 44 + self.num, kMainScreenWidth, kMainScreenHeight - 44 - self.num) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = RGB(242, 242, 242);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;//测试
    }else if (section == 1){
        return 8;
    }
    return 1;
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
                //姓名
                [cell setTextFieldValue:_model.name DefaultValue:@"请输入"];
                UILabel * markLab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 7, 20)];
                markLab2.text = @"*";
                markLab2.textColor = RGBA(255, 27, 55, 1);
                [cell addSubview:markLab2];

                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //城市
//                NSString *cityCode = [mUserDefaults valueForKey:@"city"];
//                NSString *cityStr = [XZLUtil getCityNameWithCityCode:cityCode?cityCode:@"1111"];
                [cell setLabelValue:_model.city DefaultValue:@"请选择"];
                UILabel * markLab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 7, 20)];
                markLab2.text = @"*";
                markLab2.textColor = RGBA(255, 27, 55, 1);
                [cell addSubview:markLab2];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        [cell setTitleValue:_arrat_title_1[indexPath.row]];
        switch (indexPath.row) {
            case 0://公司
                [cell setTextFieldValue:_model.company DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;

                break;
            case 1://行业
                [cell setLabelValue:_model.industry_name DefaultValue:@"请选择"];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2://职位
                [cell setTextFieldValue:_model.occupation DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
                break;
            case 3://手机
                [cell setLabelValue:_model.mobile DefaultValue:@""];
                cell.accessoryType=UITableViewCellAccessoryNone;
                break;
            case 4://固话
                [cell setTextFieldValue:_model.telphone DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
                break;
            case 5://邮箱
                [cell setTextFieldValue:_model.email DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
                break;
            case 6://微信
                [cell setTextFieldValue:_model.wechat DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;

                break;
            case 7://QQ
                [cell setTextFieldValue:_model.qq DefaultValue:@"请输入"];
                cell.accessoryType=UITableViewCellAccessoryNone;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    _indexPath_current = indexPath;
    GRReadModel *model = [[GRReadModel alloc] init];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {//不是选择器的情况都在cell的代理里面实现了赋值传值保存到当前要上传的model里了
            }
                break;
            case 1:
            {
                [self selectCity];
                //                [self selectDate];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 1:
                model.name = _model.industry_name;
                model.code = _model.industry_code;
                [self selectIndustry:indexPath Model:model];
                break;
            default:
                break;
        }
    }
}
#pragma mark - GRResumeEditTableViewCellDelegate cell的输入框代理
-(void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            _model.name = stringValue;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){//公司
            _model.company = stringValue;
        }else if (indexPath.row == 2){//职位
            _model.occupation = stringValue;
        }else if (indexPath.row == 3){//手机
            _model.mobile = stringValue;
        }else if (indexPath.row == 4){//固话
            _model.telphone = stringValue;
        }else if (indexPath.row == 5){//邮箱
            _model.email = stringValue;
        }else if (indexPath.row == 6){//微信
            _model.wechat = stringValue;
        }else if (indexPath.row == 7){//QQ
            _model.qq = stringValue;
        }
    }
}

#pragma mark- 选择行业
-(void)selectIndustry:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMIndustry;
    edu.titleString = @"选择行业";
    [self.navigationController pushViewController:edu animated:YES];
}

#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理
- (void)onSelectIndustryWithModel:(GRReadModel *)model_selected{
    _model.industry_name = model_selected.name;
    _model.industry_code = model_selected.code;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark- 选择城市
-(void)selectCity{
    allCityViewController *allCityVC=[[allCityViewController alloc]init];
    allCityVC.delegate=self;
    if (_indexPath_current.row == 1) {
        allCityVC.city_selected = _model.city;
    }
    [self.navigationController pushViewController:allCityVC animated:YES];
}
//选择完城市修改model值
- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName{
    if (_indexPath_current.row == 1) {
        _model.city = cityName;
        _model.cityCode = cityCode;
    }
    [_tableView reloadRowsAtIndexPaths:@[_indexPath_current] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark- 保存修改网络请求
-(void)saveingRequest{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.name forKey:@"name"];
    [paramDic setValue:_model.cityCode forKey:@"city"];
    [paramDic setValue:_model.company forKey:@"company"];
    [paramDic setValue:_model.industry_code forKey:@"industry_code"];
    [paramDic setValue:_model.industry_name forKey:@"industry_name"];
    [paramDic setValue:_model.occupation forKey:@"occupation"];
    [paramDic setValue:_model.mobile forKey:@"mobile"];
    [paramDic setValue:_model.telphone forKey:@"telphone"];
    [paramDic setValue:_model.email forKey:@"email"];
    [paramDic setValue:_model.wechat forKey:@"wechat"];
    [paramDic setValue:_model.qq forKey:@"qq"];
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/account/hunter/update"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSLog(@"data是%@",responseObject[@"data"]);
            if (error.integerValue==0) {
                mGhostView(nil, @"更新个人信息成功");
                [mUserDefaults setValue:_model.name forKey:@"name"];
                [mUserDefaults setValue:_model.email forKey:@"email"];
                [mUserDefaults setValue:_model.cityCode forKey:@"city"];
                [mUserDefaults setValue:_model.qq forKey:@"qq"];
                //                [mUserDefaults setValue:_model.mobile forKey:@"mobile"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        }
    }failure:^(NSError *error) {
            mGhostView(nil, @"操作失败");
        }];
    
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([_model.name isNullOrEmpty]) {
        mGhostView(nil, @"请输入姓名");
        return;
    }else{
        if (_model.name.length>5) {
            mGhostView(nil, @"姓名长度5位以下");
            return;
        }
    }
    
    if ([_model.city isNullOrEmpty]) {
        mGhostView(nil, @"请选择城市");
        return;
    }
    if (![_model.company isNullOrEmpty]) {
        if (_model.company.length>30) {
            mGhostView(nil, @"公司长度30位以下");
            return;
        }
    }
    
    if (![_model.occupation isNullOrEmpty]) {
        if (_model.occupation.length>10) {
            mGhostView(nil, @"职位长度10位以下");
            return;
        }
    }
    
    if (![_model.mobile isNullOrEmpty]) {
        if (![XZLUtil isValidateMobile:_model.mobile]) {
            mGhostView(nil, @"手机格式不正确");
            return;
        }
    }
    if (![_model.telphone isNullOrEmpty]) {
        NSRange range = [_model.telphone rangeOfString:@"-"];
        if (range.length==0) {
            mGhostView(nil, @"固话格式：区号-号码");
            return;
        }else{
            NSArray *array = [_model.telphone componentsSeparatedByString:@"-"];
            NSString *str1 = array[0];
            NSString *str2 = array[1];
            if (str1.length<3||str1.length>4) {
                mGhostView(nil, @"区号不正确");
                return;
            }
            if (str2.length<7||str2.length>8) {
                mGhostView(nil, @"号码不正确");
                return;
            }
        }
        
    }
    
    if (![_model.email isNullOrEmpty]) {
        if (![self validateEmail:_model.email]) {
            mGhostView(nil, @"请输入正确的邮箱格式");
            return;
        }if (_model.email.length>30) {
            mGhostView(nil, @"邮箱长度30位以下");
            return;
        }
    }
    
    if (![_model.wechat isNullOrEmpty]) {
        if (_model.wechat.length>30) {
            mGhostView(nil, @"微信长度30位以下");
            return;
        }
    }
    
    if (![_model.qq isNullOrEmpty]) {
        if (![self checkQQ]) {
            mGhostView(nil, @"请输入正确的QQ格式");
            return;
        }else{
            if (_model.qq.length>20) {
                mGhostView(nil, @"QQ长度20位以下");
                return;
            }
        }
    }
    
    
//    if (![_model.email isNullOrEmpty]) {
//        if (![self validateEmail:_model.email]) {
//            mGhostView(nil, @"请输入正确的邮箱格式");
//            return;
//        }if (_model.email.length>30) {
//            mGhostView(nil, @"邮箱长度30位以下");
//            return;
//        }
//    }
    
    [self saveingRequest];
}
/***检测是否是正确的QQ号码***/
-(BOOL)checkQQ
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:_model.qq]) {
        return YES;
    }
    return NO;
}
- (BOOL)validateEmail:(NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
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
