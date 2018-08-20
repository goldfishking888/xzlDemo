//
//  HRPersonalCenterVC.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "HRBasicInfoModel.h"
@interface HRPersonalCenterVC : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)HRBasicInfoModel *model_PersonBasicInfo;

@end
