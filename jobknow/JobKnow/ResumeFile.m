//
//  ResumeFile.m
//  JobKnow
//
//  Created by liuxiaowu on 13-9-13.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ResumeFile.h"
#import "Photo.h"
#import "SDDataCache.h"

@implementation ResumeFile

#define ImagePath @"resumeimage"

#define SoundPath @"resumesound"

/*
 *type,1图片，2语音，3文件
 *
 */
+ (NSArray *)fileJsonFrom:(NSDictionary *)jsonDic Type:(NSInteger)type
{
    NSArray *jsonArray = [jsonDic valueForKey:@"attach"];
    NSString *suf = nil;
    NSString *suf_png = nil;
    switch (type) {
        case 1:
            suf = @"jpg";
            suf_png = @"png";
            break;
        case 2:
            suf = @"amr";
            break;
        case 3:
            
            break;
    }
    NSArray *suffix = [NSArray arrayWithObjects:@"txt",@"doc",@"pdf",@"xls",@" xlsx",@"docx",@"rar", nil];
    NSMutableArray *array = [NSMutableArray array];
    //取出文件信息
    for (NSDictionary *dic in jsonArray) {
        ResumeFile *f = [[ResumeFile alloc] init];
        f.fileRealName = [dic valueForKey:@"name"];
        f.userid = [dic valueForKey:@"id"];
        f.fileName = [dic valueForKey:@"name"];
        f.attachment_id = [dic valueForKey:@"id"];
        f.downloadPath = [dic valueForKey:@"download_url"];
        f.downloadPath_mini = [dic valueForKey:@"download_url_mini"];
        
        NSString *state = [dic valueForKey:@"mtype"];
        if ([state integerValue] == 1) {
            f.binding = YES;
        }else
        {
            f.binding = NO;
        }
        NSString *t = [f.fileRealName pathExtension];
        f.type = t;
        f.fileItem = [ResumeFile fileType:t];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *path = nil;
        //判断文件类型
        if (type == 3) {
            if ([suffix containsObject:t]) {
                [array addObject:f];
            }
        }else
        {
            if ([t compare:suf options:NSCaseInsensitiveSearch] == NSOrderedSame ||[t compare:suf_png options:NSCaseInsensitiveSearch] == NSOrderedSame) {
               //语音
                if (type == 2) {
                    path = [ResumeFile saveSoundPath];
                    f.fileRealName = [[f.fileRealName stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
                    path = [path stringByAppendingPathComponent:f.fileRealName];
                    path = [path stringByReplacingOccurrencesOfString:@" " withString:@""];
                    f.openPath = path;
                    f.exsit = YES;//判断文件是否存在
                    if (![fileManager fileExistsAtPath:path]) {
                        f.exsit = NO;
                    }
                }else//图片
                {

                    SDDataCache *imageCache = [SDDataCache sharedDataCache];
                    NSData *imageData = [imageCache dataFromKey:f.fileRealName fromDisk:YES];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    f.myImage = [Photo scaleImage:image toWidth:75 toHeight:100];
                    if (imageData) {
                        f.exsit = YES;
                    }else
                    {
                        f.exsit = NO;
                    }
                }
                
                [array addObject:f];
            }
        }
    }
    return array;
}


//文件类型
+ (FileOption)fileType:(NSString *)type
{
    if ([type compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame||[type isEqualToString:@"gif"]||[type isEqualToString:@"png"]) {
        return FileImage;
    }else if([type isEqualToString:@"amr"])
    {
        return FileSound;
    }else if([type isEqualToString:@"txt"])
    {
        return FileTxt;
    }else if([type isEqualToString:@"pdf"])
    {
        return FilePdf;
    }else if([type isEqualToString:@"doc"])
    {
        return FileWord;
    }else if([type isEqualToString:@"docx"])
    {
        return FileWord;
    }
    else if([type isEqualToString:@"rar"])
    {
        return FileZip;
    }else if([type isEqualToString:@"xls"])
    {
        return FileExcel;
    }
    else if([type isEqualToString:@"xlsx"])
    {
        return FileExcel;
    }
    else if([type isEqualToString:@"gif"])
    {
        return FileImage;
    }
    else if([type isEqualToString:@"xls"])
    {
        return FileExcel;
    }
    return FileWord;
}

//返回语音路径
+ (NSString *)saveSoundPath
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
    
    return path;
}

@end
