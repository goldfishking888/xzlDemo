//
//  HR_ResumeDetail.h
//  JobKnow
//
//  Created by Suny on 15/8/5.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeFile.h"
#import "FileButton.h"
#import "TipView.h"
#import "ChatRecorderView.h"
#import "ChatVoiceRecorderVC.h"
#import "pingjiaViewController.h"
#import "XHPathCover.h"
#import "qiuzhiyxViewController.h"
#import "jibenwansViewController.h"
#import "HRReumeModel.h"
#import "HRResumeInfo_Base_Model.h"
#import "HRResumeInfoModel.h"
#import "HR_ResumeEdit.h"
#import "HR_ResumeText.h"
#import "HR_ResumeImageAttach.h"
#import "HR_ResumeVoiceAttach.h"
#import "HR_ResumeFileAttach.h"
#import "HR_ResumeList.h"

@interface HR_ResumeDetail : BaseViewController<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SendRequest,TipViewDelegate,AVAudioPlayerDelegate,UIDocumentInteractionControllerDelegate,UITableViewDelegate,UITableViewDataSource,miaosuDeleat,changeHead,HR_ResumeImageAttachDelegate,HR_ResumeVoiceAttachDelegate,qzyxDeleat,jbxxwsDeleat,HR_ResumeEditDelegate,HR_ResumeTextDelegate>
{
    UIImageView *btniv;
    UIScrollView *rootScrollView;   //左右滑动
    UIButton *societyBtn;  //简历中心
    UIButton *univerBtn;   //职位收藏
    
    UIImage *uploadImage;
    ResumeFile *selectFile;//选择的文件信息
    NSInteger selectTag;//选择的btn的tag值
    UIActionSheet *sheetRecord;
    UIView *sheetRecordView;
    TipView *recordView;//录音
    TipView *uploadView;//录音完成
    ChatVoiceRecorderVC *chatRecord;
    OLGhostAlertView *alert;
    AVAudioPlayer *resumePlayer;
    NSInteger recordTime;
    UILabel *nameLabel;
    UILabel *secdLabel;
    UILabel *emalLabel;
    NSTimer *updateProgress;
    MBProgressHUD *loadView;
    UITableView *myTableView;
    
    UIView *img_View;
    UIView *sound_View;
    UIView *file_View;
    
    OLGhostAlertView *ghostView;
    
    UIImage *image_current;
}
@property (nonatomic, strong) NSMutableArray *soundArray;//语音数组
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) NSMutableArray *fileArray;//文档数组
@property (nonatomic, assign) BOOL head;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic,retain)NSMutableArray *moreArray;

@property (nonatomic, strong) XHPathCover *pathCover;


@property (nonatomic, strong) HRReumeModel *resumeModelFromList;

@property (nonatomic, strong) HRResumeInfo_Base_Model *baseModel;//拉取的简历信息中得基本信息

@property (nonatomic, strong) HRResumeInfoModel *model_Resume;//拉取的简历信息实体

@property (nonatomic) BOOL isFromResumeAdd;//用作判断是否是从ResumeAdd跳入的标识

@property (nonatomic, retain) UIDocumentInteractionController *documentVc;

- (void)getResumeInfo;

@end
