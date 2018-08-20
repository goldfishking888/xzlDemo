//
//  XZLLoginVC.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/27.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "XZLLoginVC.h"
#import "AppDelegate.h"
#import "OLGhostAlertView.h"
#import "MBProgressHUD.h"
#import "SaveCount.h"
#import "SeachViewController.h"
#import "HomeViewController.h"
#import "HR_HomeViewController.h"
#import "XZLUtil.h"
#import "DBHelper.h"
#import "SelectIdentityViewController.h"
#import "NSString+MD5.h"

#import "HRloginMima.h"
#import "GRRegisterViewController.h"//个人注册新界面
#import "XZLCommonWebViewController.h"
#import "XZLPMListModel.h"

#import "XZLFindPassWordViewController.h"

#define HEIGHT_MENU 60
#define HEIGHT_SPACE 15
#define COLOR_TF_BORDER_DEFAULT [[UIColor colorWithHex:0xe0e0e0 alpha:1] CGColor]
#define COLOR_TF_BORDER_SELECTED [[UIColor orangeColor]CGColor]
#define BTN_01_Tag 1101
#define BTN_02_Tag 1102
#define BTN_03_Tag 1103
@interface XZLLoginVC ()<UITextFieldDelegate, UITextViewDelegate,UIApplicationDelegate,ASIHTTPRequestDelegate>
{
    
    UIView *Hrheng;
    //    UIView *otherView;
    UIButton *yourButton;
    
    
    UITextField * userName;
    UITextField * userPsw ;
    OLGhostAlertView *ghostView;
    MBProgressHUD *loadView;
    
    int _loginType;// 登录类型 2个人 3猎头顾问
}


@end

@implementation XZLLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取审核更新状态
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AppStoreCheck" object:@1];
    //    [self addBackBtn];
    //    [self addTitleLabel:@"登录"];
    //    [self addBackBtnGR];
    [self addTitleLabelGR:@"登录"];
    //    [self addRightkBtn:@"注册"];
    
    //默认是求职者
    _loginType = 2;
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.3 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor= RGBA(255, 255, 255, 1);
    UIView *HrView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, self.view.frame.size.height)];
    HrView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:HrView];
    
    UIImageView * XZLImageV = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 50, 35, 100, 50)];
    XZLImageV.image = [UIImage imageNamed:@"Login_logoIcon"];
    [HrView addSubview:XZLImageV];
    
    // 2个类型按钮
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, XZLImageV.frame.origin.y + XZLImageV.frame.size.height + 30, ([[UIScreen mainScreen] bounds].size.width)/2, 40)];// 我是求职者
    btn1.tag = BTN_01_Tag;
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn1 setTitleColor:RGBA(255, 146, 4, 1) forState:UIControlStateNormal];
    [btn1 setTitle:@"人才登录" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(ChangeLoginType:) forControlEvents:UIControlEventTouchUpInside];
    [HrView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width)/2, btn1.frame.origin.y, ([[UIScreen mainScreen] bounds].size.width)/2, 40)];// 我是人事经理
    btn2.tag = BTN_02_Tag;
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn2 setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
    [btn2 setTitle:@"猎头顾问登录" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(ChangeLoginType:) forControlEvents:UIControlEventTouchUpInside];
    [HrView addSubview:btn2];
    
    Hrheng=[[UIView alloc]initWithFrame:CGRectMake(btn1.frame.size.width / 2 - 50,btn1.frame.origin.y + btn1.frame.size.height, 100, 2)];
    Hrheng.backgroundColor=[UIColor orangeColor];
    //    Hrheng.frame=CGRectMake(btn1.frame.origin.x,XZLImageV.frame.origin.y + XZLImageV.frame.size.height + 35 + HEIGHT_MENU, ([[UIScreen mainScreen] bounds].size.width)/2, 2);
    [HrView addSubview:Hrheng];
    
    //账号、密码
    UIView * bgUserNameV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 150,64+ XZLImageV.frame.origin.y + XZLImageV.frame.size.height + 20 +HEIGHT_MENU +HEIGHT_SPACE , 300, 45)];
    bgUserNameV.layer.cornerRadius=4.0f;
    bgUserNameV.layer.masksToBounds=YES;
    bgUserNameV.layer.borderWidth= 1.0f;
    bgUserNameV.layer.borderColor=COLOR_TF_BORDER_DEFAULT;
    [self.view addSubview:bgUserNameV];
    
    UIImageView * userIconImgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 14, 17, 16)];
    userIconImgV.image = [UIImage imageNamed:@"Login_icon_shape"];
    [bgUserNameV addSubview:userIconImgV];
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 300 - 42, 45)];
    userName.placeholder = @"手机号";
    userName.clearButtonMode = UITextFieldViewModeAlways;
    userName.delegate=self;
    userName.tag = 2;
    [bgUserNameV addSubview:userName];
    
    
    UIView * bgUserPswV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 150,bgUserNameV.frame.origin.y + bgUserNameV.frame.size.height + 20, 300, 45)];
    bgUserPswV.layer.cornerRadius=4.0f;
    bgUserPswV.layer.masksToBounds=YES;
    bgUserPswV.layer.borderWidth= 1.0f;
    bgUserPswV.layer.borderColor=COLOR_TF_BORDER_DEFAULT;
    [self.view addSubview:bgUserPswV];
    
    UIImageView * lockImgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 18, 20)];
    lockImgV.image = [UIImage imageNamed:@"Login_invalidName"];
    [bgUserPswV addSubview:lockImgV];
    
    userPsw = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 300 - 42, 45)];
    userPsw.delegate=self;
    userPsw.placeholder = @"请输入密码";
    userPsw.clearButtonMode = UITextFieldViewModeAlways;
    userPsw.secureTextEntry = YES;
    userPsw.clearsOnBeginEditing = NO;
    [bgUserPswV addSubview:userPsw];
    
    //登录
    UIButton *login=[UIButton buttonWithType:UIButtonTypeSystem];
    login.frame=CGRectMake(iPhone_width / 2 - 150, bgUserPswV.frame.origin.y + bgUserPswV.frame.size.height + 30, 300, 45);
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [login.layer setCornerRadius:login.frame.size.height / 2];
    [login.layer setMasksToBounds:YES];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [login setBackgroundColor:[UIColor orangeColor]];
    [login setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.view addSubview:login];
    
    //立即注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width)/2 - 55 - 70, login.frame.origin.y + login.frame.size.height + 25, 70, 30);
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setBackgroundColor:[UIColor clearColor]];
    [registerBtn setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    
    //忘记密码
    UIButton *forget=[UIButton buttonWithType:UIButtonTypeSystem];
    forget.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width)/2 + 55,registerBtn.frame.origin.y, 70, 30);
    [forget setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize: 13.0];
    [forget addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    [forget setBackgroundColor:[UIColor clearColor]];
    [forget setTitleColor:RGBA(155, 155, 155, 1) forState:UIControlStateNormal];
    [self.view addSubview:forget];
    
    //企业版登录
    yourButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yourButton.frame=CGRectMake(0, self.view.frame.size.height - 85, [[UIScreen mainScreen] bounds].size.width, 55);
    [yourButton addTarget:self action:@selector(qyLogin) forControlEvents:UIControlEventTouchUpInside];
    [yourButton setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(yourButton.frame.size.width / 2 - 52, 20, 86, 15)];
    titleLab.text = @"企业账号登录";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = RGBA(255, 163, 29, 1);
    [yourButton addSubview:titleLab];
    
    UIImageView * rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x + titleLab.frame.size.width + 5, titleLab.frame.origin.y, 15, 15)];
    rightImgV.image = [UIImage imageNamed:@"Login_rightarrow_icon"];
    [yourButton addSubview:rightImgV];
    
    UIView * lineLeftV = [[UIView alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x - 72, titleLab.frame.origin.y + titleLab.frame.size.height / 2 - 1, 60, 1)];
    lineLeftV.backgroundColor = RGBA(225, 225, 225, 1);
    [yourButton addSubview:lineLeftV];
    UIView * lineRightV = [[UIView alloc]initWithFrame:CGRectMake(rightImgV.frame.origin.x +rightImgV.frame.size.width + 12, titleLab.frame.origin.y + titleLab.frame.size.height / 2 - 1, 60, 1)];
    lineRightV.backgroundColor = RGBA(225, 225, 225, 1);
    [yourButton addSubview:lineRightV];
    //    [self.view addSubview:otherView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *str_username = [mUserDefaults valueForKey:@"mobile"];
    userName.text = str_username?str_username:@"";
    
}


//#pragma mark - 返回按钮
//
//- (void)backUp:(id)sender
//{
//    [self.view endEditing:YES];
//    if([self.backType isEqualToString:@"BackPersonalVC"]){
//
//        NSNotification *notification = [NSNotification notificationWithName:@"ResetSiXinCount" object:nil userInfo:[NSDictionary dictionaryWithObject:@"logout" forKey:@"logout"]];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//        [[NSUserDefaults standardUserDefaults] setObject:@"GeRen" forKey:@"LoginType"];
//        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"LoginNew"];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [app setRootVC];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark 注册事件
-(void)registerBtnClick:(UIButton *)button
{
    //    SelectIdentityViewController *hvc = [[SelectIdentityViewController alloc] init];
    //    [self.navigationController pushViewController:hvc animated:YES];
    GRRegisterViewController * GRRegVC = [[GRRegisterViewController alloc]init];
    [self.navigationController pushViewController:GRRegVC animated:YES];
}

#pragma mark 忘记密码
-(void)forget{
    
//    XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
//    vc.titleStr = @"忘记密码";
//    NSString *url = kCombineURL(kTestAPPAPIGR, @"/web/account/reset_password");
//    vc.urlStr = url;
//    [self.navigationController pushViewController:vc animated:YES];
    XZLFindPassWordViewController *vc = [XZLFindPassWordViewController new];
    [self.navigationController pushViewController:vc animated:YES];

    
}
#pragma mark 企业版登录
-(void)qyLogin{
    
    NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
    
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        //如果未安装
        OLGhostAlertView *ghost = [[OLGhostAlertView alloc] initWithTitle:nil message:@"请先安装小职了企业版" timeout:1 dismissible:YES];
        ghost.position = OLGhostAlertViewPositionCenter;
        [ghost show];
        
    }else{
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
}

#pragma mark 选择登录类型

-(void)ChangeLoginType:(UIButton*)sender{
    for (UIView * obj in sender.superview.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * thisBtn = (UIButton *)obj;
            [thisBtn setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
        }
    }
    if (sender.tag == BTN_01_Tag) {
        
        _loginType = 2;
        Hrheng.frame = CGRectMake(sender.frame.origin.x + sender.frame.size.width / 2 - 50, sender.frame.origin.y + sender.frame.size.height, 100, 2);
        [yourButton removeFromSuperview];
        [sender setTitleColor:RGBA(255, 146, 4, 1) forState:UIControlStateNormal];
        //        [self.view addSubview:otherView];
        
    }else if(sender.tag == BTN_02_Tag){
        
        _loginType = 3;
        Hrheng.frame = CGRectMake(sender.frame.origin.x + sender.frame.size.width / 2 - 50,sender.frame.origin.y + sender.frame.size.height, 100, 2);
        [sender setTitleColor:RGBA(255, 146, 4, 1) forState:UIControlStateNormal];
        //        [otherView removeFromSuperview];
        NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [self.view addSubview:yourButton];
        }
        
        
    }
}

#pragma mark 登录按钮

-(void)login{
    [self.view endEditing:YES];
    [XZLUserInfoTool setGRStatus:@"0"];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app SetRootVC:@"0"];
//    if (![self checkTelephoneNumber]) {
//        return;
//    }
//
//    if (userName.text.length == 0) {
//        ghostView.message = @"请输入用户名/邮箱/手机号！";
//        [ghostView show];
//        return;
//    }
//    if (userPsw.text.length == 0) {
//        ghostView.message = @"请输入密码！";
//        [ghostView show];
//        return;
//    }
//    //http://api.xzhiliao.cn/api/account/login ?username=15726425399&type=2&imei=asdfhy34hf9asdhfoq83yf9afadsf&password=123456
//    NSString * typeStr = @"2";
//    if (_loginType == 3) {
//        typeStr = @"3";
//    }else{
//        typeStr = @"2";
//    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:userName.text,@"username",userPsw.text,@"password",typeStr,@"type",IMEI,@"imei", nil];
//    NSLog(@"params is %@",params);
//    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/account/login");
//    [XZLNetWorkUtil requestPostURL:urlstr params:params success:^(id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//            [loadView hide:YES];
//            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
//            [ghostView show];
//            if (error.integerValue==0) {
//                mGhostView(nil, @"登录成功");
//                if ([userName.text isEqualToString:@"15806523466"]) {
//                    [mUserDefaults setValue:HideForCheck_Value forKey:HideForCheck];
//                }
//                NSDictionary *dataDic = responseObject[@"data"];
//                NSDictionary *dicUser = [dataDic valueForKey:@"user"];
//
//                [XZLUserInfoTool setToken:[dataDic valueForKey:@"token"]];
//                [XZLUserInfoTool setUserInfo:dicUser];
//                if ([[dicUser valueForKey:@"name"] isNullOrEmpty]) {
//                    [mUserDefaults setValue:[NSString stringWithFormat:@"用户%@",[dicUser valueForKey:@"mobile"]] forKey:@"name"];
//                }
//                [mUserDefaults setValue:@"1" forKey:@"isLogin"];
//                //发送通知登录成功
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSucceed" object:nil];
//                //更新用户信息
//                [XZLUserInfoTool updateUserInfo];
//
//                if (_loginType == 2) {
//                    //个人
//                    [XZLUserInfoTool setGRStatus:@"0"];
//                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [app SetRootVC:@"0"];
//                }else{
//                    [XZLUserInfoTool setGRStatus:@"1"];
//                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [app SetRootVC:@"1"];
//                }
//                //登录成功后切换数据库
//                [[DBHelper shareInstance] switchDatabase];
//                [self pushBaiduUserInfoToWeb];
//            }else{
//                NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
//                ghostView.message = msg;
//            }
//        }
//    } failure:^(NSError *error) {
//        [loadView hide:YES];
//        ghostView.message = @"登录失败，请稍后重试";
//        [ghostView show];
//
//    }];
}

-(void)pushBaiduUserInfoToWeb{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kTestToken,@"token",[mUserDefaults valueForKey:@"BChannelId"],@"pusherId",[mUserDefaults valueForKey:@"BUserId"],@"pusherUserId",@"2",@"pusherType",nil];
    NSLog(@"%@",params);
//    mAlertView(@"channelId", [mUserDefaults valueForKey:@"BChannelId"]);
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

#pragma mark - UIResponder
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    textField.layer.borderColor=COLOR_TF_BORDER_SELECTED;
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor=COLOR_TF_BORDER_DEFAULT;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 2) {
        if (textField.text.length >10&&range.length != 1) {
            textField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    return YES;
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

@end
