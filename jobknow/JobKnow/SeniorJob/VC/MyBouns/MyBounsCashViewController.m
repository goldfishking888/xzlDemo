//
//  MyBounsCashViewController.m
//  JobKnow
//
//  Created by Jiang on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "MyBounsCashViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OLGhostAlertView.h"
#import "XZLUtil.h"

#define TFValueOfCell(row) ([(UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] viewWithTag:1123] text])
@interface MyBounsCashViewController ()<UITableViewDelegate,UITableViewDataSource>{

    TPKeyboardAvoidingTableView *_tableView;
    NSArray *_titleArray;
    NSArray *_placeHolderArray;
    NSArray *_keyboardArray;
    OLGhostAlertView *_ghost;
}
@end

@implementation MyBounsCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"提现"];
    [self.view setBackgroundColor:XZHILBJ_colour];
    
    _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(10,ios7jj+44+10, iPhone_width-20, 44*5)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView.layer setCornerRadius:8];
    [_tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tableView.layer setBorderWidth:0.5];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    
    _titleArray = @[@"真实姓名",@"手机号码",@"开户银行",@"银行卡号",@"奖金金额"];
    _placeHolderArray = @[@"请填写真实姓名",@"请填写手机号码",@"请填写银行全称",@"请输入银行卡号"];//奖金金额为Label
    _keyboardArray = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeNumberPad),@(UIKeyboardTypeDefault),@(UIKeyboardTypeNumberPad)];
    
    UIButton *cashButton = [[UIButton alloc] initWithFrame:CGRectMake(10, _tableView.frame.origin.y+_tableView.frame.size.height+15, 300, 40)];
    [cashButton setTitle:@"提现" forState:UIControlStateNormal];
    [cashButton setBackgroundColor:[UIColor orangeColor]];
    [cashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cashButton.layer setCornerRadius:8];
    [cashButton addTarget:self action:@selector(cashButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cashButton];
    
    _ghost = [[OLGhostAlertView alloc] initWithTitle:nil message:@"" timeout:3 dismissible:YES];
    [_ghost setPosition:OLGhostAlertViewPositionCenter];
    
}

#pragma mark - 提现按钮点击事件
- (void)cashButtonClick{
    
    NSLog(@"提现啦~~");
    NSString *name = TFValueOfCell(0);
    NSString *mobile = TFValueOfCell(1);
    NSString *bankName = TFValueOfCell(2);
    NSString *bankNO = TFValueOfCell(3);
    if (name.length == 0) {
        _ghost.message = @"真实姓名不能为空哦~";
        [_ghost show];
        return;
    }else if(mobile.length == 0 || [XZLUtil isValidateMobile:mobile] == NO){
        _ghost.message = @"手机号码填写有误哦~";
        [_ghost show];
        return;
    }else if (bankName.length == 0){
        _ghost.message = @"银行全称不能为空哦~";
        [_ghost show];
        return;
    }else if (bankNO.length == 0 || [XZLUtil isValidateNumber:bankNO] == NO){
        _ghost.message = @"银行卡号填写有误哦~";
        [_ghost show];
        return;
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",name,@"uname",mobile,@"phone",bankName,@"bank",bankNO,@"bankNum",_cashMoney,@"bouns",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/senior/apply_withdraw?"];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString * errorStr = [NSString stringWithFormat:@"%@",resultDic[@"error"]];
        if ([errorStr isEqualToString:@"0"] == YES) {
            _ghost.message = @"提交成功";
            [_ghost show];
            [self.navigationController popViewControllerAnimated:YES];
            if (_delegate && [_delegate respondsToSelector:@selector(myBounsCashSuccess)]) {
                [_delegate myBounsCashSuccess];
            }
        }else{
            _ghost.message = @"提交失败，请稍后重试";
            [_ghost show];
        }
        
    }];
    [request setFailedBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _ghost.message = @"网络连接失败，请稍后重试";
        [_ghost show];
    }];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *ttlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [ttlLabel setText:_titleArray[indexPath.row]];
    [ttlLabel setTextColor:[UIColor darkGrayColor]];
    [ttlLabel setFont:[UIFont systemFontOfSize:15]];
    [ttlLabel setTextAlignment:NSTextAlignmentCenter];
    [cell addSubview:ttlLabel];
    if (indexPath.row <4) {
        UITextField *valueTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 7, 300-90-7, 30)];
        [valueTF setPlaceholder:_placeHolderArray[indexPath.row]];
        [valueTF setTextAlignment:NSTextAlignmentRight];
        [valueTF setTextColor:[UIColor grayColor]];
        [valueTF setBackgroundColor:XZHILBJ_colour];
        [valueTF setFont:[UIFont systemFontOfSize:15]];
        [valueTF.layer setCornerRadius:5];
        [valueTF setKeyboardType:[_keyboardArray[indexPath.row] integerValue]];
        valueTF.tag = 1123;
        if (indexPath.row == 1) {//手机号码填写默认值
            valueTF.text = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"user_tel"]];
        }
        [cell addSubview:valueTF];
    }else{
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, 300-90-7, 30)];
        [valueLabel setText:[NSString stringWithFormat:@"%@元",_cashMoney]];
        [valueLabel setTextAlignment:NSTextAlignmentRight];
        [valueLabel setTextColor:[UIColor grayColor]];
        [valueLabel setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:valueLabel];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, 300, 0.5)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:lineView];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
