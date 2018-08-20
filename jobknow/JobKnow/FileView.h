//
//  FileView.h
//  JobKnow
//
//  Created by faxin sun on 13-5-3.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"

@protocol FileViewDelegate
@optional
- (void)sendFile;

- (void)sendPhoto;//从相册选取图片

- (void)sendCamer;//拍照

- (void)sendResume;//发送简历

- (BOOL)selectFile:(File *)f;//选择文件

@end
@interface FileView : UIView <FileViewDelegate>

@property (nonatomic, assign) BOOL click;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, assign) id<FileViewDelegate>fileDelegate;
@property (nonatomic, strong) NSArray *options;

@property (nonatomic) BOOL isFromHr;

- (id)initWithItems;
- (void)addFiles:(NSArray *)files;

- (void)defaultInit;
@end
