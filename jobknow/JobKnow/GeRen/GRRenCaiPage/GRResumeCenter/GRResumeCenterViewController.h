//
//  GRResumeCenterViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/2.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkEXPTableViewCell.h"
#import "EduEXPTableViewCell.h"
#import "ProjectEXPTableViewCell.h"
#import "TrainEXPTableViewCell.h"
#import "LanguageLevelTableViewCell.h"
#import "InterestsHobbiesTableViewCell.h"

@class GRResumePrivacyModel;
@class PersonBasicInfoModel;
@class JobOrientationModel;
@class SelfIntroModel;
@class InterestsHobbiesModel;

@interface GRResumeCenterViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,WorkEXPTableViewCellDelegate,EduEXPTableViewCellDelegate,ProjectEXPTableViewCellDelegate,TrainEXPTableViewCellDelegate,LanguageLevelTableViewCellDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *tableView_header;

@property (nonatomic,strong) GRResumePrivacyModel *model_privacy;

@property (nonatomic,strong) PersonBasicInfoModel *model_PersonBasicInfo;

@property (nonatomic,strong) JobOrientationModel *model_JobOrentation;

@property (nonatomic,strong) SelfIntroModel *model_SelfIntro;

@property (nonatomic,strong) InterestsHobbiesModel *model_Interets;

@property (nonatomic,strong) NSMutableArray *array_WorkEXP;

@property (nonatomic,strong) NSMutableArray *array_EDUEXP;

@property (nonatomic,strong) NSMutableArray *array_ProjectEXP;

@property (nonatomic,strong) NSMutableArray *array_TrainEXP;

@property (nonatomic,strong) NSMutableArray *array_LanguageLevel;

@property (nonatomic) BOOL isFromUpload;

@end
