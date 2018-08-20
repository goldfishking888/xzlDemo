//
//  JobDetailViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "JobDetailViewController.h"
#import "YJSliderView.h"
#import "JobDescriptionView.h"//职位描述
#import "CompanyIntroView.h"//公司简介
#import "GRComplaintViewController.h"//举报界面
#import <UShareUI/UShareUI.h>
#import "SDWebImageManager.h"

#import "XZLPMDetailViewController.h"
#import "XZLPMListModel.h"

@interface JobDetailViewController ()<YJSliderViewDelegate>
{
    JobDescriptionView * jobdesView;
    CompanyIntroView * companyView;
    OtherJobListView * otherView;
    
    UIButton * collectBtn;
    UILabel * collectLab;
    UIImageView * collectImgV;
    MBProgressHUD * loadView;
    
    UIButton * introBtn;
    UILabel * introLab;
    int clickNum;//控制右上角更多
    UIImageView *moreView;
    BOOL isCollected;//是否收藏
    
}
@property (nonatomic, strong) YJSliderView *sliderView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation JobDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    clickNum = 0;
    isCollected = NO;
    [self addBackBtnGR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTitleLabelGR:@"职位详情"];
    [self addRightView];
    [self requestPositionByid:self.positionID];
    [self preDownloadImage];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)preDownloadImage{
    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/partner/share/info");
    NSString * tokenStr =[XZLUserInfoTool getToken];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
    [paramDic setValue:self.positionID forKey:@"position_id"];//self.searchKey
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary * dataDic = responseObject[@"data"];
                NSString *imgUrlStr = dataDic[@"other"][@"imgUrl"];
                NSURL *imgUrl = [NSURL URLWithString:imgUrlStr];
                if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:imgUrl]) {
                    NSLog(@"shareImage exist");
                    //        img = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgUrl.absoluteString];
                }else{
                    NSLog(@"shareImage is downloading~");
                    [[SDWebImageManager sharedManager] downloadImageWithURL:imgUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                    }];
                    
                }
                
                NSString *imgUrlStr2 = dataDic[@"wechat"][@"imgUrl"];
                NSURL *imgUrl2 = [NSURL URLWithString:imgUrlStr];
                if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:imgUrl2]) {
                    NSLog(@"shareImage exist");
                    //        img = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgUrl.absoluteString];
                }else{
                    NSLog(@"shareImage is downloading~");
                    [[SDWebImageManager sharedManager] downloadImageWithURL:imgUrl2 options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                    }];
                    
                }
            }
        }
    } failure:^(NSError *error) {
    }];

}

-(void)requestPositionByid:(NSString *)positionId
{
    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/info_index");
    NSString * tokenStr = [XZLUserInfoTool getToken];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
    [paramDic setValue:positionId forKey:@"position_id"];//self.searchKey
    NSLog(@"paramDic is %@",paramDic);
    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                GRJobDetailModel * PositionModel = [[GRJobDetailModel alloc]initWithDictionary:data[@"positionInfo"]];
                positionModel = PositionModel;
                
                [self requestCompanyInfoByCompanyId:PositionModel.company_pid];
            }
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        mGhostView(nil, @"获取数据失败，请检查网络请求");
        NSLog(@"failed block%@",error);
    }];
    
}



-(void)requestCompanyInfoByCompanyId:(NSString *)companyID
{
    NSString * tokenStr = [XZLUserInfoTool getToken];
    NSString * urlstr2 = kCombineURL(kTestAPPAPIGR, @"/api/position/company/info_index");
    NSMutableDictionary *paramDic2 = [[NSMutableDictionary alloc] init];
    [paramDic2 setValue:tokenStr forKey:@"token"];//待确定是否添加
    [paramDic2 setValue:companyID forKey:@"company_pid"];//self.searchKey
    [paramDic2 setValue:positionModel.user_city forKey:@"user_city"];//self.searchKey
    [XZLNetWorkUtil requestPostURL:urlstr2 params:paramDic2 success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                //大dic里面有小dic 转model先把大的转了 再把小的alloc出来转了之后赋给大model的.model就行了,这样取值的时候直接就是大model.小model.address
                comDetailModel = [[GRJobDetail_CompanyModel alloc]initWithDictionary:data];
                if (data[@"company_info"] != nil) {
                    comDetailModel.companyInfo = [[GRCompanyInfoModel alloc]initWithDictionary:data[@"company_info"]];
                }
                [self makeUIofHeader];
                [self makeUIOfFooter];
                [loadView hide:YES];

            }
            
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
//        mGhostView(nil, @"获取数据失败，请检查网络");
        NSLog(@"failed block%@",error);
    }];
}

-(void)addRightView
{
    UIButton * warnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    warnBtn.frame = CGRectMake(iPhone_width - 60,7 + self.num, 60, 40);
    [warnBtn setBackgroundColor:[UIColor clearColor]];
    [warnBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:warnBtn];
    
    UIImageView * warnImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 30, 30)];
    warnImageV.image = [UIImage imageNamed:@"GR_MoreIcon"];
    [warnBtn addSubview:warnImageV];
}

-(void)makeUIofHeader
{
    self.sliderView = [[YJSliderView alloc] initWithFrame:CGRectMake(0, 44 + self.num, self.view.frame.size.width, self.view.frame.size.height - 55)];
    self.sliderView.delegate = self;
    self.sliderView.themeColor = RGBA(255, 114, 6, 1);
    self.sliderView.fontSize = 16;
    self.titleArray = @[@"职位描述", @"企业简介", @"其他职位"];
    [self.view addSubview:self.sliderView];
    self.contentArray = [NSMutableArray new];
    //    for (NSInteger index = 0; index < 3; index ++) {
    //        SliderContentViewController *vc = [[SliderContentViewController alloc] init];
    //        [self.contentArray addObject:vc];
    //    jobdesView = [[JobDescriptionView alloc]initWithFrame:CGRectMake(0, 44 + self.num + 44, iPhone_width, self.view.frame.size.height - 44 - self.num - 55 - 44)];
    jobdesView = [[JobDescriptionView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, self.view.frame.size.height - 44 - self.num - 55 - 44) WithJobDescripView:positionModel andCompanyDetailModel:comDetailModel andCompanyName:_companyName];
    companyView = [[CompanyIntroView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, self.view.frame.size.height - 44 - self.num - 55 - 44) WithCompDescripView:comDetailModel];
    
    otherView = [[OtherJobListView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, self.view.frame.size.height - 44 - self.num - 55 - 44) withPositionId:self.positionID];
    otherView.otherDelegate = self;
}

-(void)makeUIOfFooter
{
    UIView * bgFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 55, iPhone_width, 55)];
    bgFooterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgFooterView];
    
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bgFooterView.frame.size.width, 1)];
    lineV.backgroundColor = RGBA(178, 178, 178, 1);
    [bgFooterView addSubview:lineV];
    
    collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 1, 60, 54);
    collectBtn.backgroundColor = [UIColor whiteColor];
    [collectBtn addTarget:self action:@selector(CollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgFooterView addSubview:collectBtn];
    
    collectImgV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 5, 22, 22)];
    [collectBtn addSubview:collectImgV];
    
    collectLab = [[UILabel alloc]initWithFrame:CGRectMake(25, collectImgV.frame.origin.y + collectImgV.frame.size.height + 5, 24, 11)];
    collectLab.textColor = RGBA(121, 121, 121,1);
    collectLab.font = [UIFont systemFontOfSize:11];
    [collectBtn addSubview:collectLab];
    
    UIButton * sixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sixinBtn.frame = CGRectMake(73, 5, (iPhone_width - 73 - 12 - 10) / 2, 44);
    sixinBtn.layer.cornerRadius = sixinBtn.frame.size.height / 2;
    sixinBtn.layer.masksToBounds = YES;
    sixinBtn.layer.borderWidth = 0.5;
    sixinBtn.layer.borderColor = RGBA(255, 163, 29, 1).CGColor;
    [sixinBtn addTarget:self action:@selector(sixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgFooterView addSubview:sixinBtn];
    
    UILabel * sixinLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, sixinBtn.frame.size.width, 16)];
    sixinLab.text = @"私信";
    sixinLab.textColor = RGBA(255, 163, 29, 1);
    sixinLab.font = [UIFont systemFontOfSize:16];
    sixinLab.textAlignment = NSTextAlignmentCenter;
    [sixinBtn addSubview:sixinLab];
    
    introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    introBtn.frame = CGRectMake(73 +sixinBtn.frame.size.width + 10, 5, (iPhone_width - 73 - 12 - 10) / 2, 44);
    introBtn.backgroundColor = RGBA(255, 163, 29, 1);
    introBtn.layer.cornerRadius = sixinBtn.frame.size.height / 2;
    introBtn.layer.masksToBounds = YES;
    introBtn.layer.borderWidth = 0.7;
    introBtn.layer.borderColor = RGBA(255, 163, 29, 1).CGColor;
    introBtn.selected = YES;
    [introBtn addTarget:self action:@selector(introBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgFooterView addSubview:introBtn];
    
    introLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, introBtn.frame.size.width, 16)];
    introLab.text = @"马上自荐";
    introLab.textColor = RGBA(255, 255, 255, 1);
    introLab.font = [UIFont systemFontOfSize:16];
    introLab.textAlignment = NSTextAlignmentCenter;
    [introBtn addSubview:introLab];
    
    if ([positionModel.is_fav intValue] == 0) {//0为未收藏 1为已收藏
        collectLab.text = @"收藏";
        collectImgV.image = [UIImage imageNamed:@"hr_fav_n"];
        collectBtn.selected = NO;
        
    }else{
        collectImgV.image = [UIImage imageNamed:@"GR_fav_y"];
        collectBtn.selected = YES;
        collectLab.text = @"取消";
    }
    if ([positionModel.is_recommend intValue] == 0) {//0为未自荐 1已**
       introBtn.backgroundColor = RGBA(255, 163, 29, 1);
        introLab.textColor = RGBA(255, 255, 255, 1);
        introLab.text = @"马上自荐";
    }else{
        introBtn.selected = NO;
        introBtn.backgroundColor = [UIColor whiteColor];
        introLab.textColor = RGBA(255, 163, 29, 1);
        introLab.text = @"已自荐";

    }
}

-(void)rightBtnClick:(UIButton *)button
{
    NSLog(@"点击右边调到方法");//这个是右边按钮在父类的方法,在这个页面重写就行
    
    if (clickNum % 2 == 0)
    {
        [self createMoreView];
    }
    else
    {
        [self removeMoreView];
    }
    clickNum++;
}

#pragma mark - 收藏请求
-(void)CollectionBtnClick:(UIButton *)button
{
    
    if (button.selected == NO) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.positionID,@"position_id",[XZLUserInfoTool getToken],@"token",@"1",@"favorite_type", nil];
        NSLog(@"params is %@",params);
//        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString * url = kCombineURL(kTestAPPAPIGR, @"/api/position/favorite/do");
        [XZLNetWorkUtil requestPostURL:url params:params success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//                [loadView hide:YES];
                NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
                if (error.integerValue==0) {
                    mGhostView(nil, @"收藏成功");
                    collectBtn.selected = YES;
                    collectImgV.image = [UIImage imageNamed:@"hr_fav_y"];
                    collectLab.text = @"取消";
                }else{
                }
            }
        } failure:^(NSError *error) {
            [loadView hide:YES];
            mGhostView(nil, @"收藏失败");
        }];
        
    }else if (button.selected == YES)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.positionID,@"position_id",[XZLUserInfoTool getToken],@"token",@"0",@"favorite_type", nil];
//        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString * url = kCombineURL(kTestAPPAPIGR, @"/api/position/favorite/do");
        [XZLNetWorkUtil requestPostURL:url params:params success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//                [loadView hide:YES];
                NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
                if (error.integerValue==0) {
                    //                    NSDictionary *dataDic = responseObject;
                    //                    NSDictionary *dic = [dataDic valueForKey:@"data"];
                    mGhostView(nil, @"取消收藏成功");
                    collectImgV.image = [UIImage imageNamed:@"hr_fav_n"];
                    collectLab.text = @"收藏";
                    collectBtn.selected = NO;
                }else{
                }
            }
        } failure:^(NSError *error) {
            [loadView hide:YES];
            mGhostView(nil, @"取消收藏失败");
        }];
    }
    //发送通知收藏刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCollectList" object:nil];
}


#pragma mark - 私信
-(void)sixinBtnClick:(UIButton *)button
{
    XZLPMDetailViewController *talklistVC = [[XZLPMDetailViewController alloc] init];
    XZLPMListModel *pmListModel;
    NSArray *array = [XZLPMListModel findAll];
    for (XZLPMListModel *model in array) {
        if ([model.uid isEqualToString:@"1"]) {
            pmListModel = model;
        }
    }

    if (!pmListModel) {
        pmListModel = [[XZLPMListModel alloc] init];
        pmListModel.uid = @"1";
        pmListModel.pk = [pmListModel getPkWithParamName:@"uid" paramValue:[NSString stringWithFormat:@"%@",@"1"]];
        pmListModel.name = @"小职了官方";
        pmListModel.portrait = @"http://www.xzhiliao.com/dist/img/n16811/guanfang_touxiang.png";
        pmListModel.created_time = @"0";
        pmListModel.unRead = @"0";
        pmListModel.content = @"";
    }

    talklistVC.pmlistModel = pmListModel;
    [self.navigationController pushViewController:talklistVC animated:YES];
}

#pragma mark -马上自荐
-(void)introBtnClick:(UIButton *)button
{
    if (button.selected == NO) {
        mGhostView(nil, @"您已经自荐过,不能重复自荐");
        return;
    }
    NSLog(@"点击了马上自荐");
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/recommend/partner/do");
    NSString * tokenStr =  [XZLUserInfoTool getToken];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
    [paramDic setValue:self.positionID forKey:@"position_id"];//self.searchKey
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        [loadView hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                mGhostView(nil, @"自荐成功");
                introBtn.selected = NO;
                introBtn.backgroundColor = [UIColor whiteColor];
                introLab.textColor = RGBA(255, 163, 29, 1);
                introLab.text = @"已自荐";
            }else{
               mGhostView(nil, responseObject[@"message"]);
            }
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        mGhostView(nil, @"自荐失败，请检查网络");
        NSLog(@"failed block%@",error);
    }];
}




#pragma mark - 以下是设置切换title的参数
//需要展示几个页面
- (NSInteger)numberOfItemsInYJSliderView:(YJSliderView *)sliderView {
    return 3;
}
//每个位置页面展示的View
- (UIView *)yj_SliderView:(YJSliderView *)sliderView viewForItemAtIndex:(NSInteger)index {
    //因为没有写重用的逻辑，建议在控制器中定义view的数组，在此处取出展示(注意在此处定义控制器传入它的view，view中的子视图最好使用约束进行布局)
    if (index == 0) {
        return jobdesView;
    } else if (index == 1) {
        return companyView;
    } else if (index == 2) {
        return otherView;
    } else {
        return nil;
    }
}
//每个页面的标题
- (NSString *)yj_SliderView:(YJSliderView *)sliderView titleForItemAtIndex:(NSInteger)index {
    return self.titleArray[index];
}
//初始化的时候展示的页面位置
- (NSInteger)initialzeIndexForYJSliderView:(YJSliderView *)sliderView {
    return 0;
}

- (NSInteger)yj_SliderView:(YJSliderView *)sliderView redDotNumForItemAtIndex:(NSInteger)index {
    return 0;
}

- (void)createMoreView
{
    NSArray *titleArray1;
    
    titleArray1 = @[@"分享", @"举报"];
    moreView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 44 + self.num + 2, 0, 0)];
    moreView.userInteractionEnabled = YES;
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.borderWidth = 1;
    moreView.layer.borderColor = RGBA(216, 216, 216, 1).CGColor;
    moreView.layer.cornerRadius = 4;
    moreView.layer.masksToBounds = YES;
    [UIView animateWithDuration:0.05 animations:^{
        moreView.frame = CGRectMake(self.view.frame.size.width - 107, 44 + self.num + 2, 105, 45 * titleArray1.count + 5);
        [self.view addSubview:moreView];
    } completion:^(BOOL finished) {
        for (int index = 0; index < titleArray1.count; index++){
            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
            moreButton.frame = CGRectMake(0, 5 + 45 * index, 107, 44);
            [moreButton setTitle:titleArray1[index] forState:UIControlStateNormal];
            [moreButton setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
            moreButton.titleLabel.font  =[UIFont systemFontOfSize:16];
            if ([titleArray1[index] isEqualToString:@"分享"]){
                moreButton.tag = 0;
            }else if ([titleArray1[index] isEqualToString:@"举报"]){
                moreButton.tag = 1;
            }else{
            }
            [moreButton addTarget:self action:@selector(MoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [moreView addSubview:moreButton];
            if (index != titleArray1.count - 1)
            {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5 + 45 * index + 44, moreView.frame.size.width, 1)];
                line.backgroundColor = RGBA(216, 216, 216, 1);
                [moreView addSubview:line];
            }
        }
    }];
}


- (void)MoreButtonClick:(UIButton *)sender
{
    clickNum++;
    if (sender.tag == 0){
        NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/partner/share/info");
        NSString * tokenStr =[XZLUserInfoTool getToken];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
        [paramDic setValue:self.positionID forKey:@"position_id"];//self.searchKey
        [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] ) {
                [loadView hide:YES];
                NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
                if (error.integerValue == 0) {
                    NSDictionary * dataDic = responseObject[@"data"];
                    NSLog(@"分享按钮被执行到了。。。。。。");
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        // 根据获取的platformType确定所选平台进行下一步操作
                        [self shareWithType:platformType Data:dataDic];
                    }];
                }
            }
        } failure:^(NSError *error) {
            mGhostView(nil, @"分享失败，请检查网络");
            NSLog(@"failed block%@",error);
        }];
        
        
    }else if (sender.tag == 1){
        NSLog(@"举报");
        GRComplaintViewController * vc = [[GRComplaintViewController alloc]init];
        if (self.positionID) {
            vc.positionID = self.positionID;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
    [self removeMoreView];   
}

-(void)shareWithType:(UMSocialPlatformType)platformType Data:(NSDictionary *)dataDic{
    switch (platformType) {
        case UMSocialPlatformType_Sina:
        {
            NSString *text = [NSString stringWithFormat:@"%@ %@",dataDic[@"other"][@"desc"],dataDic[@"other"][@"link"]];
            [self shareTextToPlatformType:UMSocialPlatformType_Sina text:text];
        }
            break;
        case UMSocialPlatformType_QQ:
        {
            [self shareImageAndTextToPlatformType:UMSocialPlatformType_QQ Data:dataDic[@"other"]];
        }
            break;
        case UMSocialPlatformType_Qzone:
        {
            [self shareImageAndTextToPlatformType:UMSocialPlatformType_Qzone Data:dataDic[@"other"]];
        }
            break;
        case UMSocialPlatformType_WechatSession:
        {
            [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatSession Data:dataDic[@"wechat"]];
        }
            break;
        case UMSocialPlatformType_WechatTimeLine:
        {
            [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatTimeLine Data:dataDic[@"wechat"]];
        }
            break;
            
        default:
            break;
    }
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType text:(NSString *)text
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            mGhostView(nil, @"分享失败");
        }else{
            NSLog(@"response data is %@",data);
            mGhostView(nil, @"分享成功");
        }
    }];
}

- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType Data:(NSDictionary *)dataDic
{
    
    UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:dataDic[@"imgUrl"]];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV setImageWithURL:[NSURL URLWithString:dataDic[@"imgUrl"]]];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dataDic[@"title"] descr:dataDic[@"desc"] thumImage:img];
    //设置网页地址
    shareObject.webpageUrl =dataDic[@"link"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            mGhostView(nil, @"分享失败");
        }else{
            NSLog(@"response data is %@",data);
            mGhostView(nil, @"分享成功");
        }
    }];
}


- (void)removeMoreView
{
    [moreView removeFromSuperview];
}
#pragma mark OtherJobListView代理方法
- (void)checkOtherJob:(NSMutableArray *)otherArray otherIndex:(NSInteger)index
{
    
    JobDetailViewController * jobDetailVC = [[JobDetailViewController alloc]init];
    SearchResultModel * searchModel = [otherArray objectAtIndex:index];
    jobDetailVC.positionID = [NSString stringWithFormat:@"%@",searchModel.Id];
    jobDetailVC.companyName = searchModel.company_name;
    [self.navigationController pushViewController:jobDetailVC animated:YES];
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
