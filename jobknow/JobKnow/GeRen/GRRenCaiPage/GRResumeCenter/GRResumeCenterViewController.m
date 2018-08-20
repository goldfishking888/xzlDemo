//
//  GRResumeCenterViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/2.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRResumeCenterViewController.h"

#import "PersonBasicInfoModel.h"
#import "PersonBasicInfoTableViewCell.h"
#import "GRResumeBasicInfoViewController.h"

#import "JobOrientationModel.h"
#import "JobOrientationTableViewCell.h"
#import "GRResumeJobOrientationEditViewController.h"

#import "SelfIntroModel.h"
#import "SelfIntroTableViewCell.h"
#import "GRResumeSelfIntroEditViewController.h"

#import "WorkEXPModel.h"
#import "WorkEXPTableViewCell.h"
#import "GRResumeJobEXPEditViewController.h"

#import "EduEXPModel.h"
#import "EduEXPTableViewCell.h"
#import "GRResumeEduEXPEditViewController.h"

#import "ProjectEXPModel.h"
#import "ProjectEXPTableViewCell.h"
#import "GRResumeProjectEXPEditViewController.h"

#import "TrainEXPModel.h"
#import "TrainEXPTableViewCell.h"
#import "GRResumeTrainEXPEditViewController.h"

#import "LanguageLevelModel.h"
#import "LanguageLevelTableViewCell.h"
#import "GRResumeLanguageLevelEditViewController.h"

#import "InterestsHobbiesModel.h"
#import "InterestsHobbiesTableViewCell.h"
#import "GRResumeInterestEditViewController.h"

#import "GRResumePrivacySettingViewController.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "GRUploadResumeWebViewController.h"


@interface GRResumeCenterViewController ()

@end

@implementation GRResumeCenterViewController{
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    UILabel *label_updatedAt;
    UIImageView *imageAvatar;
}

-(void)backUp:(id)sender{
    if (_isFromUpload) {
        NSArray *array = self.navigationController.viewControllers;
//        for (int i =0; i<array.count-1; i++) {
////            if (i==array.count-3) {
                UIViewController *v = array[0];
                [self.navigationController popToViewController:v animated:YES];
                return;
//            }
//        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self getResumeInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configHeadView:RGB(255, 163, 29)];
    [self addBackBtnGROnly];
    [self addTitleLabel:@"简历" color:[UIColor whiteColor]];
    [self addRightButtonWithTitle:@"隐私设置" Color:RGB(255, 255, 255) Font:[UIFont systemFontOfSize:16]];
    [self initData];
    [self initTableView];
//    [self getResumeInfo];
    
}

-(void)onClickRightBtn:(UIButton *)sender
{
    GRResumePrivacySettingViewController *vc = [GRResumePrivacySettingViewController new];
    _model_privacy.name = _model_PersonBasicInfo.name;
    _model_privacy.resume_id = _model_PersonBasicInfo.resumeId;
    vc.model = _model_privacy;
    if ([vc.model.resume_id isNullOrEmpty]) {
        ghostView.message = @"请刷新简历后尝试";
        [ghostView show];
        return;
    }
    [self.navigationController pushViewController:vc  animated:YES];
}

-(void)initData{
    
    _model_privacy = [GRResumePrivacyModel new];
    
    _model_SelfIntro = [SelfIntroModel new];
    
    _model_JobOrentation = [JobOrientationModel new];
    
    _model_SelfIntro = [SelfIntroModel new];
    
    _array_WorkEXP = [NSMutableArray new];
    
    _array_EDUEXP = [NSMutableArray new];
    
    _array_ProjectEXP = [NSMutableArray new];
    
    _array_TrainEXP = [NSMutableArray new];
    
    _array_LanguageLevel = [NSMutableArray new];

    _model_Interets = [InterestsHobbiesModel new];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;

}

-(void)initTableView{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight  - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = self.tableView_header;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

-(UIView *)tableView_header{
    if (_tableView_header ==nil) {
        _tableView_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenHeight, 180)];
        _tableView_header.backgroundColor = RGB(255, 163, 29);
        
        imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-36, 8, 72, 72)];
        mViewBorderRadius(imageAvatar, 36, 1, [UIColor clearColor]);
        imageAvatar.backgroundColor = RGB(255, 214, 154);
        imageAvatar.userInteractionEnabled = YES;
//        btn_avatar
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgClick)];
        [imageAvatar addGestureRecognizer:tapAvatar];
        
//        [btn_avatar addTarget:self action:@selector(uploadAvatar) forControlEvents:UIControlEventTouchUpInside];
        [_tableView_header addSubview:imageAvatar];
        
        UIButton *btn_uploadResume = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-6-130, 105,130, 36)];
        mViewBorderRadius(btn_uploadResume, 18, 1, [UIColor whiteColor]);
        [btn_uploadResume setTitle:@"上传简历附件" forState:UIControlStateNormal];
        [btn_uploadResume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_uploadResume.backgroundColor = RGB(255, 163, 29);
        [btn_uploadResume addTarget:self action:@selector(uploadResume) forControlEvents:UIControlEventTouchUpInside];
        [_tableView_header addSubview:btn_uploadResume];
        
        UIButton *btn_refresh = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2+6, 105,130, 36)];
        mViewBorderRadius(btn_refresh, 18, 1, [UIColor whiteColor]);
        [btn_refresh setTitle:@"刷新简历" forState:UIControlStateNormal];
        [btn_refresh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_refresh.backgroundColor = RGB(255, 163, 29);
        [btn_refresh addTarget:self action:@selector(refreshResume) forControlEvents:UIControlEventTouchUpInside];
        [_tableView_header addSubview:btn_refresh];
        
        label_updatedAt = [[UILabel alloc] initWithFrame:CGRectMake(0, 158, kMainScreenWidth, 13)];
        label_updatedAt.font = [UIFont systemFontOfSize:12];
        label_updatedAt.textColor = [UIColor whiteColor];
        label_updatedAt.textAlignment = NSTextAlignmentCenter;
        label_updatedAt.tag = 1;
        [_tableView_header addSubview:label_updatedAt];
        
    }
    

    return  _tableView_header;
}

#pragma mark-上传头像
-(void)uploadAvatar:(UIImage *)image{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
     NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/user/upload_profile"];
    [XZLNetWorkUtil uploadImageWithUrl:url Image:image params:paramDic
    success:^(id responseObject) {
        [loadView hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                NSString *imageURL = [dataDic valueForKey:@"path"];
                _model_PersonBasicInfo.avatar = imageURL;
                if(_model_PersonBasicInfo.avatar.length>0){
                    [imageAvatar setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"portrait_default"]];
                    [mUserDefaults setValue:_model_PersonBasicInfo.avatar forKey:@"portrait"];
                }
                return ;
            }
        }
        ghostView.message = @"上传失败";
        [ghostView show];
    } failure:^(NSError *error) {
        [loadView hide:YES];
        NSLog(@"%@",error);
        ghostView.message = @"上传失败";
        [ghostView show];
    }];
}

#pragma mark - 头像点击
-(void)headImgClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        [self takePhotos];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        [self callPhotos];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark 拍照
-(void)takePhotos
{
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
}

#pragma mark 相册
-(void)callPhotos
{
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    //上传头像
    [self uploadAvatar:image];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark-上传简历附件
-(void)uploadResume{
    GRUploadResumeWebViewController *vc = [GRUploadResumeWebViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 刷新简历（更新简历刷新时间）
-(void)refreshResume{
//
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model_PersonBasicInfo.tel forKey:@"mobile"];
    loadView =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    loadView.userInteractionEnabled = NO;
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/resumelib/refresh_resume"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                //                NSMutableArray *dataArray = responseObject[@"data"];
                NSString *date = responseObject[@"data"];
                date = [date substringToIndex:10];
                label_updatedAt.text = [NSString stringWithFormat:@"更新时间:%@",date];
                mGhostView(nil, @"刷新成功");
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            [loadView hide:YES];
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];

}

#pragma mark-获取简历信息
- (void)getResumeInfo{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
    loadView =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    loadView.userInteractionEnabled = NO;
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume"];
    __weak typeof(self) weakSelf = self;
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSLog(@"resumeCenter resumeInfo is %@",responseObject);
            [loadView hide:YES];

            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {

//                NSMutableArray *dataArray = responseObject[@"data"];
                NSDictionary *dataDic = responseObject[@"data"][@"resume"];
                _model_PersonBasicInfo = [[PersonBasicInfoModel alloc] initWithDictionary:dataDic];
                _model_JobOrentation = [[JobOrientationModel alloc] initWithDictionary:dataDic];
                _model_SelfIntro = [[SelfIntroModel alloc] initWithDictionary:dataDic];
                _model_Interets = [[InterestsHobbiesModel alloc] initWithDictionary:dataDic];
                NSMutableArray *array_workexp = [NSMutableArray new];
                for (NSDictionary *item in dataDic[@"work_experiences"]) {
                    WorkEXPModel *model = [[WorkEXPModel alloc] initWithDictionary:item];
                    [array_workexp addObject:model];
                }
                _array_WorkEXP = array_workexp;
                
                NSMutableArray *array_eduexp = [NSMutableArray new];
                for (NSDictionary *item in dataDic[@"edu_experiences"]) {
                    EduEXPModel *model = [[EduEXPModel alloc] initWithDictionary:item];
                    [array_eduexp addObject:model];
                }
                _array_EDUEXP = array_eduexp;
                
                NSMutableArray *array_project = [NSMutableArray new];
                for (NSDictionary *item in dataDic[@"project_experiences"]) {
                    ProjectEXPModel *model = [[ProjectEXPModel alloc] initWithDictionary:item];
                    [array_project addObject:model];
                }
                _array_ProjectEXP = array_project;
                
                NSMutableArray *array_train = [NSMutableArray new];
                for (NSDictionary *item in dataDic[@"train_experiences"]) {
                    TrainEXPModel *model = [[TrainEXPModel alloc] initWithDictionary:item];
                    [array_train addObject:model];
                }
                _array_TrainEXP = array_train;
                
                NSMutableArray *array_language = [NSMutableArray new];
                for (NSDictionary *item in dataDic[@"language_level"]) {
                    LanguageLevelModel *model = [[LanguageLevelModel alloc] initWithDictionary:item];
                    [array_language addObject:model];
                }
                _array_LanguageLevel = array_language;

                [weakSelf.tableView reloadData];

                if(_model_PersonBasicInfo.avatar.length>0){
                    [imageAvatar setImageWithURL:[NSURL URLWithString:_model_PersonBasicInfo.avatar] placeholderImage:[UIImage imageNamed:@"portrait_default"]];
                }
                label_updatedAt.text = [NSString stringWithFormat:@"更新时间:%@",_model_PersonBasicInfo.updated_at];
            }
        }else{
            NSLog(responseObject);
            NSLog(@"register_do %@",@"fail");
            [loadView hide:YES];
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];
    
}


#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 3){
        return _array_WorkEXP.count;
    }else if(section == 4){
        return _array_EDUEXP.count;
    }else if(section == 5){
        return _array_ProjectEXP.count;
    }else if(section == 6){
        return _array_TrainEXP.count;
    }else if (section == 7){
        return _array_LanguageLevel.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        static NSString *ID = @"basicInfoCell";
        PersonBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[PersonBasicInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.model = _model_PersonBasicInfo;
        return cell;
    }else if (indexPath.section == 1) {
        static NSString *ID = @"jobOrientationCell";
        JobOrientationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[JobOrientationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.model = _model_JobOrentation;
        return cell;
    }else if (indexPath.section == 2) {
        static NSString *ID = @"selfIntroCell";
        SelfIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SelfIntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.model = _model_SelfIntro;
        return cell;
    }else if (indexPath.section == 3) {
        static NSString *ID = @"workEXPCell";
        WorkEXPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[WorkEXPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        NSArray *array = _array_WorkEXP;
        if (array.count==1) {
            cell.type = 0;
        }else if (array.count == 2){
            if (indexPath.row==0) {
                cell.type = 1;
            }else{
                cell.type = 3;
            }
        }else if(array.count>2){
            if (indexPath.row == 0) {
                cell.type = 1;
            }else if (indexPath.row == array.count-1){
                cell.type = 3;
            }else{
                cell.type = 2;
            }
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        WorkEXPModel *tm = _array_WorkEXP[indexPath.row];
//        tm.date_end = @"至今";
        cell.model = tm;
        return cell;
    }else if (indexPath.section == 4) {
        static NSString *ID = @"eduEXPCell";
        EduEXPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[EduEXPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        NSArray *array = _array_EDUEXP;
        if (array.count==1) {
            cell.type = 0;
        }else if (array.count == 2){
            if (indexPath.row==0) {
                cell.type = 1;
            }else{
                cell.type = 3;
            }
        }else if(array.count>2){
            if (indexPath.row == 0) {
                cell.type = 1;
            }else if (indexPath.row == array.count-1){
                cell.type = 3;
            }else{
                cell.type = 2;
            }
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = _array_EDUEXP[indexPath.row];
        return cell;
    }else if (indexPath.section == 5) {
        static NSString *ID = @"projectEXPCell";
        ProjectEXPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[ProjectEXPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        NSArray *array = _array_ProjectEXP;
        if (array.count==1) {
            cell.type = 0;
        }else if (array.count == 2){
            if (indexPath.row==0) {
                cell.type = 1;
            }else{
                cell.type = 3;
            }
        }else if(array.count>2){
            if (indexPath.row == 0) {
                cell.type = 1;
            }else if (indexPath.row == array.count-1){
                cell.type = 3;
            }else{
                cell.type = 2;
            }
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = _array_ProjectEXP[indexPath.row];
        return cell;
    }else if (indexPath.section == 6) {
        static NSString *ID = @"trainEXPCell";
        TrainEXPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[TrainEXPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        NSArray *array = _array_TrainEXP;
        if (array.count==1) {
            cell.type = 0;
        }else if (array.count == 2){
            if (indexPath.row==0) {
                cell.type = 1;
            }else{
                cell.type = 3;
            }
        }else if(array.count>2){
            if (indexPath.row == 0) {
                cell.type = 1;
            }else if (indexPath.row == array.count-1){
                cell.type = 3;
            }else{
                cell.type = 2;
            }
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = _array_TrainEXP[indexPath.row];
        return cell;
    }else if (indexPath.section == 7) {
        static NSString *ID = @"LanguageLevelCell";
        LanguageLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[LanguageLevelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        NSArray *array = _array_LanguageLevel;
        if (array.count==1) {
            cell.type = 0;
        }else if (array.count >= 2){
            if (indexPath.row==array.count-1) {
                cell.type = 2;
            }else if(indexPath.row == 0 ){
                cell.type = 1;
            }else{
                cell.type = 1;
            }
        }
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = _array_LanguageLevel[indexPath.row];
        return cell;
    }else if (indexPath.section == 8) {
        static NSString *ID = @"INHOCell";
        InterestsHobbiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[InterestsHobbiesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.model = _model_Interets;
        return cell;
    }

    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    if (indexPath.section == 0) {
        return [_tableView cellHeightForIndexPath:indexPath model:_model_PersonBasicInfo keyPath:@"model" cellClass:[PersonBasicInfoTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 1){
        return [_tableView cellHeightForIndexPath:indexPath model:_model_JobOrentation keyPath:@"model" cellClass:[JobOrientationTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 2){
        return [_tableView cellHeightForIndexPath:indexPath model:_model_SelfIntro keyPath:@"model" cellClass:[SelfIntroTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 3){
        return [_tableView cellHeightForIndexPath:indexPath model:_array_WorkEXP[indexPath.row] keyPath:@"model" cellClass:[WorkEXPTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 4){
        return [_tableView cellHeightForIndexPath:indexPath model:_array_EDUEXP[indexPath.row] keyPath:@"model" cellClass:[EduEXPTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 5){
        return [_tableView cellHeightForIndexPath:indexPath model:_array_ProjectEXP[indexPath.row] keyPath:@"model" cellClass:[ProjectEXPTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 6){
        return [_tableView cellHeightForIndexPath:indexPath model:_array_TrainEXP[indexPath.row] keyPath:@"model" cellClass:[TrainEXPTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 7){
        return [_tableView cellHeightForIndexPath:indexPath model:_array_LanguageLevel[indexPath.row] keyPath:@"model" cellClass:[LanguageLevelTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (indexPath.section == 8){
        return [_tableView cellHeightForIndexPath:indexPath model:_model_Interets keyPath:@"model" cellClass:[InterestsHobbiesTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    viewH.backgroundColor = [UIColor whiteColor];
    
    UIView *viewtag = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 4, 20)];
    viewtag.backgroundColor = RGB(255, 163, 29);
    [viewH addSubview:viewtag];
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(19, 18, 100, 16)];
    label_title.font = [UIFont systemFontOfSize:16];
    label_title.textColor =RGB(0, 0, 0);
    [viewH addSubview:label_title];
    
    UIButton *btn_edit = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-21-15, 10, 24, 26)];
    [btn_edit addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    btn_edit.backgroundColor = [UIColor blueColor];
    btn_edit.tag = section;
    [btn_edit setImage:[UIImage imageNamed:@"resume_edit_btn"] forState:UIControlStateNormal];
    
    if (section==0) {
        [label_title setFrame:CGRectMake(18.5, 19, 100, 18)];
        label_title.font = [UIFont systemFontOfSize:18];
        label_title.text = _model_PersonBasicInfo.name;
        
        viewtag.hidden = YES;
        [viewH addSubview:btn_edit];
        
    }else if (section == 1){
        label_title.text = @"职业意向";
        [viewH addSubview:btn_edit];
    }else if (section == 2){
        label_title.text = @"自我评价";
        [viewH addSubview:btn_edit];
    }else if (section == 3){
        label_title.text = @"工作经验";
    }else if (section == 4){
        label_title.text = @"教育经历";
    }else if (section == 5){
        label_title.text = @"项目经验";
    }else if (section == 6){
        label_title.text = @"培训经历";
    }else if (section == 7){
        label_title.text = @"语言能力";
    }else if (section == 8){
        label_title.text = @"兴趣爱好";
        [viewH addSubview:btn_edit];
    }
    return viewH;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0||section==1||section==2||section==8) {
        return 10;
    }
    return 28+10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 28)];
//    viewH.userInteractionEnabled = YES;
    viewH.tag = section;
    viewH.backgroundColor = [UIColor whiteColor];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFooter:)];
//    [viewH addGestureRecognizer:tap];
    
    UIButton *label_title = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 16)];
    [label_title.titleLabel setFont:[UIFont systemFontOfSize:16]] ;
    [label_title setTitleColor:RGB(255, 146, 4) forState:UIControlStateNormal];
    [label_title setTitleColor:RGB(216, 216, 216) forState:UIControlStateHighlighted];
    label_title.tag = section;
    [label_title addTarget:self action:@selector(clickFooter:) forControlEvents:UIControlEventTouchUpInside];
    [viewH addSubview:label_title];
    
    UIView *view_space = [[UIView alloc] initWithFrame:CGRectMake(0, 28, kMainScreenWidth, 10)];
    view_space.backgroundColor = RGB(242, 242, 242);
    [viewH addSubview:view_space];
    
    if (section==0||section == 1||section == 2||section == 8) {
        [view_space setFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
        return view_space;
    }else if (section == 3){
//        label_title.titleLabel.text = @"+添加工作经验";
        [label_title setTitle:@"+添加工作经验" forState:UIControlStateNormal];
    }else if (section == 4){
//        label_title.titleLabel.text = @"+添加教育经历";
        [label_title setTitle:@"+添加教育经历" forState:UIControlStateNormal];
    }else if (section == 5){
//        label_title.titleLabel.text = @"+添加项目经验";
        [label_title setTitle:@"+添加项目经验" forState:UIControlStateNormal];
    }else if (section == 6){
//        label_title.titleLabel.text = @"+添加培训经历";
        [label_title setTitle:@"+添加培训经历" forState:UIControlStateNormal];
    }else if (section == 7){
        label_title.titleLabel.text = @"+添加语言能力";
        [label_title setTitle:@"+添加语言能力" forState:UIControlStateNormal];
        
    }
    return viewH;
    
}

- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}



//-(void)tapFooter:(UITapGestureRecognizer *)recognizer{
//    int tag = recognizer.view.tag;
//    switch (tag) {
//        case 3:
//            [self editWorkEXPItem:nil IndexPath:nil];
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark-点击Cell的编辑按钮触发代理方法
#pragma mark-编辑工作经验
- (void)editWorkEXPItem:(WorkEXPModel *)model IndexPath:(NSIndexPath *)indexPath{
    GRResumeJobEXPEditViewController *vc = [[GRResumeJobEXPEditViewController alloc] init];
    vc.indexPath_current = indexPath;
    vc.model = [model copy];
    vc.resume_id = _model_PersonBasicInfo.resumeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-编辑教育经历
- (void)editEduEXPItem:(EduEXPModel *)model IndexPath:(NSIndexPath *)indexPath{
    GRResumeEduEXPEditViewController *vc = [[GRResumeEduEXPEditViewController alloc] init];
    vc.indexPath_current = indexPath;
    vc.model = [model copy];
    vc.resume_id = _model_PersonBasicInfo.resumeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-编辑项目经验
- (void)editProjectEXPItem:(ProjectEXPModel *)model IndexPath:(NSIndexPath *)indexPath{
    GRResumeProjectEXPEditViewController *vc = [[GRResumeProjectEXPEditViewController alloc] init];
    vc.indexPath_current = indexPath;
    vc.model = [model copy];
    vc.resume_id = _model_PersonBasicInfo.resumeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-编辑培训经历
- (void)editTrainEXPItem:(TrainEXPModel *)model IndexPath:(NSIndexPath *)indexPath{
    GRResumeTrainEXPEditViewController *vc = [[GRResumeTrainEXPEditViewController alloc] init];
    vc.indexPath_current = indexPath;
    vc.model = [model copy];
    vc.resume_id = _model_PersonBasicInfo.resumeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-编辑语言等级
- (void)editLanguageLevelItem:(LanguageLevelModel *)model IndexPath:(NSIndexPath *)indexPath{
    GRResumeLanguageLevelEditViewController *vc = [[GRResumeLanguageLevelEditViewController alloc] init];
    vc.indexPath_current = indexPath;
    vc.model = [model copy];
    vc.resume_id = _model_PersonBasicInfo.resumeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-点击Header的编辑按钮触发代理方法
-(void)editBtnClicked:(UIButton *)sender{
    if (sender.tag == 0) {
        GRResumeBasicInfoViewController *vc = [[GRResumeBasicInfoViewController alloc] init];
        vc.model = [_model_PersonBasicInfo copy];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1) {
        GRResumeJobOrientationEditViewController *vc = [[GRResumeJobOrientationEditViewController alloc] init];
        vc.model = [_model_JobOrentation copy];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 2) {
        GRResumeSelfIntroEditViewController *vc = [[GRResumeSelfIntroEditViewController alloc] init];
        vc.model = [_model_SelfIntro copy];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 8) {
        GRResumeInterestEditViewController *vc = [[GRResumeInterestEditViewController alloc] init];
        vc.model = [_model_Interets copy];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark-点击Footer(例如添加工作经验)的编辑按钮触发方法
-(void)clickFooter:(UIButton *)btn{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 3:{
            [self editWorkEXPItem:nil IndexPath:nil];
        }
            break;
        case 4:{
            [self editEduEXPItem:nil IndexPath:nil];
        }
            break;
        case 5:{
            [self editProjectEXPItem:nil IndexPath:nil];
        }
            break;
            
        case 6:{
            [self editTrainEXPItem:nil IndexPath:nil];
        }
            break;
        case 7:{
            [self editLanguageLevelItem:nil IndexPath:nil];
        }
            break;

            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
