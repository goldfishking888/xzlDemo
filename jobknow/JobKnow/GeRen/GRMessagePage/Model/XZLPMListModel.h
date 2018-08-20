//
//  XZLPMListModel.h
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "DBModel.h"

@interface XZLPMListModel : DBModel
@property (nonatomic, copy) NSString *uid;// 消息列表的唯一id
@property (nonatomic, copy) NSString *portrait;// 头像路径
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;// 最新消息内容
@property (nonatomic, copy) NSString *created_time;// 最新消息的时间戳
//@property (nonatomic, copy) NSString *type;// 消息类型
@property (nonatomic, copy) NSString *unRead;// 是否未读 1未读 0已读

// dic => model
+ (XZLPMListModel*)getPMListModelWithDic:(NSDictionary*)dic isHistory:(BOOL)isHistory;
@end
