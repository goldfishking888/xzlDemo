//
//  PassWordViewController.m
//  JobKnow
//
//  Created by Zuo on 14-1-13.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "PassWordViewController.h"
#import "OtherLogin.h"
#import "SaveCount.h"
#import "XZLUtil.h"
#import "HomeViewController.h"

@interface PassWordViewController ()

@end

@implementation PassWordViewController

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
    
    if ([self.myType integerValue]==1) {
        [self addTitleLabel:@"修改密码"];
    }else{
        [self addTitleLabel:@"设置密码"];
    }
    
    //密码输入框1
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(10,54+num, iPhone_width-20, 40)];
    
    if ([self.myType integerValue]==1) {
        _passwordField.placeholder = @"旧密码";
    }else{
        _passwordField.placeholder = @"请设置6个字符以上的密码";
    }
    _passwordField.tag = 11;
    _passwordField.textColor = [UIColor grayColor];
    _passwordField.keyboardType = UIKeyboardTypeAlphabet;
    _passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [_passwordField setSecureTextEntry:YES];
    _passwordField.delegate = self;
    [self.view addSubview: _passwordField];
    
    
    //密码输入框
    _passwordField2 = [[UITextField alloc]initWithFrame:CGRectMake(10, 105+num, iPhone_width-20, 40)];
    _passwordField2.delegate = self;
    _passwordField2.tag = 12;
    _passwordField2.secureTextEntry=YES;
     _passwordField2.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordField2.textColor = [UIColor grayColor];
    _passwordField2.keyboardType = UIKeyboardTypeAlphabet;
    _passwordField2.returnKeyType = UIReturnKeyGo;
    if ([self.myType integerValue]==1) {
        _passwordField2.placeholder = @"6位以上新密码";
    }else{
        _passwordField2.placeholder = @"请再次输入密码";
    }
    _passwordField2.text=@"";
    _passwordField2.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_passwordField2];
    
    //密码最好是数字和字母混合
    UILabel *readLabel=[[UILabel alloc]init];
    if ([self.myType integerValue]==1){
        readLabel.frame=CGRectMake(12,215+num,300,20);
    }else{
        readLabel.frame=CGRectMake(12,160+num,300,20);
    }
    
    readLabel.backgroundColor=[UIColor clearColor];
    readLabel.font=[UIFont systemFontOfSize:12];
    readLabel.textColor=RGBA(255, 115, 4, 1);
    readLabel.text=@"  密码最好为数字和字母混合，这样账号更安全";
    [self.view addSubview:readLabel];
    
    //确定按钮
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.myType integerValue]==1){
        loginBtn.frame=CGRectMake(10,160+num,300,40);
        loginBtn.backgroundColor = [UIColor clearColor];
        [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        [loginBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    }else{
        loginBtn.frame=CGRectMake(10,210+num,300,40);
        loginBtn.backgroundColor = [UIColor clearColor];
        [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        [loginBtn setTitle:@"注册" forState:UIControlStateHighlighted];
    }
    
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)sureBtnClick
{
    if ([self.myType integerValue]==1) {
    
        if(![self checkTelephoneNumber])
        {
            ghostView.message = tipString;
            [ghostView show];
            return;
        }else{
            [self changeMima];
        }
        
    }else{
        
        NSLog(@"此处执行了。。。。。。");
        
        if (![_passwordField.text isEqualToString:_passwordField2.text]) {
            ghostView.message=@"两次输入的密码不一致,请重新输入";
            [ghostView show];
            return;
        }else//如果前后密码一致
        {
            if (_passwordField.text.length<6){
                
                ghostView.message=@"密码长度不得小于6位";
                [ghostView show];
                return;
                
            }else
            {
                NSString *urlStr = kCombineURL(KXZhiLiaoAPI, kNewUserRegister);
                
                NSLog(@"用户名＝＝%@",self.userStr);
                
                loadView =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",self.userStr,@"userAccount",_passwordField.text,@"userPsw",nil];
                
//                NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
//                ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
//                request.delegate=self;
//                [request setTimeOutSeconds:20];
//                [request startAsynchronous];
                NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
                ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
                [request setCompletionBlock:^{
                    
                    [loadView hide:YES];
                    
                    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
                    
                    NSString *resultStr=[resultDic valueForKey:@"error"];
                    
                    if (resultStr.integerValue==0&&resultDic) {
                        [self getLogin];
                        
                        //        ghostView.message=@"恭喜，注册成功";
                        //        [ghostView show];
                        return;
                    }else
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        ghostView.message=@"注册失败，请稍后重试";
                        [ghostView show];
                        return;
                    }
                }];
                [request setFailedBlock:^{
                    //        [loadView hide:YES];
                    [loadView hide:YES];
                    ghostView.message=@"网络请求失败";
                    [ghostView show];
                    
                }];
                [request startAsynchronous];
            }
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *resultStr=[resultDic valueForKey:@"error"];
    
    if (resultStr.integerValue==0&&resultDic) {
        [self getLogin];
        
//        ghostView.message=@"恭喜，注册成功";
//        [ghostView show];
        return;
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        ghostView.message=@"注册失败，请稍后重试";
        [ghostView show];
        return;
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
        [_passwordField2 becomeFirstResponder];
    }else if (textField == _passwordField2){
        [self sureBtnClick];
    }
    return YES;
}

//注册成功以后登录

- (void)getLogin
{
    SaveCount *save=[SaveCount standerDefault];
    NSString *urlstr = kCombineURL(KXZhiLiaoAPI, kNewUserLogin);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userStr,@"userName",_passwordField2.text,@"userPsw",IMEI,@"userImei",save.deviceToken,@"pushId",@"1",@"loginType",@"1",@"type",nil];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlstr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if (resultDic&&resultDic.count!=0&&errorStr.integerValue ==0) { //如果登录成功，error的返回值保存下来
            /*
             1.登录成功后，将用户名，用户密码和登录信息存入userDefaults中
             2.向homeVC发送一个通知，通知判断订阅器是否有改变，如果改变，应该下载新的订阅器，并且刷新数据库
             */
            
            [HR_LoginSharedTool saveUserInfoDic:resultDic LoginType:@"GeRen"];
            [XZLUtil sendAliasToJPush];

            NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
            [AppUD setObject:self.userStr forKey:@"UserName"];//账号
            [AppUD setObject:_passwordField2.text forKey:@"passWord"];
            NSString *userName2=[resultDic valueForKey:@"userName"];//小名
            NSString *str=nil;
            if (userName2) {
                str=[NSString stringWithFormat:@"欢迎%@登录小职了，偶是您的求职小秘书，请快给偶下指令吧!",userName2];
            }else{
                str=[NSString stringWithFormat:@"欢迎登录小职了，偶是您的求职小秘书，请快给偶下指令吧!"];
            }
            ghostView.message=str;
            ghostView.timeout=2;
//            [self.navigationController popToRootViewControllerAnimated:YES];
            NSString * tokenStr = [NSString stringWithFormat:@"%@",resultDic[@"userToken"]];
            NSString * mobileStr = [NSString stringWithFormat:@"%@",resultDic[@"userMobile"]];
            NSString * invitedIdStr = [NSString stringWithFormat:@"%@",resultDic[@"inviteId"]];
            NSString * userEmailStr = [NSString stringWithFormat:@"%@",resultDic[@"userEmail"]];
            [self requestPCPidAndSavedWithToken:tokenStr withMobileStr:mobileStr withinvitedIdStr:invitedIdStr withEmailStr:userEmailStr withType:@"1"];

        }else if (errorStr.integerValue ==1)
        {
            ghostView.message=@"您尚未注册，请先注册账号";
        }else if (errorStr.integerValue ==2)
        {
            ghostView.message=@"您的密码输入错误!";
            
        }else if (errorStr.integerValue ==3)
        {
            ghostView.message=@"登录用户非个人";
        }else if (errorStr.integerValue ==4)
        {
            ghostView.message=@"您已下线超过24小时";
        }
        
        [ghostView show];
    }];
    
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message = @"网络连接超时，请检查网络";
        [ghostView show];
    }];
    [request startAsynchronous];
    
}
//修改密码的请求
- (void)changeMima
{
    //修改密码
    NSString *urlStr = kCombineURL(KXZhiLiaoAPI, @"new_api/loginuser/reset_pwd?");
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:_passwordField2.text,@"newPsw",_passwordField.text,@"oldPsw",IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    
    loadView =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    __weak ASIHTTPRequest  *request=[ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
    
        [loadView hide:YES];
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *data = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if ([data isEqualToString:@"please login"]) {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
        }else{
            NSString *errorStr=[resultDic  valueForKey:@"error"];
            if(errorStr.integerValue==0&&errorStr&&resultDic) {
                [self.navigationController popViewControllerAnimated:YES];
                ghostView.message=@"密码修改成功";
                [ghostView show];
                return;
                
            }else if (errorStr.integerValue ==1)
            {
                ghostView.message=@"旧密码错误";
                [ghostView show];
                return;
            }
        }
    }];
    
    [request setFailedBlock:^{
        [loadView hide:YES];
        ghostView.message = @"网络连接超时，请检查网络";
        [ghostView show];
    }];
    
    [request startAsynchronous];
}

//判断新密码格式
- (BOOL)checkTelephoneNumber
{
    if (_passwordField.text.length == 0) {//判断是否为空
        tipString = @"旧密码不能为空";
        return NO;
    }
    
    if (_passwordField2.text.length == 0) {//判断是否为空
        tipString = @"新密码不能为空";
        return NO;
    }else if(_passwordField2.text.length < 6){
        tipString = @"新密码长度不能小于六位";
        return NO;
    }else if ([_passwordField2.text isEqualToString:_passwordField.text]){
        tipString = @"新旧密码不能相同";
        return NO;
    }
    
    return YES;
}

#pragma mark - 请求pcpid并且缓存到本地
-(void)requestPCPidAndSavedWithToken:(NSString *)tokenStr withMobileStr:(NSString *)mobileStr withinvitedIdStr:(NSString *)invitedIdStr withEmailStr:(NSString *)emailStr withType:(NSString *)loginType
{
    /* token
     imei
     email
     mobile
     type//app的身份 1个人 2猎手 3hr 4企业
     invitationCode*/
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:IMEI forKey:@"imei"];
    [paramDic setValue:emailStr forKey:@"email"];
    [paramDic setValue:mobileStr forKey:@"mobile"];//手机企业没有
    [paramDic setValue:loginType forKey:@"type"];//4表示企业
    [paramDic setValue:@"" forKey:@"invitationCode"];//邀请码
    NSLog(@"paramDic is %@",paramDic);
    //    NSDictionary *params = @{@"mobile":_phoneTF.text,@"captcha":_verifyCodeTF.text,@"version":[XZLUtil currentVersion]};
    NSString * url = [NSString stringWithFormat:@"%@%@",KWWWXZhiLiaoAPI,@"api/account/register_do"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            [mUserDefaults setValue:[responseObject valueForKey:@"pcUserId"] forKey:@"pcUserId"];
            NSString * ss = [mUserDefaults valueForKey:@"pcUserId"];
            NSLog(@"pcUserId 缓存到的是 is %@",ss);
            
            for (UIViewController *item in self.navigationController.viewControllers) {
                if ([item isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:item animated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"toHomeVCFromLoginVC" object:self userInfo:nil];
                }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
