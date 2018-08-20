//
//  HR_ResumeAddNext.m
//  JobKnow
//
//  Created by Suny on 15/9/21.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeAddNext.h"

#import "More.h"
#import "VoiceConverter.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"
#import "AudioButton.h"
#import "MyTableCell.h"
#import "WebViewController.h"
#import "SDDataCache.h"
#import "GGFullscreenImageViewController.h"

@interface HR_ResumeAddNext ()

@end

@implementation HR_ResumeAddNext

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _moreArray = [NSMutableArray array];
        NSArray *more = [NSArray arrayWithObjects:@"图片简历",@"语音简历",@"文件简历",@"文本简历信息",nil];
        NSMutableArray *zu = [NSMutableArray array];
        for (NSInteger i = 0; i < more.count; i++)
        {
            More *m = [[More alloc] init];
            NSString *image = [NSString stringWithFormat:@"more_menu_%d@2x",(int)i];
            m.moreImage = [UIImage imageNamed:image];
            m.moreName = [more objectAtIndex:i];
            [zu addObject:m];
            switch (i)
            {
                
                case 2:
                    [_moreArray addObject:zu];
                    zu = [NSMutableArray array];
                    break;
                case 3:
                    [_moreArray addObject:zu];
                    zu = [NSMutableArray array];
                    break;
            }
        }
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [myTableView reloadData];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"简历中心"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"简历中心"];
}

//-(void)initDelegate{
//
//}

- (void)backUp:(id)sender
{
    if(self.isFromResumeAdd){
        for (UIViewController *item in self.navigationController.viewControllers) {
            if ([item isKindOfClass:[HR_ResumeList class]]) {
                [self.navigationController popToViewController:item animated:YES];
            }
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int num=ios7jj;
    _soundArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _fileArray = [NSMutableArray array];
    self.view.backgroundColor = XZHILBJ_colour;
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+num, iPhone_width, iPhone_height) style:UITableViewStyleGrouped];
    myTableView.delegate =self;
    myTableView.dataSource = self;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    
    [self addBackBtn];
    if (_isFromResumeAdd) {
        [self addTitleLabel:@"被推荐人基本信息填写"];
    }else{
        [self addTitleLabel:@"简历中心"];
    }
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    //预览按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor=[UIColor clearColor];
    registerBtn.frame = CGRectMake(iPhone_width-45,-3+num,45,50);
    registerBtn.showsTouchWhenHighlighted=YES;
    registerBtn.titleLabel.font=[UIFont systemFontOfSize: 16];
    [registerBtn setTitle:@"预览" forState:UIControlStateNormal];
    [registerBtn setTitle:@"预览" forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(resumeReview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
//    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0+num, CGRectGetWidth(self.view.bounds), 200)];
//    _pathCover.deleat =self;
//    if (IOS7) {
//        [_pathCover setBackgroundImage:[UIImage imageNamed:@"jianliBjios7.png"]];
//    }else{
//        [_pathCover setBackgroundImage:[UIImage imageNamed:@"jianliBj.png"]];
//    }
    
    
//    myTableView.tableHeaderView = self.pathCover;
//    __weak HR_ResumeDetail *wself = self;
//    [_pathCover setHandleRefreshEvent:^{
//        [self _refreshing];
//    }];
//    [self resetHeaderView];
//    [self _refreshing];
    /******************************************************************/
    
    
    
    chatRecord = [[ChatVoiceRecorderVC alloc] init];
    //录音界面
    recordView = [TipView defaultStander];
    recordView.label.text = @"松开结束录音";
    //录音完成
    uploadView = [[TipView alloc] initFinishRecord];
    uploadView.delegate = self;
    //添加录音
    sheetRecord = [[UIActionSheet alloc] init ];
    sheetRecord.frame = CGRectMake(0, 0, iPhone_width, 50);
    sheetRecord.title = @"\n\n\n";
    sheetRecordView = [[UIView alloc] init ];
    sheetRecordView.frame = CGRectMake(0, iPhone_height-80, iPhone_width, 50);
    sheetRecordView.alpha = 0;
    sheetRecordView.userInteractionEnabled = YES;
    [self.view addSubview:sheetRecordView];
    
    
    //录音界面背景
    UIImageView *sheetbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -45, iPhone_width, 126)];
    sheetbg.tag = 11;
    sheetbg.userInteractionEnabled = YES;
    sheetbg.image = [UIImage imageNamed:@"resume_recordbg.png"];
    [sheetRecord addSubview:sheetbg];
    [sheetRecordView addSubview:sheetbg];
    //关闭录音界面按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(iPhone_width - 60, 35, 60, 100);
    [closeBtn setImage:[UIImage imageNamed:@"close_record.png"] forState:UIControlStateNormal];
    closeBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    [closeBtn addTarget:self action:@selector(recordViewHidden) forControlEvents:UIControlEventTouchUpInside];
    [sheetbg addSubview:closeBtn];
    //录音按钮
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.tag = 12;
    recordBtn.frame = CGRectMake(iPhone_width/2 - 50, -50, 100, 100);
    [recordBtn setTitle:@"按住录音" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松开结束录音" forState:UIControlStateHighlighted];
    [recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [recordBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [recordBtn setTitleEdgeInsets:UIEdgeInsetsMake(110, 0, 0, 0)];
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"press_normal.png"] forState:UIControlStateNormal];
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"press_light.png"] forState:UIControlStateHighlighted];
    [recordBtn addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];
    [recordBtn addTarget:self action:@selector(finishRecord:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(beginRecord:) forControlEvents:UIControlEventTouchDown];
    [sheetRecord addSubview:recordBtn];
    [sheetRecordView addSubview:recordBtn];
    //播放录音按钮
    AudioButton *playBtn = [[AudioButton alloc] initWithFrame:CGRectMake(iPhone_width/2 - 50, -50, 100, 100)];
    playBtn.tag = 15;
    [playBtn setTitle:@"正在播放" forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [playBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [playBtn setTitleEdgeInsets:UIEdgeInsetsMake(110, 0, 0, 0)];
    [playBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [sheetbg addSubview:playBtn];
    
    img_View = [[UIView alloc]initWithFrame:CGRectMake(77, 5, 240, 55)];
    img_View.backgroundColor = [UIColor clearColor];
    img_View.tag = 390;
    
    sound_View = [[UIView alloc]initWithFrame:CGRectMake(77, 5, 240, 55)];
    sound_View.backgroundColor = [UIColor clearColor];
    sound_View.tag = 790;
    
    file_View = [[UIView alloc]initWithFrame:CGRectMake(77, 5, 240, 55)];
    file_View.backgroundColor = [UIColor clearColor];
    file_View.tag = 190;
    [self addFileInView];
    
    [self getResumeInfo];
    
}

- (void)addFileInView
{
    for (UIView *v in img_View.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in sound_View.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in file_View.subviews) {
        [v removeFromSuperview];
    }
    
    
    if (_soundArray.count > 0) {
        [self addfileButton:0];
    }
    if (_imageArray.count > 0) {
        [self addfileButton:1];
    }
    if (_fileArray.count > 0) {
        [self addfileButton:2];
    }
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
    NSInteger btnTag = 0;
    NSMutableArray *addarray = nil;
    if (type == 0) {
        addarray = _soundArray;
        btnTag = 100;
    }else if (type == 1)
    {
        btnTag = 110;
        addarray = _imageArray;
    }else if (type == 2)
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
        FileButton *btn = [[FileButton alloc] initWithFrame:CGRectMake(((i%4)*55), ((i/4) *55)+5, 45, 45) fileType:file.fileItem binding:YES resumeFile:file type:@"wai"];
        btn.btnTag = btnTag + i;
        btn.tag = btnTag + 100 + i;
        [btn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        switch (type) {
            case 0:
                [sound_View addSubview:btn];
                break;
            case 1:
                [img_View addSubview:btn];
                break;
            case 2:
                [file_View addSubview:btn];
                break;
            default:
                break;
        }
        
    }
}

//请求简历信息
- (void)getResumeInfo
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, HRResumeInfo);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,_resumeModelFromList.resumeUid,@"uid",nil];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:dic urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSDictionary *arr = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *data = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if ([data isEqualToString:@"please login"]) {
            //            OtherLogin *other = [OtherLogin standerDefault];
            //            [other otherAreaLogin];
        }else{
            _model_Resume = [[HRResumeInfoModel alloc] initWithDictionary:arr];
            _baseModel = _model_Resume.base;
            NSLog(@"简历信息====%@",arr);
            
            //
            //获得附件信息
            [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [self getFileInfoWithDic:arr];
            [myTableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}

-(void)getFileInfoWithDic:(NSDictionary *)dic{
    [_soundArray removeAllObjects];
    [_imageArray removeAllObjects];
    [_fileArray removeAllObjects];
    
    NSArray *i = [ResumeFile fileJsonFrom:dic Type:1];
    NSArray *s = [ResumeFile fileJsonFrom:dic Type:2];
    NSArray *f = [ResumeFile fileJsonFrom:dic Type:3];
    
    [_soundArray addObjectsFromArray:s];
    [_imageArray addObjectsFromArray:i];
    [_fileArray addObjectsFromArray:f];
    
    [self addFileInView];
    
    [self getUrlAndRequest];
    [myTableView reloadData];
    
}

//如果图片不存在，则获得图片
- (void)getUrlAndRequest
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (ResumeFile *rf in _imageArray) {
        if (!rf.exsit) {
            [imageArray addObject:rf.downloadPath];
        }
    }
    
    NSMutableArray *soundArray = [NSMutableArray array];
    for (ResumeFile *rf in _soundArray) {
        if (!rf.exsit) {
            [soundArray addObject:rf.downloadPath];
        }
    }
    
    if (imageArray.count > 0) {
        [self getImageAndSound:imageArray image:YES];
    }
    if(soundArray.count > 0)
    {
        [self getImageAndSound:soundArray image:NO];
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
        if (IorS) {
            [request setDidFinishSelector:@selector(getImageFinish:)];
        }else
        {
            NSLog(@"***************%@",url);
            [request setDidFinishSelector:@selector(getSoundFinish:)];
        }
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


- (void)getSoundFinish:(ASIHTTPRequest *)request
{
    for (ResumeFile *rf in _soundArray) {
        if (!rf.exsit) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSData *data = [NSData dataWithBytes:[request.responseData bytes] length:request.responseData.length];
            rf.exsit = YES;
            NSString *saveArmPath = [VoiceRecorderBaseVC getCacheDirectory];
            
            saveArmPath = [[saveArmPath stringByAppendingPathComponent:[self dateString]] stringByAppendingPathExtension:@"amr"];
            BOOL sucess = [fileManager createFileAtPath:saveArmPath contents:data attributes:nil];
            [VoiceConverter amrToWav:saveArmPath wavSavePath:rf.openPath];
            NSLog(@"path***************%@",rf.openPath);
            if (sucess) {
                [fileManager removeItemAtPath:saveArmPath error:nil];
            }
            break;
        }
    }
}

- (NSString *)dateString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmsss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


#pragma mark- HR_ResumeEditDelegate

-(void)resetRusumeModelWithBaseModel:(NSDictionary *)model_Base andJobString:(NSString *)jobString{
    _model_Resume.base.UserResumeName = [model_Base valueForKey:@"truename"];
    _model_Resume.base.UserResumeMobile = [model_Base valueForKey:@"mobile"];
    _model_Resume.base.UserResumeSex = [model_Base valueForKey:@"sex"];
    _model_Resume.base.work_years = [model_Base valueForKey:@"work_years"];
    _model_Resume.base.jobType = [model_Base valueForKey:@"job_sort"];
    _model_Resume.base.jobType_str = jobString;
    _model_Resume.base.recommContent = [model_Base valueForKey:@"recommend"];
    
}

#pragma mark- HR_ResumeTextDelegate
-(void)resetRusumeTextWithString:(NSString *)text{
    _model_Resume.perfectInfo = text;
    [myTableView reloadData];
}

#pragma mark- UIActionSheetDelegate

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
    }else if (actionSheet.tag == 256)
    {
        switch (buttonIndex) {
            case 0:
                // 预览
                if (selectFile.fileItem == FileImage) {
                    GGFullscreenImageViewController *imageVC = [[GGFullscreenImageViewController alloc] init];
                    FileButton *fileBtn = (FileButton *)[img_View viewWithTag:selectTag];
                    SDDataCache *imageCache = [SDDataCache sharedDataCache];
                    NSData *imageData = [imageCache dataFromKey:selectFile.fileRealName fromDisk:YES];
                    UIImage *image = [UIImage imageWithData:imageData];
                    fileBtn.bgView.image = image;
                    //UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                    imageVC.liftedImageView =fileBtn.bgView;
                    [self presentViewController:imageVC animated:YES completion:nil];
                }else if(selectFile.fileItem == FileSound)
                {
                    //                    [sheetRecord showInView:self.view];
                    sheetRecordView.alpha =1;
                    [self addRecordViewPlay:YES];
                    updateProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setAudioProgress) userInfo:nil repeats:YES];
                    [self playRecordPath:selectFile.openPath];
                }else
                {
                    [self getFileFromServer];
                }
                break;
                
            case 3:
                // 取消
                break;
        }
        
    }
    
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *str = _resumeModelFromList.resumeUid;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString*finame = [NSString stringWithFormat:@"_%@.png",str];
    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    //头像保存本地
    [imageCache storeData:imageData forKey:finame];
    //上传头像
    [self uploadHeadImage:image name:[NSString stringWithFormat:@"_%@.png",str]];
    image_current = image;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 上传头像
- (void)uploadHeadImage:(UIImage *)image name:(NSString *)name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken", _resumeModelFromList.resumeUid,@"uid",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"hr_api/hr_resume/uploadFace?"];
    [net send_HRIcon_ToServerWithImage:image imageName:name param:params withURLStr:urlStr];
    
}

#pragma mark 上传头像回调结果
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *status = [requestDic valueForKey:@"error"];
    if ([status intValue]  == 0) {
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        ghostView.message = @"上传成功";
        [ghostView show];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ReloadResumeListFromWeb object:nil];
    }
}
- (void)receiveDataFail:(NSError *)error
{
    ghostView.message = @"上传失败";
    [ghostView show];
}
- (void)requestTimeOut
{
    ghostView.message = @"连接超时";
    [ghostView show];
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

#pragma -make end

//设置播放进度
- (void)setAudioProgress
{
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
    float speed = resumePlayer.currentTime/resumePlayer.duration+0.021;
    [btn setProgress:speed];
}

- (void)recordViewHidden
{
    [updateProgress invalidate];
    sheetRecordView.alpha = 0;
    [resumePlayer stop];
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
    [btn setProgress:0];
    resumePlayer = nil;
    [sheetRecord dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark- AVAudioPlayerDelegate

//添加录音文件执行的方法,play，yes是预览，no，是录音
- (void)addRecordViewPlay:(BOOL)paly
{
    //背景
    UIImageView *sheetbg = (UIImageView *)[sheetRecordView viewWithTag:11];
    [sheetRecordView addSubview:sheetbg];
    //播放按钮
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
    [sheetRecord addSubview:btn];
    [sheetRecordView addSubview:btn];
    //录音按钮
    UIButton *recordBtn = (UIButton *)[sheetRecordView viewWithTag:12];
    recordBtn.alpha = 1;
    [sheetRecordView addSubview:recordBtn];
    if (paly) {
        [btn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        btn.alpha = 1;
        recordBtn.alpha = 0;
    }else
    {
        btn.alpha = 0;
        recordBtn.alpha = 1;
    }
}


- (void)playView
{
    
}
- (void)clickPlayBtn:(BOOL)py
{
    //NSLog(@"wavpath------------------------%@",chatRecord.recordFilePath);
    if (py) {
        [self playRecordPath:chatRecord.recordFilePath];
    }else
    {
        [resumePlayer stop];
    }
}

- (void)playRecord:(id)sender
{
    AudioButton *btn = (AudioButton *)sender;
    
    if (resumePlayer.playing) {
        [resumePlayer pause];
        [btn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [btn setTitle:@"停止播放" forState:UIControlStateNormal];
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        [btn setColourR:0.1 G:1.0 B:0.1 A:1.0];
        [btn setTitle:@"正在播放" forState:UIControlStateNormal];
        [resumePlayer play];
    }
}

- (void)playRecordPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL URLWithString:path];
        resumePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        resumePlayer.delegate = self;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [resumePlayer play];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [uploadView.play setBackgroundImage:[UIImage imageNamed:@"recording_playbutton_background.png"] forState:UIControlStateNormal];
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
    [btn setProgress:1];
    sheetRecordView.alpha = 0;
    [updateProgress invalidate];
    [sheetRecord dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark- UserInteractions

//点击文件的方法
- (void)check:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIActionSheet *sheet = nil;
    selectTag = btn.tag + 100;
    if (btn.tag >= 120) {
        selectFile = [_fileArray objectAtIndex:btn.tag - 120];
        
    }else if (btn.tag >= 110)
    {
        selectFile = [_imageArray objectAtIndex:btn.tag - 110];
    }else if (btn.tag >= 100)
    {
        selectFile = [_soundArray objectAtIndex:btn.tag - 100];
    }
    NSString *bd = @"绑定简历";
    if (selectFile.binding) {
        bd = @"与简历解绑";
    }
    sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预览", nil];
    sheet.tag = 256;
    [sheet showInView:self.view];
}


#pragma mark- 简历预览
-(void)resumeReview{
    WebViewController *web = [[WebViewController alloc]init];
    NSString *urlString = _model_Resume.userResumeUrl;
    web.urlStr = urlString;
    web.floog = @"简历预览";
    [self.navigationController pushViewController:web animated:YES];
    
}

#pragma mark- 上传简历头像方法
- (void)changeHeadViewf
{
    _head = YES;
    [self openCameraWithTitle:@"上传简历头像"];
}

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



#pragma mark- UITablewViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"——imgAry=%@ ---soundAry=%@ ---fileAry==%@",_imageArray,_soundArray,_fileArray);
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                if (_imageArray.count>0 && _imageArray.count<5) {
                    return 65;
                }else if (_imageArray.count>4)
                {
                    
                    img_View.frame = CGRectMake(77, 5, 240, 110);
                    return 120;
                }else{
                    return 50;
                }
                break;
            case 1:
                if (_soundArray.count>0) {
                    return 65;
                }else{
                    return 50;
                }
                break;
            case 2:
                if (_fileArray.count>0) {
                    return 65;
                }else{
                    return 50;
                }
                break;
            default:
                break;
        }
        
        return 50;
    }else if (indexPath.section == 2){
        return 0;
    }
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }else if(section == 2){
        return 0;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        cell.accessoryView = nil;
        
        UIView *v1 = (UIView *)[cell.contentView viewWithTag:390];
        UIView *v2 = (UIView *)[cell.contentView viewWithTag:790];
        UIView *v3 = (UIView *)[cell.contentView viewWithTag:190];
        [v1 removeFromSuperview];
        [v2 removeFromSuperview];
        [v3 removeFromSuperview];
    }
    if (indexPath.section!=2) {
        More *m = [[_moreArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewScrollPositionNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = m.moreName;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor grayColor];
        label.tag = 520;
        label.font = [UIFont fontWithName:Zhiti size:14];
        [cell.contentView addSubview:label];
        label.text = [NSString stringWithFormat:@""];
        label.textColor = [UIColor orangeColor];
        //    ResumeOperation *sr = [ResumeOperation defaultResume];
        
        if (indexPath.section ==1 && indexPath.row==0) {
            if (![_model_Resume.perfectInfo isNullOrEmpty]) {
                label.textColor = [UIColor blackColor];
                label.text = [NSString stringWithFormat:@""];
            }else{
                label.text = [NSString stringWithFormat:@"未添加"];
            }
        }
        
        if (indexPath.section==0 && indexPath.row==0) {
            [cell.contentView addSubview:img_View];
            if (_imageArray.count>0) {
                label.text= [NSString stringWithFormat:@""];
            }else{
                label.text = [NSString stringWithFormat:@"未添加"];
            }
        }else if(indexPath.section==0 && indexPath.row==1){
            [cell.contentView addSubview:sound_View];
            if (_soundArray.count>0) {
                label.text= [NSString stringWithFormat:@""];
            }else{
                label.text = [NSString stringWithFormat:@"未添加"];
            }
        }else if(indexPath.section==0 && indexPath.row==2){
            [cell.contentView addSubview:file_View];
            if (_fileArray.count>0) {
                label.text= [NSString stringWithFormat:@""];
            }else{
                label.text = [NSString stringWithFormat:@"未添加"];
            }
        }
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else if (section == 2){
        return 140;
    }
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,40)];
        UILabel *labrl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, iPhone_width-30, 40)];
        labrl.backgroundColor =[UIColor clearColor];
        labrl.text = @"完善图片、文件、语音等简历信息后，推荐成功率会提高30%以上哦!";
        labrl.font = [UIFont fontWithName:Zhiti size:13];
        labrl.textColor = [UIColor darkGrayColor];
        [labrl setLineBreakMode:NSLineBreakByWordWrapping];
        [labrl setNumberOfLines:0];
        [view addSubview:labrl];
        return view;
    }else if(section==2){
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,140)];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 17)];
        [image setImage:[UIImage imageNamed:@"ic_prompt"]];
        [view addSubview:image];
        
        UILabel *labrl2 = [[UILabel alloc]initWithFrame:CGRectMake(32, 8, iPhone_width-44, 40)];
        labrl2.backgroundColor =[UIColor clearColor];
        labrl2.text = @"简历中请勿出现人才联系电话等私密信息";
        labrl2.font = [UIFont fontWithName:Zhiti size:13];
        [labrl2 setLineBreakMode:NSLineBreakByWordWrapping];
        [labrl2 setNumberOfLines:0];
        labrl2.textColor = [UIColor orangeColor];
        [view addSubview:labrl2];
        
        UILabel *labrl1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, iPhone_width-30, 40)];
        labrl1.backgroundColor =[UIColor clearColor];
        labrl1.text = @"您可选择其中的一项或几项信息进行完善，也可跳过此步骤，直接完成创建。";
        labrl1.font = [UIFont fontWithName:Zhiti size:13];
        [labrl1 setLineBreakMode:NSLineBreakByWordWrapping];
        [labrl1 setNumberOfLines:0];
        labrl1.textColor = [UIColor darkGrayColor];
        [view addSubview:labrl1];
        
        UIButton *btn_confirm = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, iPhone_width-20*2, 40)];
        [btn_confirm setTitle:@"完成创建" forState:UIControlStateNormal];
        [btn_confirm setBackgroundColor:XZhiL_colour];
        [btn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_confirm addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn_confirm];

        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sheetRecordView.alpha =0;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   if (indexPath.section==0) {
        if (indexPath.row == 0) {
            
            HR_ResumeImageAttach *image = [[HR_ResumeImageAttach alloc]init];
            image.companyDelegate =self;
            image.imageArray = _imageArray;
            image.resumeModel = _model_Resume;
            [self.navigationController pushViewController:image animated:YES];
        }else if (indexPath.row == 1){
            
            HR_ResumeVoiceAttach *yuyin = [[HR_ResumeVoiceAttach alloc]init];
            yuyin.soundArray = _soundArray;
            yuyin.resumeModel = _model_Resume;
            yuyin.yyDelegate =self;
            [self.navigationController pushViewController:yuyin animated:YES];
        }else if (indexPath.row == 2){
            
            HR_ResumeFileAttach *file = [[HR_ResumeFileAttach alloc]init];
            file.fileArray = _fileArray;
            file.resumeModel = _model_Resume;
            [self.navigationController pushViewController:file animated:YES];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            HR_ResumeText *text = [[HR_ResumeText alloc] init];
            text.uid = _model_Resume.uid;
            text.content = _model_Resume.perfectInfo;
            text.delegate = self;
            [self.navigationController pushViewController:text animated:YES];
        }
    }
}

#pragma mark- scroll delegate


//图片 语音 代理方法
- (void)configImgAry:(NSMutableArray *)ary
{
    _imageArray = ary;
    NSLog(@"代理过来的数组_imageArray==%@",_imageArray);
    [self addFileInView];
    [myTableView reloadData];
}
//求职意向的代理方法
- (void)chuanInDic:(NSDictionary *)dic
{
    //    ResumeOperation *st = [ResumeOperation defaultResume];
    [self getResumeInfo];
}
//基本信息完善的代理方法
- (void)chuanonDic:(NSDictionary *)dic
{
    [self getResumeInfo];
}
- (void)configYuyinAry:(NSMutableArray *)ary
{
    _soundArray = ary;
    [self addFileInView];
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
