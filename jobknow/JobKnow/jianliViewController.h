//
//  jianliViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-2.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeFile.h"
#import "FileButton.h"
#import "TipView.h"
#import "ChatRecorderView.h"
#import "ChatVoiceRecorderVC.h"
#import "pingjiaViewController.h"
#import "XHPathCover.h"
#import "Image_fjViewController.h"
#import "Yuyin_fjViewController.h"
#import "File_fjViewController.h"
#import "qiuzhiyxViewController.h"
#import "jibenwansViewController.h"
@interface jianliViewController : BaseViewController<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SendRequest,TipViewDelegate,AVAudioPlayerDelegate,UIDocumentInteractionControllerDelegate,UITableViewDelegate,UITableViewDataSource,miaosuDeleat,changeHead,ComDelegate,yuyinDelegate,qzyxDeleat,jbxxwsDeleat>
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
}
@property (nonatomic, strong) NSMutableArray *soundArray;//语音数组
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) NSMutableArray *fileArray;//文档数组
@property (nonatomic, assign) BOOL head;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic,retain)NSMutableArray *moreArray;

@property (nonatomic, strong) XHPathCover *pathCover;

- (void)getResumeInfo;

@end
