//
//  peixun2ViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "peixun2ViewController.h"
#import "JSONKit.h"

@interface peixun2ViewController ()
//f
@end

@implementation peixun2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"培训经历2"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"培训经历2"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num  = ios7jj;
	self.view.backgroundColor = XZHILBJ_colour;
    [self addBackBtn];
    [self addTitleLabel:@"培训经历"];

    myScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 46+num, iPhone_width, iPhone_height-46-num)];
    myScrollow.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScrollow];
    UIImageView *viewbg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15+num, iPhone_width-10-num, 160)];
    viewbg.image = [UIImage imageNamed:@"peixunbg.png"];
     viewbg.userInteractionEnabled = YES;
    [myScrollow addSubview:viewbg];
   
    myScrollow.contentSize = CGSizeMake(iPhone_width, iPhone_height-45);

    //培训机构
    textField01 = [[UITextField alloc]initWithFrame:CGRectMake(30, 11.5, iPhone_width-60, 30)];
    textField01.delegate = self;
    [textField01 setFont:[UIFont systemFontOfSize:16]];
    textField01.tag = 101;
    textField01.textColor = [UIColor darkGrayColor];
    textField01.returnKeyType = UIReturnKeyNext;
    textField01.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField01.text = @"";
    textField01.placeholder = @"培训机构";
    textField01.borderStyle = UITextBorderStyleNone;
    textField01.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField01.keyboardType = UIKeyboardTypeTwitter;
    [viewbg addSubview:textField01];
    
    //培训内容
    textField02 = [[UITextField alloc]initWithFrame:CGRectMake(30, 64, iPhone_width-60, 30)];
    textField02.delegate = self;
    [textField02 setFont:[UIFont systemFontOfSize:16]];
    textField02.tag = 102;
    textField02.textColor = [UIColor darkGrayColor];
    textField02.returnKeyType = UIReturnKeyNext;
    textField02.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField02.text = @"";
    textField02.placeholder = @"培训内容";
    textField02.borderStyle = UITextBorderStyleNone;
    textField02.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [viewbg addSubview:textField02];
    
    //获得证书
    textField03 = [[UITextField alloc]initWithFrame:CGRectMake(30, 118, iPhone_width-60, 30)];
    textField03.delegate = self;
    [textField03 setFont:[UIFont systemFontOfSize:16]];
    textField03.tag= 103;
    textField03.textColor = [UIColor darkGrayColor];
    textField03.returnKeyType = UIReturnKeyGo;
    textField03.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField03.text = @"";
    textField03.placeholder = @"获得证书";
    textField03.borderStyle = UITextBorderStyleNone;
    textField03.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [viewbg addSubview:textField03];
    
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    //pressLogin
    [registBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    UIButton *residBtn01 =[UIButton buttonWithType:UIButtonTypeCustom];
    residBtn01.frame = CGRectMake(250, 0, 70, 44);
    [residBtn01 addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:residBtn01];
    
    if ([self.myType isEqualToString:@"gai"]) {
        textField01.text = [NSString stringWithFormat:@"%@",self.wheretr];
        textField02.text = [NSString stringWithFormat:@"%@",self.contentr];
        textField03.text = [NSString stringWithFormat:@"%@",self.booktr];
    }else{
        self.myId = [NSString stringWithFormat:@"0"];
    }

}
//textField的代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        [textField02 becomeFirstResponder];
    }else if (textField.tag==102){
        [textField03 becomeFirstResponder];
    }else
    {
        [textField03 resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 0);
        }];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
 
    }
    else if(textField.tag == 102)
    {
    }
    else
    {
          [UIView animateWithDuration:0.3 animations:^{
            myScrollow.contentOffset = CGPointMake(0, 25);
          }];
    }
}
- (void)pressLogin:(id)sender
{
    if ([textField01.text isEqualToString:@""]||[textField02.text isEqualToString:@""]||[textField03.text isEqualToString:@""]) {
        NSLog(@"wei kong");
    }else{
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [textField01 resignFirstResponder];
        [textField02 resignFirstResponder];
        [textField03 resignFirstResponder];
        [self resquext];
    }
}
//网络请求
- (void)resquext
{
    NSString *url = kCombineURL(KXZhiLiaoAPI,kSaveEducation);
    NSMutableDictionary*urlParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"user_train",@"table",self.myId,@"id",textField01.text,@"train_org",textField02.text,@"train_content",textField03.text,@"certificate", nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:urlParamter urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        ResumeOperation *st = [ResumeOperation defaultResume];
        NSArray *ary = [resultDic valueForKey:@"data"];
        [st setObject:ary forKey:@"peixun"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    NSDictionary *reslult = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    ResumeOperation *st = [ResumeOperation defaultResume];
    NSArray *ary = [reslult valueForKey:@"data"];
    [st setObject:ary forKey:@"peixun"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
