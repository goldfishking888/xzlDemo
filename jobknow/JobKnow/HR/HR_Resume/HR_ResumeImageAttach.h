//
//  HR_ResumeImageAttach.h
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResumeFile.h"
#import "HRResumeInfoModel.h"
@protocol HR_ResumeImageAttachDelegate <NSObject>

- (void)configImgAry:(NSMutableArray*)ary;

@end

@interface HR_ResumeImageAttach : BaseViewController<UIActionSheetDelegate,SendRequest,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView *bgView;
    ResumeFile *selectFile;//选择的文件信息
    NSInteger selectTag;//选择的btn的tag值
    UIImage *uploadImage;
    
}
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组

@property (nonatomic, assign) id <HR_ResumeImageAttachDelegate> companyDelegate;

@property (nonatomic, strong) HRResumeInfoModel *resumeModel;//简历dic

@end
