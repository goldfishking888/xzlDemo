//
//  HRregistChooseTradeVC.m
//  JobKnow
//
//  Created by Mathias on 15/7/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRregistChooseTradeVC.h"
#import "XZLJobVC.h"
#import "XZLLocationVC.h"
#import "XZLLocaRead.h"
//#import "HrHomeVC.h"
#import "HR_HomeViewController.h"
#import "SaveCount.h"

#import "AppDelegate.h"
#import "XZLUtil.h"
#import "DBHelper.h"
#import "NSString+MD5.h"

@interface HRregistChooseTradeVC ()<XZLjobVCDelegate,XZLLocationVCDelegate>
{
    UIButton *yourButton;//行业
    
    UIButton *yourButton1;//城市
    
    UILabel *labelhangye;//行业
    UILabel *labelchengshi;//城市
    
    UIImageView *imageviews;//小箭头
    
    OLGhostAlertView *ghostView;
    MBProgressHUD *loadView;
}
@end

@implementation HRregistChooseTradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
//    [self addTitleLabel:@"完善信息"];
    [self addTitleLabel3:@"完善信息"];
    // Do any additional setup after loading the view.
    
     self.view.backgroundColor=[UIColor colorWithRed:243 green:243 blue:243 alpha:1];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.3 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;

    
    //小箭头
    imageviews=[[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-40 , 94, 20, 20)];
    imageviews.image=[UIImage imageNamed:@"arrow_gray_right"];
    
    [self.view addSubview:imageviews];
    
    
    //小箭头
    imageviews=[[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-40 , 144, 20, 20)];
    imageviews.image=[UIImage imageNamed:@"arrow_gray_right"];
    
    [self.view addSubview:imageviews];
    
    
    //行业
    [self addBackBtn];
     labelhangye=[[UILabel alloc]initWithFrame:CGRectMake(60, 84, iPhone_width-100, 40)];
    
    labelhangye.text=@"请选择行业";
    
    labelhangye.textAlignment=NSTextAlignmentRight;
    labelhangye.font=[UIFont systemFontOfSize:14];
    
    [self.view addSubview:labelhangye];
    
    
    
    //城市
    
    labelchengshi=[[UILabel alloc]initWithFrame:CGRectMake(40, 134, [[UIScreen mainScreen] bounds].size.width-80, 40)];
    
    labelchengshi.text=@"青岛";
    
    labelchengshi.textAlignment=NSTextAlignmentRight;
    labelchengshi.font=[UIFont systemFontOfSize:14];
    
    [self.view addSubview:labelchengshi];
    
    //选择行业
    yourButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yourButton.frame=CGRectMake(20, 84, [[UIScreen mainScreen] bounds].size.width-40, 40);
    
    [yourButton setTitle:@"行业 :" forState:UIControlStateNormal];
    yourButton.layer.borderWidth = 1.5;
    
    yourButton.layer.cornerRadius = 4.5;
   
    
    [yourButton addTarget:self action:@selector(hangye:) forControlEvents:UIControlEventTouchUpInside];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 0.1  });
   
    yourButton.layer.borderColor = borderColorRef;
    [yourButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    yourButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    yourButton.contentEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    
     [self.view addSubview:yourButton];
    
    
   //选择城市
    yourButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    yourButton1.frame=CGRectMake(20, 134, [[UIScreen mainScreen] bounds].size.width-40, 40);
    
       yourButton1.contentEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [yourButton1 setTitle:@"城市 :" forState:UIControlStateNormal];
    yourButton1.layer.borderWidth = 1.5;
   
    yourButton1.layer.cornerRadius = 4.5;
  
    
    [yourButton1 addTarget:self action:@selector(chengshi:) forControlEvents:UIControlEventTouchUpInside];
    
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
   
    CGColorRef borderColorRef1 = CGColorCreate(colorSpace1,(CGFloat[]){ 0, 0, 0, 0.1 });
    
    yourButton1.layer.borderColor = borderColorRef1;
    [yourButton1 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    yourButton1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    [self.view addSubview:yourButton1];
    
    
  //注册按钮
    
    UIButton *regest=[UIButton buttonWithType:UIButtonTypeSystem];
    regest.frame=CGRectMake(15, 240, ([[UIScreen mainScreen] bounds].size.width)-30, 50);
    
    [regest setTitle:@"注册" forState:UIControlStateNormal];
    
    [regest addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    
    [regest setBackgroundColor:[UIColor orangeColor]];
    
    [regest setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    [self.view addSubview:regest];
}

-(void)hangye:(UIButton *)sender{
    
    NSLog(@"选择行业");
    XZLJobVC *pvc = [[XZLJobVC alloc] init];
    pvc.delegate =self;
    [self.navigationController pushViewController:pvc animated:YES];
        
}

-(void)chengshi:(UIButton *)sender{
    
    NSLog(@"选择城市");
    XZLLocationVC *lvc = [[XZLLocationVC alloc] init];
    lvc.delegate = self;
    [self.navigationController pushViewController:lvc animated:YES];
    
}

-(void)regist:(UIButton *)sender{
    
    NSLog(@"注册");
    if ([labelhangye.text isEqualToString:@"请选择行业"]) {
        mGhostView(nil, @"请选择行业")
        return;
    }if ([labelchengshi.text isEqualToString:@"请选择城市"]) {
    mGhostView(nil, @"请选择城市")
        return;
    }
    [self Registrequest];
    
}
//协议
- (void)getjobstr:(NSString *)jobstr
{
    labelhangye.text = jobstr;
}
- (void)getLocationStr:(NSString *)locationstr
{
    labelchengshi.text = locationstr;
}
- (void)Registrequest
{

//    Net *n = [Net standerDefault];
//    if (n.status == NotReachable) {
//        ghostView.message = @"无网络连接，请检查您的网络！";
//        [ghostView show];
//        return;
//    }
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled=NO;
//    SaveCount *save=[SaveCount standerDefault];
    XZLLocaRead *read = [[XZLLocaRead alloc] init];
    NSString *url = kCombineURL(KXZhiLiaoAPI, HRRegister);
    
    //md5加密,暂时未加
    //        NSString *tempStr = [NSString md5:[NSString stringWithFormat:@"%@%@",self.userName,self.userPaw]];
    //        tempStr = [NSString md5:[NSString stringWithFormat:@"%@%@",tempStr,IMEI]];
    //       NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"mobile",self.userPaw,@"pass",IMEI,@"userImei",[read getWorkYear:labelhangye.text Num1:3 Num2:2],@"tradeCode",[read getCodeNameStr:labelchengshi.text],@"cityCode",_inviteCode,@"inviteCode",tempStr,@"token",nil];
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"mobile",self.userPaw,@"pass",IMEI,@"userImei",[read getWorkYear:labelhangye.text Num1:3 Num2:2],@"tradeCode",[read getCodeNameStr:labelchengshi.text],@"cityCode",_inviteCode,@"inviteCode",nil];
    if(_isPTJH){
        url = kCombineURL(KXZhiLiaoAPI, PTJHRegister);
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"mobile",self.userPaw,@"pass",IMEI,@"userImei",[read getWorkYear:labelhangye.text Num1:3 Num2:2],@"tradeCode",[read getCodeNameStr:labelchengshi.text],@"cityCode",_inviteCode,@"inviteCode",nil];
    }
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request_hr=[ASIHTTPRequest requestWithURL:URL];
    [request_hr setTimeOutSeconds:25];
    request_hr.delegate=self;
    request_hr.tag = 1;
    [request_hr startAsynchronous];
}

-(void)loginRequest{

    SaveCount *save=[SaveCount standerDefault];
    NSString *url = kCombineURL(KXZhiLiaoAPI, kNewUserLogin);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"userName",self.userPaw,@"userPsw",IMEI,@"userImei",_isPTJH?@"3":@"2",@"loginType",@"1",@"type",save.deviceToken?save.deviceToken:@"",@"pushId",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request_hr=[ASIHTTPRequest requestWithURL:URL];
    [request_hr setTimeOutSeconds:25];
    request_hr.delegate=self;
    request_hr.tag = 2;
    [request_hr startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    [loadView hide:YES];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic in receiveDataFinish and LoginViewController is %@",resultDic);
    
    NSString *errorStr =[resultDic valueForKey:@"error"];
    
    if(request.tag == 1){
        if (resultDic&&resultDic.count!=0&&errorStr.integerValue ==0) { //如果登录成功，error的返回值保存下来
            
//            ghostView.message=@"您尚未注册，请先注册账号";
//            [ghostView show];
            
            [self loginRequest];
            
            return;
        }else if (errorStr.integerValue ==1)
        {
             [loadView hide:YES];
            ghostView.message=@"审核中";
            [ghostView show];
            
            return;
        }else if (errorStr.integerValue ==2)
        {
             [loadView hide:YES];
            ghostView.message=@"审核成功!";
            [ghostView show];
            
            return;
        }else if (errorStr.integerValue ==3)
        {
             [loadView hide:YES];
            ghostView.message=@"审核失败";
            [ghostView show];
            return;
        }else if (errorStr.integerValue ==4)
        {
             [loadView hide:YES];
            ghostView.message=@"此用户已注册，但是审核状态为空，不正常";
            [ghostView show];
            return;
        }else if (errorStr.integerValue ==5)
        {
             [loadView hide:YES];
            ghostView.message=@"不是手机号码，或者长度不够11位";
            [ghostView show];
            return;
        }else if (errorStr.integerValue ==6)
        {
             [loadView hide:YES];
            ghostView.message=@"未注册";
            [ghostView show];
            return;
        }
        
    }else if (request.tag == 2){
//         [loadView hide:YES];
        if (resultDic&&resultDic.count!=0&&errorStr.integerValue ==0){
            if(_isPTJH){
                [HR_LoginSharedTool saveUserInfoDic:resultDic LoginType:@"PTJHunter"];
            }else{
                [HR_LoginSharedTool saveUserInfoDic:resultDic LoginType:@"Hr"];
            }
            
            [XZLUtil sendAliasToJPush];
            
            NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
            [AppUD setObject:self.userName forKey:@"UserName"];//账号
            [AppUD setObject:self.userPaw forKey:@"passWord"];
            [AppUD synchronize];
            
            ghostView.message=@"注册成功";
            [ghostView show];
            
            //登录成功后切换数据库
            [[DBHelper shareInstance] switchDatabase];
            
            NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRUpIP);
            
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
            [request setCompletionBlock:^{
                
                NSError *error;
                
                NSLog(@"登陆成功后记录用户IP成功");
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
                NSString *errorStr =[resultDic valueForKey:@"error"];
                
            }];
            [request setFailedBlock:^{
                NSLog(@"登陆成功后记录用户IP失败");
                
            }];
            [request startAsynchronous];
            NSString * tokenStr = [NSString stringWithFormat:@"%@",resultDic[@"userToken"]];
            NSString * mobileStr = [NSString stringWithFormat:@"%@",resultDic[@"userMobile"]];
            NSString * invitedIdStr = [NSString stringWithFormat:@"%@",resultDic[@"inviteId"]];
            NSString * userEmailStr = [NSString stringWithFormat:@"%@",resultDic[@"userEmail"]];
            [self requestPCPidAndSavedWithToken:tokenStr withMobileStr:mobileStr withinvitedIdStr:invitedIdStr withEmailStr:userEmailStr withType:_isPTJH?@"2":@"3"];
            
            
            return;
        }else if (errorStr.integerValue ==1)
        {
            [loadView hide:YES];
            ghostView.message=@"您尚未注册，请先注册账号";
            [ghostView show];
            
            return;
        }else if (errorStr.integerValue ==2)
        {
            [loadView hide:YES];
            ghostView.message=@"您的密码输入错误!";
            [ghostView show];
            
            return;
        }else if (errorStr.integerValue ==401)
        {
            [loadView hide:YES];
            ghostView.message=@"HR不存在";
            if (_isPTJH) {
                ghostView.message=@"兼职猎手不存在";
            }
            [ghostView show];
            return;
        }

        }
        
}

-(void)afterLoginSucceeded{
    //跳转到HR home页
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setRootVC];
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
            [self performSelector:@selector(afterLoginSucceeded) withObject:nil afterDelay:1];
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];
}


@end
