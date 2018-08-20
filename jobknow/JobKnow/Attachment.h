//
//  Attachment.h
//  JobKnow
//
//  Created by faxin sun on 13-5-13.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attachment : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *attachment_id;
+ (NSArray *)attachments:(NSArray *)attachments;

@end
