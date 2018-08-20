//
//  FindPassWordViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-1.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "FindPassWordViewController.h"
#import "SuccessFindViewController.h"
@interface FindPassWordViewController ()

@end

@implementation FindPassWordViewController

-(void)initData
{
    item = requestGetNum;
    
    num=ios7jj;
    
    tipString=[[NSString alloc]init];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    tableArray=[[NSMutableArray alloc]init];
    
    tableArray = [NSArray arrayWithObjects:@"@163.com",@"@126.com",@"@qq.com",@"@sina.com",@"@sina.cn",@"@vip.sina.com",@"@sohu.com",@"@yahoo.com",@"@hotemail.com",@"@gemail.com",@"@189.com",@"@139.com",@"@wo.com",@"@21.com", nil];
    
    emailArray=[NSMutableArray array];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"找回密码"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"找回密码"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"密码找回"];
    
    self.view.backgroundColor=XZHILBJ_colour;
    
    insertWordField = [[UITextField alloc]initWithFrame:CGRectMake(10, 54+num,iPhone_width-20,40)];//邮箱输入框
    insertWordField.borderStyle = UITextBorderStyleRoundedRect;
    insertWordField.keyboardType = UIKeyboardTypeNumberPad;
    insertWordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    insertWordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    insertWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    insertWordField.placeholder = @"请输入您的手机号";
    insertWordField.delegate =self;
    insertWordField.returnKeyType = UIReturnKeyNext;
    insertWordField.textColor = [UIColor blackColor];
    [self.view addSubview:insertWordField];
    
    findBtn=[UIButton buttonWithType:UIButtonTypeCustom]; //找回按钮
    findBtn.backgroundColor = [UIColor clearColor];
    findBtn.frame=CGRectMake(10,125,iPhone_width-20,40);
    [findBtn setTitle:@"找回" forState:UIControlStateNormal];
    [findBtn setTitle:@"找回" forState:UIControlStateHighlighted];
    [findBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [findBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [findBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findBtn];
}

-(void)loginClick:(id)sender
{
    if (insertWordField.text.length!=0) {
        
        //首先判断是邮箱还是电话号码
//        NSString *number=insertWordField.text;
        
//        BOOL isTelephone=[self analyseTelOrEmail:number];
        
//        if (isTelephone) { //如果是电话号码
        
            if (![self checkTelephoneNumber]) {
                NSLog(@"tipString is %@",tipString);
                ghostView.message=tipString;
                [ghostView show];
                return;
            }
//        }
//        else
//        {
//            if (![self checkEmailNumber:number]) {
//                ghostView.message=@"您输入的邮箱格式有误,请重新输入";
//                [ghostView show];
//                return;
//            }
//        }
        
        NSString *url = kCombineURL(KXZhiLiaoAPI, kNewFindPassWord);
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:insertWordField.text,@"userAccount",nil];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
//        [[ASIHTTPRequest alloc] initWithURL:URL];
        
        [request setCompletionBlock:^(){
            
            [loadView hide:YES];
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"resultDic is %@",resultDic);
            
            NSString *resultStr=[resultDic valueForKey:@"error"];
            
            NSLog(@"resultStr is %@",resultStr);
            
            if (resultDic&&resultStr.integerValue==0) {
                
                //进入找回成功界面
                SuccessFindViewController *successVC=[[SuccessFindViewController alloc]init];
                [self.navigationController pushViewController:successVC animated:YES];
            }else if (resultStr.integerValue ==2)
            {
                ghostView.message=@"该账号尚未被注册";
                [ghostView show];
                return;
            }else if (resultStr.integerValue ==3)
            {
                ghostView.message=@"您的密码今天已找回超过三次";
                [ghostView show];
                return;
            }
        }];
        
        [request setFailedBlock:^(){
            
            [loadView hide:YES];
            
            ghostView.message=@"密码找回失败,请稍后再试~";
            [ghostView show];
            return ;
        }];
        
        [request startAsynchronous];
        
    }else
    {
        ghostView.message=@"请您先输入手机号码";
        [ghostView show];
    }
}

/**判断传入的参数是电话号码还是邮箱**/
-(BOOL)analyseTelOrEmail:(NSString *)number
{
    for (int i=0;i<[number length];i++) {
        
        NSString *subString=[number substringWithRange:NSMakeRange(i,1)];
        
        if ([subString isEqualToString:@"@"]) {
            return NO;
        }
    }
    
    return YES;
}

/***检测是否是正确的电话号码***/
- (BOOL)checkTelephoneNumber
{
    if (insertWordField.text.length == 0) {//判断是否为空
        tipString = @"手机号码不能为空";
        return NO;
    }
    
    //判断是否是11位
    if (insertWordField.text.length != 11){
        tipString = @"手机号码格式错误，请输入真实有效的信息";
        return NO;
    }
    
//    NSString *subNumber = [insertWordField.text substringWithRange:NSMakeRange(0, 3)];
//    NSArray *telArray = [NSArray arrayWithObjects:@"134",@"135",@"144",@"136",@"137",@"138",@"139",@"147",@"150",@"151",@"152",@"157",@"170",@"158",@"159",@"182",@"183",@"184",@"187",@"188",@"130",@"131",@"132",@"156",@"185",@"186",@"145",@"133",@"153",@"180",@"181",@"189", nil];
    
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    BOOL isMobile = [phoneTest evaluateWithObject:insertWordField.text];
    
    //判断手机前三位
    if (isMobile) {
        return YES;
    }
    else
    {
        tipString = @"手机号码格式错误，请输入真实有效的信息";
        return NO;
    }
}

/**检测是否是正确的邮箱格式**/
-(BOOL)checkEmailNumber:(NSString *)number
{
    for (int i=0;i<[tableArray count];i++)
    {
        if ([number hasSuffix:[tableArray objectAtIndex:i]]){
            return YES;
        }
    }
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan代码被执行到了。。。。。");
  
    [insertWordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
