//
//  MessageDetailViewController.h
//  JobKnow
//

#import <UIKit/UIKit.h>
#import "JobReaderDetailViewController.h"
#import "MessageListModel.h"
#import "MessageCell.h"
#import "MessageDetailCell.h"
#import "HPGrowingTextView.h"
#import "FileView.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatRecorderView.h"
#import "ChatVoiceRecorderVC.h"
#import "TipsView.h"
#import "TipView.h"

typedef enum{
    DetailRequestBackward = 0,
    DetailRequestForward = 1,
    
}DetailRequestToward;

@interface MessageDetailViewController : BaseViewController <HPGrowingTextViewDelegate,UITableViewDataSource,UITableViewDelegate,SendRequest,UIGestureRecognizerDelegate,UINavigationControllerDelegate,FileViewDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,TipViewDelegate,MessageDetailCellDelegate>
{
    UIView *containerView;// 输入面板
    AVAudioRecorder *audioRecorder;//录音对象
    UIButton *leftBtn;//出现录音按钮
    UIButton *sendBtn;// 添加文件按钮
    
    BOOL edit;//文本框是否编辑
    BOOL keyBoard;// 键盘是否显示
    
    UIButton *recordBtn;//录音
    CGRect inputFrame;// 输入框frame
    
    //所有的附加
    NSArray *allFiles;
    TipsView *tipV;
    TipView *tips;
    TipView *play;
    OLGhostAlertView *alert;// 提示信息
    OLGhostAlertView *sendAlert;// “正在发送”
    
    //选择的附件
    NSMutableArray *selectFiles;
    ChatVoiceRecorderVC *charVC;
    AVAudioPlayer       *player;
    NSMutableArray *fileSe;
    MBProgressHUD *loadView;
}
@property (nonatomic, strong) NSArray *fileArray;
@property (nonatomic, strong) FileView *fileView;
//@property (nonatomic, assign) InfoRequestOption infoRequest;
@property (nonatomic, strong) MessageListModel *message;// 会话model
//@property (nonatomic, strong) ActivetView *actView;//加载view
@property (nonatomic, strong) UITableView *tableView;//
@property (nonatomic, strong) NetWorkConnection *netWork;//网络请求对象
@property (nonatomic, strong) NSMutableArray *messageArray;//tableView数据源
@property (nonatomic, strong) HPGrowingTextView *textView;

@property (nonatomic, copy) NSString *defautText;
@property (nonatomic, copy) NSString *headerUrlString;

@property (nonatomic) CGRect defaultkeyboardRect;

@property (nonatomic) BOOL isFromHr;

/** 发送简历需要的字段 */
@property (nonatomic, copy) NSString *postName;// 申请的职位
@property (nonatomic, copy) NSString *jobId;// 申请的职位Id
@property (nonatomic, copy) NSString *cityCode;// 申请的职位所在的城市
/******/
@end

