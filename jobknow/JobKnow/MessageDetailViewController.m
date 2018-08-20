//
//  MessageDetailViewController.m
//  JobKnow
//

#import "MessageDetailViewController.h"
#import "MessageDetailCell.h"
#import "JobInfo.h"
#import "MessageDetailModel.h"
#import "VoiceConverter.h"
#import "Attachment.h"
#import "Photo.h"
#import "SDDataCache.h"
#import "ImageViewController.h"
#import "ASINetworkQueue.h"
#import "jobRead.h"
#import "GGFullScreenImageViewController.h"
#import "WebViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "AFURLSessionManager.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController
NSString *contentStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+ios7jj , iPhone_width, iPhone_height -44-ios7jj) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_tableView];
    [self addBackBtn];
    [self addCenterTitle:[NSString stringWithFormat:@"%@",self.message.name]];//title

    [self defaultInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:kReceiveRemoteNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.message.isread = [NSNumber numberWithInt:1];
    [self.message saveOrUpdate];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageListTableReload object:nil];
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_netWork) {
        _netWork.delegate = nil;
    }
}

#pragma mark 初始化界面

- (void)defaultInit
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    keyBoard = YES;
    edit = YES;
    
    sendAlert = [[OLGhostAlertView alloc] initWithTitle:nil message:@"正在发送..." timeout:15 dismissible:NO];
    sendAlert.position = OLGhostAlertViewPositionCenter;
    
    fileSe = [NSMutableArray array];
    //选择附件的数组
    selectFiles = [NSMutableArray array];
    self.messageArray = [NSMutableArray array];
    tipV = [TipsView standerDefault];
    [self.view addSubview:tipV];
    
    //注册播放通知（图片、语音、简历预览）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postPlay:) name:@"play" object:nil];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, iPhone_width, 44)];
    
    //添加文件按钮
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(279, containerView.frame.size.height - 39, 32, 32);
    [sendBtn addTarget:self action:@selector(addfileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background_highlighted.png"] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background.png"] forState:UIControlStateNormal];
    
    self.fileView = [[FileView alloc] initWithItems];
    self.fileView.alpha = 0;
    self.fileView.isFromHr = _isFromHr;
    [self.fileView defaultInit];
    self.fileView.fileDelegate = self;
    [self.view addSubview:self.fileView];
    
    //录音按钮
    recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.layer.cornerRadius = -3;
    //添加取消
    [recordBtn addTarget:self action:@selector(swipeCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [recordBtn addTarget:self action:@selector(tapRecord:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchDown];
    
    recordBtn.frame = CGRectMake(45, 4.5, iPhone_width - 90, 38);
    [recordBtn setTitle:@"按住发送语音" forState:UIControlStateNormal];
    [recordBtn setTitle:@"松手结束录音" forState:UIControlStateHighlighted];
    [recordBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    recordBtn.alpha = 0;
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"recordbg.png"] forState:UIControlStateNormal];
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"recordbg.png"] forState:UIControlStateHighlighted];
    
    //录音
    charVC = [[ChatVoiceRecorderVC alloc] init];
    //播放
    
    //语音按钮
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(9, containerView.frame.size.height - 39, 32, 32);
    [leftBtn addTarget:self action:@selector(sendRecording:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"message_voice_background.png"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"mess    age_voice_background_highlighted.png"] forState:UIControlStateHighlighted];
    
    containerView.backgroundColor = [UIColor redColor];
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(45, 6, iPhone_width - 90, 30)];
    
    //输入框
    _textView.internalTextView.backgroundColor = [UIColor clearColor];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.minNumberOfLines = 1;
    _textView.maxNumberOfLines = 3;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15.0f];
    _textView.internalTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textView.delegate = self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    _textView.text = _defautText;
    [_textView refreshHeight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"sixininput.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:12 topCapHeight:20];
    
    //输入框背景图片
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(40, 2, iPhone_width - 80, _textView.frame.size.height+10);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    //整个背景
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background] ;
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [containerView addSubview:imageView];
    [containerView addSubview:entryImageView];
    [containerView addSubview:_textView];
    [containerView addSubview:leftBtn];
    [containerView addSubview:recordBtn];
    [containerView addSubview:sendBtn];
    [self.view addSubview:containerView];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.frame = CGRectMake(0, 44, iPhone_width, iPhone_height - containerView.frame.size.height - 44);
    self.tableView.allowsSelection = NO;
    
    // 下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"下拉加载更多";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHiddenKeyboard:)];
    [self.tableView addGestureRecognizer:tap];
    
    
    tips = [TipView defaultStander];
    tips.delegate = self;
    [self.view addSubview:tips];
    
    [self initDataFromDB];
    // 获取一下最新的消息
    [self requestDataWithToward:DetailRequestForward];

}

#pragma mark - 收到推送消息

- (void)receiveRemoteNotification{
    
    [self requestDataWithToward:DetailRequestForward];
    
}

#pragma mark - 下拉刷新的方法
- (void)headerRefresh{
    
    // 取历史记录
    [self requestDataWithToward:DetailRequestBackward];
    
}

#pragma mark - 从DB中获取数据

- (void)initDataFromDB{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tempArray = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ and sendStatus <>%d order by dateline asc",_message.plid,MessageSendStatusSending]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _messageArray = [NSMutableArray arrayWithArray:tempArray];
            [self scrollToTableViewBottom];
        });
    });
}

#pragma mark - 获取单个联系人的聊天记录
- (void)requestDataWithToward:(DetailRequestToward)toward
{
    Net *n = [Net standerDefault];
    if (n.status == NotReachable) {
        alert.message = @"无网络连接，请检查您的网络！";
        [alert show];
        return;
    }

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:IMEI forKey:@"userImei"];
    [paramDic setValue:kUserTokenStr forKey:@"userToken"];
    [paramDic setValue:_message.plid forKey:@"plid"];
    NSString *sqlCriteria = nil;
    if (toward == DetailRequestForward) {//取新
        sqlCriteria = [NSString stringWithFormat:@"where plid = %@ and sendStatus = %d order by dateline desc",_message.plid,MessageSendStatusSuccess];
    }else{// 取旧
        sqlCriteria = [NSString stringWithFormat:@"where plid = %@ and sendStatus = %d order by dateline asc",_message.plid,MessageSendStatusSuccess];
    }
    MessageDetailModel *tempModel = [MessageDetailModel findFirstByCriteria:sqlCriteria];
    NSString *lastDateline = tempModel ? tempModel.dateline : @"0";
    if([lastDateline isEqualToString:@"0"] == NO){
        lastDateline = [XZLUtil changeDateStrToTimestampStr:lastDateline];
    }
    [paramDic setValue:lastDateline forKey:@"dateline"];
    [paramDic setValue:@(toward) forKey:@"getunread"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/pm/session_list_new?"];
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        if ([_tableView isHeaderRefreshing] == YES) {
            [_tableView headerEndRefreshing];
        }
        NSError *err;
        NSDictionary *data=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&err];

        NSNumber *error = data[@"error"];
        if ([error isEqualToNumber:@(0)] == YES) {
            NSMutableArray *array = data[@"data"];
            NSString *resumeUrl = data[@"resumeUrl"];
            if (resumeUrl.length >0 && [resumeUrl isEqualToString:@"(null)"] == NO) {
                [mUserDefaults setValue:resumeUrl forKey:@"resumeUrl"];
            }
            NSLog(@"Detail 获取到%@",array);
            if ([array count] > 0) {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (NSDictionary *dataDic in array) {
                    MessageDetailModel *tempModel = [MessageDetailModel getMessageDetailModelWithDic:dataDic];
                    tempModel.sendStatus = MessageSendStatusSuccess;
                    [tempArray addObject:tempModel];
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   BOOL succeed =  [MessageDetailModel saveOrUpdateObjects:tempArray];
                    
                    if((toward == DetailRequestForward) && ([tempArray count] == 20)&&succeed){// 取新时，如果获取到20条数据，则继续去获取
                        [self requestDataWithToward:DetailRequestForward];
                    }
                    NSArray *arrayTemp = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ order by dateline asc",_message.plid]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _messageArray = [NSMutableArray arrayWithArray:arrayTemp];
                        if (toward == DetailRequestForward) {
                            [self scrollToTableViewBottom];
                        }else{
                            [_tableView reloadData];// 刷新
                        }
                    });
                });
            }
        }
        
    }];
    
    [request setFailedBlock:^{
        if ([_tableView isHeaderRefreshing] == YES) {
            [_tableView headerEndRefreshing];
        }
        alert.message = @"获取数据失败，请检查网络";
        [alert show];
        
    }];
    [request startAsynchronous];

    
}


#pragma mark 拼接消息内容
- (NSString *)messageInit
{
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    NSString *sh = [myUser valueForKey:@"user_sh"];
    NSString *tel = [myUser valueForKey:@"user_tel"];
    NSString *messageString = [[NSString alloc] initWithFormat:@"您好，我应聘：%@，我毕业于：%@，我的联系电话是：%@",self.postName,sh,tel];
    return messageString;
}

#pragma mark 点击隐藏键盘
- (void)tapHiddenKeyboard:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.fileView.alpha = 0;
        
    }];
    keyBoard = YES;
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background.png"] forState:UIControlStateNormal];
    [self.textView resignFirstResponder];
    
    self.tableView.frame = CGRectMake(0, 44, iPhone_width,iPhone_height-88);
    containerView.frame = CGRectMake(0, iPhone_height -20+ios7jj - 44 -(containerView.frame.size.height-44), iPhone_width, containerView.frame.size.height);
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark 语音按钮的点击事件
- (void)sendRecording:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    [btn setImage:nil forState:UIControlStateNormal];
    [btn setImage:nil forState:UIControlStateHighlighted];
    
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background_highlighted.png"] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background.png"] forState:UIControlStateNormal];
    if (recordBtn.alpha == 0) {
        [btn setBackgroundImage:[UIImage imageNamed:@"message_board_background.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"message_board_background_highlighted.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"message_voice_background.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"message_voice_background_highlighted.png"] forState:UIControlStateHighlighted];
    }
    
    if (recordBtn.alpha == 0) {
        CGFloat h = 0;
        inputFrame = containerView.frame;
        if (containerView.frame.size.height > 44) {
            h = containerView.frame.size.height - 44;
        }
        _textView.alpha = 0;
        recordBtn.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.fileView.alpha = 0;
            containerView.frame = CGRectMake(0, iPhone_height - 44 -20+ios7jj, iPhone_width, 44);
        }];
        keyBoard = YES;
        [_textView resignFirstResponder];
        self.tableView.frame = CGRectMake(0, 44, iPhone_width,iPhone_height-20+ios7jj- 44 -containerView.frame.size.height);
    }else
    {
        _textView.alpha = 1;
        keyBoard = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.fileView.alpha = 0;
            containerView.frame = CGRectMake(0, iPhone_height -20+ios7jj- inputFrame.size.height, iPhone_width, inputFrame.size.height);
        }];
        [_textView becomeFirstResponder];
        self.tableView.frame = CGRectMake(0, 44, iPhone_width,iPhone_height- 44 -containerView.frame.size.height);
        recordBtn.alpha = 0;
    }
}

//取消录音
- (void)swipeCancel:(id)sender
{
    [tips hidden];
    [charVC.recorder stop];
    alert.message = @"取消发送";
    [alert show];
    if([charVC.recorder deleteRecording])
    {
        NSLog(@"-----------------删除录音");
    }
}

- (void)tapRecord:(id)sender
{
    if (tips.time >= 2)
    {
        [charVC.recorder stop];
        [selectFiles removeAllObjects];
        NSString *min = [[NSString alloc] initWithFormat:@"%d",tips.time];
        [self rightBtnAndRightClick:min];
    }else
    {
        alert.message = @"录音时间太短";
        [alert show];
        [charVC.recorder stop];
        [charVC.recorder deleteRecording];
        
    }
    [tips hidden];
}


#pragma mark 接受通知，播放语音或查看图片或查看简历
- (void)postPlay:(NSNotification *)notification
{
    NSString *type = [notification.userInfo valueForKey:@"type"];
    NSLog(@"userinfo---------------%@",notification.userInfo);
    if ([type isEqualToString:@"image"]) {
        NSString *localImage = [notification.userInfo valueForKey:@"localImage"];
        NSString *url = [notification.userInfo valueForKey:@"url"];
        GGFullscreenImageViewController *imageVC = [[GGFullscreenImageViewController alloc] init];
        UIImageView *rv = [notification.userInfo valueForKey:@"rect"];
        UIImage *image = nil;
        if ([localImage isEqualToString:@"1"]) {//本地存在的
            image = [UIImage imageWithContentsOfFile:url];
        }else{
            image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        }
        
        imageVC.liftedImageView = rv;
        imageVC.liftedImageView.image = image;
        [self presentViewController:imageVC animated:YES completion:^(void){}];
    }else if ([type isEqualToString:@"sound"])
    {
        NSInteger num = 0;
        for (MessageDetailModel *message in _messageArray) {
            if ([message.pmtype intValue] == 2) {// 语音
                NSIndexPath *tpath = [NSIndexPath indexPathForRow:num inSection:0];
                MessageDetailCell *cell = (MessageDetailCell *)[_tableView cellForRowAtIndexPath:tpath];
                [cell.sendImageView stopAnimating];
            }
            num ++;
        }
        NSString *name = [notification.userInfo valueForKey:@"name"];
        NSString *wavSavePath = [[[[self getAudioPath] stringByAppendingPathComponent:name] stringByDeletingPathExtension] stringByAppendingString:@".wav"];
        [self playRecordPath:wavSavePath];
    }else
    {
        WebViewController *web = [[WebViewController alloc]init];
        if (_isFromHr) {
            NSString *query_string = [notification.userInfo valueForKey:@"query_string"];
            NSString *url = [NSString stringWithFormat:@"%@adminapi/look_hr_resume/view_resume?%@",KXZhiLiaoAPI,query_string];
            web.urlStr =url;
            NSLog(@"%@",url);
        }else{
            NSString *resumeUrl = [mUserDefaults valueForKey:@"resumeUrl"];
            web.urlStr = resumeUrl;
        }
        web.floog = @"简历预览";
        [self.navigationController pushViewController:web animated:YES];
    }
    
}
#pragma mark 播放语音
- (void)playRecordPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL URLWithString:path];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        player.delegate = self;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [player play];
    }
}

//录音
- (void)record:(id)sender
{
    [tips show];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:date];
    //开始录音
    [charVC beginRecordByFileName:dateString];
}

#pragma mark - AVAudioRecorderDelegate

//开始录音
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    
}


//结束录音
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}


#pragma mark - TipViewDelegate

- (void)recordTimeOut
{
    
    alert.message = @"录音超时，停止录音";
    [charVC.recorder stop];
    [alert show];
}

- (void)leftBtnAndRightClick
{
    [play.play setBackgroundImage:[UIImage imageNamed:@"recording_playbutton_background.png"] forState:UIControlStateNormal];
    play.p = YES;
    [player stop];
    [charVC.recorder deleteRecording];
    [play dismiss];
}

//播放录音
- (void)clickPlayBtn:(BOOL)py
{
    if (py) {
        [self playRecordPath:charVC.recordFilePath];
    }else
    {
        [player stop];
    }
}

#pragma mark - 发送语音
- (void)rightBtnAndRightClick:(NSString *)min
{
    NSString *fileName = [[charVC.recordFilePath lastPathComponent] stringByDeletingPathExtension];
    fileName = [fileName stringByAppendingString:@".amr"];;
    NSString *cachePath = [VoiceRecorderBaseVC getCacheDirectory];
    NSString *soundPath = [cachePath stringByAppendingPathComponent:fileName];
    [VoiceConverter wavToAmr:charVC.recordFilePath amrSavePath:soundPath];
    
    [self sendVoiceFileWithFileName:fileName FilePath:soundPath time:min];
    
//    _netWork = [[NetWorkConnection alloc] init];
//    _netWork.delegate = self;
//    //上传录音
//    [_netWork sendToServerWithSound2:soundPath soundName:fileName min:min resume:NO companyid:self.message.soureId];
}

#pragma mark-发送语音ASIBlock方法
-(void)sendVoiceFileWithFileName:(NSString *)name FilePath:(NSString *)path time:(NSString *)min{
    
    MessageDetailModel *detailModel = [[MessageDetailModel alloc] init];
    detailModel.plid = _message.plid;
    detailModel.msg = @"[语音]";
    detailModel.isself = @(1);
    detailModel.pmtype = @"2";
    detailModel.dateline = [XZLUtil changeDateToString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    detailModel.download_url = @"";
    detailModel.download_url_mini = @"";
    detailModel.file_real_name = name;
    detailModel.sendStatus = MessageSendStatusSending;
    detailModel.soundTime = min;
    [detailModel saveOrUpdate];
    [_messageArray addObject:detailModel];
    [self scrollToTableViewBottom];
    
    NSString *urlStr=@"http://timages.hrbanlv.com/pm2/upload?";
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"0",@"flag",@"1",@"pflag",min,@"soundTime",min,@"file_size",_message.soureId,@"otherId",name,@"fileName",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
//    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    [request setFile:path forKey:@"Filedata"];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            
            
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"请求成功");
            detailModel.pmid = [resultDic valueForKey:@"pmid"];
            detailModel.dateline = [resultDic valueForKey:@"time"];
            detailModel.download_url = [resultDic valueForKey:@"download_url"];
            detailModel.download_url_mini = [resultDic valueForKey:@"download_url_mini"];
            detailModel.sendStatus = MessageSendStatusSuccess;
            [detailModel saveOrUpdate];
            [_tableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
            _message.dateline = detailModel.dateline;
            _message.msg = detailModel.msg;
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        detailModel.sendStatus = MessageSendStatusFail;
        [detailModel saveOrUpdate];
        [_tableView reloadData];
    }];
    [request startAsynchronous];

}

#pragma mark 下载语音文件
- (void)downloadAudioWithPath:(NSString *)path name:(NSString *)name{
    NSURL *URL = [NSURL URLWithString:path];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
     [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;  需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
         [self changeAudioFromAmrToWav:name];

        
    }];
    
}

#pragma mark 保存语音路径
- (NSString *)getAudioPath
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return cachesPath;
}

#pragma mark 文件是否存在
- (BOOL)isExistAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark 将下载的amr转换为wav格式保存

- (void)changeAudioFromAmrToWav:(NSString *)amrName
{
    if ([amrName rangeOfString:@".amr"].length == 0) {
        NSLog(@"%@不是一个wav文件名",amrName);
        return;
    }
    NSString *amrSavePath = [[self getAudioPath] stringByAppendingPathComponent:amrName];
    NSString *wavSavePath = [[amrSavePath stringByDeletingPathExtension] stringByAppendingString:@".wav"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:amrSavePath] == NO) {
        NSLog(@"%@要转换的文件不存在",amrSavePath);
        return;
    }
    if ([fileManager fileExistsAtPath:wavSavePath] == YES) {
        NSLog(@"%@该路径已经存在",wavSavePath);
        return;
    }
    [VoiceConverter amrToWav:amrSavePath wavSavePath: wavSavePath];
    if ([fileManager fileExistsAtPath:wavSavePath] == YES) {
        NSLog(@"转换成功！");
    }
}



#pragma mark - AVAudioPlayerDelegate
//播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

#pragma mark - FileViewDelegate
//- (void)sendFile
//{
//    NSString *urlString = [[NSString alloc]initWithFormat:@"%@%@",KXZhiLiaoAPI,kSendFiles];
//    NSString *string = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthID];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:string,kAuthID, nil];
//    
//    //请求附件信息
//    _netWork = [[NetWorkConnection alloc] init];
//    _netWork.delegate = self;
////    _infoRequest = InfoRequestUpload;
//    [_netWork sendRequestURLStr:urlString ParamDic:dic Method:@"GET"];
//}
- (void)sendPhoto
{
    [self sendPhotoToCompany:UIImagePickerControllerSourceTypePhotoLibrary];
}

//发送简历
- (void)sendResume
{
    
    NSString *companyID=self.message.soureId;
    NSLog(@"companyID in postBtnClick is %@",companyID);
    
    NSString *jobID=self.jobId;
    NSLog(@"jobID in postBtnClick is %@",jobID);
    
    NSString *cityCode=self.cityCode;
    NSLog(@"cityCode in  postBtnClick is %@",cityCode);
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    NSString *nameStr=[userDefaults valueForKey:@"personName"];
    NSString *telephoneStr=[userDefaults valueForKey:@"user_tel"];
    NSString *workYearStr=[userDefaults valueForKey:@"mWorkYear"];
    
    NSLog(@"userName is %@\nworkYear is %@\ntelphone is %@",nameStr,telephoneStr,workYearStr);
    
    contentStr=[NSString stringWithFormat:@"简历:%@,工作经验:%@,联系电话:%@",nameStr,workYearStr,telephoneStr];
    
    
    MessageDetailModel *model = [[MessageDetailModel alloc] init];
    model.plid = _message.plid;
    model.msg = contentStr;
    model.isself = @(1);
    model.pmtype = @"0";
    model.dateline = [XZLUtil changeDateToString:[NSDate new] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    model.sendStatus = MessageSendStatusSending;
    [model saveOrUpdate];
    [_messageArray addObject:model];
    
    [self scrollToTableViewBottom];
    
    
    NSString *url = kCombineURL(KXZhiLiaoAPI, kSendMessage);
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:IMEI,kUserTokenStr,self.message.soureId,@"1", @"0",contentStr,nil] forKeys:[NSArray arrayWithObjects:@"userImei",@"userToken",@"toUserid",@"device_type" ,@"type",@"content",nil]];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:dic urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    //    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(errorStr&&errorStr.integerValue == 0&&errorStr){
            NSLog(@"发送成功");
            model.pmid = [resultDic valueForKey:@"pmid"];
            model.dateline = [resultDic valueForKey:@"time"];
            model.sendStatus = MessageSendStatusSuccess;
            [model saveOrUpdate];
            [_tableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
            _message.dateline = model.dateline;
            _message.msg = model.msg;
        }else{
            model.sendStatus = MessageSendStatusFail;
            [model saveOrUpdate];
            [_tableView reloadData];
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        model.sendStatus = MessageSendStatusFail;
        [model saveOrUpdate];
        [_tableView reloadData];
    }];
    [request startAsynchronous];

    
}
//打开照相机
- (void)sendCamer
{
    if (selectFiles.count >= 3) {
        return;
    }
    [self sendPhotoToCompany:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)selectFile:(File *)f
{
    [selectFiles removeAllObjects];
    [selectFiles addObject:f];
    
    _textView.text = [self messageInit];
    [_textView becomeFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    
//    Net *n = [Net standerDefault];
//    if (n.status == NotReachable) {
//        alert.message = @"无网络连接，请检查您的网络！";
//        [alert show];
//        return;
//    }
    [selectFiles removeAllObjects];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *files = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        files = [[NSString alloc]initWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    }else if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        files = [[NSString alloc]initWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
        UIImageWriteToSavedPhotosAlbum(image,
                                       self, @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
    }
    
    // 存到沙盒中
    [UIImagePNGRepresentation(image) writeToFile:[[self getImagePath] stringByAppendingPathComponent:files] atomically:YES];
    MessageDetailModel *detailModel = [[MessageDetailModel alloc] init];
    detailModel.plid = _message.plid;
    detailModel.msg = @"[图片]";
    detailModel.isself = @(1);
    detailModel.pmtype = @"1";
    detailModel.dateline = [XZLUtil changeDateToString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    detailModel.download_url = @"";
    detailModel.download_url_mini = @"";
    detailModel.file_real_name = files;
    detailModel.sendStatus = MessageSendStatusSending;
    [detailModel saveOrUpdate];
    [_messageArray addObject:detailModel];
    [self scrollToTableViewBottom];
    
        NSLog(@"imageinfo-------------------%@",info);
        // 发送图片

//    NSData *imagedata = UIImageJPEGRepresentation(image, 1.0);
    NSString *urlStr=@"http://timages.hrbanlv.com/pm2/upload?";
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"2",@"pflag",_message.soureId,@"otherId",@"0",@"iscom",@"0",@"flag",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    //    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
//    for (NSString *tempKey in [paramDic allKeys]) {
//        NSString *tempValue = [NSString stringWithFormat:@"%@",paramDic[tempKey]];
//        [request setPostValue:tempValue forKey:tempKey];
//    }
    NSString *filePath = [[self getImagePath] stringByAppendingPathComponent:files];
    [request setFile:filePath forKey:@"Filedata"];
//    [request setFile:filePath withFileName:files andContentType:@"image/jpeg" forKey:@"Filedata"];
    

    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        

        if(errorStr.integerValue == 0&&errorStr){
            NSLog(@"发送成功");
//            NSString *str = [NSString stringWithFormat:@"%@",[resultDic valueForKey:@"message"]];
//            NSLog(str);
            detailModel.pmid = [resultDic valueForKey:@"pmid"];
            detailModel.dateline = [resultDic valueForKey:@"time"];
            detailModel.download_url = [resultDic valueForKey:@"download_url"];
            detailModel.download_url_mini = [resultDic valueForKey:@"download_url_mini"];
            detailModel.sendStatus = MessageSendStatusSuccess;
            [detailModel saveOrUpdate];
            [_tableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
            _message.dateline = detailModel.dateline;
            _message.msg = detailModel.msg;
            
        }else{
            [loadView hide:YES];
            detailModel.sendStatus = MessageSendStatusFail;
            [detailModel saveOrUpdate];
            [_tableView reloadData];
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        detailModel.sendStatus = MessageSendStatusFail;
        [detailModel saveOrUpdate];
        [_tableView reloadData];
    }];
    [request startAsynchronous];

}


//打开相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)info
{
    NSLog(@"error------------------------%@",error);
}

#pragma mark - 获得图片路径
- (NSString *)getImagePath
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return cachesPath;
}

- (void)sendPhotoToCompany:(UIImagePickerControllerSourceType)type
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:^(void){}];
    }
}

#pragma mark 添加按钮点击事件
- (void)addfileBtnClick:(id)sender
{
    if (edit) {
        recordBtn.alpha = 0;
        _textView.alpha = 1;
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"message_voice_background.png"] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"message_voice_background_highlighted.png"] forState:UIControlStateHighlighted];
        if (keyBoard) {
            keyBoard = NO;
            
            [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_board_background.png"] forState:UIControlStateNormal];
            [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_board_background_highlighted.png"] forState:UIControlStateHighlighted];
            if (inputFrame.size.height > 50)
            {
                containerView.frame = CGRectMake(0, iPhone_height +ios7jj- 216 - inputFrame.size.height, iPhone_width, inputFrame.size.height);
            }else
            {
                containerView.frame = CGRectMake(0, iPhone_height - 216 - containerView.frame.size.height, iPhone_width, containerView.frame.size.height);
            }
            [UIView animateWithDuration:0.3 animations:^{self.fileView.alpha = 1.;}];
            CGRect rect_containerView = containerView.frame;
            NSLog([NSString stringWithFormat:@"containerView x=%f y=%f wid =%f height = %f",rect_containerView.origin.x,rect_containerView.origin.y,rect_containerView.size.width,rect_containerView.size.height]);

            
        }
        else
        {
            [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background_highlighted.png"] forState:UIControlStateHighlighted];
            [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background.png"] forState:UIControlStateNormal];
            [_textView.internalTextView becomeFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{self.fileView.alpha = 0.;}];
            [UIView animateWithDuration:0.25
                             animations:^{
                                 containerView.frame = CGRectMake(0, iPhone_height -20 +ios7jj - _defaultkeyboardRect.size.height - containerView.frame.size.height, iPhone_width, containerView.frame.size.height);
                             }completion:^(BOOL finished) {
                                 self.tableView.frame = CGRectMake(0, 44, iPhone_width,iPhone_height - 44 - _defaultkeyboardRect.size.height - containerView.frame.size.height);
                                 [UIView animateWithDuration:0.3 animations:^{
                                     self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height -(iPhone_height -  _defaultkeyboardRect.size.height - 44)+ 50);
                                 }];
                             }];
        }
        
        self.tableView.frame = CGRectMake(0, 44, iPhone_width,iPhone_height - 44 - self.fileView.frame.size.height - containerView.frame.size.height);
        CGRect rect_table = self.tableView.frame;
        NSLog([NSString stringWithFormat:@"tableview x=%f y=%f wid =%f height = %f",rect_table.origin.x,rect_table.origin.y,rect_table.size.width,rect_table.size.height]);
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height -(iPhone_height -  self.fileView.frame.size.height - 44)+ 50);}];
        NSLog([NSString stringWithFormat:@"tableview contentOffset x=%f y=%f",self.tableView.contentOffset.x,self.tableView.contentOffset.y]);
    }
    else
    {
        
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_board_background.png"] forState:UIControlStateNormal];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_board_background_highlighted.png"] forState:UIControlStateHighlighted];
        
        [_textView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.fileView.alpha = 1.;
            containerView.frame = CGRectMake(0, iPhone_height   - 216 - containerView.frame.size.height, iPhone_width, containerView.frame.size.height);}];
    }
    
    CGRect rect_fileview = self.fileView.frame;
     NSLog([NSString stringWithFormat:@"rect_fileview x=%f y=%f wid =%f height = %f",rect_fileview.origin.x,rect_fileview.origin.y,rect_fileview.size.width,rect_fileview.size.height]);
}

#pragma mark - keyboard通知方法

- (void)keyboardWillHide:(NSNotification *)notification
{
    edit = YES;
    self.tableView.frame = CGRectMake(0, 44, iPhone_width, iPhone_height - containerView.frame.size.height - 44 - self.fileView.frame.size.height);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    _defaultkeyboardRect = keyboardRect;
    edit = NO;
    recordBtn.alpha = 0;
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.25
                     animations:^{
                         containerView.frame = CGRectMake(0, iPhone_height - keyboardRect.size.height - containerView.frame.size.height, iPhone_width, containerView.frame.size.height);
                     }completion:^(BOOL finished) {
                         self.tableView.frame = CGRectMake(0, 44, iPhone_width,iPhone_height - 44 - keyboardRect.size.height - containerView.frame.size.height);
                         NSLog([NSString stringWithFormat:@"tableView.contentSize.height = %f",self.tableView.contentSize.height]);
                         [UIView animateWithDuration:0.3 animations:^{
                             if (_messageArray.count>2) {
                                 self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height -(iPhone_height -  keyboardRect.size.height - 44-containerView.frame.size.height));
                             }
                             
                         }];
                     }];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background_highlighted.png"] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background.png"] forState:UIControlStateNormal];
    
}

#pragma mark- MessageDetailCellDelegate 重发消息
- (void)resendMessageWithModel:(MessageDetailModel *)message_model{
    [_tableView reloadData];
    if ([message_model.pmtype isEqualToString:@"0"]) {
        //重发文字消息
        NSDictionary *dic = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:IMEI,kUserTokenStr,self.message.soureId,@"1", @"0",message_model.msg,nil] forKeys:[NSArray arrayWithObjects:@"userImei",@"userToken",@"toUserid",@"device_type" ,@"type",@"content",nil]];
        message_model.dateline = [XZLUtil changeDateToString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
        [message_model saveOrUpdate];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *tempArray = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ order by dateline asc",_message.plid]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _messageArray = [NSMutableArray arrayWithArray:tempArray];
                [_tableView reloadData];
                [self scrollToTableViewBottom];
                
            });
        });
        
        NSString *url = kCombineURL(KXZhiLiaoAPI, kSendMessage);;
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:dic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        //    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
        
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *errorStr =[resultDic valueForKey:@"error"];
            
            if(errorStr.integerValue == 0&&errorStr){
                NSLog(@"发送成功");
                message_model.pmid = [resultDic valueForKey:@"pmid"];
                message_model.dateline = [resultDic valueForKey:@"time"];
                message_model.sendStatus = MessageSendStatusSuccess;
                [message_model saveOrUpdate];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
                _message.dateline = message_model.dateline;
                _message.msg = message_model.msg;
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSArray *tempArray = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ order by dateline asc",_message.plid]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _messageArray = [NSMutableArray arrayWithArray:tempArray];
                        [_tableView reloadData];
                        [self scrollToTableViewBottom];
                        
                    });
                });
            }else{
                message_model.sendStatus = MessageSendStatusFail;
                [message_model saveOrUpdate];
                [_tableView reloadData];
            }
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            message_model.sendStatus = MessageSendStatusFail;
            [message_model saveOrUpdate];
            [_tableView reloadData];
            
        }];
        [request startAsynchronous];

    }else if([message_model.pmtype isEqualToString:@"1"]){
        //重发图片消息
        message_model.sendStatus = MessageSendStatusSending;
        message_model.dateline = [XZLUtil changeDateToString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
        [message_model saveOrUpdate];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *tempArray = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ order by dateline asc",_message.plid]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _messageArray = [NSMutableArray arrayWithArray:tempArray];
                [_tableView reloadData];
                [self scrollToTableViewBottom];
                
            });
        });
        
        NSString *urlStr=@"http://timages.hrbanlv.com/pm2/upload?";
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"2",@"pflag",_message.soureId,@"otherId",@"0",@"iscom",@"0",@"flag",nil];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        //    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
        NSString *filePath = [[self getImagePath] stringByAppendingPathComponent:message_model.file_real_name];
        [request setFile:filePath forKey:@"Filedata"];
        [request setCompletionBlock:^{
            [loadView hide:YES];
            NSError *error;
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *errorStr =[resultDic valueForKey:@"error"];
            if(errorStr.integerValue == 0&&errorStr){
                NSLog(@"发送成功");
                message_model.pmid = [resultDic valueForKey:@"pmid"];
                message_model.dateline = [resultDic valueForKey:@"time"];
                message_model.download_url = [resultDic valueForKey:@"download_url"];
                message_model.download_url_mini = [resultDic valueForKey:@"download_url_mini"];
                message_model.sendStatus = MessageSendStatusSuccess;
                [message_model saveOrUpdate];
                [_tableView reloadData];

//                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
                _message.dateline = message_model.dateline;
                _message.msg = message_model.msg;
            }else{
                message_model.sendStatus = MessageSendStatusFail;
                [message_model saveOrUpdate];
                [_tableView reloadData];
            }
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            message_model.sendStatus = MessageSendStatusFail;
            [message_model saveOrUpdate];
            [_tableView reloadData];
        }];
        [request startAsynchronous];
    }else if ([message_model.pmtype isEqualToString:@"2"]){
        //重发语音消息
        message_model.dateline = [XZLUtil changeDateToString:[NSDate date] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
        message_model.sendStatus = MessageSendStatusSending;
        [message_model saveOrUpdate];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *tempArray = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ order by dateline asc",_message.plid]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _messageArray = [NSMutableArray arrayWithArray:tempArray];
                [_tableView reloadData];
                [self scrollToTableViewBottom];
                
            });
        });
        
        NSString *urlStr=@"http://timages.hrbanlv.com/pm2/upload?";
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"0",@"flag",@"1",@"pflag",message_model.soundTime,@"soundTime",_message.soureId,@"otherId",message_model.file_real_name,@"fileName",nil];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        //    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
        
        NSString *cachePath = [VoiceRecorderBaseVC getCacheDirectory];
        NSString *soundPath = [cachePath stringByAppendingPathComponent:message_model.file_real_name];
        
        [request setFile:soundPath forKey:@"Filedata"];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *errorStr =[resultDic valueForKey:@"error"];
            if(errorStr.integerValue == 0&&errorStr){
                NSLog(@"请求成功");
                message_model.pmid = [resultDic valueForKey:@"pmid"];
                message_model.dateline = [resultDic valueForKey:@"time"];
                message_model.download_url = [resultDic valueForKey:@"download_url"];
                message_model.download_url_mini = [resultDic valueForKey:@"download_url_mini"];
                message_model.sendStatus = MessageSendStatusSuccess;
                [message_model saveOrUpdate];
                [_tableView reloadData];

//                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
                _message.dateline = message_model.dateline;
                _message.msg = message_model.msg;
            }else{
                message_model.sendStatus = MessageSendStatusFail;
                [message_model saveOrUpdate];
                [_tableView reloadData];
            }
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            message_model.sendStatus = MessageSendStatusFail;
            [message_model saveOrUpdate];
            [_tableView reloadData];
        }];
        [request startAsynchronous];

    }else{
        //发送简历

        message_model.dateline = [XZLUtil changeDateToString:[NSDate new] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
        message_model.sendStatus = MessageSendStatusSending;
        [message_model saveOrUpdate];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *tempArray = [MessageDetailModel findByCriteria:[NSString stringWithFormat:@"where plid = %@ order by dateline asc",_message.plid]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _messageArray = [NSMutableArray arrayWithArray:tempArray];
                [_tableView reloadData];
                [self scrollToTableViewBottom];
                
            });
        });
        NSString *url = kCombineURL(KXZhiLiaoAPI, kSendMessage);
        NSDictionary *dic = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:IMEI,kUserTokenStr,self.message.soureId,@"1", @"0",contentStr,nil] forKeys:[NSArray arrayWithObjects:@"userImei",@"userToken",@"toUserid",@"device_type" ,@"type",@"content",nil]];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:dic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        //    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
        
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *errorStr =[resultDic valueForKey:@"error"];
            
            if(errorStr&&errorStr.integerValue == 0&&errorStr){
                NSLog(@"发送成功");
                message_model.pmid = [resultDic valueForKey:@"pmid"];
                message_model.dateline = [resultDic valueForKey:@"time"];
                message_model.sendStatus = MessageSendStatusSuccess;
                [message_model saveOrUpdate];
                [_tableView reloadData];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
                _message.dateline = message_model.dateline;
                _message.msg = message_model.msg;
                
            }else{
                message_model.sendStatus = MessageSendStatusFail;
                [message_model saveOrUpdate];
                [_tableView reloadData];
            }
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            message_model.sendStatus = MessageSendStatusFail;
            [message_model saveOrUpdate];
            [_tableView reloadData];
        }];
        [request startAsynchronous];
    }
   
}

#pragma mark -  textView 代理方法

//改变高度时的代理方法
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (growingTextView.text.length == 0) {
            return NO;
        }
        
        [self sendMessage:growingTextView.text];
        
        
        _fileView.alpha = 0;
        [_textView resignFirstResponder];
        
        containerView.frame = CGRectMake(0, iPhone_height -20+ios7jj-containerView.frame.size.height, iPhone_width, containerView.frame.size.height);
        
        self.tableView.frame = CGRectMake(0, 44, iPhone_width, iPhone_height -20+ios7jj - containerView.frame.size.height - 44 );
        
    }
    if (growingTextView.text.length >= 1000) {
        return NO;
    }
    return YES;
}

#pragma mark - 发送文本私信

- (void)sendMessage:(NSString *)text
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:IMEI,kUserTokenStr,self.message.soureId,@"1", @"0",text,nil] forKeys:[NSArray arrayWithObjects:@"userImei",@"userToken",@"toUserid",@"device_type" ,@"type",@"content",nil]];
    
    MessageDetailModel *model = [[MessageDetailModel alloc] init];
    model.plid = _message.plid;
    model.msg = text;
    model.isself = @(1);
    model.pmtype = @"0";
    model.dateline = [XZLUtil changeDateToString:[NSDate new] withFormatter:@"yyyy-MM-dd HH:mm:ss"];
    model.sendStatus = MessageSendStatusSending;
    [model saveOrUpdate];
    [_messageArray addObject:model];
    
    [self scrollToTableViewBottom];
    
    //发送文本私信
//    _netWork = [[NetWorkConnection alloc] init];
//    _netWork.delegate = self;
//    [_netWork sendMessageWithDictionary:dic];
    NSString *url = kCombineURL(KXZhiLiaoAPI, kSendMessage);;
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:dic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:URL];
    
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(errorStr.integerValue == 0){
            NSLog(@"发送成功");
            model.pmid = [resultDic valueForKey:@"pmid"];
            model.dateline = [resultDic valueForKey:@"time"];
            model.sendStatus = MessageSendStatusSuccess;
            [model saveOrUpdate];
            [_tableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotification object:nil];
            _message.dateline = model.dateline;
            _message.msg = model.msg;
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        model.sendStatus = MessageSendStatusFail;
        [model saveOrUpdate];
        [_tableView reloadData];
    }];
    [request startAsynchronous];

    
    _textView.text = @"";
    self.tableView.frame = CGRectMake(0, 44, iPhone_width, containerView.frame.origin.y + 44);
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height -  containerView.frame.origin.y + 60);
}

#pragma mark - 滚到最后一行

- (void)scrollToTableViewBottom{
    
    [_tableView reloadData];
    if (self.messageArray.count > 0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.messageArray.count-1 inSection: 0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: NO];
    }
    
}

#pragma mark - tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    MessageDetailCell *detailcell = [tableView dequeueReusableCellWithIdentifier:identifier];
    MessageDetailModel *m = [_messageArray objectAtIndex:indexPath.row];
    detailcell = [[MessageDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier detailMessage:m companyName:self.message.name];
    detailcell.headerUrlString = _headerUrlString;
    [detailcell senondCellInitWithMessage:m];
    detailcell.delegate = self;
    if ([m.pmtype intValue] == 2) {//语音
        
        NSString *fileName = [m.file_real_name stringByDeletingPathExtension];
        if ([self isExistAtPath:[[self getAudioPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",fileName]]] == YES) {
            
            NSLog(@"存在该语音文件");
            
        }else if ([self isExistAtPath:[[self getAudioPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",fileName]]] == YES) {
            //amr->wav 转换
            [self changeAudioFromAmrToWav:m.file_real_name];
           
        }else{
            //下载
            [self downloadAudioWithPath:m.download_url name:m.file_real_name];
        }
    }
    return detailcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageDetailModel *d = [self.messageArray objectAtIndex:indexPath.row];
    
    if ([d.pmtype intValue] == 1) {
        
//        if (d.myImage.size.height > d.myImage.size.width) {
//            return 170.0f;
//        }else
//        {
            return 150.0f;
//        }
    }
    else if([d.pmtype intValue] == 2)
    {
        return 100.0f;
    }
    CGSize s = [MessageDetailCell widthCell:d.msg];
//    CGFloat h = d.files.count*20;
//    return s.height + 80 + h;
    return s.height + 80;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
