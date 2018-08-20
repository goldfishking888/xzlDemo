//
//  HR_ResumeVoiceAttach.h
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatVoiceRecorderVC.h"
#import "TipView.h"
#import "ResumeFile.h"
#import "HRResumeInfoModel.h"

@protocol HR_ResumeVoiceAttachDelegate <NSObject>

- (void)configYuyinAry:(NSMutableArray*)ary;

@end
@interface HR_ResumeVoiceAttach : BaseViewController<TipViewDelegate,SendRequest,AVAudioPlayerDelegate,UIActionSheetDelegate>
{
    ChatVoiceRecorderVC *chatRecord;
    UIActionSheet *sheetRecord;
    UIView *sheetRecordView;
    UIView *sheetRecordView_back;
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
@property (nonatomic, assign) id <HR_ResumeVoiceAttachDelegate> yyDelegate;

@property (nonatomic, strong) HRResumeInfoModel *resumeModel;//简历dic

@end
