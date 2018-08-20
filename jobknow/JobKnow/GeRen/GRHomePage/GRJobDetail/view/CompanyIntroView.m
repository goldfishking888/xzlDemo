//
//  CompanyIntroView.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "CompanyIntroView.h"
@interface CompanyIntroView(){
    UIScrollView * scrollbgView;
    UIView * bgBottomView;
    UILabel * companyDesContentLab;
}
@end
@implementation CompanyIntroView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithFrame:(CGRect)frame WithCompDescripView:(GRJobDetail_CompanyModel *)model
{
    self = [super initWithFrame:frame];
    if (self){
        _companyDetailModel = model;
        scrollbgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, self.frame.size.height)];
        scrollbgView.scrollEnabled = YES;
        scrollbgView.contentSize = CGSizeMake(iPhone_width, iPhone_height);
        scrollbgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollbgView];
        self.backgroundColor = RGBA(243, 243, 243, 1);
        
        UIView * sepaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 10)];
        sepaV.backgroundColor = RGBA(243, 243, 243, 1);
        [scrollbgView addSubview:sepaV];
        
        UIView * headerbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, iPhone_width, 130)];
        headerbgView.backgroundColor = [UIColor whiteColor];
        [scrollbgView addSubview:headerbgView];
        
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, iPhone_width - 40, 20)];
        titleLab.text = [NSString stringWithFormat:@"%@",_companyDetailModel.name];
        CGSize autoSize0 = CGSizeMake(titleLab.size.width ,MAXFLOAT);
        CGSize size0 = [[titleLab.text stringByAppendingString:@"\n"] sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:autoSize0 lineBreakMode:NSLineBreakByWordWrapping];
        NSInteger introductionHeight0=size0.height;
        titleLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y, titleLab.frame.size.width, introductionHeight0);
        titleLab.numberOfLines = 0;
        titleLab.textColor = [UIColor blackColor];
//        titleLab.backgroundColor = [UIColor greenColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = [UIFont boldSystemFontOfSize:18];
        [headerbgView addSubview:titleLab];
        
        UILabel * tradeLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.frame.size.height + 15, 40, 15.5)];
        tradeLab.text = @"行业:";
        //    tradeLab.backgroundColor = [UIColor greenColor];
        tradeLab.textColor = RGBA(153, 153, 153, 1);
        tradeLab.font = [UIFont systemFontOfSize:13];
        [headerbgView addSubview:tradeLab];
        
        UILabel * tradeLabContent = [[UILabel alloc]initWithFrame:CGRectMake(tradeLab.frame.origin.x + tradeLab.frame.size.width + 2, tradeLab.frame.origin.y, iPhone_width - tradeLab.frame.origin.x - tradeLab.frame.size.width - 20, 27)];
        CGSize autoSize1 = CGSizeMake(tradeLabContent.size.width ,MAXFLOAT);
        tradeLabContent.text = [NSString stringWithFormat:@"%@",_companyDetailModel.trade_name];//@"行业: 通讯（设备/运营/增值服务）、金融/银行/投资/基金/证券、家居/室内设计/装饰装潢、耐用消费品（服装服饰/纺织/皮革/家具/家电）";// _companyDetailModel.trade_name;
        CGSize size1 = [[tradeLabContent.text stringByAppendingString:@"\n"] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:autoSize1 lineBreakMode:NSLineBreakByWordWrapping];
        NSInteger introductionHeight1=size1.height;
        tradeLabContent.frame = CGRectMake(tradeLabContent.frame.origin.x, tradeLabContent.frame.origin.y, tradeLabContent.frame.size.width, introductionHeight1);
        tradeLabContent.numberOfLines = 0;
        tradeLabContent.textColor = RGBA(74, 74, 74, 1);
//        tradeLabContent.backgroundColor = [UIColor greenColor];
        tradeLabContent.font = [UIFont systemFontOfSize:13];
        [tradeLabContent sizeToFit];
        [headerbgView addSubview:tradeLabContent];
        
        UILabel * companyTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(tradeLab.frame.origin.x, tradeLabContent.frame.origin.y + tradeLabContent.frame.size.height + 14, 40, 20)];
        companyTypeLab.text = @"性质:";
        companyTypeLab.textColor = RGBA(153, 153, 153, 1);
        companyTypeLab.font = [UIFont systemFontOfSize:13];
        [headerbgView addSubview:companyTypeLab];
        
        UILabel * companyTypeDetailLab = [[UILabel alloc]initWithFrame:CGRectMake(companyTypeLab.frame.origin.x + companyTypeLab.frame.size.width + 5, companyTypeLab.frame.origin.y, iPhone_width - 20, 20)];
        NSNumber * num = _companyDetailModel.companyInfo.corpprop;
       NSString * xingzhiStr = [XZLUtil getCompanyCorpWithCompanyCorpCode:[NSString stringWithFormat:@"%d",[num intValue]]];
        if (xingzhiStr.length == 0) {
            xingzhiStr = @"不详";
        }
        companyTypeDetailLab.text = xingzhiStr;
        companyTypeDetailLab.textColor = RGBA(74, 74, 74, 1);
        companyTypeDetailLab.font = [UIFont systemFontOfSize:13];
        [headerbgView addSubview:companyTypeDetailLab];
        headerbgView.frame = CGRectMake(headerbgView.frame.origin.x, headerbgView.frame.origin.y, headerbgView.frame.size.width, headerbgView.frame.size.height + introductionHeight1);
        UIView * separateView = [[UIView alloc]initWithFrame:CGRectMake(0, headerbgView.frame.origin.y + headerbgView.frame.size.height, iPhone_width,10)];
        separateView.backgroundColor = RGBA(243, 243, 243, 1);
        [scrollbgView addSubview:separateView];
        
        bgBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, headerbgView.frame.origin.y + headerbgView.frame.size.height + 10, iPhone_width, self.frame.size.height - headerbgView.frame.origin.y - headerbgView.frame.size.height - 20)];
        bgBottomView.backgroundColor = [UIColor whiteColor];
        [scrollbgView addSubview:bgBottomView];
        
        UILabel * colorLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 5, 20)];
        colorLab.backgroundColor = RGBA(255, 163, 29, 1);
        [bgBottomView addSubview:colorLab];
        
        UILabel * companyDesTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(colorLab.frame.origin.x + colorLab.frame.size.width + 15, colorLab.frame.origin.y, 140, 20)];
        companyDesTitleLab.text = @"公司简介";
        companyDesTitleLab.textColor = [UIColor blackColor];
        companyDesTitleLab.font = [UIFont systemFontOfSize:16];
        companyDesTitleLab.textAlignment = NSTextAlignmentLeft;
//        companyDesTitleLab.backgroundColor = [UIColor greenColor];
        [bgBottomView addSubview:companyDesTitleLab];
        
        companyDesContentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, companyDesTitleLab.frame.origin.y + companyDesTitleLab.frame.size.height + 15, iPhone_width - 40, bgBottomView.frame.size.height - 40)];
        companyDesContentLab.font = [UIFont systemFontOfSize:15];
        companyDesContentLab.textColor = RGBA(74, 74, 74, 1);
        companyDesContentLab.numberOfLines = 0;
        companyDesContentLab.text = @"暂无简介";
        companyDesContentLab.backgroundColor = [UIColor whiteColor];
//        companyDesContentLab.backgroundColor = [UIColor greenColor];
        companyDesContentLab.textAlignment = NSTextAlignmentLeft;
        [bgBottomView addSubview:companyDesContentLab];
        
        CGSize autoSize2 = CGSizeMake(iPhone_width - 40 ,MAXFLOAT);
        companyDesContentLab.text = [NSString stringWithFormat:@"%@",_companyDetailModel.companyInfo.company_intro.length == 0?@"":_companyDetailModel.companyInfo.company_intro];

        CGSize size2 = [[companyDesContentLab.text stringByAppendingString:@"\n \n "] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
        NSInteger introductionHeight=size2.height;
        companyDesContentLab.frame = CGRectMake(companyDesContentLab.frame.origin.x, companyDesContentLab.frame.origin.y, companyDesContentLab.frame.size.width, introductionHeight + 10);
        [companyDesContentLab sizeToFit];
        bgBottomView.frame = CGRectMake(bgBottomView.frame.origin.x, bgBottomView.frame.origin.y, bgBottomView.frame.size.width, introductionHeight + 10);
        scrollbgView.contentSize = CGSizeMake(iPhone_width,150 + introductionHeight0 + introductionHeight + introductionHeight1 + 20);
    }
    return self;
}
@end







