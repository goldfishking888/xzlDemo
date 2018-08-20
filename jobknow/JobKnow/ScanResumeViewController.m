//
//  ScanResumeViewController.m
//  JobKnow
//
//  Created by Suny on 15/11/10.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "ScanResumeViewController.h"
#import "QRCodeReaderView.h"

#import "AFNetworking.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

@interface ScanResumeViewController ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ScanResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int num=ios7jj;
    self.view.backgroundColor = XZHILBJ_colour;
    
    _ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    _ghostView.position = OLGhostAlertViewPositionCenter;
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
    [self addBackBtn];
    [self addTitleLabel:@"扫描二维码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.labIntroudction.text = @"在浏览器输入g.xzhiliao.com";
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    
    //播放扫描二维码的声音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
    
//    [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
//    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
    if ([str hasPrefix:@"xzl-"]) {
        str = [str substringFromIndex:4];
    }
    [self requestWithStr:str];
}

-(void)requestWithStr:(NSString *)str{
    
    MBProgressHUD *loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;

    NSString *urlStr=kCombineURL(KXZhiLiaoAPINo,FuncPersonalResumeScanLogin);
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"imei",kUserTokenStr,@"token",str,@"qr_token",nil];
    [XZLNetWorkUtil requestPostURL:urlStr params:paramDic success:^(id responseObject) {
        [loadView hide:YES];
        NSString *str = [NSString stringWithFormat:@"%@",responseObject];
        //    NSNumber *error = dic[@"succ"];
        if(str){
            if ([str isEqualToString:@"succ"]) {
                _ghostView.message=@"登录成功!";
                [_ghostView show];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                _ghostView.message=@"登录失败!";
                [_ghostView show];
                [self reStartScan];
                return ;
            }
        }else{
            _ghostView.message=@"登录失败!";
            [_ghostView show];
            [self reStartScan];
            return ;
            
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        _ghostView.message=@"登录失败!";
        [_ghostView show];
        [self reStartScan];
        return ;
        
    }];

}

- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
