//
//  MessageDetailModel.h
//  JobKnow
//
//  Created by Jiang on 15/9/23.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "DBModel.h"

typedef enum{
    MessageSendStatusSuccess = 0,
    MessageSendStatusSending = 1,
    MessageSendStatusFail = 2
    
}MessageSendStatus;

@interface MessageDetailModel : DBModel

@property (nonatomic ,copy) NSString *pmid;// 唯一标识
@property (nonatomic ,copy) NSString *plid;//属于的会话id
@property (nonatomic ,copy) NSString *msg;// 消息内容
@property (nonatomic ,strong) NSNumber *isself;// 是否是自己
@property (nonatomic ,copy) NSString *download_url;// 文件路径
@property (nonatomic ,copy) NSString *download_url_mini;// 图片预览图路径
@property (nonatomic ,copy) NSString *file_real_name;// 文件名称
@property (nonatomic ,copy) NSString *file_size;// 文件大小
@property (nonatomic ,copy) NSString *soundTime;// 语音时长
@property (nonatomic ,copy) NSString *pmtype;//消息类型 0-文字 1-图片 2-语音 3-附件 4-简历 6-入职奖金
@property (nonatomic ,copy) NSString *dateline;// 时间戳 "2015-09-02 17:17:40"
@property (nonatomic ,copy) NSString *pm_type;// ??? 8？
@property (nonatomic ,copy) NSString *query_string;//companyId=46218973591&hr_uid=9211859&resume_uid=9220392&jobId=2969980&isAnonymity=1
@property (nonatomic ,assign) MessageSendStatus sendStatus;// 发送状态

// dic => model
+ (MessageDetailModel*)getMessageDetailModelWithDic:(NSDictionary*)dic;

@end
