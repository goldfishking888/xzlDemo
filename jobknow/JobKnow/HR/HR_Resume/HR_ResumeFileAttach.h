//
//  HR_ResumeFileAttach.h
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeFile.h"
#import "HRResumeInfoModel.h"

@interface HR_ResumeFileAttach : BaseViewController<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate>
{
    UIView *bgVIew;  //背景图片
    NSInteger selectTag;//选择的btn的tag值
    ResumeFile *selectFile;//选择的文件信息
    OLGhostAlertView *alert;
}
@property (nonatomic, strong) NSMutableArray *fileArray;//文档数组

@property (nonatomic, strong) HRResumeInfoModel *resumeModel;//简历dic

@end
