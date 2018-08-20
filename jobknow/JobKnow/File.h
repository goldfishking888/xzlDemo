//
//  File.h
//  JobKnow
//
//  Created by faxin sun on 13-5-2.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property (nonatomic, copy)NSString *fileid;//文件id
@property (nonatomic, copy)NSString *fileName;//文件名称
@property (nonatomic, copy)NSString *fileType;//文件类型

+ (NSArray*)allAttachments:(NSArray *)attachments;

+ (File *)upLoadFile:(NSDictionary *)file;

//+ (NSArray *)detailMessageFromNSDictionary:(NSDictionary *)dic;

@end
