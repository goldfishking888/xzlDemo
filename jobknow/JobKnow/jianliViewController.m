//
//  jianliViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-2.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jianliViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Photo.h"
#import "VoiceConverter.h"
#import "ASINetworkQueue.h"
#import "SDDataCache.h"
#import "ASIDownloadCache.h"
#define ImagePath @"resumeimage"
#define SoundPath @"resumesound"
#import "yulanViewController.h"
#import "jiaoyu2ViewController.h"
#import "AudioButton.h"
#import "GGFullScreenImageViewController.h"
#import "jibenxxViewController.h"
#import "More.h"
#import "MyTableCell.h"

#import "jiaoyuxxViewController.h"

#import "jingliViewController.h"
#import "peixunViewController.h"
#import "waiyuViewController.h"
#import "jibenxxViewController.h"

#import "OtherLogin.h"

#import "WebViewController.h"

#import "ScanResumeViewController.h";

@interface jianliViewController ()

@end

@implementation jianliViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _moreArray = [NSMutableArray array];
        NSArray *more = [NSArray arrayWithObjects:@"图片",@"语音",@"文件",@"基本信息",@"教育信息",@"求职意向",@"基本信息完善",@"工作经历",@"工作能力与自我评价",@"培训经历",@"外语能力",@"职业标签",nil];
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
                case 5:
                    [_moreArray addObject:zu];
                    zu = [NSMutableArray array];
                    break;
                case 11:
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    int num=ios7jj;
    _soundArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _fileArray = [NSMutableArray array];
    self.view.backgroundColor = XZHILBJ_colour;

    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, iPhone_width, iPhone_height) style:UITableViewStyleGrouped];
    myTableView.delegate =self;
    myTableView.dataSource = self;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    
    [self addBackBtn];
    [self addTitleLabel:@"简历中心"];
    
    //预览按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor=[UIColor clearColor];
    registerBtn.frame = CGRectMake(iPhone_width-135,-3+num,135,50);
    [registerBtn setImage:[UIImage imageNamed:@"dataline_needpclogin"] forState:UIControlStateNormal];
    [registerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 3,3 )];
    [registerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -170, 0, 0)];
    UIImage *image = [UIImage imageNamed:@"dataline_needpclogin"];

    registerBtn.titleLabel.font=[UIFont systemFontOfSize: 13];
    [registerBtn setTitle:@"电脑简历" forState:UIControlStateNormal];
    [registerBtn setTitle:@"电脑简历" forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0+num, CGRectGetWidth(self.view.bounds), 200)];
    _pathCover.deleat =self;
    if (IOS7) {
        [_pathCover setBackgroundImage:[UIImage imageNamed:@"jianliBjios7.png"]];
    }else{
        [_pathCover setBackgroundImage:[UIImage imageNamed:@"jianliBj.png"]];
    }
   
   [_pathCover setAvatarImage:[UIImage imageNamed:@"header_default.png"]];
    UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previewBtn.backgroundColor=[UIColor clearColor];
    previewBtn.frame = CGRectMake(iPhone_width-55,120,45,50);
    previewBtn.showsTouchWhenHighlighted=YES;
    previewBtn.titleLabel.font=[UIFont systemFontOfSize: 16];
    [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [previewBtn setTitle:@"预览" forState:UIControlStateHighlighted];
    [previewBtn addTarget:self action:@selector(takephoto2:) forControlEvents:UIControlEventTouchUpInside];
    [_pathCover addSubview:previewBtn];
    
//   [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"徐雪妮", XHUserNameKey, @"女|北京|3年", XHBirthdayKey,@"" ,XHQzStateKey ,nil]];
    myTableView.tableHeaderView = self.pathCover;
    __weak jianliViewController *wself = self;
    [_pathCover setHandleRefreshEvent:^{
        [wself _refreshing];
    }];
    
    /******************************************************************/
    
    //判断有没有改文件名下的plist文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *namea = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    namea = [namea stringByAppendingPathExtension:@"plist"];
    path = [path stringByAppendingPathComponent:namea];
    if (![fileManager fileExistsAtPath:path]||!namea) {
        //[fileManager createFileAtPath:path contents:nil attributes:nil];
        [self getResumeInfo];
        NSLog(@"没有plist文件");
    }else{
        NSLog(@"有plist文件");
//        SDDataCache *imageCache = [SDDataCache sharedDataCache];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSString *sss = [user valueForKey:@"UserName"];
//        NSData *imageData = [imageCache dataFromKey:[NSString stringWithFormat:@"%@.png",sss] fromDisk:YES];
//        UIImage *image = [UIImage imageWithData:imageData];
////        NSLog(@"此处为存本地的头像-————————%@",image);
//        [_pathCover setAvatarImage:image];
        [self getResumeInfo];
//        
    }
    
    ResumeOperation *resume = [ResumeOperation defaultResume];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *name =[user valueForKey:@"personName"];
    //姓名
    if (name) {
       [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:name, XHUserNameKey,nil]];
    }
    //简历是否公开
    NSString *is_visible = [resume.resumeDictionary valueForKey:@"gongKai"];
    if (is_visible) {
        [_pathCover setJianliState:is_visible];
    }
    //基本信息
    NSString *sex = [resume.resumeDictionary valueForKey:@"mySex"];
    NSString *home = [resume.resumeDictionary valueForKey:@"myHome"];
    NSString *workYe = [resume.resumeDictionary valueForKey:@"myWorkYear"];
    if (sex&&workYe) {
        NSString *newWorkY = nil;
        if ([workYe integerValue]>0) {
            newWorkY = [NSString stringWithFormat:@"%@年",workYe];
        }else{
            if ([workYe isEqualToString:@"-2"]) {
                newWorkY= [NSString stringWithFormat:@"不限"];
            }else if ([workYe isEqualToString:@"-1"]){
                newWorkY= [NSString stringWithFormat:@"在读学生"];
            }else if ([workYe isEqualToString:@"0"]){
                newWorkY= [NSString stringWithFormat:@"应届毕业生"];
            }else{
                newWorkY = [NSString stringWithFormat:@"不限"];
            }
        }
        NSString *newSex=nil;
        if ([sex integerValue]==1) {
            newSex = @"男";
        }else{
            newSex = @"女";
        }

        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@|%@",newSex,newWorkY],XHBirthdayKey, nil]];
    }
    //求职状态
    NSString *state = [resume.resumeDictionary valueForKey:@"UserResumeState"];
    if (state) {
        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:state,XHQzStateKey, nil]];
    }
 
    
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
    
    img_View = [[UIView alloc]initWithFrame:CGRectMake(47, 5, 240, 55)];
    img_View.backgroundColor = [UIColor clearColor];
    img_View.tag = 390;
    
    sound_View = [[UIView alloc]initWithFrame:CGRectMake(47, 5, 240, 55)];
    sound_View.backgroundColor = [UIColor clearColor];
    sound_View.tag = 790;
    
    file_View = [[UIView alloc]initWithFrame:CGRectMake(47, 5, 240, 55)];
    file_View.backgroundColor = [UIColor clearColor];
    file_View.tag = 190;
    [self addFileInView];
  
}
#pragma mark---刷新
- (void)_refreshing {
    // 刷新简历
    [self getResumeInfo];
    __weak jianliViewController *wself = self;
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [wself.pathCover stopRefresh];
    });
}

//网上获取头像
-(void)requestHeadimg
{
    //请求
    ResumeOperation *st = [ResumeOperation defaultResume];
    NSString *str=[st.resumeDictionary valueForKey:@"headimg"];
    //    NSString *urlString = kCombineURL(KXZhiLiaoAPI, str);
    [_pathCover setAvatarImage:[UIImage imageNamed:str]];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:nil urlString:str];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        UIImage *img =[UIImage imageWithData:request.responseData];
         [_pathCover setAvatarImage:img];
        //头像保存本地
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString *str = [st valueForKey:@"UserName"];
        NSData *imageData = UIImageJPEGRepresentation(img, 1);
        NSString*finame = [NSString stringWithFormat:@"%@.png",str];
        SDDataCache *imageCache = [SDDataCache sharedDataCache];
        [imageCache storeData:imageData forKey:finame];
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}

//请求简历信息
- (void)getResumeInfo
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, @"new_api/resume/info?");
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,nil];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:dic1 urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSDictionary *arr = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *data = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if ([data isEqualToString:@"please login"]) {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
        }
        NSString *errorStr = [arr valueForKey:@"error"];
        if ([errorStr integerValue]==0&&arr) {
            //此处保存请求的数据
            ResumeOperation *st = [ResumeOperation defaultResume];
            NSDictionary *dic2 = [arr valueForKey:@"base"];//基本信息
            NSString *jianliId = [arr valueForKey:@"id"];
            NSString *ageStr = [dic2 valueForKey:@"UserResumeBrith"];
            NSString *email = [dic2 valueForKey:@"UserResumeEmail"];
            NSString *headUrl = [dic2 valueForKey:@"UserResumeHead"];
            NSString *homeCode = [dic2 valueForKey:@"UserResumeLocation"];
            NSString *homeStr = [dic2 valueForKey:@"UserResumeLocation_str"];
            NSString *marred  =[dic2 valueForKey:@"UserResumeMarried"];
            NSString *telStr = [dic2 valueForKey:@"UserResumeMobile"];
            NSString *nameStr  = [dic2 valueForKey:@"UserResumeName"];
            NSString *openname = [dic2 valueForKey:@"UserResumeNameOpen"];
            NSString *sex  =[dic2 valueForKey:@"UserResumeSex"];
            NSString *state = [dic2 valueForKey:@"UserResumeState"];
            NSString *salary = [dic2 valueForKey:@"cur_salary"];
            NSString *talent_type = [dic2 valueForKey:@"talent_type"];
            NSString *userTag  =[dic2 valueForKey:@"userTag"];
            NSString *workYeSfftr = [dic2 valueForKey:@"work_years"];
            NSString *is_visible = [arr valueForKey:@"is_visible"];
            NSString *jl_url = [arr valueForKey:@"userResumeUrl"];
            
            //简历公开
            if (is_visible) {
                [st setObject:[NSString stringWithFormat:@"%@",is_visible] forKey:@"gongKai"];
                [_pathCover setJianliState:is_visible];
            }
            //姓名
            if (nameStr) {
                [st setObject:[NSString stringWithFormat:@"%@",nameStr] forKey:@"myName"];
                [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:nameStr, XHUserNameKey,nil]];
            }
            
            //头像
            NSLog(@"头像url----%@",headUrl);
            if (headUrl) {
                if(![headUrl hasSuffix:@".com/"]){
                    [_pathCover setAvatarUrlString:headUrl];
                }
                
            }
            
            //基本信息
            NSString *newSex = nil;
            if (sex) {
                if ([sex integerValue]==1) {
                    newSex = [NSString stringWithFormat:@"男"];
                }else{
                    newSex = [NSString stringWithFormat:@"女"];
                }
                [st setObject:[NSString stringWithFormat:@"%@",sex] forKey:@"mySex"];
            }
            NSString *newWorkY = nil;
            if (workYeSfftr) {
                if ([workYeSfftr integerValue]>0) {
                    newWorkY = [NSString stringWithFormat:@"%@年",workYeSfftr];
                }else{
                    if ([workYeSfftr isEqualToString:@"-2"]) {
                        newWorkY= [NSString stringWithFormat:@"不限"];
                    }else if ([workYeSfftr isEqualToString:@"-1"]){
                        newWorkY= [NSString stringWithFormat:@"在读学生"];
                    }else if ([workYeSfftr isEqualToString:@"0"]){
                        newWorkY= [NSString stringWithFormat:@"应届毕业生"];
                    }else{
                        newWorkY = [NSString stringWithFormat:@"不限"];
                    }
                }
                [st setObject:[NSString stringWithFormat:@"%@",workYeSfftr] forKey:@"myWorkYear"];
            }
            
            if (homeStr) {
                [st setObject:[NSString stringWithFormat:@"%@",homeStr] forKey:@"myHome"];
            }
            //        if (homeStr.length>0) {
            //
            //        }else{
            //            homeStr = @"居住地";
            //        }
            //        NSLog(@"newSex==%@ homecode = %@ newWork==%@",newSex,homeCode,newWorkY);
            if (sex && workYeSfftr) {
                [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@|%@",newSex,newWorkY],XHBirthdayKey, nil]];
            }
            
            //求职状态
            if (state) {
                [st setObject:[NSString stringWithFormat:@"%@",state] forKey:@"UserResumeState"];
                [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:state,XHQzStateKey, nil]];
            }
            //            //头像路径
            //            if (headUrl) {
            //                [st setObject:[NSString stringWithFormat:@"%@",headUrl] forKey:@"headimg"];
            //                //获取头像并保存本地供下次本地读取
            //                [self requestHeadimg];
            //            }
            
            //私信使用（姓名,电话,工作经验）
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if (nameStr) {
                [user setObject:[NSString stringWithFormat:@"%@",nameStr] forKey:@"personName"];
            }
            if (telStr) {
                [user setObject:[NSString stringWithFormat:@"%@",telStr] forKey:@"user_tel"];
                [st setObject:[NSString stringWithFormat:@"%@",telStr] forKey:@"myTel"];//电话
            }
            if (newWorkY) {
                [user setObject:newWorkY forKey:@"mWorkYear"];
            }
            
            if (!jl_url) {
                [st setObject:@"" forKey:@"userjlUrl"];//简历URL为空
            }else{
                [st setObject:jl_url forKey:@"userjlUrl"];//简历URL
            }
            
            if (!jianliId) {
                [st setObject:@"" forKey:@"jlId"];//简历ID为空
            }else{
                [st setObject:jianliId forKey:@"jlId"];//简历ID
            }
            
            [st setObject:[NSString stringWithFormat:@"%@",openname] forKey:@"openName"];//姓名公开
            
            
            if (talent_type) {
                [st setObject:[NSString stringWithFormat:@"%@",talent_type] forKey:@"myLeix"]; //人才类型
            }
            
            //基本信息（是否完整）
            if (talent_type && workYeSfftr && nameStr.length>0 && telStr.length>0) {
                [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"jibenxinxi"];
            }else{
                [st setObject:[NSString stringWithFormat:@"不完整"] forKey:@"jibenxinxi"];
            }
            //教育经历（是否完整）
            NSArray *resumeArray = [arr valueForKey:@"education"];
            if (resumeArray.count > 0) {
                [st setObject:@"完整" forKey:@"education"];
            }else
            {
                [st setObject:@"不完整" forKey:@"education"];
            }
            [jiaoyu2ViewController jsonEducation:resumeArray];
            
            //求职意向（是否完整）
            NSDictionary *resumeArray3 = [arr valueForKey:@"expect_job"];
            NSLog(@"求职意向=%@",resumeArray3);
            NSString *hope_work = [resumeArray3 valueForKey:@"hope_workarea"];
            NSString *trade = [resumeArray3 valueForKey:@"trade"];
            if (hope_work.length > 0 && trade.length>0) {
                [st setObject:@"完整" forKey:@"expect"];
            }else
            {
                [st setObject:@"不完整" forKey:@"expect"];
            }
            [st setObject:resumeArray3 forKey:ApplyJob];
            
            //分别取值 判断简历是否完整
            NSString *jiben = [st.resumeDictionary valueForKey:@"jibenxinxi"];
            NSString *jiaoyu = [st.resumeDictionary valueForKey:@"education"];
            NSString *qzyx = [st.resumeDictionary valueForKey:@"expect"];
            
            if (jiben.length==2&&jiaoyu.length==2&&qzyx.length==2) {
                [user setObject:@"完整" forKey:@"isComplete"];
                [user setObject:@"0" forKey:@"canDeliver"];
            }else{
                [user setObject:@"不完整" forKey:@"isComplete"];
                [user setObject:@"1" forKey:@"canDeliver"];
            }
            
            /************************************************************************/
            //拼接基本信息完善的字典
            NSDictionary *xxwsDic = [[NSDictionary alloc]initWithObjectsAndKeys:ageStr,@"userBrith",salary,@"cur_salary",email,@"userEmail",homeStr,@"userLocal",homeCode,@"userLocalCode",marred,@"userMarriage",state,@"userHuntState", nil];
            [st setObject:xxwsDic forKey:@"jbws"];
            //基本信息完善（是否完整）
            if (salary.length>0&&![salary isEqualToString:@"0"]) {
                [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve-jiben"];
            }else{
                [st setObject:[NSString stringWithFormat:@"不完整"] forKey:@"leve-jiben"];
            }
            
            //自我评价保存
            NSString *pijia = [arr valueForKey:@"introduction"];
            NSNull *null = [NSNull null];
            if (![pijia isEqual:null]) {
                [st setObject:[NSString stringWithFormat:@"%@",pijia] forKey:@"pingjia"];
            }
            
            //工作经历（是否完整）
            NSArray *resumeArray2 = [arr valueForKey:@"work"];
            if (![resumeArray2 isKindOfClass:[NSNull class]]) {
                [st setObject:resumeArray2 forKey:WorkExperience];
            }else{
                resumeArray2 = [[NSArray alloc] init];
                [st setObject:resumeArray2 forKey:WorkExperience];
            }
            
            
            if (resumeArray2.count > 0) {
                [st setObject:@"完整" forKey:@"workExperience"];
            }else
            {
                [st setObject:@"不完整" forKey:@"workExperience"];
            }
            
            //培训经历（是否完整）
            NSMutableArray *peixunDic = [arr valueForKey:@"train"];
            if (!peixunDic) {
                peixunDic = [[NSMutableArray alloc] init];
            }
            [st setObject:peixunDic forKey:@"peixun"];
            if (peixunDic.count ==0) {
                [st setObject:[NSString stringWithFormat:@"不完整"] forKey:@"leve_peixun"];
            }else{
                [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve_peixun"];
            }
            
            //外语能力(是否完整)
            NSMutableArray *waiyuAry = [arr valueForKey:@"language"];
            if (!waiyuAry) {
                waiyuAry = [[NSMutableArray alloc] init];
            }
            [st setObject:waiyuAry forKey:Language];
            if (waiyuAry.count ==0) {
                [st setObject:[NSString stringWithFormat:@"不完整"] forKey:@"leve_waiyu"];
            }else{
                [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve_waiyu"];
            }
            
            //职业标签（是否完整）
            if (userTag) {
                [st setObject:[NSString stringWithFormat:@"%@",userTag] forKey:@"userTagg"];//职业标签
                NSLog(@"职业标签====%@",userTag);
            }
            
            //获得附件信息
            [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [self getFileInfo];
        }else{
//            NSLog(@"简历信息====%@",arr);
//            mAlertView(nil, @"数据异常");
            alert.message = @"数据异常";
            [alert show];

        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}

//请求附件信息
- (void)getFileInfo
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, @"new_api/attach/ios_attach_list?");
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,nil];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:dic urlString:urlString];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    //设置缓存方式
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setTimeOutSeconds:20];
    //设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setRequestMethod:@"GET"];
    [request setSecondsToCache:60*60*24*30];
    
    
    [request setCompletionBlock:^{
        NSString *result = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"please login"]) {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
        }
            NSLog(@"附件微儿-----------------------------------%@",result);
        [_soundArray removeAllObjects];
        [_imageArray removeAllObjects];
        [_fileArray removeAllObjects];
        NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSArray *i = [ResumeFile fileJsonFrom:requestDic Type:1];
        NSArray *s = [ResumeFile fileJsonFrom:requestDic Type:2];
        NSArray *f = [ResumeFile fileJsonFrom:requestDic Type:3];
        
        [_soundArray addObjectsFromArray:s];
        [_imageArray addObjectsFromArray:i];
        [_fileArray addObjectsFromArray:f];
        
        [self addFileInView];
        
        [self getUrlAndRequest];
        [myTableView reloadData];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
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

//改变添加文件按钮的位置
- (void)setAddBtnPosition:(NSInteger)tag
{
    FileButton *btn = (FileButton *)[rootScrollView viewWithTag:tag];
    NSInteger index = 0;
    
    if (tag == 151) {
        if(_soundArray.count >=8)
        {
            [btn removeFromSuperview];
        }
        index = _soundArray.count;
        btn.frame = CGRectMake(20+((index%4)*75), 45 +((index/4) *75), 55, 55);
    }else if (tag == 152)
    {
        if(_imageArray.count >=8)
        {
            [btn removeFromSuperview];
        }
        index = _imageArray.count;
        btn.frame = CGRectMake(iPhone_width + 20+((index%4)*75), 45 +((index/4) *75), 55, 55);
    }else if (tag == 153)
    {
        if(_fileArray.count >=8)
        {
            [btn removeFromSuperview];
        }
        index = _fileArray.count;
        btn.frame = CGRectMake(iPhone_width*2 + 20+((index%4)*75), 45 +((index/4) *75), 55, 55);
    }
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

//点击文件的方法
- (void)check:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIActionSheet *sheet = nil;
    selectTag = btn.tag + 100;
    if (btn.tag >= 120) {
        if (_fileArray&&_fileArray.count>0) {
            selectFile = [_fileArray objectAtIndex:btn.tag - 120];
        }
        
        
    }else if (btn.tag >= 110)
    {
        if (_imageArray&&_imageArray.count>0) {
            selectFile = [_imageArray objectAtIndex:btn.tag - 110];
        }
    }else if (btn.tag >= 100)
    {
        if (_soundArray&&_soundArray.count>0) {
            selectFile = [_soundArray objectAtIndex:btn.tag - 100];
        }
    }
    NSString *bd = @"绑定简历";
    if (selectFile.binding) {
        bd = @"与简历解绑";
    }
    sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"预览", nil];
    sheet.tag = 256;
    [sheet showInView:self.view];
}
//上传简历头像方法
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

#pragma mark- 简历预览
- (void)takephoto2:(id)sender
{
    WebViewController *web = [[WebViewController alloc]init];
    ResumeOperation *st = [ResumeOperation defaultResume];
    NSString *urlString = [st.resumeDictionary valueForKey:@"userjlUrl"];
    web.urlStr = urlString;
    web.floog = @"简历预览";
    [self.navigationController pushViewController:web animated:YES];
}

//扫一扫
- (void)scan:(id)sender
{
    ScanResumeViewController *scan = [[ScanResumeViewController alloc] init];
    [self.navigationController pushViewController:scan animated:YES];
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
                    [self presentModalViewController:imageVC animated:YES];
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

//删除文件
- (void)deleteResumeFileBtn
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, @"message.php?ac=attachment_del&");
    NSDictionary *paramter = nil;
    NSString *authId = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthID];
    paramter = [NSDictionary dictionaryWithObjectsAndKeys:selectFile.attachment_id,@"attachment_id",authId,kAuthID, nil];
    urlString = [[NSString alloc] initWithFormat:@"%@%@=%@",urlString,kAuthID,authId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:selectFile.attachment_id forKey:@"attachment_id"];
    [request setPostValue:authId forKey:kAuthID];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSLog(@"image----------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        if (selectFile.fileItem == FileImage) {
            [_imageArray removeObject:selectFile];
            SDDataCache *cache = [SDDataCache sharedDataCache];
            [cache removeDataForKey:selectFile.fileRealName];
        }
        else if (selectFile.fileItem == FileSound) {
            
            [[NSFileManager defaultManager] removeItemAtPath:selectFile.openPath error:nil];
            [_soundArray removeObject:selectFile];
        }else {
            [_fileArray removeObject:selectFile];
        }
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self addFileInView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}
//解绑
- (void)unbindingFromResume
{
    FileButton *fileBtn = (FileButton *)[rootScrollView viewWithTag:selectTag];
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, @"message.php?ac=attachment_status&");
    NSDictionary *paramter = nil;
    NSString *authId = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthID];
    if (selectFile.binding) {
        paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"mtype",selectFile.attachment_id,@"file_id",authId,kAuthID, nil];
        
    }else
    {
        paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"mtype",selectFile.attachment_id,@"file_id",authId,kAuthID, nil];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:paramter urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        NSLog(@"image----------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        if (selectFile.binding) {
            selectFile.binding = NO;
            fileBtn.binding = NO;
            fileBtn.bindingView.alpha = 0;
        }else
        {
            fileBtn.bindingView.alpha = 1;
            fileBtn.binding = YES;
            selectFile.binding = YES;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
}


#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - 截取图片
- (void)cutMapView:(UIView *)theView
{
    //************** 得到图片 *******************
    CGRect rect = theView.frame;  //截取图片大小
    
    //开始取图，参数：截图图片大小
    UIGraphicsBeginImageContext(rect.size);
    //截图层放入上下文中
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //从上下文中获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束截图
    UIGraphicsEndImageContext();
    
    
    //************** 存图片 *******************
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"jietu"]];   // 保存文件的名称
    NSLog(@"filePath = %@",filePath);
    //UIImagePNGRepresentation方法将image对象转为NSData对象
    //写入文件中
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath atomically:YES];
    NSLog(@"result = %d",result);
    
    
    //*************** 截取小图 ******************
    CGRect rect1 = CGRectMake(90, 0, 77, 77);//创建矩形框
    //对图片进行截取
    UIImage * image2 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect1)];
    NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"jietu2"]];   // 保存文件的名称
    NSLog(@"filePath = %@",filePath);
    BOOL result2 = [UIImagePNGRepresentation(image2)writeToFile:filePath2 atomically:YES];
    NSLog(@"result2 = %d",result2);
    
    //存入相册
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
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
    //简历头像
    if (_head) {
        //头像保存本地
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString *str = [st valueForKey:@"UserName"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString*finame = [NSString stringWithFormat:@"%@.png",str];
        SDDataCache *imageCache = [SDDataCache sharedDataCache];
        [imageCache storeData:imageData forKey:finame];
         [_pathCover setAvatarImage:image];
        //上传头像
        [self uploadPath2:image name:[NSString stringWithFormat:@"%@.png",str]];
        
    }else//上传图片
    {
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
//        NSLog(@"path-----------------------------------%@",image);
        //上传图片
        [self uploadPath:zipImage name:fileName];
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
//上传图片
- (void)uploadPath:(UIImage *)image name:(NSString *)name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [net sendToServerWithImage:image imageName:name resume:YES];
}
//上传头像
- (void)uploadPath2:(UIImage *)image name:(NSString *)name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken", nil];
    [net send2ToServerWithImage:image imageName:name param:params];
}

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"shangtouxiang________%@",requestDic);
    NSString *state = [requestDic valueForKey:@"state"];
    if ([state boolValue]) {
        [self uploadResult:requestDic];
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//上传结果
- (void)uploadResult:(NSDictionary *)requestDic
{
    ResumeFile *file = [[ResumeFile alloc] init];
    file.fileRealName = [requestDic valueForKey:@"file_name"];
    file.userid = [requestDic valueForKey:@"resume_id"];
    file.fileName = [requestDic valueForKey:@"file_showname"];
    file.attachment_id = [requestDic valueForKey:@"file_id"];
    file.downloadPath = [requestDic valueForKey:@"file_store_path"];
    file.downloadPath_mini = [requestDic valueForKey:@"downloadpath_mini"];
    file.type = [requestDic valueForKey:@"file_extension"];
    file.binding = YES;
    file.exsit = YES;
    file.fileItem = [ResumeFile fileType:file.type];
    file.myImage = uploadImage;
    if ([file.type isEqualToString:@"amr"]) {
        [_soundArray addObject:file];
        file.openPath = chatRecord.recordFilePath;
        NSLog(@"rp------------------------------%@",file.openPath);
    }else
    {
        [_imageArray addObject:file];
    }
    [self addFileInView];
}
- (void)receiveDataFail:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)requestTimeOut
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark-------tablewView的代理方法
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
                    
                    img_View.frame = CGRectMake(47, 5, 240, 110);
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
    }
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 6;
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
    label.text = [NSString stringWithFormat:@"不完整"];
    ResumeOperation *sr = [ResumeOperation defaultResume];
    if (indexPath.section==0 && indexPath.row==0) {
        [cell.contentView addSubview:img_View];
    }else if(indexPath.section==0 && indexPath.row==1){
        [cell.contentView addSubview:sound_View];
    }else if(indexPath.section==0 && indexPath.row==2){
        [cell.contentView addSubview:file_View];
    }
    if (indexPath.section==2 && indexPath.row==5) {
        NSString *ste = [sr.resumeDictionary valueForKey:@"userTagg"];
        if (ste.length>0) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==2 && indexPath.row==4) {
        NSString *ste = [sr.resumeDictionary valueForKey:@"leve_waiyu"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==2 && indexPath.row==3) {
        NSString *ste = [sr.resumeDictionary valueForKey:@"leve_peixun"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==2 && indexPath.row==2)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"pingjia"];
        if (ste.length>0) {
            if ([ste isEqualToString:@"工作能力及自我评价(800字以内)"]) {
                label.text = [NSString stringWithFormat:@"不完整"];
            }else{
                label.text = [NSString stringWithFormat:@"完整"];
            }
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }
    else if (indexPath.section ==2 && indexPath.row==0)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"leve-jiben"];
        if (ste.length==2) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==1 && indexPath.row==0)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"jibenxinxi"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==1 && indexPath.row==1)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"education"];
//        NSLog(@"ste ===%@",ste);
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==1 && indexPath.row==2)
    {
        NSString *ste  = [sr.resumeDictionary valueForKey:@"expect"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
        
    }else if (indexPath.section ==2 && indexPath.row==1)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"workExperience"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section==0 && indexPath.row==0){
        if (_imageArray.count>0) {
            label.text= [NSString stringWithFormat:@""];
        }else{
            label.text = [NSString stringWithFormat:@"未添加"];
        }
    }else if (indexPath.section==0 && indexPath.row==1){
        if (_soundArray.count>0) {
            label.text= [NSString stringWithFormat:@""];
        }else{
            label.text = [NSString stringWithFormat:@"未添加"];
        }
    }else if (indexPath.section==0 && indexPath.row==2){
        if (_fileArray.count>0) {
            label.text= [NSString stringWithFormat:@""];
        }else{
            label.text = [NSString stringWithFormat:@"未添加"];
        }
    }
    
    if (label.text.length>2) {
        label.textColor = [UIColor orangeColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section==1)
	{
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,-5, tableView.bounds.size.width,25)];
        UILabel *labrl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, iPhone_width-20, 30)];
        labrl.backgroundColor =[UIColor clearColor];
        labrl.text = @"必填:填完后即可配合附件简历速投职位!";
        labrl.font = [UIFont fontWithName:Zhiti size:14];
        labrl.textColor = [UIColor darkGrayColor];
        [view addSubview:labrl];
		return view;
	}else if(section==2){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,20)];
        UILabel *labrl1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, iPhone_width-20, 30)];
        labrl1.backgroundColor =[UIColor clearColor];
        labrl1.text = @"完善:完善信息后坐等企业主动联系您!";
        labrl1.font = [UIFont fontWithName:Zhiti size:14];
        labrl1.textColor = [UIColor darkGrayColor];
        [view addSubview:labrl1];
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sheetRecordView.alpha =0;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0 && indexPath.row==0) {
        Image_fjViewController *image = [[Image_fjViewController alloc]init];
        image.companyDelegate =self;
        image.imageArray = _imageArray;
        [self.navigationController pushViewController:image animated:YES];
    }else if (indexPath.section==0 && indexPath.row==1){
        Yuyin_fjViewController *yuyin = [[Yuyin_fjViewController alloc]init];
        yuyin.soundArray = _soundArray;
        yuyin.yyDelegate =self;
        [self.navigationController pushViewController:yuyin animated:YES];
    }else if (indexPath.section==0 && indexPath.row==2){
        File_fjViewController *file = [[File_fjViewController alloc]init];
        file.fileArray = _fileArray;
        [self.navigationController pushViewController:file animated:YES];
    }if (indexPath.section == 1 && indexPath.row == 0)
    {
        jibenxxViewController *jiben = [[jibenxxViewController alloc]init];
        [self.navigationController pushViewController:jiben animated:YES];
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
        jiaoyuxxViewController *jiaoyu = [[jiaoyuxxViewController alloc]init];
        [self.navigationController pushViewController:jiaoyu animated:YES];
    }else if(indexPath.row == 2 && indexPath.section == 1)
    {
        qiuzhiyxViewController *qiuzhi = [[qiuzhiyxViewController alloc]init];
        qiuzhi.deleate = self;
        [self.navigationController pushViewController:qiuzhi animated:YES];
    }
    else if (indexPath.section == 2&& indexPath.row == 0)
    {
        jibenwansViewController *jiben = [[jibenwansViewController alloc]init];
        jiben.deleate  =self;
        [self.navigationController pushViewController:jiben animated:YES];
    }else if (indexPath.section == 2&& indexPath.row == 1){
        jingliViewController *jingji = [[jingliViewController alloc]init];
        [self.navigationController pushViewController:jingji animated:YES];
    }
    else if (indexPath.section == 2&& indexPath.row == 2)
    {
        pingjiaViewController *pingjia = [[pingjiaViewController alloc]init];
        pingjia.deleat =self;
        [self.navigationController pushViewController:pingjia animated:YES];
    }
    else if (indexPath.section == 2&& indexPath.row == 3)
    {
        peixunViewController *peixun = [[peixunViewController alloc]init];
        [self.navigationController pushViewController:peixun animated:YES];
    }else if (indexPath.section == 2&& indexPath.row == 4)
    {
        waiyuViewController *waiyu = [[waiyuViewController alloc]init];
        [self.navigationController pushViewController:waiyu animated:YES];
    }else if (indexPath.section ==2&&indexPath.row ==5){
        //职业标签
        pingjiaViewController *pingjia =[[pingjiaViewController alloc]init];
        pingjia.trpe = [NSString stringWithFormat:@"biaoqian"];
        pingjia.deleat =self;
        [self.navigationController pushViewController:pingjia animated:YES];
    }
}

//自我评价代理方法
- (void)wanzhengFou:(NSString *)str
{
    
    ResumeOperation *st = [ResumeOperation defaultResume];
    [st setObject:[NSString stringWithFormat:@"%@",str] forKey:@"pingjia"];
    [myTableView reloadData];
}
//标签的代理方法
- (void)bianqian:(NSString *)str
{
    ResumeOperation *st = [ResumeOperation defaultResume];
    [st setObject:[NSString stringWithFormat:@"%@",str] forKey:@"userTagg"];
    [myTableView reloadData];
    
}
- (void)kaiguan
{
    ResumeOperation *sr = [ResumeOperation defaultResume];
    NSString *str1 = [sr.resumeDictionary valueForKey:@"gongKai"];
    if ([str1 integerValue]==0) {
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestVisible:[NSString stringWithFormat:@"1"]];
    }else{
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self requestVisible:[NSString stringWithFormat:@"0"]];
    }
}
//更改简历状态
-(void)requestVisible:(NSString *)stre
{
    NSString *url = kCombineURL(KXZhiLiaoAPI,jiben1);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"3",@"flag",stre,@"UserResumeOpen",nil];
    NSURL *urlstr = [NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:urlstr];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSDictionary *arr = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSString *str = [arr valueForKey:@"error"];
        if ([str integerValue]==0) {
            //保存成功
            ResumeOperation *st = [ResumeOperation defaultResume];
            NSString *str = [st.resumeDictionary valueForKey:@"gongKai"];
            if ([str integerValue]==0) {
                [st setObject:[NSString stringWithFormat:@"1"] forKey:@"gongKai"];
                [_pathCover setJianliState:@"1"];
            }else{
                [st setObject:[NSString stringWithFormat:@"0"] forKey:@"gongKai"];
                [_pathCover setJianliState:@"0"];
            }
           
        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}
- (void)miashuZiShu:(NSString *)str destring:(NSString *)des
{}

#pragma mark- scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
