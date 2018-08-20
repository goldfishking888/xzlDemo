//
//  XZLPMDetailModel.h
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "DBModel.h"

typedef enum{
    MessageSendStatusSuccess = 0,
    MessageSendStatusSending = 1,
    MessageSendStatusFail = 2
    
}MessageSendStatus;

@interface XZLPMDetailModel : DBModel

@property (nonatomic, copy) NSString *uid;// 消息列表的唯一id
@property (nonatomic, copy) NSString *portrait;// 头像路径
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;// 最新消息内容
@property (nonatomic, copy) NSString *created_time;// 最新消息的时间戳
//@property (nonatomic, copy) NSString *type;// 消息类型
@property (nonatomic ,assign) MessageSendStatus sendStatus;// 发送状态
@property (nonatomic, copy) NSString *isSelf;// 是否是自己（根据消息uid和列表uid共同判断，如果相同则是对方，如果不同则是自己）

// dic => model
+ (XZLPMDetailModel*)getPMDetailModelWithDic:(NSDictionary*)dic andPMListUid:(NSString *)pmListUid;

@end
