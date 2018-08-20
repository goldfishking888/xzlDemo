//
//  Yuyin_fjViewController.h
//  JobKnow
//
//  Created by Zuo on 14-2-24.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatVoiceRecorderVC.h"
#import "TipView.h"
#import "ResumeFile.h"
@protocol yuyinDelegate <NSObject>

- (void)configYuyinAry:(NSMutableArray*)ary;

@end
@interface Yuyin_fjViewController : BaseViewController<TipViewDelegate,SendRequest,AVAudioPlayerDelegate,UIActionSheetDelegate>
{
    ChatVoiceRecorderVC *chatRecord;
    UIActionSheet *sheetRecord;
    UIView *sheetRecordView;
    TipView *recordView;//录音
    TipView *uploadView;//录音完成
    NSTimer *updateProgress;
    AVAudioPlayer *resumePlayer;
    NSInteger recordTime;
    OLGhostAlertView *alert;
    ResumeFile *selectFile;//选择的文件信息
    UIView *bgVIew;
    NSInteger selectTag;//选择的btn的tag值
}
@property (nonatomic, strong) NSMutableArray *soundArray;//语音数组
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) id <yuyinDelegate> yyDelegate;
@end
