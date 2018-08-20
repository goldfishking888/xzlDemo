//
//  GRPersonalViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/8.
//  Copyright © 2017年 lxw. All rights reserved.
// 个人中心

#import "GRPersonalViewController.h"
#import "GRResumeCenterViewController.h"
#import "GRSettingViewController.h"//gerenshezhi新
#import "XZLCommonWebViewController.h"
#import "GRCollectPositionVC.h"//收藏的职位
#import "GRMyIntroViewController.h"//我的自荐
#import "GRUploadResumeWebViewController.h"//上传简历
#import "GRScanQRCodeVC.h"//扫描二维码
#import "HRPersonalCenterVC.h"//HR个人中心
#import "AppDelegate.h"
#import "GRUploadResumeWebViewController.h"

@interface GRPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    UITableView * _tableView;
    UIButton * nameBtn;
    UILabel * nameLab;
    UILabel * jobLab;
    UIImageView *imageview_avatar;
    int appearTime;
}
@end

@implementation GRPersonalViewController

-(void)viewWillAppear:(BOOL)animated
{
    appearTime++;
    if (appearTime > 1) {
        [self reloadHeader];
    }
}
-(void)reloadHeader
{
    NSString * iconUrl = [mUserDefaults valueForKey:@"portrait"];
    [imageview_avatar setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"portrait_default"]];
    nameLab.text = [mUserDefaults valueForKey:@"name"];
    NSString *jobStr = [mUserDefaults valueForKey:@"expect_job"];
    if (jobStr.length==0) {
        jobLab.hidden = YES;
    }else{
        jobLab.hidden = NO;
        jobLab.text = jobStr;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appearTime = 0;
    [self addTitleLabelGR:@"我的"];
    [self initTableView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeader) name:@"LoginSucceed" object:nil];
    // Do any additional setup after loading the view.
}

-(void)initTableView
{
    //高度减去tabbar高度50
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, iPhone_width, iPhone_height-50) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(245, 245, 245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView * headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 290)];
    headBgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 220)];
    headImgV.image = [UIImage imageNamed:@"GR_personal_mineBg"];
    [headBgView addSubview:headImgV];
    
    imageview_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(iPhone_width / 2 - 35, 55, 70, 70)];
    imageview_avatar.backgroundColor = RGB(255, 214, 154);
    mViewBorderRadius(imageview_avatar, imageview_avatar.width/2, 1, [UIColor clearColor]);
    NSString *image_url = @"";
    if ([mUserDefaults valueForKey:@"portrait"]) {
        image_url = [mUserDefaults valueForKey:@"portrait"];
    }
    [imageview_avatar setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"portrait_default"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconBtnClick)];
    [imageview_avatar addGestureRecognizer:tap];
    imageview_avatar.userInteractionEnabled = YES;
    [headBgView addSubview:imageview_avatar];
    
    nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBtn.frame = CGRectMake(iPhone_width / 2 - 100, imageview_avatar.frame.origin.y + imageview_avatar.frame.size.height + 17, 200, 40);
//    nameBtn.backgroundColor = [UIColor greenColor];
    [nameBtn addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headBgView addSubview:nameBtn];
//
    nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nameBtn.frame.size.width, 19)];
    nameLab.text = @"登录/注册";
    nameLab.textColor = RGBA(255, 255, 255, 1);
    nameLab.font = [UIFont systemFontOfSize:18];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [nameBtn addSubview:nameLab];
    
    jobLab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLab.frame.origin.y + nameLab.frame.size.height + 5, nameBtn.frame.size.width, 15)];
    jobLab.text = @"";
    jobLab.textColor = RGBA(255, 255, 255, 1);
    jobLab.font = [UIFont systemFontOfSize:14];
    jobLab.textAlignment = NSTextAlignmentCenter;
    [nameBtn addSubview:jobLab];
    
    UIView * clickV = [[UIView alloc]initWithFrame:CGRectMake(0, 220, iPhone_width, 50)];
    clickV.backgroundColor = [UIColor clearColor];
    [headBgView addSubview:clickV];
    //上传简历
    UIButton * upLoadResumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upLoadResumeBtn.frame = CGRectMake(0, 0, iPhone_width / 2, clickV.frame.size.height);
    [upLoadResumeBtn addTarget:self action:@selector(uploadResumeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    upLoadResumeBtn.tag = 1001;
    [clickV addSubview:upLoadResumeBtn];
    
    UIImageView * upImgV = [[UIImageView alloc]initWithFrame:CGRectMake(upLoadResumeBtn.frame.size.width / 2 - 40, 15, 18, 18)];
    upImgV.image = [UIImage imageNamed:@"GRPersonal_uploadResume"];
    [upLoadResumeBtn addSubview:upImgV];
    
    UILabel * upLab = [[UILabel alloc]initWithFrame:CGRectMake(upImgV.frame.origin.x + upImgV.frame.size.width + 8, upImgV.frame.origin.y, 100, 17)];
    upLab.text = @"上传简历";
    upLab.textColor = RGBA(74, 74, 74, 1);
    upLab.textAlignment = NSTextAlignmentLeft;
    upLab.font = [UIFont systemFontOfSize:15];
    upLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapResume = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadResume)];
    [upLab addGestureRecognizer:tapResume];
    [upLoadResumeBtn addSubview:upLab];
    
    //我的自荐
    UIButton * mySelfIntroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mySelfIntroBtn.frame = CGRectMake(iPhone_width / 2, 0, iPhone_width / 2, clickV.frame.size.height);
    [mySelfIntroBtn addTarget:self action:@selector(uploadResumeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    mySelfIntroBtn.tag = 1002;
    [clickV addSubview:mySelfIntroBtn];
    
    UIImageView * myIntroImgV = [[UIImageView alloc]initWithFrame:CGRectMake(mySelfIntroBtn.frame.size.width / 2 - 40, 15, 18, 18)];
    myIntroImgV.image = [UIImage imageNamed:@"GRPersonal_MyIntro"];
    [mySelfIntroBtn addSubview:myIntroImgV];
    
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 0.5, 13, 1, 24)];
    lineV.backgroundColor = RGBA(216, 216, 216, 1);
    [clickV addSubview:lineV];
    
    UILabel * myIntroLab = [[UILabel alloc]initWithFrame:CGRectMake(myIntroImgV.frame.origin.x + myIntroImgV.frame.size.width + 8, myIntroImgV.frame.origin.y, 100, 17)];
    myIntroLab.text = @"我的自荐";
    myIntroLab.textColor = RGBA(74, 74, 74, 1);
    myIntroLab.textAlignment = NSTextAlignmentLeft;
    myIntroLab.font = [UIFont systemFontOfSize:15];
    [mySelfIntroBtn addSubview:myIntroLab];
    
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, clickV.frame.origin.y + clickV.frame.size.height, iPhone_width, 20)];
    grayView.backgroundColor = RGBA(245, 245, 245, 1);
    [headBgView addSubview:grayView];
    _tableView.tableHeaderView = headBgView;
    [self.view addSubview:_tableView];
    
    [self reloadHeader];

}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 20;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    view.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        return nil;
    }else if (section == 1){
        return view;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString * cellID = @"personCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else
    {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"GRPersonal_Mycollect"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"收藏职位";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(imageV.frame.origin.x, 54.5, iPhone_width - imageV.frame.origin.x, 0.5)];
        lineV.backgroundColor  =RGBA(245, 245, 245, 1);
        [cell addSubview:lineV];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"GRPersonal_seeting"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"设置";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(imageV.frame.origin.x, 54.5, iPhone_width - imageV.frame.origin.x, 0.5)];
        lineV.backgroundColor  =RGBA(245, 245, 245, 1);
        [cell addSubview:lineV];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"GRPersonal_BigData"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"职位大数据";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"GRPersonal_changeType"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"切换为猎头创客";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {//收藏职位
        GRCollectPositionVC * vc = [[GRCollectPositionVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1){//设置
        GRSettingViewController * vc = [[GRSettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2){//职位大数据
        XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
        vc.titleStr = @"职位大数据";
        NSString *url = kCombineURL(kTestAPPAPIGR, @"/web/account/from_source");
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?localcity=%@",[XZLUtil getCityCodeWithCityName:[XZLUserInfoTool getLocalCity]]]];
        vc.urlStr = url;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){//切换身份
        mGhostView(nil, @"切换为猎头创客");
        [XZLUserInfoTool setGRStatus:@"1"];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app SetRootVC:@"1"];

    }
}

#pragma mark - 点击上传简历
-(void)uploadResume{
    GRUploadResumeWebViewController *vc = [GRUploadResumeWebViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击头像上传头像
-(void)iconBtnClick{
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

#pragma mark-上传头像
-(void)uploadAvatar:(UIImage *)image{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:@"82e38dda7b5732791415852296b3c081" forKey:@"userToken"];
    [paramDic setValue:@"3.2.1" forKey:@"version"];
    [paramDic setValue:@"351554054729885" forKey:@"userImei"];
    [paramDic setValue:@"1" forKey:@"flag"];
    [paramDic setValue:@"2" forKey:@"pflag"];
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url = [NSString stringWithFormat:@"%@",@"http://timages.hrbanlv.com/pm2/upload"];
    [XZLNetWorkUtil uploadImageWithUrl:url Image:image params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSString *image_url_mini = responseObject[@"download_url"];
            [self updateAvatarWithUrl:image_url_mini withImage:image];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        ghostView.message = @"上传失败";
        [ghostView show];
    }];
}

#pragma mark-上传头像成功后更新头像url
-(void)updateAvatarWithUrl:(NSString *)avatar_string withImage:(UIImage *)image{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:avatar_string forKey:@"avatar"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/account/avatar/update"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            [loadView hide:YES];
            if (error_code.intValue == 0) {
                ghostView.message = @"更新成功";
                [ghostView show];
                [mUserDefaults setValue:avatar_string forKey:@"portrait"];
                imageview_avatar.image = image;
            }
        }
        [loadView hide:YES];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [loadView hide:YES];
        ghostView.message = @"更新失败";
        [ghostView show];
        
    }];

}


#pragma mark - 点击名称跳到简历页
-(void)nameBtnClick:(UIButton *)sender
{
    if ([XZLUserInfoTool isResumeUploaded]) {//上传了简历就跳转
        GRResumeCenterViewController * vc = [[GRResumeCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)uploadResumeBtnClick:(UIButton *)button
{
    if (button.tag == 1001) {
        NSLog(@"点击了上传简历web");
        GRUploadResumeWebViewController * vc = [[GRUploadResumeWebViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (button.tag == 1002){
        NSLog(@"点击了我的自荐");
        GRMyIntroViewController * vc = [[GRMyIntroViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
