//
//  Attachment.m
//  JobKnow
//
//  Created by faxin sun on 13-5-13.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "Attachment.h"

@implementation Attachment

+ (NSArray *)attachments:(NSArray *)attachments
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i<attachments.count; i++) {
        NSDictionary *dic = [attachments objectAtIndex:i];
        Attachment *att = [[Attachment alloc] init];
        att.user_id = [dic valueForKey:@"userid"];
        att.fileName = [dic valueForKey:@"file_real_name"];
        att.fileSize = [dic valueForKey:@"file_size"];
        att.attachment_id = [dic valueForKey:@"attachment_id"];
        [array addObject:att];
    }
    return array;
}

@end
