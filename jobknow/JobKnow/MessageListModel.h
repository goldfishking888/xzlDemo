//
//  MessageListModel.h
//  JobKnow
//
//  Created by Jiang on 15/9/23.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "DBModel.h"


@interface MessageListModel : DBModel

// 存数据库
@property (nonatomic ,copy) NSString *plid;// 唯一标志（会话id）
@property (nonatomic ,copy) NSString *msgListhead;// 头像链接
@property (nonatomic ,copy) NSString *name;// 企业名
@property (nonatomic ,copy) NSString *msg;// 最新的一条消息内容
@property (nonatomic ,copy) NSString *dateline;// 时间戳 "2015-09-22 15:56:15"
@property (nonatomic ,copy) NSString *type; // 最后一条消息的类型
@property (nonatomic ,strong) NSNumber *isread;// 是否读过 0 未读 1已读
@property (nonatomic ,copy) NSString *soureId;// 聊天对象的id
@property (nonatomic ,strong) NSNumber *destType;// 0跟企业聊天；1跟个人聊天


// dic => model
+ (MessageListModel*) getMessageListModelWithDic:(NSDictionary*)dic IsHistory:(BOOL)isHistroy;
@end
