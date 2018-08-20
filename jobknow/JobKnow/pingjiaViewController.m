//
//  pingjiaViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "pingjiaViewController.h"
@interface pingjiaViewController ()

@end

@implementation pingjiaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.trpe isEqualToString:@"miao"]) {
       
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作描述"];
      
    }else if ([self.trpe isEqualToString:@"biaoqian"]){
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"职业标签"];
    
    }else{
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"自我评价"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([self.trpe isEqualToString:@"miao"]) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作描述"];
        
    }else if ([self.trpe isEqualToString:@"biaoqian"]){
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"职业标签"];
        
    }else{
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"自我评价"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = XZHILBJ_colour;
    int num = ios7jj;
	[self addBackBtn];
        //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    //pressLogin
    [registBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    UIButton *residBtn01 =[UIButton buttonWithType:UIButtonTypeCustom];
    residBtn01.frame = CGRectMake(250, 0+num, 70, 44);
    [residBtn01 addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:residBtn01];
    
    
    //添加文本框下面的图片
    tableViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60+num, 300, 44*3+14)];
    tableViewImage.image = [UIImage imageNamed:@"textView_2.png"];
    [self.view addSubview:tableViewImage];
    //添加文本框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 60+num, 300, 44*3+14)];
    self.textView.text = @"工作能力及自我评价(800字以内)";
    self.textView.font=[UIFont fontWithName:Zhiti size:14];
    self.textView.textColor=[UIColor darkGrayColor];
    self.textView.backgroundColor=[UIColor clearColor];
    //自动修改
    self.textView.autocorrectionType=UITextAutocorrectionTypeNo;
    //大写锁定
    self.textView.scrollEnabled = YES;
    self.textView.delegate=self;
    self.textView.showsVerticalScrollIndicator=YES;
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
    ResumeOperation *sr = [ResumeOperation defaultResume];
    if ([self.trpe isEqualToString:@"miao"]) {
        [self addTitleLabel:@"工作描述"];
        self.textView.text = _contentString;
    }else if ([self.trpe isEqualToString:@"biaoqian"]){
        [self addTitleLabel:@"职业标签"];
        self.textView.text= [sr.resumeDictionary valueForKey:@"userTagg"];
    }else{
        [self addTitleLabel:@"自我评价"];
        self.textView.text= [sr.resumeDictionary valueForKey:@"pingjia"];
    }
}
#pragma mark-UITextView的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"工作能力及自我评价(800字以内)"]) {
        self.textView.text=@"";
    }
    self.textView.textColor=[UIColor blackColor];
    return YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.textView.text=@"工作能力及自我评价(800字以内)";
    }
    self.textView.textColor=[UIColor darkGrayColor];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range

 replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)pressLogin:(id)sender
{
    if ([self.trpe isEqualToString:@"miao"]) {
        [self.deleat miashuZiShu:[NSString stringWithFormat:@"%d",[self.textView.text length]] destring:self.textView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.trpe isEqualToString:@"biaoqian"]){
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestBiaoqian];
    }else{
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self resquext];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}
//自我评价的网络请求
- (void)resquext
{
    NSString *url = kCombineURL(KXZhiLiaoAPI,kSaveEducation);
    ResumeOperation *resume = [ResumeOperation defaultResume];
    NSString *str = [NSString stringWithFormat:@"%@",self.textView.text];
    NSString *jianliId= [resume.resumeDictionary valueForKey:@"jlId"];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"resume_cn",@"table",jianliId,@"id",str,@"introduction", nil];
//    [net sendRequestURLStr:url ParamDic:urlParamter Method:@"GET"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:dic urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(errorStr&&errorStr.integerValue == 0&&errorStr){
            NSLog(@"评价成功");
            //评价成功
            ResumeOperation *st = [ResumeOperation defaultResume];
            [st setObject:[NSString stringWithFormat:@"%@",self.textView.text] forKey:@"pingjia"];
            [self.deleat wanzhengFou:[NSString stringWithFormat:@"%@",self.textView.text]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
       
    }];
    [request startAsynchronous];

}
- (void)requestTimeOut
{
    [loadView hide:YES];
}
- (void)receiveDataFail:(NSError *)error
{
    [loadView hide:YES];
}
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    NSDictionary *reslult = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSString *strr = [reslult valueForKey:@"error"];
    if ([strr integerValue]==0) {
        //评价成功
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"%@",self.textView.text] forKey:@"pingjia"];
        [self.deleat wanzhengFou:[NSString stringWithFormat:@"%@",self.textView.text]];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
//保存职业标签
-(void)requestBiaoqian{

    NSString *url = kCombineURL(KXZhiLiaoAPI,jiben1);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"2",@"flag",self.textView.text,@"userTag",nil];
    NSURL *url2 = [NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url2];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request setCompletionBlock:^{
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *resume = [resultDic valueForKey:@"error"];
        if ([resume integerValue] == 0) {
            ResumeOperation *resume = [ResumeOperation defaultResume];
            if (self.textView.text.length> 0) {
                [resume setObject:self.textView.text forKey:@"userTagg"];
            }else
            {
                [resume setObject:self.textView.text forKey:@"userTagg"];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.deleat bianqian:self.textView.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
