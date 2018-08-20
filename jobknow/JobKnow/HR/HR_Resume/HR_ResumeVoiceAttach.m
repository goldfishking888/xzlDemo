//
//  HR_ResumeVoiceAttach.m
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeVoiceAttach.h"
#import "AudioButton.h"
#import "FileButton.h"
#import "VoiceConverter.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "HRNetWorkConnection.h"

@interface HR_ResumeVoiceAttach ()
{
    BOOL isAdd;
    MBProgressHUD *hud;
}

@end

@implementation HR_ResumeVoiceAttach

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _soundArray = [NSMutableArray array];
        alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
        alert.position = OLGhostAlertViewPositionCenter;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"简历附件（语音）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"简历附件（语音）"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTitleLabel:@"简历附件"];
    int num = ios7jj;
    bgVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    bgVIew.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgVIew];
    
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
    
//    sheetRecordView_back = [[UIView alloc] init ];
//    sheetRecordView.frame = CGRectMake(0, iPhone_height-80, iPhone_width, 50);
//    sheetRecordView.alpha = 0;
//    sheetRecordView.userInteractionEnabled = YES;
//    [self.view addSubview:sheetRecordView];
    
    sheetRecordView = [[UIView alloc] init ];
    sheetRecordView.frame = CGRectMake(0, iPhone_height-150, iPhone_width, 150);
//    [sheetRecordView setBackgroundColor:[UIColor redColor]];
    sheetRecordView.alpha = 0;
    sheetRecordView.userInteractionEnabled = YES;
    [self.view addSubview:sheetRecordView];
    
    
    
    //录音界面背景
    UIImageView *sheetbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, sheetRecordView.frame.size.height-126, iPhone_width, 126)];
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
//    [recordBtn setBackgroundColor:[UIColor greenColor]];
    recordBtn.frame = CGRectMake(iPhone_width/2 - 50, sheetbg.frame.origin.y, 100, 100);
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
    AudioButton *playBtn = [[AudioButton alloc] initWithFrame:CGRectMake(iPhone_width/2 - 50, sheetbg.frame.origin.y, 100, 100)];
    playBtn.tag = 15;
    [playBtn setTitle:@"正在播放" forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [playBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [playBtn setTitleEdgeInsets:UIEdgeInsetsMake(110, 0, 0, 0)];
    [playBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [sheetbg addSubview:playBtn];
    
    NSLog(@"传过来的语音数组为------%@",_soundArray);
    [self addFileInView];
    [self getUrlAndRequest];
}

- (void)addaddBtn
{
    //语音按钮
    NSInteger index = 0;
    if (_soundArray.count < 4) {
        index = _soundArray.count;
        FileButton *btn = [[FileButton alloc] initWithFrame:CGRectMake(20+((index%4)*75), 60-44 +((index/4) *75), 55, 55) fileType:FileNone binding:NO resumeFile:nil type:@"li"];
        btn.tag = 151;
        [btn.fileBtn setBackgroundImage:[UIImage imageNamed:@"zengjia1.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addfile:) forControlEvents:UIControlEventTouchUpInside];
        [bgVIew addSubview:btn];
        
    }
}
- (void)addfile:(id)sender
{
    //    [sheetRecord showInView:bgVIew];
    sheetRecordView.alpha = 1;
    isAdd = YES;
    [self addRecordViewPlay:NO];
}
//添加录音文件执行的方法,play，yes是预览，no，是录音
- (void)addRecordViewPlay:(BOOL)paly
{
    //背景
    UIImageView *sheetbg = (UIImageView *)[sheetRecordView viewWithTag:11];
    //    [sheetRecord addSubview:sheetbg];
    sheetRecordView.alpha = 1;
    [sheetRecordView addSubview:sheetbg];
    [self.view addSubview:sheetRecordView];
    //播放按钮
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
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
//开始录音
- (void)beginRecord:(id)sender
{
    [bgVIew addSubview:recordView];
    [recordView show];
    
    //开始录音
    [chatRecord beginRecordByFileName:[self dateString]];
    
}

//完成录音
- (void)finishRecord:(id)sender
{
    if (recordView.time >= 2)
    {
        recordTime = recordView.time;
        [chatRecord.recorder stop];
        sheetRecordView.alpha = 0;
        [bgVIew addSubview:uploadView];
        [uploadView showPlay];
    }else
    {
        alert.message = @"录音时间太短";
        [alert show];
        [chatRecord.recorder stop];
        [chatRecord.recorder deleteRecording];
        
    }
    [recordView hidden];
    [sheetRecord dismissWithClickedButtonIndex:0 animated:YES];
}
//取消录音
- (void)cancelRecord:(id)sender
{
    [recordView hidden];
    [sheetRecord dismissWithClickedButtonIndex:0 animated:YES];
}

//取消
- (void)leftBtnAndRightClick
{
    [uploadView dismiss];
    [[NSFileManager defaultManager] removeItemAtPath:chatRecord.recordFilePath error:nil];
}

//上传
- (void)rightBtnAndRightClick
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _fileName = [VoiceRecorderBaseVC getCurrentTimeString];
    NSString *recordPath = [VoiceRecorderBaseVC getCacheDirectory];
    _fileName = [[recordPath stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:@"amr"];
    
    [VoiceConverter wavToAmr:chatRecord.recordFilePath amrSavePath:_fileName];
    HRNetWorkConnection *net = [[HRNetWorkConnection alloc] init];
    net.delegate = self;
    NSString *name = [[chatRecord.recordFilePath lastPathComponent] stringByDeletingPathExtension];
    name = [name stringByAppendingString:@".amr"];
    NSLog(@"wavpath------------------------%@",name);
    
    NSString *time = [[NSString alloc] initWithFormat:@"%d",recordTime];
    [net sendHRResumeVoiceToServerWithSound:_fileName soundName:name min:time resume:YES resumedic:_resumeModel];
    [uploadView dismiss];
}


#pragma mark----上传成功代理方法

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSString *state = [requestDic valueForKey:@"state"];
    //    NSLog(@"上传语音结果________%@",requestDic);
    if ([state integerValue]==1) {
        [self uploadResult:requestDic];
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    [MBProgressHUD hideHUDForView:bgVIew animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)receiveDataFail:(NSError *)error
{
    [MBProgressHUD hideHUDForView:bgVIew animated:YES];
}
- (void)requestTimeOut
{
    [MBProgressHUD hideHUDForView:bgVIew animated:YES];
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
    //    file.myImage = uploadImage;
    if ([file.type isEqualToString:@"amr"]) {
        [_soundArray addObject:file];
        file.openPath = chatRecord.recordFilePath;
        NSLog(@"rp------------------------------%@",file.openPath);
    }else
    {
        //        [_imageArray addObject:file];
    }
    [self addFileInView];
}
- (void)addFileInView
{
    for (UIView *v in bgVIew.subviews) {
        [v removeFromSuperview];
    }
    if (_soundArray.count > 0) {
        [self addfileButton:0];
    }
    [self addaddBtn];
}
//添加文件按钮
- (void)addfileButton:(NSInteger)type
{
    CGFloat xx = iPhone_width * type+20;
    
    NSInteger btnTag = 0;
    NSMutableArray *addarray = nil;
    
    if (type == 0) {
        addarray = _soundArray;
        btnTag = 100;
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
    selectFile = [_soundArray objectAtIndex:btn.tag - 100];
    selectTag = btn.tag + 100;
//    NSString *bd = @"绑定简历";
//    if (selectFile.binding) {
//        bd = @"与简历解绑";
//    }
    sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预览",@"删除", nil];
    [sheet showInView:bgVIew];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        //        [sheetRecord showInView:bgVIew];
        isAdd = NO;
        [self addRecordViewPlay:YES];
        updateProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setAudioProgress) userInfo:nil repeats:YES];
        [self playRecordPath:selectFile.openPath];
    }else if (buttonIndex==1){
        //删除附件
        sheetRecordView.alpha = 0;
        [self deleteResumeFileBtn];
    }else{
        //取消
    }
}


- (void)clickPlayBtn:(BOOL)py
{
    //    NSLog(@"wavpath------------纷纷------------%@",chatRecord.recordFilePath);
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
//设置播放进度
- (void)setAudioProgress
{
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
    float speed = resumePlayer.currentTime/resumePlayer.duration+0.021;
    [btn setProgress:speed];
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
    AudioButton *btn = (AudioButton *)[sheetRecord viewWithTag:15];
    [btn setProgress:1];
    if (!isAdd) {
        sheetRecordView.alpha = 0;
    }
    
    [updateProgress invalidate];
    [sheetRecord dismissWithClickedButtonIndex:0 animated:YES];
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
        NSLog(@"voice delete---------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        [[NSFileManager defaultManager] removeItemAtPath:selectFile.openPath error:nil];
        [_soundArray removeObject:selectFile];
        
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self addFileInView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}

//如果语音不存在，则获得语音
- (void)getUrlAndRequest
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (ResumeFile *rf in _soundArray) {
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
        NSLog(@"***************%@",url);
        [request setDidFinishSelector:@selector(getSoundFinish:)];
        [fromArray addObject:request];
        
    }
    //队列请求
    ASINetworkQueue *queue = [ASINetworkQueue queue];
    [queue setMaxConcurrentOperationCount:1];
    [queue addOperations:fromArray waitUntilFinished:NO];
    //队列开始
    [queue go];
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
- (void)getFail:(ASIHTTPRequest *)request{
    NSLog(@"语音失败");
}
//时间（录音文件名）
- (NSString *)dateString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmsss"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (void)recordViewHidden
{
    sheetRecordView.alpha = 0;
    [updateProgress invalidate];
    [resumePlayer stop];
    AudioButton *btn = (AudioButton *)[sheetRecordView viewWithTag:15];
    [btn setProgress:0];
    resumePlayer = nil;
    [sheetRecord dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)backUp:(id)sender
{
    //    NSLog(@"返回");
    [self.yyDelegate configYuyinAry:_soundArray];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
