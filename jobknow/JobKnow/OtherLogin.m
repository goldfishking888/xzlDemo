//
//  OtherLogin.m
//  ShouXi
//
//  Created by liuxiaowu on 13-8-3.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "OtherLogin.h"
#import "MoreViewController.h"
#import "SaveCount.h"
#import "XZLUtil.h"
@implementation OtherLogin

+ (id)standerDefault
{
    static OtherLogin *other = nil;
    
    if (other == nil) {
        other = [[OtherLogin alloc] init];
        other.login = YES;
    }
    
    return other;
}

- (void)otherAreaLogin
{
    NSLog(@"otherAreaLogin 执行到了。。。。。");
    
    if (self.login) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账号在异地登录" delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:@"取消", nil];
        
        [alert show];
     
        self.login=NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"重新登录被执行到了。。。。");
        
        [self loginyet];//重新登录
        
    }else
    {
        //此处为注销信息，删除登录信息之后进入程序的首页
        [MoreViewController removeAllInfo];
        NSNotification *notification = [NSNotification notificationWithName:@"ResetSiXinCount" object:nil userInfo:[NSDictionary dictionaryWithObject:@"logout" forKey:@"logout"]];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backfirst" object:nil];
    }
}


//重新登录

- (void)loginyet
{
    SaveCount *save=[SaveCount standerDefault];
    
    NSString *userNameStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    
    NSString *passWordStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"passWord"];
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:userNameStr,@"userName",passWordStr,@"userPsw",IMEI,@"userImei",save.deviceToken,@"pushId",@"1",@"loginType",@"1",@"type",nil];
    
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kNewUserLogin);
    
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlString];
   
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:15];

    [request setCompletionBlock:^{
        
        NSLog(@"重新登录成功");
        
        _login=YES;
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
       
        //保存个人信息
        
        [HR_LoginSharedTool saveUserInfoDic:resultDic LoginType:@"GeRen"];
        [XZLUtil sendAliasToJPush];

        NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
        [AppUD setObject:userNameStr forKey:@"UserName"];//账号
        [AppUD setObject:passWordStr forKey:@"passWord"];
        [AppUD synchronize];
        
        NSString *userName2=[resultDic valueForKey:@"userName"];
        
        NSString *str;
        
        if (userName2) {
            str=[NSString stringWithFormat:@"欢迎%@登录小职了，偶是您的求职小秘书，请快给偶下指令吧!",userName2];
        }else{
           str=[NSString stringWithFormat:@"欢迎登录小职了，偶是您的求职小秘书，请快给偶下指令吧!"];
        }
        
        ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:str timeout:1 dismissible:YES];
        ghostView.position = OLGhostAlertViewPositionCenter;
        ghostView.message=str;
        [ghostView show];
        
        if (self.isHrBool == YES) {
            //是HR
            self.isHrBool = NO;
        }
        else
        {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backfirst" object:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"toHomeVCFromLoginVC" object:self userInfo:nil];
        }
        
    }];
    [request setFailedBlock:^{
        
        NSLog(@"重新登录失败。。。");
    
        ghostView.message=@"重新登录失败";
        
        [ghostView show];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"backfirst" object:nil];
    }];
    
    [request startAsynchronous];
}

@end
