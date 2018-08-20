//
//  XZLPMDetailViewController.m
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "XZLPMDetailViewController.h"
#import "XZLNewPMDetailCell.h"
//#import "MJPhoto.h"
//#import "MJPhotoBrowser.h"
#import "XZLCommonWebViewController.h"
#import "OLGhostAlertView.h"
#import "XZLUtil.h"
#import "VoiceConverter.h"
#import "GGFullScreenImageViewController.h"
#import "ChatVoiceRecorderVC.h"
#import "MJRefresh.h"
#import "SeeFileVC.h"

#import "AFHTTPSessionManager.h"

#import "TPKeyboardAvoidingTableView.h"

typedef enum {
    TalkListRequestBackward = 0,// 用最小的时间戳，向后取历史记录
    TalkListRequestForward = 1,// 用最大的时间戳，向前取最新的列表数据
    
}TalkListRequestToward;
@interface XZLPMDetailViewController ()
{
    UITableView *_myTableView;
    UIView *inputView;// 输入面板
    NSMutableArray *dataArray; // 数据数组
    HPGrowingTextView *_hpTextView;// 输入文本框
    UIButton *leftBtn;//语音按钮
    UIButton *rightBtn;//添加文件按钮
    UIButton *recordBtn;//录音按钮
    BOOL keyboard;
    BOOL edit;
    AVAudioRecorder *recorder;
    TipView *tips;
    OLGhostAlertView *alert;
    NSString *playName;
    CGSize kbSize;
    CGSize ipSize;
    ChatVoiceRecorderVC *chatRecord;
    NSString *DataTotal;
    CGFloat rate;
}

@end

@implementation XZLPMDetailViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [self setSixinCount:@"0"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:(_pmlistModel.name.length>0 ? _pmlistModel.name :@"未实名用户")];
    self.view.backgroundColor = RGB(245, 2452, 245);
    dataArray = [[NSMutableArray alloc] init];
    
    rate = 1;
    if (isScreenIPhone6Below) {
        rate = 320.0/375.0;
    }else if (isScreenIPhone6Upper){
        rate = 414.0/375.0;
    }
    
    [self initTableView];
    [self initInputView];
//    [self initDataFromDB];
    [self.view sendSubviewToBack:_myTableView];
    
    // 取新
    [self requestDataWithToward:TalkListRequestForward];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seeImage:)
                                                 name:@"seeImage"
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRemoteNotification)
                                                 name:kReceiveRemoteNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark 设置未读私信数量
- (void)setSixinCount:(NSString *)count{
    // 重置私信红点
    NSString *pid = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"company_email"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mUserDefaults valueForKey:@"SixinCount"]];
    [dic setValue:count forKey:pid];
    [mUserDefaults setObject:dic forKey:@"SixinCount"];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 导航栏左按钮
- (void)backUp:(id)sender
{
    _pmlistModel.unRead = @"0";
    [_pmlistModel saveOrUpdate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 通知方法

#pragma mark 收到推送消息

- (void)receiveRemoteNotification{
    sleep(1);
    [self requestDataWithToward:TalkListRequestForward];
    [self setsixinListReadWithUid:_pmlistModel.uid];
    
}


#pragma mark 查看图片
- (void)seeImage:(NSNotification *)notification
{
    GGFullscreenImageViewController *imageVC = [[GGFullscreenImageViewController alloc] init];
    UIImageView *rv = [notification.userInfo valueForKey:@"imageview"];
    imageVC.liftedImageView = rv;
    
    [self  presentViewController:imageVC animated:YES completion:^(void){}];
}

#pragma mark - 从DB中获取数据

- (void)initDataFromDB{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *tempArray = [XZLPMDetailModel findByCriteria:[NSString stringWithFormat:@"where uid = %@ and sendStatus <> %d order by created_time asc",_pmlistModel.uid,MessageSendStatusSending]];
        dispatch_async(dispatch_get_main_queue(), ^{
            dataArray = [NSMutableArray arrayWithArray:tempArray];
            [self tvToBottom];
        });
    });
}

#pragma mark - 获取单个联系人的聊天记录
- (void)requestDataWithToward:(TalkListRequestToward)toward
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    [paramDic setValue:@"1000" forKey:@"paginate"];
    [paramDic setValue:_pmlistModel.uid forKey:@"uid"];
    
    [paramDic setValue:@"0" forKey:@"time"];
    [paramDic setValue:@(toward) forKey:@"getUnread"];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/get/chat/record/list"];
    
    [XZLNetWorkUtil requestPostURL:urlStr params:paramDic success:^(id responseObject) {
        if([_myTableView isFooterRefreshing] == YES){
            [_myTableView footerEndRefreshing];
        }
        if([_myTableView isHeaderRefreshing] == YES){
            [_myTableView headerEndRefreshing];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            //            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *array = data[@"recordList"];
            NSLog(@"%@",array);
            if (error.integerValue == 0) {
                if ([array count] > 0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in array) {
                        [tempArray addObject:[XZLPMDetailModel getPMDetailModelWithDic:dataDic andPMListUid:_pmlistModel.uid]];
                    }
                    dataArray = tempArray;
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        [XZLPMDetailModel saveOrUpdateObjects:tempArray];
//                        if((toward == TalkListRequestForward) && ([tempArray count] == 20)){// 取新时，如果获取到20条数据，则继续去获取
//                            [self requestDataWithToward:TalkListRequestForward];
//                        }
//                        NSArray *talkListArrayTemp = [XZLPMDetailModel findByCriteria:[NSString stringWithFormat:@"where uid = %@ order by created_time asc",_pmlistModel.uid]];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            dataArray = [NSMutableArray arrayWithArray:talkListArrayTemp];
//                            if (toward == TalkListRequestForward) {
                                [self tvToBottom];// 刷新，并滚到最底部
//                            }else{
//                                [_myTableView reloadData];// 刷新
//                            }
//                        });
//                    });
                }
                
            }else{
                //                ghostView.message = @"用户名或密码错误，登录失败";
                //                [ghostView show];
            }
        }
    } failure:^(NSError *error) {
        //        [loadView hide:YES];
        [_myTableView headerEndRefreshing];
        alert.message = @"获取数据失败，请检查网络";
        [alert show];
        NSLog(@"failed block%@",error);
        
        
    }];

    
}

#pragma mark - 初始化tableView
- (void)initTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-50) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:_myTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(hideKeyboard)];
    [_myTableView addGestureRecognizer:tap];
    
    // 下拉刷新
//    [_myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
//    _myTableView.headerPullToRefreshText= @"下拉加载历史数据";
//    _myTableView.headerReleaseToRefreshText = @"松开马上加载历史数据";
//    _myTableView.headerRefreshingText = @"努力加载中……";
}

#pragma mark 下拉刷新的方法
- (void)headerRefresh{
    
    // 取历史记录
    [self requestDataWithToward:TalkListRequestBackward];
    
}

#pragma mark 初始化inputview
- (void)initInputView
{
    chatRecord = [[ChatVoiceRecorderVC alloc] init];
    
    _hpTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, 7, kMainScreenWidth-73-15, 34)];
    _hpTextView.minNumberOfLines = 1;
    _hpTextView.maxNumberOfLines = 3;
    _hpTextView.returnKeyType = UIReturnKeySend;
    _hpTextView.font = kContentFontSmall;
    _hpTextView.internalTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _hpTextView.delegate = self;
    _hpTextView.autoresizingMask =UIViewAutoresizingFlexibleWidth;
    _hpTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    mViewBorderRadius(_hpTextView, 6, 1, RGB(231, 231, 231));
    
    //发送按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kMainScreenWidth-64, 7, 48, 34);
    [rightBtn addTarget:self action:@selector(onClickSendTextBtn:) forControlEvents:UIControlEventTouchUpInside];
    mViewBorderRadius(rightBtn, 6, 1, RGB(155, 155, 155));
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
//        [rightBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background_highlighted.png"] forState:UIControlStateHighlighted];
//        [rightBtn setBackgroundImage:[UIImage imageNamed:@"message_add_background.png"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGB(155, 155, 155) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-50, kMainScreenWidth, 50) ];
    inputView.backgroundColor = [UIColor whiteColor];
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    view_line.backgroundColor = RGB(216, 216, 216);
    [inputView addSubview:view_line];
    if (self.preparedMsg && self.preparedMsg.length > 0) {
        _hpTextView.text = self.preparedMsg;
        _hpTextView.frame = CGRectMake(45, 4, kMainScreenWidth-90, 60);
        inputView.frame = CGRectMake(0, kMainScreenHeight-74, kMainScreenWidth, 74) ;
        _myTableView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64 - 50 -30);
    }
    [inputView addSubview:_hpTextView];
    [inputView addSubview:rightBtn];
    [self.view addSubview:inputView];
    
    
    tips = [TipView defaultStander];
    tips.delegate = self;
    [self.view addSubview:tips];
    
    ipSize = inputView.frame.size;
}

#pragma mark 隐藏键盘
- (void)hideKeyboard
{
    [self setLayout:0];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZLPMDetailModel *model = dataArray[indexPath.row];
//    if ([model.type isEqualToString:@"1"]) {
//        return 140.0f;
//    }else if ([model.type isEqualToString:@"4"]||[model.type isEqualToString:@"8"])
//    {
//        CGSize size = CGSizeMake(kMainScreenWidth-150, CGFLOAT_MAX);
//        size = [model.msg boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kContentFontSmall} context:nil].size;
//        return size.height+70;
//        
//    }else{
    if([model.content containsString:@"<a"]){
        NSData *data = [model.content dataUsingEncoding:NSUnicodeStringEncoding];
        //        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
        NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                                   options:options
                                                        documentAttributes:nil
                                                                     error:nil];
        CGSize size = CGSizeMake(kMainScreenWidth-150*rate , CGFLOAT_MAX);
        size = [html.string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kContentFontMiddle} context:nil].size;
        return size.height+70;
    }
    
        CGSize size = CGSizeMake(kMainScreenWidth-150*rate , CGFLOAT_MAX);
        size = [model.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kContentFontMiddle} context:nil].size;
        return size.height+80;
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    
    XZLNewPMDetailCell *cell = [_myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XZLNewPMDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    XZLPMDetailModel *model = dataArray[indexPath.row];
    [cell setModelData:model];
    
//    if ([model.type intValue] == 2) {//语音
//        
//        NSString *fileName = [model.file_real_name stringByDeletingPathExtension];
//        if ([self isExistAtPath:[[self getAudioPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",fileName]]] == YES) {
//            //            NSLog(@"存在该语音文件");
//            
//        }else if ([self isExistAtPath:[[self getAudioPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",fileName]]] == YES) {
//            //amr->wav 转换
//            [self changeAudioFromAmrToWav:model.file_real_name];
//            
//        }else{
//            //下载
//            if(model.download_url.length > 0 && model.file_real_name.length > 0){
//                [self downloadAudioWithPath:model.download_url name:model.file_real_name];
//            }
//        }
//    }else if([model.type intValue] == 3){// 附件
//        
//        /*
//         NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:model.file_real_name];
//         if ([self isExistAtPath:filePath] == NO && model.download_url.length > 0 && model.file_real_name.length > 0) {
//         AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.download_url]]];
//         [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
//         [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//         NSLog(@"download-%@：%f", model.file_real_name,(float)totalBytesRead / totalBytesExpectedToRead);
//         }];
//         [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSLog(@"%@下载成功",model.file_real_name);
//         
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"%@下载失败",model.file_real_name);
//         }];
//         [operation start];
//         }
//         */
//    }
    
    return cell;
}


#pragma mark 文件是否存在
- (BOOL)isExistAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - 键盘操作

- (void)keyboardWillChange:(NSNotification *)note
{
    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
        CGFloat e = moveY;
        if (e<0) {
            if (dataArray.count<3) {
                e=0;
            }
        }
        _myTableView.transform = CGAffineTransformMakeTranslation(0, e);
        inputView.transform = CGAffineTransformMakeTranslation(0, moveY);
        [self tvToBottom];
    }];
}

//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    _myTableView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64 - ipSize.height);
////    _myTableView.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight - 64-ipSize.height);
//    inputView.frame = CGRectMake(0,kMainScreenHeight-ipSize.height, kMainScreenWidth, ipSize.height);
//}
//
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    kbSize = CGSizeMake(keyboardRect.size.width, keyboardRect.size.height);
//
//    //set frame
//    inputView.frame = CGRectMake(0, kMainScreenHeight- ipSize.height - kbSize.height , kMainScreenWidth, ipSize.height);
//    _myTableView.frame = CGRectMake(0, 64, kMainScreenWidth,kMainScreenHeight - 64 - ipSize.height - kbSize.height);
////    _myTableView.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight - 64+ipSize.height+kbSize.height);
//    [self tvToBottom];
//}


#pragma mark -  textView 代理方法

//改变高度时的代理方法
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = inputView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    inputView.frame = r;
    
    ipSize = r.size;
}


- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length == 0) {
        return NO;
    }
    //发送消息
    [self sendMessage:growingTextView.text];
    _hpTextView.internalTextView.text = nil;
    [_hpTextView resignFirstResponder];
    return true;
}

-(void)onClickSendTextBtn:(id)sender{
    if (_hpTextView.internalTextView.text.length == 0) {
        return;
    }
    //发送消息
    [self sendMessage:_hpTextView.internalTextView.text];
    _hpTextView.internalTextView.text = nil;
    [_hpTextView resignFirstResponder];

}

#pragma  mark - 发送私信
//发送私信调用方法
- (void)sendMessage:(NSString *)text
{
    XZLPMDetailModel *model = [[XZLPMDetailModel alloc] init];
    model.content = text;
    model.isSelf = @"1";
    model.uid = _pmlistModel.uid;
//    model.type = @"0";
    model.portrait = [mUserDefaults valueForKey:@"portrait"];
    model.sendStatus = MessageSendStatusSending;
    model.created_time = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
//    [model saveOrUpdate];//因为接口没返回时间 暂时不保存
    [dataArray addObject:model];
    
    [self tvToBottom];
    // 发送文本消息
    [self sendTextMessage:model];
    
}

#pragma  mark - 发送文本消息

- (void)sendTextMessage:(XZLPMDetailModel *)talkListModel{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    [paramDic setValue:talkListModel.content forKey:@"content"];
    [paramDic setValue:_pmlistModel.uid  forKey:@"toUserId"];

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/chat/person/record_send"];
    
    [XZLNetWorkUtil requestPostURL:urlStr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            //            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];

            if (error.integerValue == 0) {
//                mGhostView(@"发送成功", @"");
                talkListModel.sendStatus = MessageSendStatusSuccess;
                [self updatePmListWithXZLPMListModel:_pmlistModel msg:talkListModel.content type:@"0" dateline:[NSString stringWithFormat:@"%@",talkListModel.created_time]];

            }else{
                talkListModel.sendStatus = MessageSendStatusFail;
//                [talkListModel saveOrUpdate];
                [self tvToBottom];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotificationPMList object:nil];
        }
     } failure:^(NSError *error) {
         //        [loadView hide:YES];
         mAlertView(@"提示", @"发送失败，请检查网络");
         NSLog(@"failed block%@",error);
         talkListModel.sendStatus = MessageSendStatusFail;
//         [talkListModel saveOrUpdate];
         [self tvToBottom];
         
     }];

}

#pragma mark - 添加文件
- (void)file:(id)sender
{
    if(keyboard){
        [self setLayout:2];
    }else{
        [self setLayout:3];
    }
}
#pragma mark - 布局控制
- (void) setLayout:(int)type
{
    switch (type) {
        case 0: //原始   音+加 输入框 无键盘 无录音无面板
        {
            //set alpha
            _hpTextView.alpha = 1;
            recordBtn.alpha = 0;

            [_hpTextView resignFirstResponder];
            keyboard = NO;
            //set image

            inputView.frame = CGRectMake(0, kMainScreenHeight- ipSize.height , kMainScreenWidth, ipSize.height);
            _myTableView.frame = CGRectMake(0, 64, kMainScreenWidth,kMainScreenHeight - 64 - ipSize.height);
        }
            break;
        
        default:
            break;
    }
}
#pragma mark - tableview显示最后一条
-(void)tvToBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_myTableView reloadData];
        if (dataArray.count > 0) {
            NSIndexPath* ipath = [NSIndexPath indexPathForRow: dataArray.count-1 inSection: 0];
            [_myTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: NO];
//            [_myTableView setContentOffset:CGPointMake(0, _myTableView.contentSize.height -_myTableView.bounds.size.height) animated:YES];
        }
    });
    
}

#pragma mark - fileview协议方法
- (void)sendPhoto{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消上传" otherButtonTitles:@"本地上传",@"拍照上传", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消上传" destructiveButtonTitle:nil otherButtonTitles:@"本地上传", nil];
    }
    [sheet showInView:self.view];
}
-(void)sendDate{
//    NSString *preparedMsg ;
//    NSString *cname = [XZLEnterpriseModel valueForKeyWord:@"cname"] ;
//    NSString *linktel = [XZLEnterpriseModel valueForKeyWord:@"linktel"] ;
//    NSString *linkman = [XZLEnterpriseModel valueForKeyWord:@"linkman"] ;
//    NSString *addr = [XZLEnterpriseModel valueForKeyWord:@"addr"] ;
//    preparedMsg = [NSString stringWithFormat:@"%@，你好！通知您来参加 %@ 的面试。联系方式：%@，联系人：%@ ，面试地点：%@。",_XZLPMListModel.name,cname,linktel,linkman,addr];
//    
//    [self sendMessage:preparedMsg];
}
-(void)sendRefuse{
    NSString *preparedMsg = @"您的简历暂时不符合我们的要求，感谢您投递简历。";
    
    [self sendMessage:preparedMsg];
}


#pragma mark - 获取当前时间来作为名字
- (NSString *)getNameWithCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - XZLTalkListCellDelegate 重新发送
- (void)resendMessageWithModel:(XZLPMDetailModel *)talkListModel{
//    if([talkListModel.type intValue] == 0){// 文本
    
        [self sendTextMessage:talkListModel];
        
//    }else if([talkListModel.type intValue] == 1){// 图片
//        
//        [self sendImageMessage:talkListModel];
//        
//    }else if([talkListModel.type intValue] == 2){// 语音
//        
//        [self sendAudioMessage:talkListModel];
//        
//    }else{//其他
//        
//    }
}

#pragma mark - 发送消息成功后，更新对应的消息列表
- (void)updatePmListWithXZLPMListModel:(XZLPMListModel *)model msg:(NSString *)msg type:(NSString *)type dateline:(NSString *)dateline{
    if (model.uid.length > 0) {
        model.content = msg;
        model.created_time = dateline;
        model.unRead = @"0";
//        model.type = type;
//        [model saveOrUpdate];
    }
}


-(void)setsixinListReadWithUid:(NSString *)uid{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    [paramDic setValue:uid forKey:@"uid"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/chat/person/record_status"];
    
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"responseObject is %@",responseObject);
            NSNumber *error_code = responseObject[@"error_code"];
            if ([error_code isEqualToNumber:@0]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotificationPMList object:nil];
            }else{
                
            }
        }
    }failure:^(NSError *error){
        NSLog(@"error is %@",error);
    }];
    
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
