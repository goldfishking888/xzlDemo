//
//  ResumeFile.h
//  JobKnow
//
//  Created by liuxiaowu on 13-9-13.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
//文件格式
typedef enum FileType
{
    FileTxt,
    FilePdf,
    FileWord,
    FileExcel,
    FileZip,
    FileSound,
    FileImage,
    FileNone
}FileOption;

@interface ResumeFile : NSObject

@property (nonatomic, copy) NSString *userid;//用户id
@property (nonatomic, copy) NSString *fileName;//服务器端文件名
@property (nonatomic, copy) NSString *fileRealName;//文件名称
@property (nonatomic, copy) NSString *attachment_id;//
@property (nonatomic, copy) NSString *downloadPath;//下载地址
@property (nonatomic, copy) NSString *downloadPath_mini;//mini下载地址
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *openPath;
@property (nonatomic, assign) BOOL exsit;//文件是否存在本地，否则下载
@property (nonatomic, assign) FileOption fileItem;
@property (nonatomic, strong) UIImage *myImage;
@property (nonatomic, assign) BOOL binding;
+ (NSArray *)fileJsonFrom:(NSDictionary *)jsonDic Type:(NSInteger)type;
+ (FileOption)fileType:(NSString *)type;
+ (NSString *)saveSoundPath;
@end
