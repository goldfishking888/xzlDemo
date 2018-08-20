//
//  File.m
//  JobKnow
//
//  Created by faxin sun on 13-5-2.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "File.h"

@implementation File

+ (NSArray*)allAttachments:(NSArray *)attachments
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i<attachments.count; i++) {
        NSDictionary *dic = [attachments objectAtIndex:i];
        File *att = [[File alloc] init];
        att.fileName = [dic valueForKey:@"file_real_name"];
        NSString *f = [File backFileSuffix:att.fileName];
        att.fileType = f;
        att.fileid = [[NSString alloc]initWithFormat:@"%@",[dic valueForKey:@"attachment_id"]];
        [array addObject:att];
    }
    return array;
}


+ (File *)upLoadFile:(NSDictionary *)file
{
    File *f = [[File alloc] init];
    
    f.fileName = [file valueForKey:@"file_name"];
    f.fileid = [[NSString alloc]initWithFormat:@"%@",[file valueForKey:@"file_id"]];
    NSLog(@"fu=================%@",f.fileid);

    f.fileType = [File backFileSuffix:f.fileName];
    return f;
}

+ (NSString *)backFileSuffix:(NSString *)fileName
{
    NSArray *array = [fileName componentsSeparatedByString:@"."];
    if (array.count > 1) {
        return [array objectAtIndex:1];
    }else
    {
        return @"doc";
    }
}

@end
