//
//  MyBonusApplyDetailVC.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/9.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "MyBonusApplyDetailVC.h"
#import "ReApplyBonusViewController.h"
#import "ViewEntryIdentifierViewController.h"//我的入职证明查看
#import "ApplyStateDetailViewController.h"//申请详情查看
#import "MyBounsListViewController.h"//我的奖金列表
#import "JobReaderDetailViewController.h"//xiangqing 
@interface MyBonusApplyDetailVC ()
{
    UIButton * bgCenterBtn;
    
    UILabel * applyStateLabel;//等待入职满月奖金发放
    UILabel * BonusCountLabel;//奖金金额
    UILabel * applyNumberLabel;//申请单号
    
    UILabel * applyCompanyLabel;
    UILabel * applyPositionLabel;
    UILabel * applyTimeLabel;
    UILabel * moneyCountLabel;
    
    UILabel * applyStateBottomLabel;
}
@end

@implementation MyBonusApplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"申请详情"];
    self.view.backgroundColor = RGBA( 243, 243, 243, 1);
    [self createSameheader];
    [self configDataOfSameHeader];
    [self createOtherByState:self.bonusState];
    // Do any additional setup after loading the view.
    [self requestJobDetailData];
}

#pragma mark- 获取职位详情（请求问了web修改查看数，获取的职位数据没用，用的列表数据）

-(void)requestJobDetailData
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled=NO;
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,SeniorJobDetail);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_NewModel.jid,@"jid",_NewModel.localcity,@"localcity",_NewModel.pid,@"pid",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSDictionary *infoDic = [resultDic valueForKey:@"info"];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        if(!resultDic){
            
            //            ghostView.message=@"请重新登录";
            //            [ghostView show];
            
//            HRLogin *vc = [HRLogin new];
//            vc.backType = @"BackPersonalVC";
//            [self.navigationController pushViewController:vc animated:YES];
//            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"获取职位详情成功");
            //TODO 修改列表查看数
            positionModel = [[SeniorJobDetailModel alloc] initWithDictionary:infoDic] ;

        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
}


-(void)createSameheader
{
    UIImageView * bgHeaderImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44 + ios7jj, self.view.frame.size.width,80)];
    bgHeaderImageV.image = [UIImage imageNamed:@"shape_middle_normal"];
    [self.view addSubview:bgHeaderImageV];
    
    UIImageView * iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 20)];
    iconImageV.image = [UIImage imageNamed:@"item_bonus_detail"];
    [bgHeaderImageV addSubview:iconImageV];
    //UILabel * applyStateLabel;
    //UILabel * BonusCountLabel;
    //UILabel * applyNumberLabel;
    applyStateLabel = [MyControl createLableFrame:CGRectMake(iconImageV.frame.origin.x + iconImageV.frame.size.width + 15, iconImageV.frame.origin.y, 200, 12) font:12 title:@"奖金申请审核中"];
    applyStateLabel.textColor = [UIColor orangeColor];
    applyStateLabel.textAlignment = NSTextAlignmentLeft;
    [bgHeaderImageV addSubview:applyStateLabel];
    
    BonusCountLabel = [MyControl createLableFrame:CGRectMake(applyStateLabel.frame.origin.x, applyStateLabel.frame.origin.y + applyStateLabel.frame.size.height + 5, 200, 12) font:12 title:@"奖金金额:666元"];
    BonusCountLabel.textAlignment = NSTextAlignmentLeft;
    [bgHeaderImageV addSubview:BonusCountLabel];
    
    applyNumberLabel = [MyControl createLableFrame:CGRectMake(BonusCountLabel.frame.origin.x, BonusCountLabel.frame.origin.y + BonusCountLabel.frame.size.height + 5, 200, 23) font:12 title:@"申请单号:80902222"];
    applyNumberLabel.textAlignment = NSTextAlignmentLeft;
    [bgHeaderImageV addSubview:applyNumberLabel];
    
    bgCenterBtn = [MyControl createButtonFrame:CGRectMake(bgHeaderImageV.frame.origin.x, bgHeaderImageV.frame.origin.y + bgHeaderImageV.frame.size.height + 15, self.view.frame.size.width, 100) bgImageName:@"shape_middle_normal" image:nil title:nil method:@selector(entryInfoBtnClick) target:self];
    [self.view addSubview:bgCenterBtn];
    
    UILabel * entryInfoLabel = [MyControl createLableFrame:CGRectMake(15, 12.5, 100, 14) font:14 title:@"入职信息"];
    entryInfoLabel.font = [UIFont boldSystemFontOfSize:14];
    entryInfoLabel.textAlignment = NSTextAlignmentLeft;
    [bgCenterBtn addSubview:entryInfoLabel];
    
    UIImageView * lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(entryInfoLabel.frame.origin.x, entryInfoLabel.frame.origin.y + entryInfoLabel.frame.size.height + 12.5, bgCenterBtn.frame.size.width - 30, 0.5)];
    lineImageV.backgroundColor = RGBA(228, 228, 228, 1);
    [bgCenterBtn addSubview:lineImageV];
//    UILabel * applyCompanyLabel;
//    UILabel * applyPositionLabel;
//    UILabel * applyTimeLabel;
//    UILabel * moneyCountLabel;
    applyCompanyLabel = [MyControl createLableFrame:CGRectMake(lineImageV.frame.origin.x, lineImageV.frame.origin.y + lineImageV.frame.size.height + 15, 165, 12) font:12 title:@"入职公司:英网股份有限公司"];
    applyCompanyLabel.textAlignment = NSTextAlignmentLeft;
    [bgCenterBtn addSubview:applyCompanyLabel];
    
    applyPositionLabel = [MyControl createLableFrame:CGRectMake(applyCompanyLabel.frame.origin.x + applyCompanyLabel.frame.size.width + 10, applyCompanyLabel.frame.origin.y, 110, 12) font:12 title:@"职位项目经理"];
    applyPositionLabel.textAlignment = NSTextAlignmentLeft;
    [bgCenterBtn addSubview:applyPositionLabel];
    
    applyTimeLabel = [MyControl createLableFrame:CGRectMake(applyCompanyLabel.frame.origin.x, applyCompanyLabel.frame.origin.y + applyCompanyLabel.frame.size.height + 5, applyCompanyLabel.frame.size.width, 12) font:12 title:@"入职日期: 2015-09-10"];
    applyTimeLabel.textAlignment = NSTextAlignmentLeft;
    [bgCenterBtn addSubview:applyTimeLabel];
    
    moneyCountLabel = [MyControl createLableFrame:CGRectMake(applyTimeLabel.frame.origin.x + applyTimeLabel.frame.size.width + 10, applyTimeLabel.frame.origin.y, applyPositionLabel.frame.size.width, 12) font:12 title:@"入职奖金:666元"];
    moneyCountLabel.textAlignment = NSTextAlignmentLeft;
    [bgCenterBtn addSubview:moneyCountLabel];
    
    UIImageView * imageVRight = [[UIImageView alloc]initWithFrame:CGRectMake(bgCenterBtn.frame.size.width - 15, bgCenterBtn.frame.size.height / 2 - 8 + 20, 10, 16)];
    imageVRight.image = [UIImage imageNamed:@"hr_circle_gray_arrow"];
    [bgCenterBtn addSubview:imageVRight];
    
}
-(void)configDataOfSameHeader
{
//    UILabel * BonusCountLabel;//奖金金额
//    UILabel * applyNumberLabel;//申请单号
//    
//    UILabel * applyCompanyLabel;
//    UILabel * applyPositionLabel;
//    UILabel * applyTimeLabel;
//    UILabel * moneyCountLabel;
    BonusCountLabel.text = [NSString stringWithFormat:@"奖金金额:%@元",self.NewModel.bounsPrice];
    applyNumberLabel.text = [NSString stringWithFormat:@"申请单号:%@",self.NewModel.bonusNumber];
    
    applyCompanyLabel.text = [NSString stringWithFormat:@"公司:%@",self.NewModel.companyName];//入职公司
    applyCompanyLabel.numberOfLines = 1;
    applyCompanyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    applyPositionLabel.text = [NSString stringWithFormat:@"职位:%@",self.NewModel.jobName];//职位名称
    applyPositionLabel.numberOfLines = 1;
    applyPositionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    applyTimeLabel.text = [NSString stringWithFormat:@"日期:%@",self.NewModel.entryDate];//入职时间
    moneyCountLabel.text = [NSString stringWithFormat:@"奖金:%@元",self.NewModel.bounsPrice];//入职奖金
}
-(void)createOtherByState:(NSString *)bonusStateStr
{
    //审核中
    UIButton * bgBottomImageV = [MyControl createButtonFrame:CGRectMake(bgCenterBtn.frame.origin.x, bgCenterBtn.frame.origin.y + bgCenterBtn.frame.size.height + 15, self.view.frame.size.width, 100) bgImageName:@"shape_middle_normal" image:nil title:nil method:@selector(applydetailBtnClick) target:self];
    [self.view addSubview:bgBottomImageV];
    
    UIImageView * imageVRight = [[UIImageView alloc]initWithFrame:CGRectMake(bgBottomImageV.frame.size.width - 15, bgBottomImageV.frame.size.height / 2 - 8 + 20, 10, 16)];
    imageVRight.image = [UIImage imageNamed:@"hr_circle_gray_arrow"];
    [bgBottomImageV addSubview:imageVRight];
    
    UILabel * shenqingLabel = [MyControl createLableFrame:CGRectMake(15, 15, 70, 14) font:14 title:@"申请状态"];
    shenqingLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgBottomImageV addSubview:shenqingLabel];
    
    UIImageView * lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(shenqingLabel.frame.origin.x, shenqingLabel.frame.origin.y + shenqingLabel.frame.size.height + 10, bgBottomImageV.frame.size.width - 30, 0.5)];
    lineImageV.backgroundColor = RGBA(228, 228, 228, 1);
    [bgBottomImageV addSubview:lineImageV];
    
    //item_bonus_detail_point
    UIImageView * leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(shenqingLabel.frame.origin.x, lineImageV.frame.origin.y + lineImageV.frame.size.height + 12, 15, 15)];
    leftImageV.image = [UIImage imageNamed:@"item_bonus_detail_point"];
    [bgBottomImageV addSubview:leftImageV];
    
    UIImageView * lineVImageV = [[UIImageView alloc]initWithFrame:CGRectMake(leftImageV.frame.origin.x + leftImageV.frame.size.width / 2, leftImageV.frame.origin.y + leftImageV.frame.size.height, 0.5, 20)];
    lineVImageV.backgroundColor = RGBA(110, 110, 110, 1);
    [bgBottomImageV addSubview:lineVImageV];
    
    applyStateBottomLabel = [MyControl createLableFrame:CGRectMake(leftImageV.frame.origin.x + leftImageV.frame.size.width + 15, leftImageV.frame.origin.y + 2, 200, 12) font:12 title:@"奖金申请状态:"];
    applyStateBottomLabel.textAlignment = NSTextAlignmentLeft;
    [bgBottomImageV addSubview:applyStateBottomLabel];
    NSString * state = bonusStateStr;
    if ([state isEqualToString:@"0"])
    {
        applyStateLabel.text = @"奖金申请审核中";
        applyStateBottomLabel.text = @"奖金申请审核中";
    }else if ([state isEqualToString:@"1"])
    {//官方支付账单
        applyStateLabel.text = @"奖金已发放";
        applyStateBottomLabel.text = @"奖金已发放";
        UILabel * entryTimeLabel = [MyControl createLableFrame:CGRectMake(applyStateBottomLabel.frame.origin.x, applyStateBottomLabel.frame.origin.y + applyStateBottomLabel.frame.size.height + 5, applyStateBottomLabel.frame.size.width, 12) font:12 title:[NSString stringWithFormat:@"%@",self.NewModel.userPayTime]];
        [bgBottomImageV addSubview:entryTimeLabel];
        
        UIButton * CheckGetMoneyBtn = [MyControl createButtonFrame:CGRectMake(25, bgBottomImageV.frame.origin.y + bgBottomImageV.frame.size.height + 10, self.view.frame.size.width - 50, 35) bgImageName:nil image:nil title:@"查看我的入职奖金" method:@selector(CheckGetMoneyBtnClick) target:self];
        CheckGetMoneyBtn.layer.cornerRadius = 4;
        CheckGetMoneyBtn.layer.masksToBounds = YES;
        [CheckGetMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [CheckGetMoneyBtn setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:CheckGetMoneyBtn];

        
    }else if ([state isEqualToString:@"2"])
    {//申请失败
        applyStateLabel.text = @"申请失败";
        applyStateBottomLabel.text = @"申请失败";
        
        UIImageView * imageFailV = [[UIImageView alloc]initWithFrame:CGRectMake(bgBottomImageV.frame.origin.x, bgBottomImageV.frame.origin.y + bgBottomImageV.frame.size.height + 0.5, bgBottomImageV.frame.size.width, 46)];
        imageFailV.image = [UIImage imageNamed:@"shape_middle_normal"];
        [self.view addSubview:imageFailV];
        
        UILabel * reasonLabel = [MyControl createLableFrame:CGRectMake(15, 5, bgBottomImageV.frame.size.width - 30, 36) font:12 title:[NSString stringWithFormat:@"申请失败原因:%@",self.NewModel.refuseReason]];
        reasonLabel.numberOfLines = 3;
        reasonLabel.adjustsFontSizeToFitWidth = YES;
        [imageFailV addSubview:reasonLabel];
        
        UIButton * postIdentifierBtn = [MyControl createButtonFrame:CGRectMake(15, imageFailV.frame.origin.y + imageFailV.frame.size.height + 20, self.view.frame.size.width - 30, 37) bgImageName:nil image:nil title:@"提交入职证明" method:@selector(postIdentifierBtnClick:) target:self];
        postIdentifierBtn.tag = 1008611;
        [postIdentifierBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        postIdentifierBtn.backgroundColor = [UIColor orangeColor];
        postIdentifierBtn.layer.cornerRadius = 4;
        postIdentifierBtn.layer.masksToBounds = YES;
        [self.view addSubview:postIdentifierBtn];
    }else if ([state isEqualToString:@"3"])
    {//入职证明审核中
        applyStateLabel.text = @"入职证明审核中";
        applyStateBottomLabel.text = @"入职证明审核中";
        //
        UIButton * imageFailV = [MyControl createButtonFrame:CGRectMake(bgBottomImageV.frame.origin.x, bgBottomImageV.frame.origin.y + bgBottomImageV.frame.size.height + 5, bgBottomImageV.frame.size.width, 46) bgImageName:@"shape_middle_normal" image:nil title:nil method:@selector(postIdentifierBtnClick:) target:self];
        imageFailV.tag = 1008612;
        [self.view addSubview:imageFailV];
        
        UILabel * reasonLabel = [MyControl createLableFrame:CGRectMake(15, 5, bgBottomImageV.frame.size.width - 30, 36) font:12 title:[NSString stringWithFormat:@"%@",@"我的入职证明"]];
        reasonLabel.numberOfLines = 3;
        reasonLabel.adjustsFontSizeToFitWidth = YES;
        [imageFailV addSubview:reasonLabel];
    }
    else if ([state isEqualToString:@"4"])
    {//入职证明审核失败
        applyStateLabel.text = @"入职证明审核失败";
        applyStateBottomLabel.text = @"入职证明审核失败";
        
        UIImageView * imageFailV = [[UIImageView alloc]initWithFrame:CGRectMake(bgBottomImageV.frame.origin.x, bgBottomImageV.frame.origin.y + bgBottomImageV.frame.size.height + 0.5, bgBottomImageV.frame.size.width, 46)];
        imageFailV.userInteractionEnabled = YES;
        imageFailV.image = [UIImage imageNamed:@"shape_middle_normal"];
        [self.view addSubview:imageFailV];
        
        UILabel * reasonLabel = [MyControl createLableFrame:CGRectMake(15, 5, bgBottomImageV.frame.size.width - 30, 36) font:12 title:[NSString stringWithFormat:@"申请失败原因:%@",self.NewModel.refuseReason]];
        reasonLabel.numberOfLines = 3;
        reasonLabel.adjustsFontSizeToFitWidth = YES;
        [imageFailV addSubview:reasonLabel];

        UIButton * imageFailBtn = [MyControl createButtonFrame:CGRectMake(imageFailV.frame.origin.x, imageFailV.frame.origin.y + imageFailV.frame.size.height + 5, imageFailV.frame.size.width, 46) bgImageName:@"shape_middle_normal" image:nil title:nil method:@selector(postIdentifierBtnClick:) target:self];
        imageFailBtn.tag = 1008612;
        [self.view addSubview:imageFailBtn];
        
        UILabel * myCerTifierLabel = [MyControl createLableFrame:CGRectMake(15, 5, bgBottomImageV.frame.size.width - 30, 36) font:12 title:[NSString stringWithFormat:@"%@",@"我的入职证明"]];
        reasonLabel.numberOfLines = 3;
        reasonLabel.adjustsFontSizeToFitWidth = YES;
        [imageFailBtn addSubview:myCerTifierLabel];
        
        UIImageView * imageVRight = [[UIImageView alloc]initWithFrame:CGRectMake(imageFailBtn.frame.size.width - 15, imageFailBtn.frame.size.height / 2 - 8, 10, 16)];
        imageVRight.image = [UIImage imageNamed:@"hr_circle_gray_arrow"];
        [imageFailBtn addSubview:imageVRight];
        
    }else if ([state isEqualToString:@"5"])
    {//等待入职满月发放奖金
        applyStateLabel.text = @"等待入职满月发放奖金";
        applyStateBottomLabel.text = @"等待入职满月发放奖金";
        
        UILabel * entryTimeLabel = [MyControl createLableFrame:CGRectMake(applyStateBottomLabel.frame.origin.x, applyStateBottomLabel.frame.origin.y + applyStateBottomLabel.frame.size.height + 5, applyStateBottomLabel.frame.size.width, 12) font:12 title:[NSString stringWithFormat:@"预计奖金发放时间:%@",self.NewModel.userPayTime]];
        [bgBottomImageV addSubview:entryTimeLabel];

        UIButton * imageFailV = [MyControl createButtonFrame:CGRectMake(bgBottomImageV.frame.origin.x, bgBottomImageV.frame.origin.y + bgBottomImageV.frame.size.height + 5, bgBottomImageV.frame.size.width, 46) bgImageName:@"shape_middle_normal" image:nil title:nil method:@selector(postIdentifierBtnClick:) target:self];
        imageFailV.tag = 1008612;
        [self.view addSubview:imageFailV];
        
        UILabel * reasonLabel = [MyControl createLableFrame:CGRectMake(15, 5, bgBottomImageV.frame.size.width - 30, 36) font:12 title:[NSString stringWithFormat:@"%@",@"我的入职证明"]];
        reasonLabel.numberOfLines = 3;
        reasonLabel.adjustsFontSizeToFitWidth = YES;
        [imageFailV addSubview:reasonLabel];
        
    }else if ([state isEqualToString:@"6"])
    {//奖金申请直接通过 等待入职满月发放奖金
        applyStateLabel.text = @"等待入职满月发放奖金";
        applyStateBottomLabel.text = @"等待入职满月发放奖金";
        UILabel * entryTimeLabel = [MyControl createLableFrame:CGRectMake(applyStateBottomLabel.frame.origin.x, applyStateBottomLabel.frame.origin.y + applyStateBottomLabel.frame.size.height + 5, applyStateBottomLabel.frame.size.width, 12) font:12 title:[NSString stringWithFormat:@"预计奖金发放时间:%@",self.NewModel.userPayTime]];
        [bgBottomImageV addSubview:entryTimeLabel];
    }else if ([state isEqualToString:@"7"])
    {//入职满月，可提现
        applyStateLabel.text = @"入职满月,可提现";
        applyStateBottomLabel.text = @"入职满月,可提现";
        UILabel * entryTimeLabel = [MyControl createLableFrame:CGRectMake(applyStateBottomLabel.frame.origin.x, applyStateBottomLabel.frame.origin.y + applyStateBottomLabel.frame.size.height + 5, applyStateBottomLabel.frame.size.width, 12) font:12 title:self.NewModel.userPayTime];
        [bgBottomImageV addSubview:entryTimeLabel];
        
        UIButton * applyGetMoneyBtn = [MyControl createButtonFrame:CGRectMake(25, bgBottomImageV.frame.origin.y + bgBottomImageV.frame.size.height + 10, self.view.frame.size.width - 50, 35) bgImageName:nil image:nil title:@"申请提现" method:@selector(applyGetMoneyBtnClick) target:self];
        applyGetMoneyBtn.layer.cornerRadius = 4;
        applyGetMoneyBtn.layer.masksToBounds = YES;
        [applyGetMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [applyGetMoneyBtn setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:applyGetMoneyBtn];
    }
    else if ([state isEqualToString:@"8"])
    {//奖金提现中
        applyStateLabel.text = @"奖金提现中";
        applyStateBottomLabel.text = @"奖金提现中";
        UILabel * entryTimeLabel = [MyControl createLableFrame:CGRectMake(applyStateBottomLabel.frame.origin.x, applyStateBottomLabel.frame.origin.y + applyStateBottomLabel.frame.size.height + 5, applyStateBottomLabel.frame.size.width, 12) font:12 title:[NSString stringWithFormat:@"%@",self.NewModel.userPayTime]];
        [bgBottomImageV addSubview:entryTimeLabel];
    }
}
-(void)postIdentifierBtnClick:(UIButton *) sender
{
    NSLog(@"提交入职证明");
    if (sender.tag == 1008611) {
        ReApplyBonusViewController * vc = [[ReApplyBonusViewController alloc]init];
        vc.payID = [NSString stringWithFormat:@"%@",self.NewModel.bonusNumber];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1008612)
    {
        ViewEntryIdentifierViewController * vc =[[ViewEntryIdentifierViewController alloc]init];
        vc.CertifyRemark = self.NewModel.certifyRemark;
        vc.CertifyUrl = self.NewModel.certifyUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - 申请状态详情
-(void)applydetailBtnClick
{
    NSLog(@"申请状态详情");
    ApplyStateDetailViewController * vc= [[ApplyStateDetailViewController alloc]init];
    vc.detailIDStr = [NSString stringWithFormat:@"%@",self.NewModel.bonusNumber];
    vc.applyTimeStr = self.NewModel.userPayTime;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)entryInfoBtnClick
{
    if (!positionModel) {
        return;
    }
    NSLog(@"传到下个页面--入职公司详情");
    Bonus_JobDetailVCViewController *detail = [[Bonus_JobDetailVCViewController alloc] init];
    detail.positionModel = positionModel;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - 申请提现
-(void)applyGetMoneyBtnClick
{
    NSLog(@"申请提现");
    MyBounsListViewController * vc = [[MyBounsListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 查看我的入职奖金
-(void)CheckGetMoneyBtnClick
{
    MyBounsListViewController * vc = [[MyBounsListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
