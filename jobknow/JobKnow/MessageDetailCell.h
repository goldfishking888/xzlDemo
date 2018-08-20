//
//  MessageDetailCell.h
//  JobKnow
//
//  Created by faxin sun on 13-4-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageDetailModel.h"
#import <AVFoundation/AVFoundation.h>
#import "EGOImageView.h"

@protocol MessageDetailCellDelegate <NSObject>
@optional
- (void)resendMessageWithModel:(MessageDetailModel *)message_model;
@end
@interface MessageDetailCell : UITableViewCell<AVAudioPlayerDelegate>
{
    EGOImageView * head;
    bool fromSelf;
}
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *personName;//用户名
@property (nonatomic, strong) UILabel *dateLabel;//日期
@property (nonatomic, strong) UITextView *messageLabel;//消息
@property (nonatomic, strong) UILabel *fileLable;//文件名
@property (nonatomic, strong) UIImageView *backgroundImage;//背景图片
@property (nonatomic, strong) UIImageView *bubbleImageView;//背景图片
@property (nonatomic, strong) UIButton *soundBtn;
@property (nonatomic, strong) UIImageView *sendImageView;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) MessageDetailModel *mes;
@property (nonatomic, strong) NSString *headerUrlString;
@property (nonatomic, strong) UIButton *button_status;

@property(nonatomic,assign) id<MessageDetailCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier detailMessage:(MessageDetailModel *)message companyName:(NSString *)cname;
- (void)senondCellInitWithMessage:(MessageDetailModel *)message;

+ (CGSize)widthCell:(NSString *)message;

@end