//
//  WeiboViewController.m
//  JobKnow
//
//  Created by king on 13-5-2.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "WeiboViewController.h"
#import "SinaWeiboRequest.h"
#import "AppDelegate.h"
@interface WeiboViewController ()

@end

@implementation WeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        olghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
        olghostView.position = OLGhostAlertViewPositionCenter;
        isfasong = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sinaweibo.myDeleate = self;

    _myScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, iPhone_height-44, iPhone_width)];
    _myScro.contentSize = CGSizeMake(320, iPhone_height - 44);
    [self.view addSubview:_myScro];
    
    UIImage *EntryBackground = [UIImage imageNamed:@"app_background.png"];
    UIImage *entryBackgrounds = [EntryBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.view.backgroundColor = [UIColor colorWithPatternImage:entryBackgrounds];
    
    
	UIImageView *navigationView = kNavigation;
    navigationView.frame = kNavigationFrame;
    [self.view addSubview:navigationView];
    [self addTitleLabel:self.title];
    //添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = kBackLeftFrame;
    [backBtn setBackgroundImage:kBackNormalImage forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBtn setBackgroundImage:kBackHighLigthImage forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backUpVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = KBackRightFrame;
    [button setBackgroundImage:[UIImage imageNamed:@"fenxiang.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"fenxiang2.png"] forState:UIControlStateHighlighted];
    button.frame = KBackRightFrame;
    [button addTarget:self action:@selector(myBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 85-64, 300, 170)];
    textView.text=self.shareStr;
    textView.font=[UIFont systemFontOfSize:13.5];
    textView.backgroundColor = [UIColor clearColor];
    textView.userInteractionEnabled=NO;
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 85-64, 300, 170)];
    imgView.image = [UIImage imageNamed:@"bg01.png"];
    [_myScro addSubview:imgView];
    [_myScro addSubview:textView];
    
    _myScro.contentSize = CGSizeMake(320, iPhone_height+1-44);
}
- (void)changeWeibo02
{
    olghostView.message = @"发送微博成功";
    [olghostView show];

}
//返回方法
- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//发送微博方法
- (void)myBack:(id)sender
{
    if (isfasong) {
        if ([self.title isEqualToString:@"新浪微博分享"]) {
 
            
            BOOL authValid = sinaweibo.isAuthValid;
            if (authValid) {
 
                
                olghostView.message = @"发送微博成功";
                isfasong = NO;

                [olghostView show];
                
            }else{
        
                 isfasong = NO;
                [sinaweibo logInIn];
               
                
            }
        }else if([self.title isEqualToString:@"腾讯微博分享"]){
            [[WBShareKit mainShare] startTxOauthWithSelector:@selector(txSuccess:) withFailedSelector:@selector(txError:)];
        }

    }else{
        NSLog(@"请十秒中以后再分享");
        olghostView.message = @"请十秒钟以后再分享";
        [olghostView show];
        isfasong = NO;
        [self performSelector:@selector(yanshi) withObject:nil afterDelay:10];
    }
        
    
        
}
- (void)yanshi
{
    isfasong = YES;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        if (alertView.tag == 0)
        {
            

        }
        else if(alertView.tag == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

-(UILabel *)addTitleLabel:(NSString*)title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 8, 160, 25)] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize: 18.0]];
    [titleLabel setText:title];
    [self.view addSubview:titleLabel];
    return titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end
