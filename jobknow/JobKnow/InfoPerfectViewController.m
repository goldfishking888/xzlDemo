//
//  InfoPerfectViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-1.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "InfoPerfectViewController.h"
#import "TipsView.h"
#import "HomeViewController.h"


@interface InfoPerfectViewController ()

@end

@implementation InfoPerfectViewController
NSString * flag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //plist 初始化
        num = ios7jj;
        myUser = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"信息完善"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"信息完善"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    olalterView.position = OLGhostAlertViewPositionCenter;
    
    //[self addTitleLabel:@"信息完善"];
    self.view.backgroundColor=[UIColor clearColor];
    _sexStr = @"1";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 43)];
    _scrollView.contentSize = CGSizeMake(320, iPhone_height - 44);
    // [self.view addSubview:_scrollView];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, iPhone_width - 20, 310)];
    image.image = [UIImage imageNamed:@"resign.png"];
    [self.scrollView addSubview:image];
    
    //***********************************/新的信息完善//*************************/
    [self addBackBtn];
    [self addTitleLabel:@"基本信息"];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = XZHILBJ_colour;
    self.myScrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 43)];
    self.myScrollow.contentSize = CGSizeMake(320, iPhone_height - 42);
    UIImageView*backIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, iPhone_width - 20, 56)];
    backIV.image = [UIImage imageNamed:@"mimaimg.png"];
    [self.myScrollow addSubview:backIV];
    
    UIImageView *imageVe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Input_Base_2.png"]];
    imageVe.frame = CGRectMake(10, 90, iPhone_width - 20, 112);
    [self.myScrollow addSubview:imageVe];
    
    UILabel *tipLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 222, iPhone_width - 30, 40)];
    tipLabel3.text = @"重要求职信息请务必真实填写！手机号码用于人事经理第一时间联系您！";
    tipLabel3.font = font;
    tipLabel3.numberOfLines = 0;
    [tipLabel3 setTextColor:[UIColor grayColor]];
    [tipLabel3 setFont:[UIFont fontWithName:Zhiti size:13]];
    tipLabel3.backgroundColor = [UIColor clearColor];
    [self.myScrollow addSubview:tipLabel3];
    

    //导航上的对号
    UIButton *faBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faBtn.frame = CGRectMake(250, 0, 70, 40);
    [faBtn addTarget:self action:@selector(setUsr) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faBtn];
    UIButton *fasongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fasongBtn addTarget:self action:@selector(setUsr) forControlEvents:UIControlEventTouchUpInside];
    fasongBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [self.view addSubview:fasongBtn];
    
    
    UILabel *label01 = [[UILabel alloc]initWithFrame:CGRectMake(17, 18, 60, 20)];
    label01.backgroundColor = [UIColor clearColor];
    label01.textColor = [UIColor darkGrayColor];
    label01.text = @"姓 名";
    label01.font = [UIFont boldSystemFontOfSize:15];
    [backIV addSubview:label01];
    
    UILabel *label02 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 60, 20)];
    label02.backgroundColor = [UIColor clearColor];
    label02.textColor = [UIColor darkGrayColor];
    label02.text = @"手机号码";
    label02.font = [UIFont boldSystemFontOfSize:14];
    [imageVe addSubview:label02];
    
    label03 = [[UILabel alloc]initWithFrame:CGRectMake(15, 72, 60, 20)];
    label03.backgroundColor = [UIColor clearColor];
    label03.textColor = [UIColor darkGrayColor];
    label03.text = @"邀 请 码";
    label03.font = [UIFont boldSystemFontOfSize:14];
    [imageVe addSubview:label03];
    
    //姓名输入框
    _personName = [[UITextField alloc]initWithFrame:CGRectMake(100, 18, iPhone_width - 140, 20)];
    _personName.tag = 10001;
    NSString *myNamee = [myUser valueForKey:@"userName"];
    if (myNamee == nil) {
        _personName.text = @"";
        self.enter = YES;
    }else{
        self.enter = NO;
        _personName.text = myNamee;
    }
    _personName.returnKeyType = UIReturnKeyNext;
    _personName.font = font;
    _personName.borderStyle = UITextBorderStyleNone;
    _personName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _personName.placeholder = @" 请输入姓名";
    _personName.delegate = self;
    _personName.textColor = [UIColor grayColor];
    _personName.font = [UIFont fontWithName:@"Arial" size:14.0f];
    backIV.userInteractionEnabled = YES;
    [backIV addSubview:_personName];
    
    
    
    //输入手机号码的输入框
    //手机号码输入框
    _telNumber = [[UITextField alloc]initWithFrame:CGRectMake(100, 20, iPhone_width - 140, 20)];
    _telNumber.tag = 10002;
    _telNumber.font = font;
    NSString *myTel = [myUser valueForKey:@"user_tel"];
    if (myTel.length == 0) {
        _telNumber.text = @"";
    }else{
        _telNumber.text = myTel;
    }
    _telNumber.returnKeyType = UIReturnKeyDone;
    _telNumber.borderStyle = UITextBorderStyleNone;
    _telNumber.delegate = self;
    _telNumber.font = [UIFont systemFontOfSize:14];
    _telNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _telNumber.placeholder = @" 请输入手机号";
    _telNumber.keyboardType = UIKeyboardTypeNumberPad;
    _telNumber.textColor = [UIColor grayColor];
    imageVe.userInteractionEnabled = YES;
    [imageVe addSubview:_telNumber];
    
    //邀请码
    _invite = [[UITextField alloc]initWithFrame:CGRectMake(100, 72, iPhone_width - 140, 20)];
    _invite.tag = 10003;
    NSString *inviteName =[myUser valueForKey:@"invitename"];
    //    if (inviteName.length > 0) {
    //        _invite.text = inviteName;
    //        _invite.userInteractionEnabled = NO;
    //        label03.text = @"邀  请  人";
    //    }
    _invite.placeholder = @"邀请码，不知可不填";
    _invite.font = [UIFont systemFontOfSize:14];
    _invite.keyboardType = UIKeyboardTypeNumberPad;
    _invite.textColor = [UIColor grayColor];
    [imageVe addSubview:_invite];
    
    [self.view addSubview:self.myScrollow];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_myScrollow addGestureRecognizer:taps];
    
    
    [self getUsr];
}

//检测字符串
- (BOOL)checkString:(NSString *)str
{
    NSString * regex = [[NSString alloc] initWithFormat:@"^[\u4e00-\u9fa5,0-9]{2,20}$"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (void)changeName:(id)sender
{
    NSNotification *notification = (NSNotification *)sender;
    NSString *s = [notification.userInfo valueForKey:@"uname"];
    _univercity.text = s;
}

//return按钮的执行方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 51)
    {
        if (_subUnivercity.alpha == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                
                if (!iPhone_5Screen) {
                    _scrollView.contentOffset = CGPointMake(0, 200);
                }
                [_subUnivercity becomeFirstResponder];}];
        }
        
    }else if(textField.tag == 10001)
    {
        [self.telNumber becomeFirstResponder];
    }
    else if (textField.tag == 53)
    {
        [textField becomeFirstResponder];
    }else if(textField.tag == 55)
    {
        [_money becomeFirstResponder];
    }else if(textField.tag == 56)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 200);
            [_personName becomeFirstResponder];
        }];
        
    }
    
    
    return YES;
}


//textField的代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _scrollView.frame = CGRectMake(0, 44, iPhone_width, iPhone_height - 260);
    if (seg.selectedSegmentIndex == 0) {
        _scrollView.contentSize = CGSizeMake(iPhone_width, iPhone_height + 100);
    }else
    {
        _scrollView.contentSize = CGSizeMake(iPhone_width, iPhone_height);
    }
    
    
    switch (textField.tag) {
        case 51:
            img_un.image = [UIImage imageNamed:@"textField_1.png"];
            break;
        case 52:
            img_per.image = [UIImage imageNamed:@"textField_1.png"];
            break;
        case 53:
        {
            img_tel.image = [UIImage imageNamed:@"textField_1.png"];
            [UIView animateWithDuration:0.5 animations:^{
                _scrollView.contentOffset = CGPointMake(0, 150);
                
            }];
        }
            break;
        case 54:{
            imageV.image = [UIImage imageNamed:@"textField_1.png"];
            [UIView animateWithDuration:0.5 animations:^{
                _scrollView.contentOffset = CGPointMake(0, 200);
                
            }];}
            
            break;
        case 55:
            subMv.image = [UIImage imageNamed:@"textField_1.png"];
            break;
        case 56:
            moneyMv.image = [UIImage imageNamed:@"textField_1.png"];
            break;
            
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = CGRectMake(0, 44, iPhone_width, iPhone_height - 44);
        _scrollView.contentSize = CGSizeMake(320, 580);
    }];
    img_un.image = [UIImage imageNamed:@"textField_2.png"];
    img_per.image = [UIImage imageNamed:@"textField_2.png"];
    img_tel.image = [UIImage imageNamed:@"textField_2.png"];
    imageV.image = [UIImage imageNamed:@"textField_2.png"];
    subMv.image = [UIImage imageNamed:@"textField_2.png"];
    moneyMv.image = [UIImage imageNamed:@"textField_2.png"];
}


//返回
- (void)backPage:(id)sender
{
    UIAlertView *alertv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有信息尚未提交,确定要返回么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertv show];
    
}




- (BOOL)resultWithTip
{
    if (![self checkString:_personName.text length:8])
    {
        _tipString = @"姓名格式错误，请输入真实有效的信息";
        return NO;
    }
    if (![self isValidateMobile:_telNumber.text])
    {
        _tipString = @"手机号码格式错误，请输入真实有效的信息";
        return NO;
    }
//    
//    else if (_telNumber.text.length == 0 || [self isValidateMobile:_telNumber.text])
//    {
//        _tipString = @"手机号码格式错误，请输入真实有效的信息";
//        [_telNumber becomeFirstResponder];
//        return NO;
//    }
//    if(_telNumber.text.length == 11)
//    {
//        return [self telPhotoNumber];
//    }else
//    {
//        _tipString = @"手机号码格式错误，请输入真实有效的信息";
//        _telNumber.text = @"";
//        [_telNumber becomeFirstResponder];
//        return NO;
//    }
    return YES;
}

- (BOOL)checkString:(NSString *)str length:(NSInteger)l
{
    NSString * regex = [[NSString alloc] initWithFormat:@"^[\u4e00-\u9fa5]{2,%d}$",l];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (BOOL)telPhotoNumber
{
    NSString *num = _telNumber.text;
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    if([phoneTest evaluateWithObject:num]){
        return YES;
    }
    else
    {
        _tipString = @"手机号码格式错误，请输入真实有效的信息";
        _telNumber.text = @"";
        [_telNumber becomeFirstResponder];
        return NO;
    }

}


- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"信息完善Dic====%@",resultDic);
    [loadView setHidden:YES];
    [olalterView hide];
    olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    olalterView.position = OLGhostAlertViewPositionCenter;
    
    if([@"setUsr" isEqual:flag]){
        NSString *strr = [resultDic valueForKey:@"error"];
        if ([strr integerValue]==0) {
            [myUser setObject:_telNumber.text forKey:@"user_tel"];
            olalterView.message =@"修改成功";
            [olalterView show];
            //基本信息保存成功
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([strr integerValue]==1) {
            olalterView.message =@"邀请码不正确";
            [olalterView show];
        }if ([strr integerValue]==2) {
            olalterView.message =@"不能填写自己的邀请码";
            [olalterView show];
        }
    }else if ([@"getUsr" isEqual:flag] && resultDic&&[resultDic count]>0){
                 [loadView hide:YES];
        NSString * invitedMan = [resultDic valueForKey:@"inviteName"];
        if(invitedMan && invitedMan.length>0){
            _invite.text = @"";
            _invite.text =  [resultDic valueForKey:@"inviteName"];
            label03.text = @"邀 请 人";
            [_invite setEnabled:NO];
   
        }
        _personName.text =@"";
        _personName.text =[resultDic valueForKey:@"userName"];
        _telNumber.text = @"";
        _telNumber.text =[resultDic valueForKey:@"userMobile"];
        
    }
}

- (void)receiveDataFail:(NSError *)error
{
    [loadView hide:YES];
}

- (void)requestTimeOut
{
    [olalterView hide];
    [loadView hide:YES];
}

//保存数据方法 （获取后）
- (void)saveShuJu1:(NSString *)dic
{
    [myUser setObject:dic forKey:@"invitename"];
    [myUser setObject:self.personName.text forKey:@"personName"];
    [myUser setObject:self.univercity.text forKey:@"user_sh"];
    [myUser setObject:self.telNumber.text forKey:@"user_tel"];
    [myUser setObject:_sexStr forKey:@"sex"];
    [myUser setObject:_personType forKey:@"PType"];
    [myUser synchronize];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.personName resignFirstResponder];
    [self.telNumber resignFirstResponder];
    [self.univercity resignFirstResponder];
    [self.invite resignFirstResponder];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.personName resignFirstResponder];
    [self.telNumber resignFirstResponder];
    [self.univercity resignFirstResponder];
    [self.invite resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)backUp:(id)sender
{
    if (![self.myType isEqualToString:@"mima"]) {
        UIAlertView *alertd = [[UIAlertView alloc]initWithTitle:@"提示" message:@"基本信息尚未完善,确定要返回么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertd show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"u_name" object:nil];
}


-(void)getUsr{
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    flag = @"getUsr";
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI, kInviteShow);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
//    [net sendRequestURLStr:url ParamDic:param Method:@"GET"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        [olalterView hide];
        olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
        olalterView.position = OLGhostAlertViewPositionCenter;
        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"信息完善Dic====%@",resultDic);
        if(resultDic&&[resultDic count]>0){
            NSString * invitedMan = [resultDic valueForKey:@"inviteName"];
            if(invitedMan && invitedMan.length>0){
                _invite.text = @"";
                _invite.text =  [resultDic valueForKey:@"inviteName"];
                label03.text = @"邀 请 人";
                [_invite setEnabled:NO];
                
            }
            _personName.text =@"";
            _personName.text =[resultDic valueForKey:@"userName"];
            _telNumber.text = @"";
            _telNumber.text =[resultDic valueForKey:@"userMobile"];
        }
        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [olalterView hide];
        
    }];
    [request startAsynchronous];
}

-(void)setUsr{
    flag = @"setUsr";
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI, kInviteSet);
    
    if (![self resultWithTip]) {
        olalterView.message = _tipString;
        [olalterView show];
        return;
    }else{
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_personName.text,@"userName",_telNumber.text,@"userMobile",
                           [label03.text isEqualToString:@"邀 请 人"]?nil:_invite.text,@"inviteId",nil];
//        [net sendRequestURLStr:url ParamDic:param Method:@"GET"];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            [loadView setHidden:YES];
            [olalterView hide];
            olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
            olalterView.position = OLGhostAlertViewPositionCenter;
            [loadView hide:YES];
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"信息完善Dic====%@",resultDic);
            NSString *strr = [resultDic valueForKey:@"error"];
            if ([strr integerValue]==0) {
                [myUser setObject:_telNumber.text forKey:@"user_tel"];
                olalterView.message =@"修改成功";
                [olalterView show];
                //基本信息保存成功
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([strr integerValue]==1) {
                olalterView.message =@"邀请码不正确";
                [olalterView show];
            }if ([strr integerValue]==2) {
                olalterView.message =@"不能填写自己的邀请码";
                [olalterView show];
            }

        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            [olalterView hide];
            
        }];
        [request startAsynchronous];
    }
}


// 正则判断手机号码地址格式
- (BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return  [phoneTest evaluateWithObject:mobile];
}

@end
