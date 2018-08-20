//
//  HR_ResumeFileAttach.m
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeFileAttach.h"
#import "FileButton.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
@interface HR_ResumeFileAttach ()

@end

@implementation HR_ResumeFileAttach

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _fileArray = [NSMutableArray array];
        alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
        alert.position = OLGhostAlertViewPositionCenter;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"简历附件（文件）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"简历附件（文件）"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"简历附件"];
    int num = ios7jj;
    bgVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    bgVIew.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgVIew];
    [self addFileInView];
}
- (void)addFileInView
{
    for (UIView *v in bgVIew.subviews) {
        [v removeFromSuperview];
    }
    if (_fileArray.count > 0) {
        [self addfileButton:2];
    }
    [self addaddBtn];
}
//添加"添加文件按钮"
- (void)addaddBtn
{
    NSInteger index = 0;
    //文档按钮
    if (_fileArray.count < 4) {
        index = _fileArray.count;
        FileButton *btn = [[FileButton alloc] initWithFrame:CGRectMake( 20+((index%4)*75), 60-44 +((index/4) *75), 55, 55) fileType:FileNone binding:NO resumeFile:nil type:@"li"];
        btn.tag = 153;
        [btn.fileBtn setBackgroundImage:[UIImage imageNamed:@"zengjia1.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addfile:) forControlEvents:UIControlEventTouchUpInside];
        [bgVIew addSubview:btn];
        
    }
    
}
//添加文件
- (void)addfile:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录www.xzhiliao.com/hr_resume上传文档！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
/*
 *type
 *1，代表语音按钮
 *2，代表图片按钮
 *3，代表文件按钮
 */
//添加文件按钮
- (void)addfileButton:(NSInteger)type
{
    CGFloat xx = 20;
    NSInteger btnTag = 0;
    NSMutableArray *addarray = nil;
    if (type == 2)
    {
        btnTag = 120;
        addarray = _fileArray;
    }
    if (addarray.count == 0) {
        return;
    }
    //循环添加按钮
    for (NSInteger i = 0; i < addarray.count; i++) {
        ResumeFile *file = [addarray objectAtIndex:i];
        FileButton *btn = [[FileButton alloc] initWithFrame:CGRectMake(xx+((i%4)*75), 60-44 +((i/4) *75), 55, 55) fileType:file.fileItem binding:YES resumeFile:file type:@"li"];
        btn.btnTag = btnTag + i;
        btn.tag = btnTag + 100 + i;
        [btn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        [bgVIew addSubview:btn];
    }
}
//点击文件的方法
- (void)check:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIActionSheet *sheet = nil;
    selectTag = btn.tag + 100;
    selectFile = [_fileArray objectAtIndex:btn.tag - 120];
//    NSString *bd = @"绑定简历";
//    if (selectFile.binding) {
//        bd = @"与简历解绑";
//    }
    sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预览",@"删除", nil];
    sheet.tag = 256;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self getFileFromServer];
    }else if (buttonIndex==1){
        //删除附件
        [self deleteResumeFileBtn];
    }else{
        //取消
    }
}
- (void)getFileFromServer
{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:[selectFile.downloadPath lastPathComponent]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"http://timages.hrbanlv.com/%@",selectFile.downloadPath];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"附件连接====%@",url);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        selectFile.openPath = path;
        [request.responseData writeToFile:path atomically:YES];
        [self openFile];
    }];
    [request setFailedBlock:^{
        alert.message = @"网络连接失败，请检查网络";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}
- (void)openFile
{
    UIDocumentInteractionController *documentVc = [[UIDocumentInteractionController alloc]init];
    documentVc.URL = [NSURL fileURLWithPath:selectFile.openPath];
    documentVc.delegate = self;
    [documentVc presentPreviewAnimated:YES];
}
//删除文件
- (void)deleteResumeFileBtn
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, HRResumeAttachDelete);
    [MBProgressHUD showHUDAddedTo:bgVIew animated:YES];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:_resumeModel.pid forKey:@"pid"];
    [request setPostValue:selectFile.userid forKey:@"id"];
    [request setPostValue:kUserTokenStr forKey:@"userToken"];
    [request setPostValue:IMEI forKey:@"userImei"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSLog(@"file  delete----------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        [[NSFileManager defaultManager] removeItemAtPath:selectFile.openPath error:nil];
        [_fileArray removeObject:selectFile];
        
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self addFileInView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
