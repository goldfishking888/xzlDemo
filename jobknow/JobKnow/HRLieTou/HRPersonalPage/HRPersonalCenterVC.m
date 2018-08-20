//
//  HRPersonalCenterVC.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRPersonalCenterVC.h"
#import "AppDelegate.h"
#import "HRSettingViewController.h"
#import "HRModifyHRInfoViewController.h"//修改HR的信息
#import "XZLCommonWebViewController.h"
#import "XZLPMListViewController.h"
#import "XZLPMListModel.h"

@interface HRPersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    UILabel * nameLab;
    UILabel * companyLab;
    UIImageView *imageview_avatar;
    MBProgressHUD *loadView;
    int appearTime;
    UILabel *label_MessageCount;
}
@end

@implementation HRPersonalCenterVC


-(void)refreshHeadInfo
{
    NSString * nameStr = [mUserDefaults valueForKey:@"name"];
    nameLab.text = nameStr.length == 0 ? @"暂无信息": nameStr;
    NSString *companyStr = _model_PersonBasicInfo.company;
    if ([companyStr isNullOrEmpty]) {
       companyStr = @"";
    }
    companyLab.text = companyStr;
    //[[mUserDefaults valueForKey:@"company"] length] == 0 ? @"不详":[mUserDefaults valueForKey:@"company"];
}

-(void)viewWillAppear:(BOOL)animated
{
//    appearTime++;
//    if (appearTime > 1) {
        [self requestHRInfo];
        [self refreshHeadInfo];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    appearTime = 0;
    [self addBackBtnGR];
    [self addTitleLabelGR:@"我的"];
    [self initTableView];
    [self requestHRInfo];
    [self refreshHeadInfo];
    [self requestDataWithToward];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kReceiveRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kHasMessageUnread object:nil];
}

#pragma mark - 收到推送消息

- (void)receiveRemoteNotification:(NSNotification *)noti{
    NSNumber *count = noti.object;
    if(count){
        if (count.intValue==999) {
            label_MessageCount.hidden = YES;
        }else{
            label_MessageCount.hidden = NO;
        }
        
    }
    
}

-(void)initTableView
{
    //高度减去tabbar高度50
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  0, iPhone_width, iPhone_height - 50) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBA(245, 245, 245, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

#pragma mark - 获取猎头用户信息
-(void)requestHRInfo
{
    //http://appapi.xzhiliao.com/api/account/hunter
    NSString * tokenStr = [XZLUserInfoTool getToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:tokenStr,@"token", nil];
    NSString * url = kCombineURL(kTestAPPAPIGR, @"/api/account/hunter");
    [XZLNetWorkUtil requestPostURLWithoutAddingParams:url params:params success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSLog(@"data是%@",responseObject[@"data"]);
            if (error.integerValue==0) {
                //发送成功 有用户信息
                NSDictionary *dataDic = responseObject[@"data"];
                _model_PersonBasicInfo = [[HRBasicInfoModel alloc] initWithDictionary:dataDic];
                _model_PersonBasicInfo.name = [mUserDefaults valueForKey:@"name"];
                _model_PersonBasicInfo.email = [mUserDefaults valueForKey:@"email"];
                _model_PersonBasicInfo.cityCode = [mUserDefaults valueForKey:@"city"];
                _model_PersonBasicInfo.qq = [mUserDefaults valueForKey:@"qq"];
                _model_PersonBasicInfo.city = [XZLUtil getCityNameWithCityCode:_model_PersonBasicInfo.cityCode];
            }else if(error.intValue == 1){
                //无用户信息
                _model_PersonBasicInfo = [[HRBasicInfoModel alloc] initWithDictionary:nil];
            }
            [self refreshHeadInfo];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 根据DB时间戳，获取服务器的列表数据
- (void)requestDataWithToward{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/get/conversation/member/list"];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:kTestToken forKey:@"token"];
    NSString *sqlCriteria = nil;
    
    XZLPMListModel *pmTempModel = [XZLPMListModel findFirstByCriteria:sqlCriteria];
    NSString *lastDateline = pmTempModel ? pmTempModel.created_time : @"0";
    [paramDic setValue:@"0" forKey:@"createdTime"];
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            //            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *array = data[@"memberList"];
            if (error.integerValue == 0) {
                if ([array count] > 0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in array) {
                        
                        [tempArray addObject:[XZLPMListModel getPMListModelWithDic:dataDic isHistory:NO]];
                    }
                    int count = 0;
                    for (XZLPMListModel *model in tempArray) {
                        if ([model.unRead isEqualToString:@"1"]) {
                            count++;
                        }
                    }
                    if (count>0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHasMessageUnread object:[NSNumber numberWithInt:count]];
                    }
                }
                
            }else{
                
            }
        }
    } failure:^(NSError *error) {
        //        [loadView hide:YES];
        mAlertView(@"提示", @"获取数据失败，请检查网络");
        NSLog(@"failed block%@",error);
    }];
    
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 200;
    }else if (section == 1){
        return 20;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 320)];
        headBgView.backgroundColor = RGBA(255, 255, 255, 1);
        
        UIImageView * headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200)];
        headImgV.image = [UIImage imageNamed:@"GR_personal_mineBg"];
        [headBgView addSubview:headImgV];
        
        imageview_avatar = [[UIImageView alloc] initWithFrame:CGRectMake(26, 63, 70, 70)];
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
        //
        //        UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        iconBtn.frame = CGRectMake(26, 63, 70, 70);
        //        iconBtn.backgroundColor = [UIColor whiteColor];
        //        iconBtn.layer.cornerRadius = iconBtn.frame.size.width / 2;
        //        iconBtn.layer.masksToBounds = YES;
        //        [iconBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        //        [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [headBgView addSubview:iconBtn];
        
        //HR_rightArrow@2x
        UIImageView * rightArrowImgV = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width - 23, imageview_avatar.frame.origin.y + imageview_avatar.frame.size.height / 2, 7, 12)];
        rightArrowImgV.image = [UIImage imageNamed:@"HR_rightArrow"];
        [headBgView addSubview:rightArrowImgV];
        
        UIButton * nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nameBtn.frame = CGRectMake(imageview_avatar.frame.origin.x + imageview_avatar.frame.size.width + 15, imageview_avatar.frame.origin.y, kMainScreenWidth-imageview_avatar.width-28, 70);
        nameBtn.backgroundColor = [UIColor clearColor];
        [nameBtn addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headBgView addSubview:nameBtn];
        
        nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, nameBtn.width-40, 20)];
        nameLab.textColor = RGBA(255, 255, 255, 1);
        nameLab.font = [UIFont systemFontOfSize:18];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.textAlignment = NSTextAlignmentLeft;
        [nameBtn addSubview:nameLab];
        
        companyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLab.frame.origin.y + nameLab.frame.size.height + 14, nameBtn.width-40, 18)];
        companyLab.textColor = RGBA(255, 255, 255, 1);
//        companyLab.numberOfLines = 0;
        [companyLab setLineBreakMode:NSLineBreakByTruncatingTail];
        companyLab.font = [UIFont systemFontOfSize:14];
        companyLab.backgroundColor = [UIColor clearColor];
        companyLab.textAlignment = NSTextAlignmentLeft;
        [nameBtn addSubview:companyLab];
        
        return headBgView;
    }else if(section == 1){
        UIView * headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 20)];
        headBgView.backgroundColor = RGBA(245, 245, 245, 1);
        return headBgView;
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
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"HR_inviteFri"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"邀请好友";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(imageV.frame.origin.x, 54 , iPhone_width - imageV.frame.origin.x, 1)];
        lineV.backgroundColor  =RGBA(245, 245, 245, 1);
        [cell addSubview:lineV];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 0 && indexPath.row == 1){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"tab3"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"私信";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        
        label_MessageCount = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth -60, imageV.frame.origin.y, 18, 18)];
        label_MessageCount.text = @"1";
        label_MessageCount.textColor = [UIColor whiteColor];
        label_MessageCount.backgroundColor = [UIColor redColor];
        label_MessageCount.textAlignment = NSTextAlignmentCenter;
        label_MessageCount.font = [UIFont systemFontOfSize:15];
        label_MessageCount.hidden = YES;
        mViewBorderRadius(label_MessageCount, label_MessageCount.width/2, 1, [UIColor clearColor]);
        [cell addSubview:label_MessageCount];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(imageV.frame.origin.x, 54 , iPhone_width - imageV.frame.origin.x, 1)];
        lineV.backgroundColor  =RGBA(245, 245, 245, 1);
        [cell addSubview:lineV];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"GRPersonal_seeting"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"设置";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 19, 16, 16)];
        imageV.image = [UIImage imageNamed:@"GRPersonal_changeType"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"切换为人才";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {//邀请好友
        XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
        vc.titleStr = @"邀请好友";
        NSString *url = kCombineURL(kTestAPPAPIGR, @"/api/partner/invite");
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?token=%@",kTestToken]];
        vc.urlStr = url;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1){//私信
        XZLPMListViewController *vc = [[XZLPMListViewController alloc] init];
        vc.hasBackBtn = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2){//设置
        HRSettingViewController * vc = [[HRSettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){//切换身份
        mGhostView(nil, @"切换为人才");
        [XZLUserInfoTool setGRStatus:@"0"];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app SetRootVC:@"0"];
    }
}


#pragma mark -进入编辑信息页
-(void)nameBtnClick:(UIButton *)button
{
    HRModifyHRInfoViewController * vc = [[HRModifyHRInfoViewController alloc]init];
    vc.model = _model_PersonBasicInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 70;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NSString *image_url_mini = responseObject[@"download_url_mini"];
            [self updateAvatarWithUrl:image_url_mini withImage:image];
        }
//        mGhostView(nil, @"上传失败");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        mGhostView(nil,@"上传失败");
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
                mGhostView(nil,@"更新成功");
                imageview_avatar.image = image;
                 [mUserDefaults setValue:avatar_string forKey:@"portrait"];
            }
        }
        [loadView hide:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [loadView hide:YES];
        mGhostView(nil,@"更新失败");
    }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
/*else if (indexPath.section == 0 && indexPath.row == 1){
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
 }*/
@end
