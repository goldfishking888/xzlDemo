//
//  HR_ResumeImageAttach.m
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
// 简历附件 图片

#import "HR_ResumeImageAttach.h"
#import "FileButton.h"
#import "GGFullScreenImageViewController.h"
#import "SDDataCache.h"
#import "ASINetworkQueue.h"
#import "Photo.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"

#import "HRNetWorkConnection.h"
@interface HR_ResumeImageAttach ()

@end

@implementation HR_ResumeImageAttach
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"简历附件（图片）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"简历附件（图片）"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTitleLabel:@"简历附件"];
    int num = ios7jj;
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-num-44)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    NSLog(@"传过来的图片数组为------%@",_imageArray);
    [self addFileInView];
    [self getUrlAndRequest];
}
- (void)addFileInView
{
    for (UIView *v in bgView.subviews) {
        [v removeFromSuperview];
    }
    if (_imageArray.count > 0) {
        [self addfileButton:1];
    }
    [self addaddBtn];
}
//添加"添加文件按钮"
- (void)addaddBtn
{
    NSInteger index = 0;
    //添加“添加图片按钮”
    if (_imageArray.count < 8) {
        index = _imageArray.count;
        FileButton *btn = [[FileButton alloc] initWithFrame:CGRectMake( 20+((index%4)*75), 60-44 +((index/4) *75), 55, 55) fileType:FileNone binding:NO resumeFile:nil type:@"li"];
        btn.tag = 152;
        [btn.fileBtn setBackgroundImage:[UIImage imageNamed:@"zengjia1.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addfile:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
}
//添加文件
- (void)addfile:(id)sender
{
    [self openCameraWithTitle:@"上传图片"];
}
//上传图片
- (void)openCameraWithTitle:(NSString *)title
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
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
    if (type == 1)
    {
        btnTag = 110;
        addarray = _imageArray;
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
        [bgView addSubview:btn];
    }
}
//点击文件的方法
- (void)check:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIActionSheet *sheet = nil;
    selectTag = btn.tag + 100;
    if (btn.tag >= 110)
    {
        selectFile = [_imageArray objectAtIndex:btn.tag - 110];
    }
//    NSString *bd = @"绑定简历";
//    if (selectFile.binding) {
//        bd = @"与简历解绑";
//    }
    sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预览",@"删除", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        //        [self presentViewController:imagePickerController animated:YES completion:^{}];
        [self presentModalViewController:imagePickerController animated:YES];
    }else{
        if (buttonIndex==0) {
            GGFullscreenImageViewController *imageVC = [[GGFullscreenImageViewController alloc] init];
            FileButton *fileBtn = (FileButton *)[bgView viewWithTag:selectTag];
            SDDataCache *imageCache = [SDDataCache sharedDataCache];
            NSData *imageData = [imageCache dataFromKey:selectFile.fileRealName fromDisk:YES];
            UIImage *image = [UIImage imageWithData:imageData];
            fileBtn.bgView.image = image;
            //UIImageView *iv = [[UIImageView alloc] initWithImage:image];
            imageVC.liftedImageView =fileBtn.bgView;
            [self presentModalViewController:imageVC animated:YES];
        }else if (buttonIndex==1){
            //删除附件
            [self deleteResumeFileBtn];
        }else{
            //取消
        }
    }
}
#pragma mark------图片代理方法
//如果图片不存在，则获得图片
- (void)getUrlAndRequest
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (ResumeFile *rf in _imageArray) {
        if (!rf.exsit) {
            [imageArray addObject:rf.downloadPath];
        }
    }
    if (imageArray.count > 0) {
        [self getImageAndSound:imageArray image:YES];
    }
    
}

/*获取图片和语音的队列
 *urls图片或语音的下载地址
 *IorS，yes图片，no语音
 */
- (void)getImageAndSound:(NSArray *)urls image:(BOOL)IorS
{
    NSMutableArray *fromArray = [NSMutableArray array];
    for (NSString *url in urls) {
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://timages.hrbanlv.com/%@",url]];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url2];
        request.delegate = self;
        request.requestMethod = @"GET";
        [request setDidFailSelector:@selector(getFail:)];
        [request setDidFinishSelector:@selector(getImageFinish:)];
        [fromArray addObject:request];
        
    }
    //队列请求
    ASINetworkQueue *queue = [ASINetworkQueue queue];
    [queue setMaxConcurrentOperationCount:1];
    [queue addOperations:fromArray waitUntilFinished:NO];
    //队列开始
    [queue go];
}

- (void)getImageFinish:(ASIHTTPRequest *)request
{
    
    for (ResumeFile *rf in _imageArray) {
        if (!rf.exsit) {
            rf.exsit = YES;
            SDDataCache *cache = [SDDataCache sharedDataCache];
            rf.myImage = [UIImage imageWithData:request.responseData];
            [cache storeData:request.responseData forKey:rf.fileRealName toDisk:YES];
            [self addFileInView];
            break;
        }
    }
    
}
- (void)getFail:(ASIHTTPRequest *)request{
    NSLog(@"失败");
}
#pragma mark - image picker delegte

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString *fileName = [self dateString];
    fileName = [fileName stringByAppendingPathExtension:@"jpg"];
    //将图片保存
    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    [imageCache storeData:imageData forKey:fileName toDisk:YES];
    UIImage *zipImage = nil;
    if (image.size.height > image.size.width) {
        zipImage = [Photo scaleImage:image toWidth:75*2 toHeight:100*2];
    }else
    {
        zipImage = [Photo scaleImage:image toWidth:100*2 toHeight:75*2];
    }
    uploadImage = zipImage;
    NSLog(@"path-----------------------------------%@",image);
    //上传图片
    [self uploadPath:zipImage name:fileName];
    
}
//上传图片
- (void)uploadPath:(UIImage *)image name:(NSString *)name
{
    
    HRNetWorkConnection *net = [[HRNetWorkConnection alloc] init];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:bgView animated:YES];
    [net sendHRResumeImageToServerWithImage:image imageName:name resume:YES resumeDic:_resumeModel];
}
#pragma mark----上传成功代理方法

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSString *state = [requestDic valueForKey:@"state"];
    [MBProgressHUD hideHUDForView:bgView animated:YES];
    NSLog(@"上传图片结果________%@",requestDic);
    if ([state integerValue]==1) {
        [self uploadResult:requestDic];
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    
}
- (void)receiveDataFail:(NSError *)error
{
    [MBProgressHUD hideHUDForView:bgView animated:YES];
}
- (void)requestTimeOut
{
    [MBProgressHUD hideHUDForView:bgView animated:YES];
}
//上传结果
- (void)uploadResult:(NSDictionary *)requestDic
{
    ResumeFile *file = [[ResumeFile alloc] init];
    file.fileRealName = [requestDic valueForKey:@"name"];
    file.userid = [requestDic valueForKey:@"id"];
    //    file.fileName = [requestDic valueForKey:@"file_showname"];
    //    file.attachment_id = [requestDic valueForKey:@"file_id"];
    file.downloadPath = [requestDic valueForKey:@"download_url"];
    file.downloadPath_mini = [requestDic valueForKey:@"download_url_mini"];
    file.type = [requestDic valueForKey:@"file_extension"];
    file.binding = YES;
    file.exsit = YES;
    file.fileItem = [ResumeFile fileType:file.type];
    file.myImage = uploadImage;
    if ([file.type isEqualToString:@"amr"]) {
        //        [_soundArray addObject:file];
        //        file.openPath = chatRecord.recordFilePath;
    }else
    {
        [_imageArray addObject:file];
    }
    [self addFileInView];
}
//删除文件
- (void)deleteResumeFileBtn
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, HRResumeAttachDelete);
    [MBProgressHUD showHUDAddedTo:bgView animated:YES];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:_resumeModel.pid forKey:@"pid"];
    [request setPostValue:selectFile.userid forKey:@"id"];
    [request setPostValue:kUserTokenStr forKey:@"userToken"];
    [request setPostValue:IMEI forKey:@"userImei"];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSLog(@"image  delete----------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        [[NSFileManager defaultManager] removeItemAtPath:selectFile.openPath error:nil];
        [_imageArray removeObject:selectFile];
        
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self addFileInView];
        [MBProgressHUD hideHUDForView:bgView animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:bgView animated:YES];
    }];
    [request startAsynchronous];
    
}

//时间（图片文件名）
- (NSString *)dateString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmsss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (void)backUp:(id)sender
{
    //    NSLog(@"返回");
    [self.companyDelegate configImgAry:_imageArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
