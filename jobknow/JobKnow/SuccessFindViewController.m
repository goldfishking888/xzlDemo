//
//  SuccessFindViewController.m
//  JobKnow
//
//  Created by Zuo on 14-1-14.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "SuccessFindViewController.h"

@interface SuccessFindViewController ()

@end

@implementation SuccessFindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        num=ios7jj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self addBackBtn];
    
    [self addTitleLabel:@"成功找回"];
    
    self.view.backgroundColor=XZHILBJ_colour;
    
    UILabel *textLabel=[[UILabel alloc]init];
    textLabel.backgroundColor=[UIColor clearColor];
    textLabel.frame=CGRectMake(10,20+num,300,100);
    textLabel.font=[UIFont systemFontOfSize:13];
    textLabel.numberOfLines=0;
    textLabel.textColor=RGBA(255, 115, 4, 1);
    textLabel.text=@"新密码已发送到您的手机或邮箱里面，请在48小时内及时登录修改";
    [self.view addSubview:textLabel];
    
    //找回按钮
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(10,100+num,iPhone_width-20,40);
    sureBtn.backgroundColor =[UIColor clearColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

-(void)sureBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end