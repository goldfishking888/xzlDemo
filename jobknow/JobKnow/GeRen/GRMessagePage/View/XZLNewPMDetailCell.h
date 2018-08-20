//
//  XZLNewPMDetailCell.h
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZLPMDetailModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatVoiceRecorderVC.h"

@protocol XZLPMDetailCellDelegate <NSObject>
@optional
- (void)resendMessageWithModel:(XZLPMDetailModel *)pmDetailModel;
- (void)seeFileWithFileName:(NSString *)fileName;
@end
@interface XZLNewPMDetailCell : UITableViewCell<AVAudioPlayerDelegate>
{
    ChatVoiceRecorderVC *chatRecord;
    
}

- (void)setModelData:(XZLPMDetailModel *)model;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) UIButton *statusButton;// 状态按钮，点击重发
@property (nonatomic, assign) id<XZLPMDetailCellDelegate> delegate;

@property (nonatomic, strong) NSString *pmListUid;

@property (nonatomic, strong) XZLPMDetailModel *tempModel;

@end
