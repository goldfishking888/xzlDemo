//
//  SeachViewController.m
//  JobKnow
//
//  Created by Mathias on 15/7/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "SeachViewController.h"

@interface SeachViewController ()
{
    UITextField *shouji;
    
}
@end

@implementation SeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackBtn];
    
    
    self.view.backgroundColor=RGBA(241, 239, 240, 1);
    
    
    shouji = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, ([[UIScreen mainScreen] bounds].size.width)-20, 30)];
    [shouji setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    [shouji setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    shouji.clearButtonMode = UITextFieldViewModeAlways;
    
    
    shouji.layer.cornerRadius=8.0f;
    shouji.layer.masksToBounds=YES;
    shouji.layer.borderColor=[[UIColor orangeColor]CGColor];
    shouji.layer.borderWidth= 1.0f;
    
    shouji.placeholder = @"请输入注册时使用的手机号"; //默认显示的字
    
    shouji.clearButtonMode = UITextFieldViewModeAlways;
    
    
   
    //登录
    UIButton *zhaohui=[UIButton buttonWithType:UIButtonTypeSystem];
    zhaohui.frame=CGRectMake(15, 130, ([[UIScreen mainScreen] bounds].size.width)-30, 30);
    
    
    [zhaohui setTitle:@"找回" forState:UIControlStateNormal];
    
    [zhaohui addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [zhaohui setBackgroundColor:[UIColor orangeColor]];
    
    [zhaohui setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    
    
    [self.view addSubview:shouji];
    
    [self.view addSubview:zhaohui];
    
}
//找回密码
-(void)login{
    
    
    NSLog(@"找回密码");
    
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    
}
@end
