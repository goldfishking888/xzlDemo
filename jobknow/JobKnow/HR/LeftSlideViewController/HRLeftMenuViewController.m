//
//  HRLeftMenuViewController.m
//  JobKnow
//
//  Created by admin on 15/7/31.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRLeftMenuViewController.h"
#import "SDDataCache.h"
#import "AppDelegate.h"
#import "HR_HomeViewController.h"
#import "Config.h"
#import "MyHrFamilyViewController.h"
#import "OLGhostAlertView.h"
#import "UIImageView+WebCache.h"
#import "HrCircleViewController.h"
#import "HR_CompanyVipViewController.h"
#import "SDImageCache.h"
#import "HR_MyCardViewController.h"
#import "PCResumeTutorViewController.h"
#import "HR_ScanToLoginVC.h"

#define TableViewWidth 300 //tableView的宽度
#define HeaderViewHeight 125 //头部的高度
#define HeadImageWidth 60 //头像的宽度（高度）
#define MenuCellImgWidth 30 //cell中图标的宽度
#define MenuCellHeight 44 //cell的高度

#pragma mark - HRLeftMenuTableCell

@implementation HRLeftMenuTableCell
-(id)initWithImage:(UIImage *)img title:(NSString *)title{
    self = [super initWithFrame:CGRectMake(0, 0, TableViewWidth, MenuCellHeight)];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(23,(MenuCellHeight-MenuCellImgWidth)/2, MenuCellImgWidth, MenuCellImgWidth)];
        [imgView setImage:img];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:imgView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, (MenuCellHeight-MenuCellImgWidth)/2, 180, MenuCellImgWidth)];
        [titleLabel setText:title];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:17]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
    }
    return self;
}
@end


#pragma mark - HRLeftMenuViewController
@interface HRLeftMenuViewController (){
    OLGhostAlertView *ghostView;
    UIImageView *_headImageView;//头像
    UIImage *_imageSuccess;//头像
}

@end

@implementation HRLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    CGSize selfSize = self.view.bounds.size;
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selfSize.width, selfSize.height)];
    [backImageView setImage:[UIImage imageNamed:@"menuwallpaper"]];
    CALayer *maskLayer=[CALayer layer];
    [maskLayer setFrame:CGRectMake(0, 0, selfSize.width, selfSize.height)];
    [maskLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor];
    [backImageView.layer setMask:maskLayer];
    [self.view addSubview:backImageView];
    [self.view sendSubviewToBack:backImageView];
    
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TableViewWidth, kMainScreenFrame.size.height)];
    _menuTableView.dataSource = self;
    _menuTableView.delegate = self;
    [_menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_menuTableView setScrollEnabled:NO];
    [self.view addSubview:_menuTableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"left刷新");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 去下载企业版
-(void)downloadEnterpriseApp{

    NSURL *url = [NSURL URLWithString:@"XZLQYB:"];
    NSString *is_exist = nil;
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        is_exist = @"1";
    }else{
        is_exist = @"0";
    }
    PCResumeTutorViewController *vc = [[PCResumeTutorViewController alloc] init];
    vc.webTitle = @"小职了企业版";
    vc.urlString = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@&is_exist=%@",KXZhiLiaoAPI,BootDownloadCompany,kUserTokenStr,IMEI,is_exist];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
    }

}

#pragma mark - 切换为个人版
- (void)switchButtonClick:(id)sender
{
    NSLog(@"switchButtonClick");
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"GeRen" forKey:@"LoginType"];
    [ud synchronize];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = nil;
    [app setRootVC];
}

#pragma mark - 头像点击
-(void)headImgClick
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"本地上传", nil];
    [sheet showInView:self.view];
}
#pragma mark  UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self takePhotos];
        
    }else if (buttonIndex == 1){
        
        [self callPhotos];
    }
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
    _imageSuccess = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    //上传头像
    [self uploadHeadImage:_imageSuccess name:[NSString stringWithFormat:@"%@.png",str]];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 上传头像
- (void)uploadHeadImage:(UIImage *)image name:(NSString *)name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken", nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"hr_api/hr_operation/uploadFace?"];
    [net send_HRIcon_ToServerWithImage:image imageName:name param:params withURLStr:urlStr];
}

#pragma mark 上传头像回调结果
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"上传头像_______%@",requestDic);
    NSNumber *status = [requestDic valueForKey:@"status"];
    if ([status boolValue] == YES) {
        if (_imageSuccess) {
            [_headImageView setImage:_imageSuccess];
            NSString *fileName = [NSString stringWithFormat:@"%@",[requestDic valueForKey:@"fileName"]];
            [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:@"headUrl"];
            [[SDImageCache sharedImageCache] storeImage:_imageSuccess forKey:fileName toDisk:YES];
            [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HeaderImageRefresh object:nil];
        [_menuTableView reloadData];
        ghostView.message = @"上传成功";
        [ghostView show];
    }
}
- (void)receiveDataFail:(NSError *)error
{
    ghostView.message = @"上传失败";
    [ghostView show];
}
- (void)requestTimeOut
{
    ghostView.message = @"连接超时";
    [ghostView show];
}
#pragma mark - 设置信息
-(void)setHeadImageToIV:(UIImageView *)headImageView nameToLabel:(UILabel *)nameLabel  phoneToLabel:(UILabel *)phoneLabel isHrToIV:(UIImageView *)isHrImageView isPayVipToIV:(UIImageView *)isPayVipImageView{
    NSString *headUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"headUrl"];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"personal_center_head_default"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        NSLog(@"头像SDImageCacheType = %ld,imageURL = %@",(long)cacheType,imageURL);
    }];
    [headImageView.layer setCornerRadius:HeadImageWidth/2];
    [headImageView.layer setMasksToBounds:YES];
    
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    NSString *name = [AppUD objectForKey:@"realName"];
    NSString *phone = [AppUD objectForKey:@"occupation"];
    [phoneLabel setText:((phone.length>0)?phone:@"")];
    NSString *tradeName = [AppUD objectForKey:@"tradeName"];
    [industryLabel setText:((tradeName.length>0)?tradeName:@"")];
    NSString *hrState = [NSString stringWithFormat:@"%@",[AppUD objectForKey:@"hrState"]];
    if ([hrState isEqualToString:@"2"]) {
        [nameLabel setText:name];
        [isHrImageView setImage:[UIImage imageNamed:@"hr_authed"]];
    }
//    else if([hrState isEqualToString:@"4"]){
//        [nameLabel setText:@"身份认证中"];
//        [isHrImageView setImage:[UIImage imageNamed:@"hr_noauth"]];
//    }else{
//        [nameLabel setText:@"点击此处认证"];
//        [isHrImageView setImage:[UIImage imageNamed:@"hr_noauth"]];
//    }
    if(nameLabel.text.length > 6){
        //超过长度之后，则设置为默认大小
        [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y,96, 16)];
    }else{
//        if (nameLabel.text.length == 2) {
//            name = [NSString stringWithFormat:@"%@ %@",[name substringToIndex:1],[name substringFromIndex:1]];
//            nameLabel.text = name;
//        }
        [nameLabel sizeToFit];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMyCard)];
    [nameLabel addGestureRecognizer:tapGesture];
    
    isHrImageView.frame = CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+2, isHrImageView.frame.origin.y,isHrImageView.frame.size.width,isHrImageView.frame.size.height);
    
    isPayVipImageView.frame = CGRectMake(isHrImageView.frame.origin.x+isHrImageView.frame.size.width+2, isPayVipImageView.frame.origin.y, isPayVipImageView.frame.size.width, isPayVipImageView.frame.size.height);
    
    tapView_vip.frame = CGRectMake(isPayVipImageView.frame.origin.x, isPayVipImageView.frame.origin.y, isPayVipImageView.frame.size.width, isPayVipImageView.frame.size.height+10);
//     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyImageTap)];
//    [tapView_vip addGestureRecognizer:tap];
    
    NSString *isPayVip = [NSString stringWithFormat:@"%@",[AppUD objectForKey:@"isRegisterCompany"]];
    if ([isPayVip isEqualToString:@"1"]) {
        [isPayVipImageView setImage:[UIImage imageNamed:@"hr_company_y"]];
        isPayVipImageView.userInteractionEnabled = NO;
        tapView_vip.hidden = YES;
    }else{
        [isPayVipImageView setImage:[UIImage imageNamed:@"hr_company_n"]];
        isPayVipImageView.userInteractionEnabled = YES;
        tapView_vip.hidden = NO;
    }
}

#pragma mark - 点击进入我的名片

-(void)gotoMyCard{
    
    HR_MyCardViewController * vc = [[HR_MyCardViewController alloc]init];
    AppDelegate * del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([del.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        [((UINavigationController *)del.window.rootViewController) pushViewController:vc animated:YES];
    }
    //跳转的同时关闭左视图
    [self performSelector:@selector(closeLeftSide) withObject:nil afterDelay:0.3];
}

#pragma mark - 发出关闭左视图通知
-(void)closeLeftSide{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseLeftSide" object:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //企业版app
        [self downloadEnterpriseApp];
        
    }
//    else if (indexPath.row == 1) {
//        
//        //人才经纪人家族
//        MyHrFamilyViewController *vc = [[MyHrFamilyViewController alloc] init];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//            
//            [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
//        }
//        
//    }
    else if(indexPath.row == 1){
        
        //HR圈
        HrCircleViewController *vc = [[HrCircleViewController alloc] init];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            
            [((UINavigationController *)app.window.rootViewController) pushViewController:vc animated:YES];
        }
        
    }else if(indexPath.row == 2){
        
        //简历列表
        HR_ResumeList *hr_resume = [[HR_ResumeList alloc] init];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)app.window.rootViewController) pushViewController:hr_resume animated:YES];
        }

    }else if(indexPath.row == 3){
        //职位收藏
        HR_JobCollectionViewController *collect = [[HR_JobCollectionViewController alloc] init];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)app.window.rootViewController) pushViewController:collect animated:YES];
        }
    } else if(indexPath.row == 4){
        //扫一扫
        HR_ScanToLoginVC *hr_scan = [[HR_ScanToLoginVC alloc] init];
        hr_scan.title_str = @"扫一扫";
        /*在浏览器中输入www.xzhiliao.com
         点击【登录】按钮
         扫描二维码登录小职了电脑版*/
        hr_scan.content_str = @"在浏览器中输入www.xzhiliao.com\n点击【登录】按钮\n扫描二维码登录小职了电脑版";
        hr_scan.usertype = @"3";
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)app.window.rootViewController) pushViewController:hr_scan animated:YES];
        }
    }else if(indexPath.row == 5){
        //设置
        HR_SettingViewController *hr_set = [[HR_SettingViewController alloc] init];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)app.window.rootViewController) pushViewController:hr_set animated:YES];
        }
    }
    //跳转的同时关闭左视图
    [self performSelector:@selector(closeLeftSide) withObject:nil afterDelay:0.3];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HRLeftMenuTableCell *cell = nil;
    if (indexPath.row == 0) {
        
        cell = [[HRLeftMenuTableCell alloc] initWithFrame:CGRectMake(0, 0, TableViewWidth, 55)];
        [cell setBackgroundColor:[UIColor clearColor]];
        UIImage *img= [UIImage imageNamed:@"hr_left_companyapp_normal"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(23+2,11+2, MenuCellImgWidth-4, MenuCellImgWidth-4)];
        [imgView setImage:img];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [cell addSubview:imgView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 180, MenuCellImgWidth)];
        [titleLabel setText:@"企业版APP"];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:17]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:titleLabel];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 54, 200, 1)];
        [lineLabel setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:lineLabel];
        
    }
//    else if (indexPath.row == 1) {
//        
//        cell = [[HRLeftMenuTableCell alloc] initWithFrame:CGRectMake(0, 0, TableViewWidth, 55)];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        UIImage *img= [UIImage imageNamed:@"hr_left_family_normal"];
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(23,11, MenuCellImgWidth, MenuCellImgWidth)];
//        [imgView setImage:img];
//        [imgView setContentMode:UIViewContentModeScaleToFill];
//        [cell addSubview:imgView];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 180, MenuCellImgWidth)];
//        [titleLabel setText:@"人才经纪人家族"];
//        [titleLabel setTextColor:[UIColor whiteColor]];
//        [titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [titleLabel setTextAlignment:NSTextAlignmentLeft];
//        [cell addSubview:titleLabel];
//        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 54, 200, 1)];
//        [lineLabel setBackgroundColor:[UIColor whiteColor]];
//        [cell addSubview:lineLabel];
//        
//    }
    else if(indexPath.row == 1){
        
        UIImage *img= [UIImage imageNamed:@"hr_left_trend_normal"];
        cell = [[HRLeftMenuTableCell alloc] initWithImage:img title:@"HR圈"];
        
    }else if(indexPath.row == 2){
        
        UIImage *img= [UIImage imageNamed:@"hr_left_resume_normal"];
        cell = [[HRLeftMenuTableCell alloc] initWithImage:img title:@"简历库"];
        
    } else if(indexPath.row == 3){
        
        UIImage *img= [UIImage imageNamed:@"hr_left_fav_normal"];
        cell = [[HRLeftMenuTableCell alloc] initWithImage:img title:@"职位收藏"];
        
    } else if(indexPath.row == 4){
        
        UIImage *img= [UIImage imageNamed:@"hr_left_saoyisao_normal"];
        cell = [[HRLeftMenuTableCell alloc] initWithImage:img title:@"扫一扫"];
        
    }else if(indexPath.row == 5){
        
        UIImage *img= [UIImage imageNamed:@"hr_left_set_normal"];
        cell = [[HRLeftMenuTableCell alloc] initWithImage:img title:@"设置"];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 55;
    }else {
        return MenuCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return (iPhone_5Screen?HeaderViewHeight:(HeaderViewHeight-20));
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menuTableView.frame.size.width, (iPhone_5Screen?HeaderViewHeight:(HeaderViewHeight-20)))];
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (iPhone_5Screen?50:30), HeadImageWidth, HeadImageWidth)];
    UITapGestureRecognizer *headGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgClick)];
    [_headImageView addGestureRecognizer:headGesture];
    [_headImageView setUserInteractionEnabled:YES];
    [headerView addSubview:_headImageView];

    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width+2, _headImageView.frame.origin.y+10, 96, 16)];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    nameLabel.userInteractionEnabled = YES;
//    [nameLabel addGestureRecognizer:tapGesture];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:nameLabel];
    
    //HR图标
    UIImageView *isHrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width, _headImageView.frame.origin.y+10, 35, 16)];
    [headerView addSubview:isHrImageView];
    
    //认证图标
    payVipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(isHrImageView.frame.origin.x+isHrImageView.frame.size.width+2, _headImageView.frame.origin.y+10, 35, 16)];
    payVipImageView.userInteractionEnabled = YES;
    [headerView addSubview:payVipImageView];
    
    tapView_vip = [[UIView alloc] initWithFrame:CGRectMake(payVipImageView.frame.origin.x, payVipImageView.frame.origin.y, payVipImageView.frame.size.width, payVipImageView.frame.size.height+10)];
    [tapView_vip setBackgroundColor:[UIColor clearColor]];
//    [tapView_vip addGestureRecognizer:tap];
    [headerView addSubview:tapView_vip];

    
    //职位
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width+2, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 150, 14)];
    [phoneLabel setFont:[UIFont systemFontOfSize:14]];
    phoneLabel.userInteractionEnabled = YES;
    [phoneLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:phoneLabel];
    
    //行业
    industryLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x+_headImageView.frame.size.width+2, phoneLabel.frame.origin.y+phoneLabel.frame.size.height+5, TableViewWidth-phoneLabel.frame.origin.x, 14)];
    [industryLabel setFont:[UIFont systemFontOfSize:14]];
    industryLabel.userInteractionEnabled = YES;
    [industryLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:industryLabel];
    
    [self setHeadImageToIV:_headImageView nameToLabel:nameLabel phoneToLabel:phoneLabel isHrToIV:isHrImageView isPayVipToIV:payVipImageView];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height-1, TableViewWidth, 1)];
    [lineLabel setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:lineLabel];
    
    return headerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TableViewWidth, 55)];
    UIView *switchButton = [[UIView alloc] initWithFrame:CGRectMake(20, 10, footView.frame.size.width-50, 40)];
    switchButton.layer.borderWidth = 1;
    switchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    switchButton.layer.cornerRadius = 8;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    [imgView setContentMode:UIViewContentModeScaleToFill];
    [imgView setImage:[UIImage imageNamed:@"hr_left_ccion_normal"]];
    [switchButton addSubview:imgView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, footView.frame.size.width-50-45-10, 30)];
    [titleLabel setText:@"切换为小职了个人版"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [switchButton addSubview:titleLabel];
    [footView addSubview:switchButton];
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TableViewWidth, 55)];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchButtonClick:)];
    [maskView addGestureRecognizer:gesture];
    [footView addSubview:maskView];
    [footView bringSubviewToFront:maskView];
    return footView;

}


@end
