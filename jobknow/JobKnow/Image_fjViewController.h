//
//  Image_fjViewController.h
//  JobKnow
//
//  Created by Zuo on 14-2-24.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeFile.h"
@protocol ComDelegate <NSObject>

- (void)configImgAry:(NSMutableArray*)ary;

@end

@interface Image_fjViewController : BaseViewController<UIActionSheetDelegate,SendRequest,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView *bgView;
    ResumeFile *selectFile;//选择的文件信息
     NSInteger selectTag;//选择的btn的tag值
    UIImage *uploadImage;

}
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, assign) id <ComDelegate> companyDelegate;
@end
