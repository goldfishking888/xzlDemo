//
//  HR_RegistHRWhenRegistedGerenVC.m
//  JobKnow
//
//  Created by Suny on 15/8/19.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_RegistHRWhenRegistedGerenVC.h"
#import "OtherLogin.h"
#import "SaveCount.h"
#import "MBProgressHUD.h"
#import "NSString+MD5.h"

@interface HR_RegistHRWhenRegistedGerenVC ()

@end

@implementation HR_RegistHRWhenRegistedGerenVC

@synthesize net;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)initData
{
    num = ios7jj;
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    net=[[NetWorkConnection alloc]init];
    
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self addBackBtn];
    

    [self addTitleLabel:@"密码"];
 
    //密码输入框1
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(10,54+num, iPhone_width-20, 40)];
    _passwordField.placeholder = @"请输入您的密码";
    _passwordField.tag = 11;
    _passwordField.textColor = [UIColor grayColor];
    _passwordField.keyboardType = UIKeyboardTypeAlphabet;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [_passwordField setSecureTextEntry:YES];
    _passwordField.delegate = self;
    [self.view addSubview: _passwordField];
    
    //邀请码输入框
    _inviteCodeField = [[UITextField alloc]initWithFrame:CGRectMake(10, 105+num, iPhone_width-20, 40)];
    _inviteCodeField.delegate = self;
    _inviteCodeField.tag = 12;
    _inviteCodeField.secureTextEntry=NO;
    _inviteCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _inviteCodeField.textColor = [UIColor grayColor];
    _inviteCodeField.keyboardType = UIKeyboardTypeAlphabet;
    _inviteCodeField.returnKeyType = UIReturnKeyDone;
    _inviteCodeField.placeholder = @"请输入邀请码（若没有可不填）";
    _inviteCodeField.text=@"";
    _inviteCodeField.borderStyle = UITextBorderStyleRoundedRect;
    _inviteCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_inviteCodeField];
    
    //密码最好是数字和字母混合
    UILabel *readLabel=[[UILabel alloc]init];
    readLabel.frame=CGRectMake(12,215+num,300,40);
    readLabel.backgroundColor=[UIColor clearColor];
    readLabel.font=[UIFont systemFontOfSize:12];
    readLabel.textColor=RGBA(255, 115, 4, 1);
    readLabel.text=@"您已注册过求职者账号，输入求职者账号密码即可直接开通人事经理账号";
    [readLabel setNumberOfLines:0];
    [readLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:readLabel];
    
    //确定按钮
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(10,160+num,300,40);
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)sureBtnClick
{
    if (_passwordField.text.length<6) {
        mGhostView(nil,@"请输入六位以上密码");
        return;
    }else
    {
        //md5加密,暂时未加
        //        NSString *tempStr = [NSString md5:[NSString stringWithFormat:@"%@%@",_userStr,_passwordField.text]];
        //        tempStr = [NSString md5:[NSString stringWithFormat:@"%@%@",tempStr,IMEI]];
        //       NSDictionary *params = @{@"mobile":_userStr,@"pass":_passwordField.text,@"token":tempStr};
        
        NSMutableDictionary *paramDic = @{@"mobile":_userStr,@"pass":_passwordField.text};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString * url = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"hr_api/hrmanage/check_member_pass"];
        NSLog(@"str is %@",url);
        
        [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSNumber *error = responseObject[@"error"];
                if ([error intValue] == 200) {
                    
                    HRregistChooseTradeVC *hrct=[[HRregistChooseTradeVC alloc]init];
                    hrct.userName = _userStr;
                    hrct.userPaw = _passwordField.text;
                    hrct.inviteCode = _inviteCodeField.text;
                    [self.navigationController pushViewController:hrct animated:YES];
                    
                }else if([error intValue] == 201) {
                    
                    ghostView.message = @"密码错误";
                    [ghostView show];
                }
            }else{
                NSLog(@"密码校验 %@",@"fail");
            }
        } failure:^(NSError *error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
            ghostView.message = @"网络出现问题，请稍后重试";
            [ghostView show];
            
        }];
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    
    ghostView.message=@"注册失败，请稍后重试";
    [ghostView show];
}

#pragma mark UITextField代理方法的实现

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passwordField) {
        [_inviteCodeField becomeFirstResponder];
    }else if (textField == _inviteCodeField){
        [self sureBtnClick];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
