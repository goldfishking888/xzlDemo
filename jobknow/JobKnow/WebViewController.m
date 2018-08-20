//
//  RootViewController.m
//  UI_Lesson
//
//  Created by Ibokan on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "OLGhostAlertView.h"
#import "SeeFileVC.h"
#import "VoiceConverter.h"

@implementation WebViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    
    num=ios7jj;
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:self.floog];
//    if (_isHRSelf) {
//        [self addRightButton];
//    }

    Net *n=[Net standerDefault];
    if (n.status ==NotReachable) {
        ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:@"" timeout:2 dismissible:NO];
        ghostView.position = OLGhostAlertViewPositionCenter;
        ghostView.message=@"无网络连接,请检查您的网络";
        [ghostView show];
        return;
    }
    self.myWebView = [[UIWebView alloc]init];
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
    
    int num=ios7jj;
    self.myWebView.frame = CGRectMake(0, 44+num,iPhone_width,iPhone_height-44-num);
    isFirst = YES;
    
    // 设置可以支持缩放
    [self.myWebView setScalesPageToFit:YES];
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled = NO;

    [self myWebViewRequestNetWithUrlStr:_urlStr];
}

-(void)viewWillAppear:(BOOL)animated{
    if (isFirst) {
        isFirst = NO;
        return;
    }else{
        [_myWebView reload];
    }
    
}

//-(void)addRightButton{
//    //编辑按钮
//    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    registerBtn.backgroundColor=[UIColor clearColor];
//    registerBtn.frame = CGRectMake(iPhone_width-45,-3+num,45,50);
//    registerBtn.showsTouchWhenHighlighted=YES;
//    registerBtn.titleLabel.font=[UIFont systemFontOfSize: 16];
//    [registerBtn setTitle:@"更多" forState:UIControlStateNormal];
//    [registerBtn setTitle:@"更多" forState:UIControlStateHighlighted];
//    [registerBtn addTarget:self action:@selector(createMoreView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:registerBtn];
//}

//- (void)createMoreView
//{
//    NSArray *titleArray = @[@"编辑", @"删除"];
//    
//    if (!moreView) {
//        moreView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 57, 0, 0)];
//        moreView.hidden = YES;
//        moreView.userInteractionEnabled = YES;
//        moreView.image = [UIImage imageNamed:@"popupwindow_bgMyCard"];
//        [UIView animateWithDuration:0.05 animations:^{
//            moreView.frame = CGRectMake(self.view.frame.size.width - 107, 57, 107, 35 * titleArray.count + 10);
//            [self.view addSubview:moreView];
//        } completion:^(BOOL finished) {
//            for (int index = 0; index < titleArray.count; index++)
//            {
//                UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
//                moreButton.frame = CGRectMake(0, 5 + 35 * index, 112, 34);
//                [moreButton setTitle:titleArray[index] forState:UIControlStateNormal];
//                moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
//                [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                if ([titleArray[index] isEqualToString:@"编辑"])
//                {
//                    moreButton.tag = 0;
//                }
//                else if ([titleArray[index] isEqualToString:@"删除"])
//                {
//                    moreButton.tag = 1;
//                }
//                
//                [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//                [moreView addSubview:moreButton];
//                if (index != titleArray.count - 1)
//                {
//                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(7, 5 + 35 * index + 34, moreView.frame.size.width, 1)];
//                    line.backgroundColor = RGBA(224, 106, 27, 1);
//                    [moreView addSubview:line];
//                }
//            }
//        }];
//
//    }
//    if (moreView.hidden) {
//        moreView.hidden = NO;
//    }else{
//        moreView.hidden = YES;
//    }
//    
//}
//
//- (void)removeMoreView
//{
//    [moreView removeFromSuperview];
//}
//#pragma mark - 更多按钮
//- (void)moreButtonClick:(UIButton *)sender
//{
//    if (sender.tag == 0)
//    {
//        NSLog(@"编辑");
//        [self createMoreView];
//        [self resumeEdit];
//    }
//    else if (sender.tag == 1)
//    {
//        NSLog(@"删除");
//        [self resumeDelete];
//        [self createMoreView];
//    }
//}

-(void)resumeEdit{
    HR_ResumeDetail *detail = [[HR_ResumeDetail alloc] init];
    detail.resumeModelFromList = _resumeModel;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)resumeDelete{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRDeleteResume);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_resumeModel.resumePid,@"pid",_resumeModel.Id,@"id",_resumeModel.resumeUid,@"uid",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            NSLog(@"删除失败");
            ghostView.message=@"删除失败";
            [ghostView show];
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"删除成功");
            ghostView.message=@"删除成功";
            [ghostView show];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ReloadResumeListFromWeb object:nil];
            [self deleteResumeWithModel:_resumeModel];
        }
        
    }];
    [request setFailedBlock:^{
        ghostView.message=@"删除失败";
        [ghostView show];
        [loadView hide:YES];
    }];
    [request startAsynchronous];

}

#pragma mark- HR_ResumeDeleteDelegate
-(void)deleteResumeWithModel:(HRReumeModel *)model{
//    if([self.delegate respondsToSelector:@selector(deleteResumeWithModel:)]){
//        [self.delegate deleteResumeWithModel:model];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [[HR_ResumeShareTool defaultTool] deleteResumeWithModel:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ReloadResumeList object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)myWebViewRequestNetWithUrlStr:(NSString *)urlStr
{
    NSString *url;
    if (![urlStr hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"http://%@",urlStr];
    } else {
        url = urlStr;
    }
    NSURL *urll = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urll];
    [self.myWebView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:100];
    NSString *newUrl = [[NSString alloc] initWithFormat:@"%@",webView.request.URL];
    textField.text = newUrl;
          [loadView hide:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"--------------fail");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    NSString *urlStrr = [NSString stringWithFormat:@"%@%@",@"http://api.xzhiliao.com/",@"hr_api/recommend_jianli"];
//    NSString *urlStrrr = [NSString stringWithFormat:@"%@%@",@"http://api.xzhiliao.com/",@"hr_api/recommend_jianli"];
    if ([urlStr hasPrefix:[NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"about"]]) {
        return YES;
    }
    
    if ([urlStr hasPrefix:urlStrr]) {
        return YES;
    }
    if ([urlStr hasSuffix:@".amr"]||[urlStr hasSuffix:@".wav"]||[urlStr hasSuffix:@".mp3"]) {
        
        [self getSoundFromServerWithPathStr:urlStr];
        return NO;
    }
    if ([urlStr hasSuffix:@".txt"]||[urlStr hasSuffix:@".doc"]||[urlStr hasSuffix:@".docx"]||[urlStr hasSuffix:@".xls"]||[urlStr hasSuffix:@".pdf"]||[urlStr hasSuffix:@".xlsx"]||[urlStr hasSuffix:@".ppt"]||[urlStr hasSuffix:@".pptx"]) {
        [self getFileFromServerWithPathStr:urlStr];
        return NO;

    }
    if ([urlStr hasSuffix:@".jpg"]||[urlStr hasSuffix:@".png"]||[urlStr hasSuffix:@".gif"]||[urlStr hasSuffix:@".jpeg"]||[urlStr hasSuffix:@".bmp"]){
        [self getImageFromServerWithPathStr:urlStr];
        return NO;
    }
    //    [self.navigationController pushViewController:seeFile animated:YES];
    return YES;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)getFileFromServerWithPathStr:(NSString *)pathStr
{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:[pathStr lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self openFileWithPathStr:path];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = pathStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"附件连接====%@",url);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [request.responseData writeToFile:path atomically:YES];
        [self openFileWithPathStr:path];
    }];
    [request setFailedBlock:^{
//        alert.message = @"网络连接失败，请检查网络";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}

- (void)getImageFromServerWithPathStr:(NSString *)pathStr
{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:[pathStr lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self openFileWithPathStr:path];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = pathStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"图片连接====%@",url);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [request.responseData writeToFile:path atomically:YES];
        [self openFileWithPathStr:path];
    }];
    [request setFailedBlock:^{
        //        alert.message = @"网络连接失败，请检查网络";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}

- (void)getSoundFromServerWithPathStr:(NSString *)pathStr
{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:[pathStr lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([pathStr hasSuffix:@".amr"]) {
            NSString *pathWav =[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
            [VoiceConverter amrToWav:path wavSavePath:pathWav];
            [self openFileWithPathStr:pathWav];
        }else{
            [self openFileWithPathStr:path];
        }
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = pathStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"语音连接====%@",url);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [request.responseData writeToFile:path atomically:YES];
        if ([pathStr hasSuffix:@".amr"]) {
            NSString *pathWav =[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
            [VoiceConverter amrToWav:path wavSavePath:pathWav];
            [self openFileWithPathStr:pathWav];
        }else{
            [self openFileWithPathStr:path];
        }
    }];
    [request setFailedBlock:^{
        //        alert.message = @"网络连接失败，请检查网络";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}

- (void)openFileWithPathStr:(NSString *)pathStr
{
    UIDocumentInteractionController *documentVc  = [[UIDocumentInteractionController alloc] init];
    
    documentVc.URL = [NSURL fileURLWithPath:pathStr];
    documentVc.delegate = self;
    [documentVc presentPreviewAnimated:YES];
    //    CGRect navRect = self.navigationController.navigationBar.frame;
    //    navRect.size = CGSizeMake(320.0f, 40.0f);
    //    [_documentVc presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
}

#pragma -mark UIDocumentInteractionController 代理方法

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

@end
