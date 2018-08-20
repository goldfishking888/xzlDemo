//
//  VerifyPhoneViewController.m
//  JobKnow
//
//  Created by Jiang on 15/10/19.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "XZLUtil.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ProtocolViewController.h"
#import "PassWordViewController.h"
#import "HRloginMima.h"
#import "MBProgressHUD.h"
#import "HR_RegistHRWhenRegistedGerenVC.h"


@interface VerifyPhoneViewController ()<UITextFieldDelegate>{
    TPKeyboardAvoidingScrollView *_scrollView;
    UITextField *_phoneTF;
    UILabel *_sendCodeLabel;// 发送验证码
    UITextField *_verifyCodeTF;
    unsigned _sec;// 60秒计时
    NSTimer *_timer;
    OLGhostAlertView *_ghost;
    UIButton *_protocolBtn;// 协议按钮
    MBProgressHUD *_loadView;
    
}

@end

@implementation VerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"验证手机号码"];
    
    _sec = 60;
    _ghost = [[OLGhostAlertView alloc] init];
    _ghost.position = OLGhostAlertViewPositionCenter;
    _ghost.timeout = 2;
    
    _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, ios7jj+44, iPhone_width, iPhone_height-ios7jj-44)];
    _scrollView.backgroundColor = kBackgroundColor;
    [self.view addSubview:_scrollView];
    
    //请输入手机号码
    UIView *phoneBg = [[UIView alloc] initWithFrame:CGRectMake(10,10, (iPhone_width-20)/3*2, 40)];
    [phoneBg setBackgroundColor:[UIColor whiteColor]];
    [phoneBg.layer setCornerRadius:5];
    [_scrollView addSubview:phoneBg];
    _phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(20,10+5, (iPhone_width-20)/3*2-20, 30)];
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.placeholder = @"请输入手机号码";
    _phoneTF.font = [UIFont systemFontOfSize:16];
    _phoneTF.delegate = self;
    _phoneTF.tag = 1753;
    [_scrollView addSubview:_phoneTF];
    
    // 获取验证码
    _sendCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(iPhone_width-20)/3*2+8,10, (iPhone_width-20)/3-8, 40)];
    _sendCodeLabel.textColor = [UIColor whiteColor];
    _sendCodeLabel.font = [UIFont systemFontOfSize:14];
    _sendCodeLabel.textAlignment = NSTextAlignmentCenter;
    [self changeVerifyCodeLabel];
    [_sendCodeLabel.layer setCornerRadius:5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendVerifyCode)];
    [_sendCodeLabel addGestureRecognizer:tap];
    [_scrollView addSubview:_sendCodeLabel];
    
    // 请输入验证码
    UIView *codeBg = [[UIView alloc] initWithFrame:CGRectMake(10, 10+40+10, (iPhone_width-20), 40)];
    [codeBg setBackgroundColor:[UIColor whiteColor]];
    [codeBg.layer setCornerRadius:5];
    [_scrollView addSubview:codeBg];
    _verifyCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 10+40+10+5, (iPhone_width-40), 30)];
    _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTF.placeholder = @"请输入验证码";
    _verifyCodeTF.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:_verifyCodeTF];
    
    // 下一步
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, 130, iPhone_width-20, 40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor orangeColor]];
    [nextBtn.layer setCornerRadius:5];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:nextBtn];
    
    // 我已阅读选择框
    _protocolBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _protocolBtn.frame=CGRectMake(15, 180, 30, 30);
    [_protocolBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [_protocolBtn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
    [_protocolBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateSelected];
    [_protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_protocolBtn setSelected:YES];
    [_scrollView addSubview:_protocolBtn];
    
    // 我已阅读
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(45, 180, 100, 30)];
    label.font=[UIFont systemFontOfSize:13];
    label.text=@"我已阅读并遵守";
    [_scrollView addSubview:label];
    
    // 查看用户协议
    UIButton *seeProtocolBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    seeProtocolBtn.frame=CGRectMake(135, 180, 150, 30);
    seeProtocolBtn.titleLabel.font = [UIFont systemFontOfSize: 13];
    [seeProtocolBtn setTitle:@"小职了用户使用协议" forState:UIControlStateNormal];
    [seeProtocolBtn setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
    seeProtocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [seeProtocolBtn addTarget:self action:@selector(seeProtocol) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:seeProtocolBtn];
}
- (void)dealloc{
    if (_timer) {
        [_timer invalidate];
    }
}

#pragma mark - 获取验证码&x秒后可重发
- (void)changeVerifyCodeLabel{
    if (_sec == 60) {
        _sendCodeLabel.text = @"获取验证码";
        _sendCodeLabel.backgroundColor = [UIColor orangeColor];
        _sendCodeLabel.userInteractionEnabled = YES;
    }else{
        _sendCodeLabel.text = [NSString stringWithFormat:@"%d秒后可重发",_sec];
        _sendCodeLabel.backgroundColor = [UIColor lightGrayColor];
        _sendCodeLabel.userInteractionEnabled = NO;
    }
}

-(void)changeTime{
    _sec --;
    if(_sec == 0){
        _sec = 60;
        [_timer invalidate];
        [self changeVerifyCodeLabel];
    }else{
        [self changeVerifyCodeLabel];
    }
}

#pragma mark - 点击发送

- (void)sendVerifyCode{
    if ([XZLUtil isValidateMobile:_phoneTF.text] == NO) {
        _ghost.message = @"请输入正确的手机号码";
        _ghost.position = OLGhostAlertViewPositionCenter;
        [_ghost show];
        return;
    }
    NSString * roleStr = nil;// role: 1 HR 2个人 3猎手
    if ([_registerModel.registType isEqualToString:@"1"]) {// 个人
        roleStr = @"2";
    }else if ([_registerModel.registType isEqualToString:@"2"]){// HR
        roleStr = @"1";
    }else if ([_registerModel.registType isEqualToString:@"3"]){// 猎手
        roleStr = @"3";
    }
    
    //新增验证参数 token = md5(@"xzl_20121215"+imei3-10位+手机号)
    NSString *imei = IMEI;
    NSString *token = [NSString stringWithFormat:@"%@%@%@",@"xzl_20121215",[imei substringWithRange:NSMakeRange(2, 8)],_phoneTF.text];
    token = [NSString md5:token];
    //发送验证码协议
    NSMutableDictionary *paramDic = @{@"phone":_phoneTF.text,@"role":roleStr,@"version":[XZLUtil currentVersion],@"token":token,@"userImei":imei};
    NSString *url = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"common/send_sms/captcha_verify"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = responseObject[@"error"];
            NSString *msg = responseObject[@"msg"];
            // NSString *outLimit = responseObject[@"outLimit"];
            if ([error intValue] == 200) {
                _ghost.message = msg;
                [_ghost show];
                if (_timer) {
                    [_timer invalidate];
                }
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
                [_timer fire];
                [_sendCodeLabel setUserInteractionEnabled:NO];
            }else if([error intValue] == 203){
                _ghost.message = @"该手机号已注册过小职了";
                [_ghost show];
            }else{
                _ghost.message = msg;
                [_ghost show];
            }
        }else{
            _ghost.message = @"网络错误，请稍后重试";
            [_ghost show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _ghost.message = @"网络错误，请稍后重试";
        [_ghost show];
    }];
}

#pragma mark - 下一步
- (void)nextBtnClick{
    if ([XZLUtil isValidateMobile:_phoneTF.text] == NO) {
        _ghost.message = @"请输入正确的手机号码";
        [_ghost show];
        return;
    }
    if ([XZLUtil isValidateNumber:_verifyCodeTF.text] == NO) {
        _ghost.message = @"请输入正确的验证码";
        [_ghost show];
        return;
    }
    if (_protocolBtn.isSelected == NO) {
        _ghost.message = @"请阅读并遵守小职了用户使用协议";
        [_ghost show];
        return;
    }
    _registerModel.mobile = _phoneTF.text;
    _registerModel.verifyCode = _verifyCodeTF.text;
    
    NSMutableDictionary *paramDic = @{@"mobile":_phoneTF.text,@"captcha":_verifyCodeTF.text,@"version":[XZLUtil currentVersion]};
    _loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"hr_api/hrmanage/isRegister"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        [_loadView hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            NSString *xzlStr =[NSString stringWithFormat:@"%@",responseObject[@"xzl"]];
            if (xzlStr.integerValue == 1) {// 已是求职者，不是HR
                if ([_registerModel.registType isEqualToString:@"1"]) {
                    //此次注册求职者时
                    _ghost.message=@"该手机号已注册";
                    [_ghost show];
                    return;
                }else if([_registerModel.registType isEqualToString:@"2"]){
                    //此次注册HR时已注册个人版
                    HR_RegistHRWhenRegistedGerenVC *vc = [[HR_RegistHRWhenRegistedGerenVC alloc] init];
                    vc.userStr = _registerModel.mobile;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
            }else if(xzlStr.integerValue == 2){// 已是求职者，也是HR
                _ghost.message=@"该手机号已注册";
                [_ghost show];
                return;
            }
            
            if ([error isEqualToString:@"1"])
            {
                _ghost.message=@"该手机号已注册";//审核中
                [_ghost show];
                
            }else if ([error isEqualToString:@"2"])
            {
                _ghost.message=@"该手机号已注册";
                [_ghost show];
                
                
            }else if ([error isEqualToString:@"3"])
            {
                _ghost.message=@"该手机号已注册";
                [_ghost show];
                
            }else if ([error isEqualToString:@"4"])
            {
                _ghost.message=@"该手机号已注册";
                [_ghost show];
                
            }else if ([error isEqualToString:@"5"])
            {
                _ghost.message=@"手机号码错误，请重新输入";
                [_ghost show];
                
            }else if ([error isEqualToString:@"6"])
            {
                if ([_registerModel.registType isEqualToString:@"1"]) {//个人版
                    PassWordViewController *vc = [[PassWordViewController alloc] init];
                    vc.userStr = _registerModel.mobile;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([_registerModel.registType isEqualToString:@"2"]){//hr经理
                    HRloginMima *hvc = [[HRloginMima alloc] init];
                    hvc.PhoneNumber = _registerModel.mobile;
                    [self.navigationController pushViewController:hvc animated:YES];
                }                
            }else if([error isEqualToString:@"8"]){
                _ghost.message = @"验证码错误";
                [_ghost show];
            }
        }

    } failure:^(NSError *error) {
        [_loadView hide:YES];
        _ghost.message = @"网络错误，请稍后重试";
        [_ghost show];
    }];


}

#pragma mark 协议按钮

- (void)protocolBtnClick
{
    if (_protocolBtn.isSelected) {
        [_protocolBtn setSelected:NO];
    }else
    {
        [_protocolBtn setSelected:YES];
    }
}

- (void)seeProtocol     //进入小职了协议界面
{
    ProtocolViewController *protocolVC=[[ProtocolViewController alloc]init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1753) {
        if (textField.text.length >10&&range.length != 1) {
            textField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

@end
