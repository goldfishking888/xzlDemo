//
//  File_fjViewController.h
//  JobKnow
//
//  Created by Zuo on 14-2-24.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeFile.h"
@interface File_fjViewController : BaseViewController<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate>
{
    UIView *bgVIew;  //背景图片
    NSInteger selectTag;//选择的btn的tag值
    ResumeFile *selectFile;//选择的文件信息
    OLGhostAlertView *alert;
}
@property (nonatomic, strong) NSMutableArray *fileArray;//文档数组
@end
