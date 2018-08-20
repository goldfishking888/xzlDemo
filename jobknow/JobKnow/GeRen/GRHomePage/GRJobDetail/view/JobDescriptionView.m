//
//  JobDescriptionView.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "JobDescriptionView.h"
@interface JobDescriptionView()
@end
@implementation JobDescriptionView
{
    NSDictionary *dic;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithFrame:(CGRect)frame WithJobDescripView:(GRJobDetailModel *)JobModel andCompanyDetailModel:(GRJobDetail_CompanyModel *)comDetailModel andCompanyName:(NSString *)companyName
{
    self = [super initWithFrame:frame];
    if (self){
        _positionModel = JobModel;
        _companyDetailModel = comDetailModel;//大的公司详情
        //        _companyInfoModel = _companyDetailModel.companyInfo;
        scrollbgView = [[UIScrollView alloc]initWithFrame:frame];//CGRectMake(0, 0, iPhone_width, self.frame.size.height)];
        scrollbgView.scrollEnabled = YES;
        scrollbgView.contentSize = CGSizeMake(iPhone_width, 180);
        scrollbgView.backgroundColor = RGBA(243, 243, 243, 1);
        [self addSubview:scrollbgView];
        
        UIView * sepaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 10)];
        sepaV.backgroundColor = RGBA(243, 243, 243, 1);
        [scrollbgView addSubview:sepaV];
        
        bgHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, iPhone_width, 190)];
        bgHeaderView.backgroundColor = [UIColor whiteColor];
        [scrollbgView addSubview:bgHeaderView];
        //    UILabel * jobtitleLab;
        jobTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 190, 19)];
        jobTypeLab.font = [UIFont boldSystemFontOfSize:18];
//        jobTypeLab.adjustsFontSizeToFitWidth = YES;
        jobTypeLab.textAlignment = NSTextAlignmentLeft;
        jobTypeLab.textColor = [UIColor blackColor];
        jobTypeLab.text = _positionModel.name;//@"PH工程PHP工程工程师";
        if (jobTypeLab.text.length <=13) {
            [jobTypeLab sizeToFit];
        }
        [bgHeaderView addSubview:jobTypeLab];
        
        isFastLab = [[UILabel alloc]initWithFrame:CGRectMake(jobTypeLab.frame.origin.x + jobTypeLab.frame.size.width + 2, jobTypeLab.frame.origin.y + 2, 18, 18)];
        isFastLab.backgroundColor = RGBA(252, 83, 102, 1);
        isFastLab.textAlignment = NSTextAlignmentCenter;
        isFastLab.textColor = [UIColor whiteColor];
        isFastLab.font = [UIFont systemFontOfSize:13];
        isFastLab.layer.cornerRadius = 3;
        isFastLab.layer.masksToBounds = YES;
        [bgHeaderView addSubview:isFastLab];
        if ([_positionModel.is_fast intValue] == 1) {
            isFastLab.text = @"急";
        }else{
            isFastLab.frame = CGRectMake(jobTypeLab.frame.origin.x + jobTypeLab.frame.size.width + 5, jobTypeLab.frame.origin.y, 0, 0);
        }
        
        //    UILabel * typeImageLab;
        typeImageLab = [[UILabel alloc]initWithFrame:CGRectMake(isFastLab.frame.origin.x + isFastLab.frame.size.width + 4, jobTypeLab.frame.origin.y + 2, 32, 18)];
        typeImageLab.backgroundColor = RGBA(252, 83, 102, 1);
        typeImageLab.text = @"收益";
        typeImageLab.textAlignment = NSTextAlignmentCenter;
        typeImageLab.textColor = [UIColor whiteColor];
        typeImageLab.font = [UIFont systemFontOfSize:13];
        typeImageLab.layer.cornerRadius = 3;
        typeImageLab.layer.masksToBounds = YES;
        [bgHeaderView addSubview:typeImageLab];
        //    UILabel * salaryLab;
        salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(typeImageLab.frame.origin.x + typeImageLab.frame.size.width + 4, typeImageLab.frame.origin.y, 140, 18)];
        salaryLab.textColor = RGBA(252, 83, 98, 1);
        NSString * strOld = _positionModel.hunter_earning;
        if (strOld.length == 0||[strOld isEqualToString:@"0"]) {
            typeImageLab.text = @"";
            typeImageLab.backgroundColor = [UIColor clearColor];
            salaryLab.text = @"";
        }else if ([strOld rangeOfString:@"-"].location == NSNotFound) {
            if (strOld.length>4) {
                salaryLab.text = [NSString stringWithFormat:@"%@",strOld];
            }else{
                salaryLab.text = [NSString stringWithFormat:@"%@K",strOld];
            }
        }else{
            NSArray *ArrayNum = [strOld componentsSeparatedByString:@"-"];
            NSString * beginStr;
            NSString * endStr;
            if (ArrayNum.count > 1) {
                beginStr = ([ArrayNum[0] intValue] < 1000) ? [NSString stringWithFormat:@"%d",[ArrayNum[0] intValue]] : [NSString stringWithFormat:@"%dK",[ArrayNum[0] intValue] / 1000];
                endStr = ([ArrayNum[1] intValue] < 1000) ? [NSString stringWithFormat:@"%d",[ArrayNum[1] intValue]] : [NSString stringWithFormat:@"%dK",[ArrayNum[1] intValue] / 1000];
                if ([beginStr isEqualToString:endStr]) {
                    NSString *str3 = [NSString stringWithFormat:@"%d",[ArrayNum[0] intValue] / 1000];
                    NSString *str4 = [NSString stringWithFormat:@".%d",[ArrayNum[0] intValue] % 1000/100];
                    if ([str4 isEqualToString:@".0"]) {
                        str4 = @"";
                    }
                    beginStr = [NSString stringWithFormat:@"%@%@K",str3,str4];
                    
                    NSString *str1 = [NSString stringWithFormat:@"%d",[ArrayNum[1] intValue] / 1000];
                    NSString *str2 = [NSString stringWithFormat:@".%d",[ArrayNum[1] intValue] % 1000/100];
                    if ([str2 isEqualToString:@".0"]) {
                        str2 = @"";
                    }
                    endStr = [NSString stringWithFormat:@"%@%@K",str1,str2];
                }
                salaryLab.text = [NSString stringWithFormat:@"%@-%@",beginStr,endStr];
            }else{
                beginStr = ([ArrayNum[0] intValue] < 1000) ? [NSString stringWithFormat:@"%d",[ArrayNum[0] intValue]] : [NSString stringWithFormat:@"%dK",[ArrayNum[0] intValue] / 1000];
                salaryLab.text = [NSString stringWithFormat:@"%@",beginStr];
            }
        }        salaryLab.font = [UIFont systemFontOfSize:15];
        [bgHeaderView addSubview:salaryLab];
        //    UILabel * detailLab;
        detailLab = [[UILabel alloc]initWithFrame:CGRectMake(jobTypeLab.frame.origin.x, jobTypeLab.frame.origin.y + jobTypeLab.frame.size.height + 20, 300, 18)];
        detailLab.textColor = RGBA(74, 74, 74, 1);
        detailLab.textAlignment = NSTextAlignmentLeft;
        //@"10K - 12K | 青岛 | 2年经验 | 本科";
        detailLab.font = [UIFont systemFontOfSize:15];
        NSString * salaryStr = [XZLUtil getSalaryRangeWithSalaryCode:[NSString stringWithFormat:@"%d",[_positionModel.salary intValue]]];
        NSString * workYearStr = [XZLUtil getWorkYearsWithWorkYearCode:[NSString stringWithFormat:@"%d",[_positionModel.work_years intValue]]];
        NSString * degreeStr = [XZLUtil getDegreeStrWithDegreeCode:[NSString stringWithFormat:@"%d",[_positionModel.degree intValue]]];
        NSString * str1 = @"";
        NSString * str2 = @"";
        NSString * str3 = @"";
        NSString * str4 = @"";
        if (salaryStr != nil) {
            if ([salaryStr containsString:@"000000"]) {
                salaryStr = [salaryStr stringByReplacingOccurrencesOfString:@"000000" withString:@"000K"];
            }
            if ([salaryStr containsString:@"00000"]) {
                salaryStr = [salaryStr stringByReplacingOccurrencesOfString:@"00000" withString:@"00K"];
            }
            if ([salaryStr containsString:@"0000"]) {
                salaryStr = [salaryStr stringByReplacingOccurrencesOfString:@"0000" withString:@"0K"];
            }
            if([salaryStr containsString:@"000"]){
                salaryStr = [salaryStr stringByReplacingOccurrencesOfString:@"000" withString:@"K"];
                salaryStr = [salaryStr stringByReplacingOccurrencesOfString:@"999" withString:@"K"];
            }
            str1 = [NSString stringWithFormat:@"%@%@",salaryStr,salaryStr.length == 0 ? @"":@" "];
        }
        if (_positionModel.work_area != nil) {
            str2 = [NSString stringWithFormat:@"%@%@%@",_positionModel.work_area.length == 0 ? @"":@"| ",_positionModel.work_area,_positionModel.work_area.length == 0 ? @"":@" "];
        }
        if (workYearStr != nil) {
            str3 = [NSString stringWithFormat:@"%@%@ ",@"| ",workYearStr.length == 0 ? @"经验不限":workYearStr];
        }
        if (degreeStr != nil) {
            str4 = [NSString stringWithFormat:@"%@%@",@"| ",degreeStr.length == 0 ? @"学历不限":degreeStr];
        }
        detailLab.text = [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
        [bgHeaderView addSubview:detailLab];
        //    UILabel * companyNameLab;
        _companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(detailLab.frame.origin.x, detailLab.frame.origin.y + detailLab.frame.size.height + 20, 300, 18)];
        _companyNameLab.textColor = RGBA(74, 74, 74, 1);
        _companyNameLab.textAlignment = NSTextAlignmentLeft;
        _companyNameLab.text = companyName;
        _companyNameLab.font = [UIFont systemFontOfSize:15];
        [bgHeaderView addSubview:_companyNameLab];
        //    UILabel * jobTypeLab;
        jobTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(_companyNameLab.frame.origin.x, _companyNameLab.frame.origin.y + _companyNameLab.frame.size.height + 15, 120, 15)];
        jobTypeLab.textColor = RGBA(153, 153, 153, 1);
        jobTypeLab.textAlignment = NSTextAlignmentLeft;
        jobTypeLab.text = ([_positionModel.type integerValue] == 1)?@"职位性质: 全职":@"职位性质: 兼职";//@"职位性质:全职";
        jobTypeLab.font = [UIFont systemFontOfSize:13];
        [bgHeaderView addSubview:jobTypeLab];
        //    UILabel * needCountLab;
        needCountLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width / 2, jobTypeLab.frame.origin.y, 120, 15)];
        needCountLab.textColor = RGBA(153, 153, 153, 1);
        needCountLab.textAlignment = NSTextAlignmentLeft;
        needCountLab.text = [NSString stringWithFormat:@"招聘人数: %@人",_positionModel.num];//@"招聘人数:5人";
        needCountLab.font = [UIFont systemFontOfSize:13];
        [bgHeaderView addSubview:needCountLab];
        //    UILabel * publicLab;
        publicLab = [[UILabel alloc]initWithFrame:CGRectMake(_companyNameLab.frame.origin.x, jobTypeLab.frame.origin.y + jobTypeLab.frame.size.height + 10, 180, 15)];
        publicLab.textColor = RGBA(153, 153, 153, 1);
        publicLab.textAlignment = NSTextAlignmentLeft;
        if (_positionModel.created_at.length >= 10) {
            NSString *str3 = [_positionModel.created_at substringWithRange:NSMakeRange(0, 10)];
            publicLab.text = [NSString stringWithFormat:@"发布日期: %@",str3];//@"发布日期:2017-04-27";
        }else{
            publicLab.text = [NSString stringWithFormat:@"发布日期: %@",@"暂无"];
        }
        publicLab.font = [UIFont systemFontOfSize:13];
        [bgHeaderView addSubview:publicLab];
        //    UILabel * refreshLab;
        refreshLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width / 2, publicLab.frame.origin.y, 180, 15)];
        refreshLab.textColor = RGBA(153, 153, 153, 1);
        refreshLab.textAlignment = NSTextAlignmentLeft;
        if (_positionModel.position_validateDate) {
            NSString *str3 = [XZLUtil getDateWithMillisecond:[_positionModel.position_validateDate longLongValue]];
            refreshLab.text = [NSString stringWithFormat:@"更新日期: %@",str3];//@"发布日期:2017-04-27";
            
        }else{
            refreshLab.text = [NSString stringWithFormat:@"更新日期: %@",@"暂无"];
        }
        refreshLab.font = [UIFont systemFontOfSize:13];
        [bgHeaderView addSubview:refreshLab];
        
        bgMiddleView = [[UIView alloc]initWithFrame:CGRectMake(0, bgHeaderView.frame.origin.y + bgHeaderView.frame.size.height + 10, iPhone_width, 380)];
        bgMiddleView.backgroundColor = [UIColor whiteColor];
        [scrollbgView addSubview:bgMiddleView];
        
        UILabel * colorLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 5, 20)];
        colorLab.backgroundColor = RGBA(255, 163, 29, 1);
        [bgMiddleView addSubview:colorLab];
        
        UILabel * companyDesTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(colorLab.frame.origin.x + colorLab.frame.size.width + 15, colorLab.frame.origin.y, 140, 20)];
        companyDesTitleLab.text = @"职位描述";
        companyDesTitleLab.textColor = [UIColor blackColor];
        companyDesTitleLab.font = [UIFont systemFontOfSize:16];
        companyDesTitleLab.textAlignment = NSTextAlignmentLeft;
        [bgMiddleView addSubview:companyDesTitleLab];
        
        companyDesContentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, companyDesTitleLab.frame.origin.y + companyDesTitleLab.frame.size.height + 5, iPhone_width - 40, bgMiddleView.frame.size.height - 40)];
        companyDesContentLab.font = [UIFont systemFontOfSize:15];
        companyDesContentLab.textColor = RGBA(74, 74, 74, 1);
        companyDesContentLab.numberOfLines = 0;
        NSString * positionDesStr = [_positionModel.remark stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        companyDesContentLab.text = positionDesStr;
        companyDesContentLab.textAlignment = NSTextAlignmentLeft;
        CGSize autoSize2 = CGSizeMake(iPhone_width - 40 ,MAXFLOAT);
        CGSize size2 = [positionDesStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
        NSInteger introductionHeight=size2.height;
        companyDesContentLab.frame = CGRectMake(companyDesContentLab.frame.origin.x, companyDesContentLab.frame.origin.y, companyDesContentLab.frame.size.width, introductionHeight + 20);
        [bgMiddleView addSubview:companyDesContentLab];

        bgMiddleView.frame = CGRectMake(bgMiddleView.frame.origin.x, bgMiddleView.frame.origin.y, bgMiddleView.frame.size.width, introductionHeight + 50 + 20);
        
        
        bgBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, bgMiddleView.frame.origin.y + bgMiddleView.frame.size.height + 10, iPhone_width, 390)];
        bgBottomView.backgroundColor = [UIColor whiteColor];
        bgBottomView.userInteractionEnabled = YES;
        [scrollbgView addSubview:bgBottomView];
        
        UILabel * colorLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 5, 20)];
        colorLab2.backgroundColor = RGBA(255, 163, 29, 1);
        [bgBottomView addSubview:colorLab2];
        
        UILabel * companyDesTitleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(colorLab2.frame.origin.x + colorLab2.frame.size.width + 15, colorLab2.frame.origin.y, 140, 20)];
        companyDesTitleLab2.text = @"发布信息";
        companyDesTitleLab2.textColor = [UIColor blackColor];
        companyDesTitleLab2.font = [UIFont systemFontOfSize:16];
        companyDesTitleLab2.textAlignment = NSTextAlignmentLeft;
        [bgBottomView addSubview:companyDesTitleLab2];
        
        UIImageView * personNameIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, companyDesTitleLab2.frame.origin.y + companyDesTitleLab2.frame.size.height + 15, 15, 16)];
        personNameIcon.image = [UIImage imageNamed:@"JobDetail_hrIcon"];
        [bgBottomView addSubview:personNameIcon];
        
        personNameLab = [[UILabel alloc]initWithFrame:CGRectMake(personNameIcon.frame.origin.x + personNameIcon.frame.size.width + 10, personNameIcon.frame.origin.y, 100, 18)];
        personNameLab.text = [NSString stringWithFormat:@"%@",_positionModel.linkman.length == 0 ? @"" : _positionModel.linkman];//@"小宋送";
        personNameLab.textAlignment = NSTextAlignmentLeft;
        personNameLab.font = [UIFont systemFontOfSize:15];
        personNameLab.textColor = RGBA(74, 74, 74, 1);
        [bgBottomView addSubview:personNameLab];
        
        UIImageView * personAddressIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, personNameIcon.frame.origin.y + personNameIcon.frame.size.height + 15, 14, 16)];
        personAddressIcon.image = [UIImage imageNamed:@"JobDetail_hrAddIcon"];
        [bgBottomView addSubview:personAddressIcon];
        
        AddressNameLab = [[UILabel alloc]initWithFrame:CGRectMake(personAddressIcon.frame.origin.x + personAddressIcon.frame.size.width + 10, personAddressIcon.frame.origin.y, iPhone_width - 60, 18)];
        AddressNameLab.text = [NSString stringWithFormat:@"%@",_companyDetailModel.companyInfo.company_address.length == 0?@"":_companyDetailModel.companyInfo.company_address];//
        AddressNameLab.textAlignment = NSTextAlignmentLeft;
        AddressNameLab.numberOfLines = 0;
        AddressNameLab.font = [UIFont systemFontOfSize:15];
        AddressNameLab.textColor = RGBA(74, 74, 74, 1);
        [AddressNameLab sizeToFit];
        [bgBottomView addSubview:AddressNameLab];
        NSLog(@"bgBottomView is %f AddressNameLab is %f",bgBottomView.frame.size.height,AddressNameLab.frame.size.height);
        
        [self requestHRInfo];
        bgBottomView.frame = CGRectMake(bgBottomView.frame.origin.x, bgBottomView.frame.origin.y, bgBottomView.frame.size.width, bgBottomView.frame.size.height + AddressNameLab.frame.size.height - 15);
        scrollbgView.contentSize = CGSizeMake(iPhone_width, 190 + introductionHeight + 50 + 20 + 390 + AddressNameLab.frame.size.height - 15);
    }
    
    return self;
}
-(void)requestHRInfo{
    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/footer/contact");
    NSString * tokenStr = [XZLUserInfoTool getToken];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
//            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                [self makeBottomWithData:data];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"failed block%@",error);
    }];
    
}
-(void)makeBottomWithData:(NSDictionary *)dataDic
{
    
    dic = dataDic;
    UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, AddressNameLab.frame.origin.y + AddressNameLab.frame.size.height + 20, iPhone_width, 10)];
    separateView.backgroundColor = RGBA(243, 243, 243, 1);
    [bgBottomView addSubview:separateView];
    
    UIImageView * interestImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, separateView.frame.origin.y + separateView.frame.size.height, iPhone_width, 56)];
    interestImgV.image = [UIImage imageNamed:@"JobDetail_interest"];
    [bgBottomView addSubview:interestImgV];
    
    UIButton * hrIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hrIconBtn.frame = CGRectMake(iPhone_width / 2 - 33, interestImgV.frame.origin.y + interestImgV.frame.size.height + 15, 66, 66);
    [hrIconBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"headPortraitUrl"]]] placeholderImage:[UIImage imageNamed:@"tab_me_normal"]];
//    [hrIconBtn setImage:[UIImage imageNamed:@"Job_hr_Icon"] forState:UIControlStateNormal];
    [bgBottomView addSubview:hrIconBtn];
    
    UIImageView * TelImgV = [[UIImageView alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 100, hrIconBtn.frame.origin.y + hrIconBtn.frame.size.height + 10, 16, 16)];
    TelImgV.image = [UIImage imageNamed:@"jobDetail_hrTelIcon"];
    [bgBottomView addSubview:TelImgV];
    
    UILabel * TelLab = [[UILabel alloc]initWithFrame:CGRectMake(TelImgV.frame.origin.x + TelImgV.frame.size.width + 8, TelImgV.frame.origin.y - 2, 200, 16)];
    TelLab.text = [NSString stringWithFormat:@"电话 : %@",dataDic[@"mobile"]];//@"电话 : 18653273367";
    TelLab.textColor = RGBA(74, 74, 74, 1);
    TelLab.font = [UIFont systemFontOfSize:15];
    TelLab.textAlignment = NSTextAlignmentLeft;
    TelLab.tag = 11;
    TelLab.userInteractionEnabled = YES;
    [bgBottomView addSubview:TelLab];
    
    UIImageView * QQImgV = [[UIImageView alloc]initWithFrame:CGRectMake(TelImgV.frame.origin.x, TelImgV.frame.origin.y + TelImgV.frame.size.height + 10, 14, 16)];
    QQImgV.image = [UIImage imageNamed:@"JobDetail_hr_qqIcon"];
    [bgBottomView addSubview:QQImgV];
    
    UILabel * QQLab = [[UILabel alloc]initWithFrame:CGRectMake(QQImgV.frame.origin.x + QQImgV.frame.size.width + 10, QQImgV.frame.origin.y - 2, 200, 16)];
    QQLab.text = [NSString stringWithFormat:@"Q Q : %@",dataDic[@"qq"]];//@"Q Q : 1458203114";
    QQLab.textColor = RGBA(74, 74, 74, 1);
    QQLab.font = [UIFont systemFontOfSize:15];
    QQLab.textAlignment = NSTextAlignmentLeft;
    QQLab.tag = 22;
    QQLab.userInteractionEnabled = YES;
    [bgBottomView addSubview:QQLab];
    
    UIImageView * EmailImgV = [[UIImageView alloc]initWithFrame:CGRectMake(TelImgV.frame.origin.x, QQImgV.frame.origin.y + QQImgV.frame.size.height + 10, 16, 12)];
    EmailImgV.image = [UIImage imageNamed:@"JobDetail_HrEmailIcon"];
    [bgBottomView addSubview:EmailImgV];
    
    UILabel * EmailLab = [[UILabel alloc]initWithFrame:CGRectMake(EmailImgV.frame.origin.x + EmailImgV.frame.size.width + 8, EmailImgV.frame.origin.y - 2, 200, 16)];
    EmailLab.text = [NSString stringWithFormat:@"邮箱 : %@",dataDic[@"email"]];//@"邮箱 : kefu@xzhiliao.com";
    EmailLab.textColor = RGBA(74, 74, 74, 1);
    EmailLab.font = [UIFont systemFontOfSize:15];
    EmailLab.textAlignment = NSTextAlignmentLeft;
    EmailLab.tag = 33;
    EmailLab.userInteractionEnabled = YES;
//    EmailLab.backgroundColor = [UIColor greenColor];
    [bgBottomView addSubview:EmailLab];
    
    UITapGestureRecognizer *tapqq = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapqq)];
    UITapGestureRecognizer *taptel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptel)];
    UITapGestureRecognizer *tapemail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapemail)];
    [TelLab addGestureRecognizer:taptel];
    [QQLab addGestureRecognizer:tapqq];
    [EmailLab addGestureRecognizer:tapemail];
}

-(void)taptel{
    NSString * str=[NSString stringWithFormat:@"tel:%@",dic[@"mobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)tapqq{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@",dic[@"qq"]];
    mGhostView(nil, @"已复制到剪贴板");
}

-(void)tapemail{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",dic[@"email"]]];
    [[UIApplication sharedApplication] openURL:url];
}
@end
