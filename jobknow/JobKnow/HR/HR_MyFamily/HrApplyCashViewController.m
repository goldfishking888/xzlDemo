//
//  HrApplyCashViewController.m
//  JobKnow
//
//  Created by admin on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HrApplyCashViewController.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "HrApplyCashHistoryListViewController.h"
#import "XZLUtil.h"


#define CrashTableViewWidth 300
#define CrashTableCellHeight 44
#define getCrashCell(a) ((HrApplyCashTableCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:a inSection:0]])

@implementation HrApplyCashTableCell

-(id)initCrashTableCell{
    self = [super initWithFrame:CGRectMake(0, 0, CrashTableViewWidth, CrashTableCellHeight)];
    if (self) {
         _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 70, CrashTableCellHeight)];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setTextColor:mRGBToColor(0x333333)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_titleLabel];
        
        _detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, CrashTableViewWidth-90-25, CrashTableCellHeight)];
        _detailTextField.textAlignment = NSTextAlignmentRight;
        [_detailTextField setTextColor:mRGBToColor(0x5c5c5c)];
        [_detailTextField setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_detailTextField];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 44, CrashTableViewWidth-14-10, 1)];
        lineLabel.backgroundColor = mRGBToColor(0xE1E1E1);
        [self addSubview:lineLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

@end

@interface HrApplyCashViewController ()<UIAlertViewDelegate>{
    NSArray *_titleArray;
    NSArray *_detailArray;
    MBProgressHUD *_progressView;
}

@end

@implementation HrApplyCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addRightButtonWithTitle:@"提现记录"];
    [self addCenterTitle:@"提现"];
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0,44+(ios7jj), kMainScreenWidth, kMainScreenFrame.size.height-44-(ios7jj))];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    
    _titleArray = @[@"姓名",@"开户银行",@"银行卡号",@"手机号码",@"提现金额"];
    _detailArray = @[@"请输入收款人姓名",@"请选择开户银行",@"请输入银行卡号",@"请输入手机号码",@"请输入提现金额"];
    
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(10,15, CrashTableViewWidth, CrashTableCellHeight*5)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.cornerRadius = 5;
    _tableView.scrollEnabled = NO;
    [scrollView addSubview:_tableView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y+_tableView.frame.size.height+15, kMainScreenWidth, 15)];
    [infoLabel setFont:[UIFont systemFontOfSize:14]];
    [infoLabel setTextColor:mRGBToColor(0xFF9204)];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setText:@"*提现金额最低为100元且须为100的整数倍哦~"];
    [scrollView addSubview:infoLabel];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(15, _tableView.frame.origin.y+_tableView.frame.size.height+45,kMainScreenWidth-30, 38)];
    [btn setBackgroundColor:RGBA(250, 90, 10, 1)];
    [btn.layer setCornerRadius:5];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:btn];
    [self.view addSubview:scrollView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 确定按钮点击事件
-(void)clickOnBtn:(id)sender{
    
    if (getCrashCell(0).detailTextField.text.length == 0) {
        mAlertView(@"提示", @"请输入收款人姓名");
        return;
    }
    if(getCrashCell(1).detailTextField.text.length == 0){
        mAlertView(@"提示", @"请选择开户银行");
        return;
    }
    if(getCrashCell(2).detailTextField.text.length == 0){
        mAlertView(@"提示", @"请输入银行卡号");
        return;
    }
    if([XZLUtil isValidateMobile:getCrashCell(3).detailTextField.text] == NO){
        mAlertView(@"提示", @"您输入的手机号码有误，请重新输入");
        return;
    }
    if(getCrashCell(4).detailTextField.text.length == 0){
        mAlertView(@"提示", @"请输入提现金额");
        return;
    }
    if ([getCrashCell(4).detailTextField.text floatValue]<100) {
        mAlertView(@"提示", @"提现金额最低为100元哦~");
        return;
    }
    if((([getCrashCell(4).detailTextField.text floatValue] - [getCrashCell(4).detailTextField.text intValue])>0) ||(([getCrashCell(4).detailTextField.text intValue]%100) != 0)){
        mAlertView(@"提示", @"提现金额为100的整数倍哦~");
        return;
    }
    if (([getCrashCell(4).detailTextField.text intValue]/100*100) > ([_money intValue]/100*100)) {
        mAlertView(@"提示", @"提现金额超限哦~");
        return;
    }
    NSString *name = getCrashCell(0).detailTextField.text;
    NSString *bank = getCrashCell(1).detailTextField.text;
    NSString *bankNum = getCrashCell(2).detailTextField.text;
    NSString *phone = getCrashCell(3).detailTextField.text;
    NSString *money = getCrashCell(4).detailTextField.text;
    NSString *urlStr = nil;
    NSDictionary *paramDic = nil;
    
    if (_appleType == HrApplyCashTypeOfInvite) {
        
//        urlStr = kCombineURL(KXZhiLiaoAPI, HRInviteApplyCash);//已废弃
        urlStr = kCombineURL(KXZhiLiaoAPI, HRApplyCash);
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr,@"userToken",IMEI,@"userImei",name,@"name",money,@"money",bank,@"bankName",bankNum,@"bankCard",phone,@"mobile",nil];
        
    }else if (_appleType == HrAppleCashTypeOfRecommend) {
        //已废弃
        urlStr = kCombineURL(KXZhiLiaoAPI, HRRecommendApplyCash);
        NSString *hrUid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr,@"userToken",IMEI,@"userImei",name,@"name",money,@"money",bank,@"bank",bankNum,@"bankCard",phone,@"mobile",hrUid,@"hr_uid",nil];
    }
    
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    _progressView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressView.userInteractionEnabled=NO;
    [request setCompletionBlock:^(void){
        [_progressView hide:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSNumber * errorValue = resultDic[@"error"];
        if (([errorValue intValue] == 200) && (_appleType == HrApplyCashTypeOfInvite)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功！" delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag = 13001;
            [alert show];
            
        }else if (([errorValue intValue] == 0) && (_appleType == HrAppleCashTypeOfRecommend)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功！" delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag = 13001;
            [alert show];
            
        }else {
            mAlertView(@"提示", @"申请失败！");
        }
    }];
    [request setFailedBlock:^(void){
        [_progressView hide:YES];
    }];
    [request startAsynchronous];
}
#pragma mark - NavigationBarRightButton 提现记录

- (void)onClickRightBtn:(id)sender
{
    HrApplyCashHistoryListViewController *listVC = [[HrApplyCashHistoryListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ((alertView.tag == 13001) && (buttonIndex == alertView.cancelButtonIndex)) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HrApplyCashTableCell *cell  = [[HrApplyCashTableCell alloc] initCrashTableCell];
    [cell.titleLabel setText:_titleArray[indexPath.row]];
    [cell.detailTextField setPlaceholder:_detailArray[indexPath.row]];
    switch (indexPath.row) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            [cell.detailTextField setEnabled:NO];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        }
            break;
        case 2:
        {
            [cell.detailTextField setKeyboardType:UIKeyboardTypeNumberPad];
        }
            break;
        case 3:
        {
            [cell.detailTextField setKeyboardType:UIKeyboardTypeNumberPad];
            NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"hrMobile"];
            [cell.detailTextField setText:phone];
        }
            break;
        case 4:
        {
            [cell.detailTextField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.detailTextField setText:_money];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        HrSelectBankViewController *bankVC = [[HrSelectBankViewController alloc] init];
        bankVC.delegate = self;
        [self.navigationController pushViewController:bankVC animated:YES];
    }
}

#pragma mark - HrSelectBankDelegate
- (void)didSelectBank:(NSString *)bankCode bankName:(NSString *)bankName{
    
    NSLog(@"didSelectBank - %@",bankName);
    [getCrashCell(1).detailTextField setText:bankName];
}

@end
