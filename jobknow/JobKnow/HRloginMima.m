//
//  HRloginMima.m
//  JobKnow
//
//  Created by Mathias on 15/7/7.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRloginMima.h"
#import "HRregistChooseTradeVC.h"
@interface HRloginMima ()<UITextFieldDelegate, UITextViewDelegate>
{
    
    UITextField * userName;
    UITextField * userPsw ;
    UITextField * invitation ;
}

@end

@implementation HRloginMima

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"完善信息"];
   
    // Do any additional setup after loading the view.
   self.view.backgroundColor=[UIColor colorWithRed:243 green:243 blue:243 alpha:1];
    
    //账号、密码
    userName = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, ([[UIScreen mainScreen] bounds].size.width)-20, 40)];
    [userName setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    userName.placeholder = @"请设置6个字符以上的密码"; //默认显示的字
    userName.clearButtonMode = UITextFieldViewModeAlways;
    
    userName.secureTextEntry=YES;
    userName.delegate=self;
    
    userName.backgroundColor=[UIColor whiteColor];
    
    userPsw = [[UITextField alloc] initWithFrame:CGRectMake(10, 144, ([[UIScreen mainScreen] bounds].size.width)-20, 40)];
    [userPsw setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    userPsw.delegate=self;
    userPsw.placeholder = @"请再次输入密码"; //默认显示的字
    
    userPsw.backgroundColor=[UIColor whiteColor];
    
    userPsw.clearButtonMode = UITextFieldViewModeAlways;
    userPsw.secureTextEntry = YES; //密码
    //提示
    
    //邀请码
    invitation = [[UITextField alloc] initWithFrame:CGRectMake(10,240, ([[UIScreen mainScreen] bounds].size.width)-20, 40)];
    [invitation setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    invitation.delegate=self;
    invitation.placeholder = @"请输入邀请码（若没有可不填）"; //默认显示的字
    
    invitation.backgroundColor=[UIColor whiteColor];
    
    invitation.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:invitation];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, [[UIScreen mainScreen] bounds].size.width, 20)];
    
    label.textAlignment=NSTextAlignmentLeft;
    
    label.textColor=[UIColor orangeColor];
    
    label.font=[UIFont systemFontOfSize:13];
    
    label.text=@"  密码最好为数字和字母混合，这样账号更安全";
    
    [self.view addSubview:label];
    
    
    //登录
    UIButton *login=[UIButton buttonWithType:UIButtonTypeSystem];
    login.frame=CGRectMake(10, 300, ([[UIScreen mainScreen] bounds].size.width)-20, 40);
    
    [login setTitle:@"注 册" forState:UIControlStateNormal];
    [login.layer setCornerRadius:4];
    [login.layer setMasksToBounds:YES];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [login setBackgroundColor:[UIColor orangeColor]];
    
    [login setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    
    [self.view addSubview:userName];
    [self.view addSubview:userPsw];
    
    [self.view addSubview:login];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor orangeColor]CGColor];
    textField.layer.borderWidth= 1.0f;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   textField.layer.borderColor=[[UIColor grayColor] CGColor];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

//确定
-(void)login{
    
    
    if (userName.text.length<6) {
        mGhostView(nil,@"请输入六位以上密码");
        return;
    }if (![userName.text isEqualToString:userPsw.text]) {
        mGhostView(nil,@"确认密码不正确");
        return;
    }
    HRregistChooseTradeVC *hrct=[[HRregistChooseTradeVC alloc]init];
    hrct.userName = self.PhoneNumber;
    hrct.userPaw = userPsw.text;
    hrct.inviteCode = invitation.text;
    [self.navigationController pushViewController:hrct animated:YES];
    
}

@end