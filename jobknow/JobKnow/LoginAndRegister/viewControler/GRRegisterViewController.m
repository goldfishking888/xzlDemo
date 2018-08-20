//
//  GRRegisterViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/27.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRRegisterViewController.h"
#import "UserAgreementViewController.h"//xin 用户协议
#import "GRRootViewController.h"//注册成功之后返回rootvc
#import "AppDelegate.h"
#import "GRPreBookViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

#define TIME 60//
@interface GRRegisterViewController ()<UITextFieldDelegate>
{
    TPKeyboardAvoidingScrollView * scrollbgV;
    UILabel * GRLab;
    UILabel * HRLab;
    UITextField * userName;
    UITextField * qrCodeTf;
    UIButton * getConfirmBtn;
    UILabel * timeLab;
    NSTimer * timer;
    int time;
    
    UITextField * userPsw ;//输入新密码
    UITextField * userInviteCode ;//输入邀请码
    
    UIImageView * agreeImgV;
    BOOL isSelected;
    BOOL isGR;//是否个人注册
    NSString * qrCodeStr;//验证码值
    OLGhostAlertView *ghostView;
    MBProgressHUD *loadView;
    NSString * cityStr;
}
@end

@implementation GRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    [self addBackBtnGR];
    [self addTitleLabelGR:@"注册"];
    isGR = YES;//开始默认是个人身份
    isSelected = YES;
    [self makeUI];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

//点击手势让键盘收起来
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [userName resignFirstResponder];
    [userPsw resignFirstResponder];
    [qrCodeTf resignFirstResponder];
    [userInviteCode resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if ([userName isFirstResponder]) {
        [userName resignFirstResponder];
        [qrCodeTf becomeFirstResponder];
    }else if ([qrCodeTf isFirstResponder]){
        [qrCodeTf resignFirstResponder];
        [userPsw becomeFirstResponder];
    }else if ([userPsw isFirstResponder]){
        [userPsw resignFirstResponder];
        [userInviteCode becomeFirstResponder];
    }else if ([userInviteCode isFirstResponder]){
        [userInviteCode resignFirstResponder];
    }
    return YES;
    
}

-(void)makeUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    scrollbgV = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 44 + self.num, iPhone_width, iPhone_height - 44 - self.num)];
    scrollbgV.contentSize = CGSizeMake(iPhone_width, iPhone_height + 50);
    [self.view addSubview:scrollbgV];
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 150)];
    headerView.backgroundColor = [UIColor whiteColor];
    [scrollbgV addSubview:headerView];
    //企业版登录
    UIView * toastView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
    [headerView addSubview:toastView];
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(toastView.frame.size.width / 2 - 50, 20, 100, 15)];
    titleLab.text = @"请选择您的身份";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = RGBA(74, 74, 74, 1);
    [toastView addSubview:titleLab];
    
    UIView * lineLeftV = [[UIView alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x - 60 - 13, titleLab.frame.origin.y + titleLab.frame.size.height / 2 - 1, 60, 1)];
    lineLeftV.backgroundColor = RGBA(225, 225, 225, 1);
    [toastView addSubview:lineLeftV];
    
    UIView * lineRightV = [[UIView alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x +titleLab.frame.size.width + 13, titleLab.frame.origin.y + titleLab.frame.size.height / 2 - 1, 60, 1)];
    lineRightV.backgroundColor = RGBA(225, 225, 225, 1);
    [toastView addSubview:lineRightV];
    
    //我是人才 我是猎头顾问
    UIButton * GRButton = [UIButton buttonWithType:UIButtonTypeSystem];
    GRButton.frame=CGRectMake(iPhone_width / 2 - 150, toastView.frame.origin.y + toastView.frame.size.height + 30, 134, 48);
    //    [GRButton.layer setBorderColor:RGBA(255, 163, 29, 1).CGColor];
    //    [GRButton setTitleColor:RGBA(255, 146, 4, 1) forState:UIControlStateNormal];
    //    [GRButton.layer setBorderWidth:1];
    //    GRButton.layer.cornerRadius = 7;
    //    GRButton.layer.masksToBounds = YES;
    //    [GRButton setTitle:@"我是人才" forState:UIControlStateNormal];
    //    GRButton.titleLabel.font = [UIFont systemFontOfSize:16];
    GRButton.tag = 10086;
    [GRButton addTarget:self action:@selector(GRHRButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:GRButton];
    
    GRLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GRButton.frame.size.width, GRButton.frame.size.height)];
    GRLab.text = @"我是人才";
    GRLab.font = [UIFont systemFontOfSize:16];
    GRLab.textAlignment = NSTextAlignmentCenter;
    GRLab.textColor = RGBA(255, 146, 4, 1);
    GRLab.layer.borderColor = RGBA(255, 163, 29, 1).CGColor;
    GRLab.layer.borderWidth = 1;
    GRLab.layer.cornerRadius = 7;
    GRLab.layer.masksToBounds = YES;
    [GRButton addSubview:GRLab];
    
    UIButton * HRButton = [UIButton buttonWithType:UIButtonTypeSystem];
    HRButton.frame=CGRectMake(iPhone_width / 2 + 16, GRButton.frame.origin.y, 134, 48);
    //    [HRButton.layer setBorderColor:RGBA(216, 216, 216, 1).CGColor];
    //    [HRButton.layer setBorderWidth:1];
    //    HRButton.layer.cornerRadius = 7;
    //    HRButton.layer.masksToBounds = YES;
    //    [HRButton setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
    //    [HRButton setTitle:@"我是职业顾问" forState:UIControlStateNormal];
    //    HRButton.titleLabel.font = [UIFont systemFontOfSize:16];
    HRButton.tag = 10087;
    [HRButton addTarget:self action:@selector(GRHRButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:HRButton];
    
    HRLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, HRButton.frame.size.width, HRButton.frame.size.height)];
    HRLab.text = @"我是猎头顾问";
    HRLab.font = [UIFont systemFontOfSize:16];
    HRLab.textAlignment = NSTextAlignmentCenter;
    HRLab.textColor = RGBA(74, 74, 74, 1);
    HRLab.layer.borderColor = RGBA(216, 216, 216, 1).CGColor;
    HRLab.layer.borderWidth = 1;
    HRLab.layer.cornerRadius = 7;
    HRLab.layer.masksToBounds = YES;
    [HRButton addSubview:HRLab];
    
    UIView * middleView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, iPhone_width, iPhone_height - headerView.frame.size.height)];
    middleView.backgroundColor = [UIColor whiteColor];
    [scrollbgV addSubview:middleView];
    
    //账号
    UIView * bgUserNameV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 150, 0, 300, 45)];
    bgUserNameV.layer.cornerRadius=4.0f;
    bgUserNameV.layer.masksToBounds=YES;
    bgUserNameV.layer.borderWidth= 1.0f;
    bgUserNameV.layer.borderColor= RGBA(216, 216, 216, 1).CGColor;
    [middleView addSubview:bgUserNameV];
    
    UIImageView * userIconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(14, 13.5, 18, 18)];
    userIconImgV.image = [UIImage imageNamed:@"GR_Register_mobile"];
    [bgUserNameV addSubview:userIconImgV];
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 300 - 42, 45)];
    userName.placeholder = @"手机号";
    userName.textColor = RGBA(74, 74, 74, 1);
    userName.font = [UIFont systemFontOfSize:15];
    userName.clearButtonMode = UITextFieldViewModeAlways;
    userName.delegate=self;
    userName.tag = 1;
    qrCodeTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [bgUserNameV addSubview:userName];
    
    //验证码
    UIView * bgVerifyV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 150, bgUserNameV.frame.origin.y + bgUserNameV.frame.size.height + 20, 300, 45)];
    [middleView addSubview:bgVerifyV];
    
    UIView * qrcodeV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 175, 45)];
    qrcodeV.layer.cornerRadius=4.0f;
    qrcodeV.layer.masksToBounds=YES;
    qrcodeV.layer.borderWidth= 1.0f;
    qrcodeV.layer.borderColor= RGBA(216, 216, 216, 1).CGColor;
    [bgVerifyV addSubview:qrcodeV];
    
    UIImageView * userVerifyImgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12.5, 20, 20)];
    userVerifyImgV.image = [UIImage imageNamed:@"GR_verifyCode"];
    [qrcodeV addSubview:userVerifyImgV];
    
    qrCodeTf = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 135, 45)];
    qrCodeTf.placeholder = @"验证码";
    qrCodeTf.textColor = RGBA(74, 74, 74, 1);
    qrCodeTf.font = [UIFont systemFontOfSize:15];
    qrCodeTf.clearButtonMode = UITextFieldViewModeAlways;
    qrCodeTf.delegate=self;
    qrCodeTf.tag = 2;
    qrCodeTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [qrcodeV addSubview:qrCodeTf];
    
    getConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getConfirmBtn.frame = CGRectMake(qrcodeV.frame.origin.x + qrcodeV.frame.size.width + 10, qrCodeTf.frame.origin.y, 115, 45);
    getConfirmBtn.backgroundColor = [UIColor whiteColor];
    [getConfirmBtn addTarget:self action:@selector(getConfirmMessageClick) forControlEvents:UIControlEventTouchUpInside];
    [bgVerifyV addSubview:getConfirmBtn];
    
    time = TIME;//计时器的初始化时间
    
    timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, getConfirmBtn.frame.size.width, getConfirmBtn.frame.size.height)];
    timeLab.backgroundColor = RGBA(251, 144, 2, 0.3);
    timeLab.text = @"获取验证码";
    timeLab.textColor = RGBA(251, 144, 2, 1);
    timeLab.font = [UIFont systemFontOfSize:15];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.layer.cornerRadius = 4;
    timeLab.layer.masksToBounds = YES;
    //    timeLab.layer.borderWidth = 1;
    //    timeLab.layer.borderColor = RGBA(251, 144, 2, 0.3).CGColor;
    [getConfirmBtn addSubview:timeLab];
    
    //请输入密码
    UIView * bgUserPswV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 150, bgVerifyV.frame.origin.y + bgVerifyV.frame.size.height + 20, 300, 45)];
    bgUserPswV.layer.cornerRadius=4.0f;
    bgUserPswV.layer.masksToBounds=YES;
    bgUserPswV.layer.borderWidth= 1.0f;
    bgUserPswV.layer.borderColor= RGBA(216, 216, 216, 1).CGColor;
    [middleView addSubview:bgUserPswV];
    
    UIImageView * userpswImgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 18, 18)];
    userpswImgV.image = [UIImage imageNamed:@"Login_invalidName"];
    [bgUserPswV addSubview:userpswImgV];
    
    userPsw = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 300 - 42, 45)];
    userPsw.placeholder = @"密码由6-10位数字或字母组成";
    userPsw.textColor = RGBA(74, 74, 74, 1);
    userPsw.font = [UIFont systemFontOfSize:15];
    userPsw.clearButtonMode = UITextFieldViewModeAlways;
    userPsw.delegate=self;
    userPsw.tag = 3;
    userPsw.secureTextEntry = YES;
    userPsw.clearsOnBeginEditing = NO;
    userPsw.clearButtonMode = UITextFieldViewModeAlways;
    [bgUserPswV addSubview:userPsw];
    
    //请输入邀请码
    UIView * bgUserInviteV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 150, bgUserPswV.frame.origin.y + bgUserPswV.frame.size.height + 20, 300, 45)];
    bgUserInviteV.layer.cornerRadius=4.0f;
    bgUserInviteV.layer.masksToBounds=YES;
    bgUserInviteV.layer.borderWidth= 1.0f;
    bgUserInviteV.layer.borderColor= RGBA(216, 216, 216, 1).CGColor;
    [middleView addSubview:bgUserInviteV];
    
    UIImageView * userInviteCodeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 20, 20)];
    userInviteCodeImgV.image = [UIImage imageNamed:@"GR_InviteCode"];
    [bgUserInviteV addSubview:userInviteCodeImgV];
    
    userInviteCode = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 300 - 42, 45)];
    userInviteCode.placeholder = @"请输入邀请码(没有可不填)";
    userInviteCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    userInviteCode.textColor = RGBA(74, 74, 74, 1);
    userInviteCode.font = [UIFont systemFontOfSize:15];
    userInviteCode.clearButtonMode = UITextFieldViewModeAlways;
    userInviteCode.delegate=self;
    userInviteCode.tag = 4;
    userInviteCode.secureTextEntry = YES;
    userInviteCode.clearsOnBeginEditing = NO;
    [bgUserInviteV addSubview:userInviteCode];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(50, bgUserInviteV.frame.origin.y + bgUserInviteV.frame.size.height + 40, iPhone_width - 100, 50);
    [sureBtn setBackgroundColor:RGBA(251, 144, 2, 1)];
    sureBtn.layer.cornerRadius = sureBtn.frame.size.height / 2;
    sureBtn.layer.masksToBounds = YES;//113043909768
    [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:sureBtn];
    
    agreeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 115 - 13, sureBtn.frame.origin.y + sureBtn.frame.size.height + 20, 15, 15)];
    agreeImgV.image = [UIImage imageNamed:@"GR_Agree"];
    [middleView addSubview:agreeImgV];
    
    UIButton * agreeImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeImgBtn.frame = CGRectMake(agreeImgV.frame.origin.x - 15, agreeImgV.frame.origin.y - 15, 45, 45);
    //    agreeImgBtn.backgroundColor = RGBA(25, 125, 143, 0.2);
    agreeImgBtn.selected = YES;
    [agreeImgBtn addTarget:self action:@selector(agreeImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:agreeImgBtn];
    
    UILabel * agreeLableft = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 122, agreeImgV.frame.origin.y, 115, 16)];
    agreeLableft.text = @"我已阅读并遵守";
    agreeLableft.textColor = RGBA(155, 155, 155, 1);
    agreeLableft.font = [UIFont systemFontOfSize:13.5];
    agreeLableft.textAlignment = NSTextAlignmentRight;
    [middleView addSubview:agreeLableft];
    
    UILabel * agreeLabRight = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 7, agreeImgV.frame.origin.y, 128, 16)];
    agreeLabRight.text = @"小职了用户使用协议";
    agreeLabRight.textColor = RGBA(255, 146, 4, 1);
    agreeLabRight.font = [UIFont systemFontOfSize:13.5];
    agreeLabRight.textAlignment = NSTextAlignmentLeft;
    [middleView addSubview:agreeLabRight];
    
    UIButton * seeAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeAgreementBtn.frame = CGRectMake(iPhone_width / 2, sureBtn.frame.origin.y + sureBtn.frame.size.height + 10, 125, 40);
    //    seeAgreementBtn.backgroundColor = RGBA(12, 123, 12, 0.3);
    [seeAgreementBtn addTarget:self action:@selector(seeAgreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:seeAgreementBtn];
}


-(void)GRHRButtonClick:(UIButton *)button
{
    if (button.tag == 10086) {
        [GRLab setTextColor:RGBA(255, 146, 4, 1)];
        [GRLab.layer setBorderColor:RGBA(255, 163, 29, 1).CGColor];
        [HRLab.layer setBorderColor:RGBA(216, 216, 216, 1).CGColor];
        [HRLab setTextColor:RGBA(74, 74, 74, 1)];
        NSLog(@"这里记录个人身份");
        isGR = YES;
    }else if (button.tag == 10087){
        NSLog(@"这里记录HR身份最后上传用");
        [HRLab setTextColor:RGBA(255, 146, 4, 1)];
        [HRLab.layer setBorderColor:RGBA(255, 163, 29, 1).CGColor];
        [GRLab.layer setBorderColor:RGBA(216, 216, 216, 1).CGColor];
        [GRLab setTextColor:RGBA(74, 74, 74, 1)];
        isGR = NO;
    }
}

#pragma mark - 时间倒计时 结束显示获取验证码
-(void)changeTimeAtTimedisplay
{
    time --;
    timeLab.text = [NSString stringWithFormat:@"重新获取(%d)", time];
    timeLab.backgroundColor = RGBA(216, 216, 216, 1);
    timeLab.textColor = RGBA(145, 145, 145, 1);
    getConfirmBtn.userInteractionEnabled = NO;
    if(time == 0){
        time = TIME;
        [timer invalidate];
        timeLab.text = @"获取验证码";
        timeLab.textColor = RGBA(251, 144, 2, 1);
        timeLab.backgroundColor = RGBA(251, 144, 2, 0.3);
        getConfirmBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - 注册 点击按钮发送 验证码
-(void)getConfirmMessageClick
{
    if (![self checkTelephoneNumber]) {
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeAtTimedisplay) userInfo:nil repeats:YES];
    [timer fire];
    //token是token规则：md5($mobile前3位+t+‘xzl1998’)
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*tStr = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSString * mobilrStr = [userName.text substringToIndex:3];
    NSString * tokenStr = [NSString stringWithFormat:@"%@%@%@",mobilrStr,tStr,@"xzl1998"];
    tokenStr = [NSString md5:tokenStr];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:userName.text,@"mobile",tStr,@"t",tokenStr,@"token", nil];
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //http://api.xzhiliao.cn/api /account/send_sms ?mobile=15726425299&t=111111&token=e80ac1ee1e3269f00c6b934ff82b4634
    NSString * url = kCombineURL(kTestAPPAPIGR, @"/api/account/send_sms");
    [XZLNetWorkUtil requestPostURLWithoutAddingParams:url params:params success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error"]];
            NSLog(@"验证码是%@",responseObject[@"data"]);
            qrCodeStr = responseObject[@"data"];
            if (responseObject&&error.integerValue==0) {
                //发送成功
                ghostView.message = @"发送验证码成功,请及时在手机上查看";
                [ghostView show];
            }else{
                ghostView.message = responseObject[@"msg"];
                [ghostView show];
            }
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];
    
}

#pragma mark - 注册按钮确定点击
-(void)sureBtnClick
{
    if (![self checkTelephoneNumber]) {
        return;
    }
    if (![self checkPassWord]) {
        return;
    }
    
    if (qrCodeTf.text.length == 0) {
        ghostView.message = @"请输入验证码";
        [ghostView show];
        return;
    }
    if (![qrCodeTf.text isEqualToString:qrCodeStr]) {
        mGhostView(nil, @"验证码输入有误");
        return;
    }
    if (isSelected == NO){
        ghostView.message = @"您还未同意用户协议";
        [ghostView show];
        return;
    }
    //    http://api.xzhiliao.cn/api/account/register?mobile=15726425399&type=2&access_token=df48bc01df5c6e50e0dc10398c268d61&imei=asdfhy34hf9asdhfoq83yf9afadsf&password=123456
    //mobile+密码 md5之后再和imei拼字符串再 md5以下 作为access_token的值
    NSString *codeMobileAndPsw = [NSString stringWithFormat:@"%@%@",userName.text,userPsw.text];
    codeMobileAndPsw = [NSString md5:codeMobileAndPsw];
    NSString * code = [NSString stringWithFormat:@"%@%@",codeMobileAndPsw,IMEI];
    code = [NSString md5:code];
    NSString * typeStr = @"2";
    if (isGR == NO) {
        typeStr = @"3";
    }else{
        typeStr = @"2";
    }
    if (cityStr.length == 0) {
        cityStr = @"1111";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:userName.text,@"mobile",userPsw.text,@"password",userInviteCode.text,@"inviter_code",cityStr,@"city_code", code,@"access_token",typeStr,@"type",IMEI,@"imei", nil];
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url = kCombineURL(kTestAPPAPIGR, @"/api/account/register")
    [XZLNetWorkUtil requestPostURL:url params:params success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue==0) {
                mGhostView(nil, @"注册成功");
                NSDictionary *dataDic = responseObject[@"data"];
                NSDictionary *dicUser = [dataDic valueForKey:@"user"];
                [XZLUserInfoTool setToken:[dataDic valueForKey:@"token"]];
                [XZLUserInfoTool setUserInfo:dicUser];
                [mUserDefaults setValue:@"1" forKey:@"isLogin"];
                if ([[dicUser valueForKey:@"name"] isNullOrEmpty]) {
                    [mUserDefaults setValue:[NSString stringWithFormat:@"用户%@",[dicUser valueForKey:@"mobile"]] forKey:@"name"];
                }
                //发送通知注册成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSucceed" object:nil];
                //更新用户信息
                [XZLUserInfoTool updateUserInfo];
                
                [self pushBaiduUserInfoToWeb];
                //注册成功
                if (isGR == YES) {
                    [XZLUserInfoTool setGRStatus:@"0"];
                    GRPreBookViewController *vc = [GRPreBookViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    [XZLUserInfoTool setGRStatus:@"1"];
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app SetRootVC:@"1"];
                    return ;
                }
                
                
                
            }else{
                mGhostView(nil, responseObject[@"message"]);
            }
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"注册失败,请稍后重试";
        [ghostView show];
        
    }];
}

-(void)pushBaiduUserInfoToWeb{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kTestToken,@"token",[mUserDefaults valueForKey:@"BChannelId"],@"pusherId",[mUserDefaults valueForKey:@"BUserId"],@"pusherUserId",@"2",@"pusherType",nil];
    
    //    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (params.count<4) {
        NSLog(@"%@",@"少侠这是模拟器吧");
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/account/push/create"];
    [XZLNetWorkUtil requestPostURL:url params:params success:^(id responseObject){
        //        [self.hud hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"responseObject is %@",responseObject);
            NSString *error_code = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if ([error_code isEqualToString:@"0"]) {
                NSDictionary *dic = responseObject[@"data"];
                //                [self testForNoti];
            }else{
                //                mAlertView(@"", @"该企业不能注册");
            }
        }
    }failure:^(NSError *error){
        NSLog(@"error is %@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***检测是否是正确的电话号码***/
- (BOOL)checkTelephoneNumber
{
    NSString *str = userName.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    userName.text = str;
    
    if (userName.text.length == 0) {//判断是否为空
        ghostView.message = @"手机号码不能为空";
        [ghostView show];
        return NO;
    }
    
    //判断是否是11位
    if (userName.text.length != 11){
        ghostView.message = @"手机号码格式错误，请输入真实有效的信息";
        [ghostView show];
        return NO;
    }
    
    //    NSString *subNumber = [insertWordField.text substringWithRange:NSMakeRange(0, 3)];
    //    NSArray *telArray = [NSArray arrayWithObjects:@"134",@"135",@"144",@"136",@"137",@"138",@"139",@"147",@"150",@"151",@"152",@"157",@"170",@"158",@"159",@"182",@"183",@"184",@"187",@"188",@"130",@"131",@"132",@"156",@"185",@"186",@"145",@"133",@"153",@"180",@"181",@"189", nil];
    
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    BOOL isMobile = [phoneTest evaluateWithObject:userName.text];
    
    //判断手机前三位
    if (isMobile) {
        return YES;
    }
    else
    {
        ghostView.message = @"手机号码格式错误，请输入真实有效的信息";
        [ghostView show];
        return NO;
    }
}

- (BOOL)checkPassWord
{
    if (userPsw.text.length == 0) {//判断是否为空
        ghostView.message = @"新密码不能为空";
        [ghostView show];
        return NO;
    }
    
    if (userPsw.text.length == 0) {//判断是否为空
        ghostView.message  = @"新密码不能为空";
        [ghostView show];
        return NO;
    }else if(userPsw.text.length < 6){
        ghostView.message = @"新密码长度不能小于六位";
        [ghostView show];
        return NO;
    }else if(userPsw.text.length > 10){
        ghostView.message = @"新密码长度不能大于十位";
        [ghostView show];
        return NO;
    }
    return YES;
}

-(void)agreeImgBtnClick:(UIButton *)button
{
    if (button.selected == YES) {
        isSelected = NO;
        button.selected = NO;
        agreeImgV.image = [UIImage imageNamed:@"GRRegister_dis"];
    }else if (button.selected == NO){
        isSelected = YES;
        button.selected = YES;
        agreeImgV.image = [UIImage imageNamed:@"GR_Agree"];
    }
}

-(void)seeAgreementBtnClick
{
    UserAgreementViewController * vc = [[UserAgreementViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DataTOjsonString
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
#pragma mark - 定位
-(void)startLocation{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.labelText = @"正在定位当前城市...";
    if (![CLLocationManager locationServicesEnabled] )
    {
        ghostView.message = @"定位失败，请手动选择城市！";
        [ghostView show];
        loadView.hidden = YES;
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        ghostView.message =@"请允许使用你的地理位置！";
        [ghostView show];
        loadView.hidden = YES;
    }
    else
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        [_locationManager startUpdatingLocation];
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    loadView.hidden = YES;
    [_locationManager stopUpdatingLocation];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f 纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    //_latitude = newLocation.coordinate.latitude;
    //_longitude = newLocation.coordinate.longitude;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&[placemarks count] > 0) {
            for (CLPlacemark * placemark in placemarks) {
                NSDictionary *test = [placemark addressDictionary];
                //  Country(国家)  State(省) City(城市)  SubLocality(区)
               NSString * cityNameStr = [test objectForKey:@"City"];
                cityNameStr = [cityNameStr substringToIndex:cityNameStr.length-1];
                cityStr = [XZLUtil getCityCodeWithCityName:cityNameStr];
//                [mUserDefaults setObject:cityStr forKey:@"localCity"];
//                _locationLabel.text = cityStr;
                
            }
        }
        else if (error == nil &&
                 [placemarks count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    loadView.hidden = YES;
   cityStr = @"1111";
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
