//
//  SearchResultCell.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/19.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SearchResultCell.h"

#define cellHeight 110

@interface SearchResultCell(){
    UILabel * positionTitleLab;
    UILabel * label_income;
    UILabel * label_isfast;
    UILabel * salaryLab;
    UILabel * companyLab;
    UILabel * contentLab;
    UIView *view_line;
}
@end
@implementation SearchResultCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    
    
    positionTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, iPhone_width - 155, 20)];
    positionTitleLab.text = @"";
    positionTitleLab.textAlignment = NSTextAlignmentLeft;
    positionTitleLab.textColor = RGBA(74, 74, 74, 1);
//    positionTitleLab.backgroundColor = [UIColor greenColor];
    positionTitleLab.font = [UIFont systemFontOfSize:18];
    [self addSubview:positionTitleLab];
    
    label_isfast = [[UILabel alloc] initWithFrame:CGRectMake(iPhone_width - 123, 22, 18, 18)];
    label_isfast.tag = 13;
    label_isfast.font = [UIFont systemFontOfSize:13];
    label_isfast.textColor = RGB(255, 255, 255);
    label_isfast.textAlignment = NSTextAlignmentCenter;
    label_isfast.layer.cornerRadius = 2;
    label_isfast.layer.masksToBounds = YES;
    label_isfast.hidden = YES;
    [self addSubview:label_isfast];
    
    label_income = [[UILabel alloc] initWithFrame:CGRectMake(label_isfast.frame.origin.x  + label_isfast.frame.size.width + 4, 22, 32, 18)];
    label_income.tag = 13;
    label_income.font = [UIFont systemFontOfSize:13];
    label_income.textColor = RGB(255, 255, 255);
    label_income.textAlignment = NSTextAlignmentCenter;
    label_income.backgroundColor = RGB(252, 83, 102);
    label_income.hidden = YES;
    label_income.text = @"收益";
    label_income.layer.cornerRadius = 2;
    label_income.layer.masksToBounds = YES;
    [self addSubview:label_income];
    
    salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(label_income.frame.origin.x + label_income.frame.size.width + 3, 23.5, 65, 15.5)];
    salaryLab.text = @"";
//    salaryLab.backgroundColor = [UIColor greenColor];
    salaryLab.textAlignment = NSTextAlignmentLeft;
    salaryLab.textColor = RGBA(252, 83, 102, 1);
    salaryLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:salaryLab];
    
    companyLab = [[UILabel alloc]initWithFrame:CGRectMake(positionTitleLab.frame.origin.x, positionTitleLab.frame.origin.y + positionTitleLab.frame.size.height + 15, 260, 15)];
    companyLab.text = @"";
    companyLab.textColor = RGBA(74, 74, 74, 1);
    companyLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:companyLab];
    
    contentLab = [[UILabel alloc]initWithFrame:CGRectMake(companyLab.frame.origin.x, companyLab.frame.origin.y + companyLab.frame.size.height + 15, 260, 15)];
    contentLab.text = @"";
    contentLab.textColor = RGBA(153, 153, 153, 1);
    contentLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:contentLab];
    
    view_line = [[UIView alloc] initWithFrame:CGRectMake(7, cellHeight-1, kMainScreenWidth-7, 1)];
    view_line.backgroundColor = RGB(239, 239, 239);
    view_line.hidden = YES;
    [self addSubview:view_line];
}

-(void)setDataWithModel:(SearchResultModel *)model
{
    view_line.hidden = NO;
    salaryLab.hidden = NO;
    label_isfast.hidden = NO;
    label_income.hidden = NO;
    positionTitleLab.text = model.position_name;
    //typeImageV
    NSString * strOld = model.earnings_total;
    label_income.text = @"收益";
    label_income.backgroundColor = RGB(252, 83, 102);
    if (strOld.length == 0||[strOld isEqualToString:@"0"]) {
        label_income.text = @"";
        label_income.backgroundColor = [UIColor clearColor];
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
    }
    companyLab.text = [NSString stringWithFormat:@"%@",model.company_name];
    if ([model.is_fast intValue] == 1) {
        label_isfast.backgroundColor = RGB(252, 83, 102);
        label_isfast.text = @"急";
    }else{
        label_isfast.backgroundColor = [UIColor clearColor];
        label_isfast.text = @"";
    }
    
    NSString * salaryStr = [XZLUtil getSalaryRangeWithSalaryCode:[NSString stringWithFormat:@"%d",[model.salary intValue]]];
    NSString * workYearStr = [XZLUtil getWorkYearsWithWorkYearCode:[NSString stringWithFormat:@"%d",[model.work_years intValue]]];
    NSString * degreeStr = [XZLUtil getDegreeStrWithDegreeCode:[NSString stringWithFormat:@"%d",[model.degree intValue]]];
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
    if (model.position_area != nil) {
        str2 = [NSString stringWithFormat:@"%@%@%@",model.position_area.length == 0 ? @"":@"| ",model.position_area,model.position_area.length == 0 ? @"":@" "];
    }
    
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:workYearStr
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, workYearStr.length)];
    if (tNumMatchCount==0) {
        workYearStr = @"经验不限";
    }
    if (workYearStr != nil) {
        str3 = [NSString stringWithFormat:@"%@%@ ",@"| ",workYearStr.length == 0 ? @"经验不限":workYearStr];
    }
    if (degreeStr != nil) {
        str4 = [NSString stringWithFormat:@"%@%@",@"| ",degreeStr.length == 0 ? @"学历不限":degreeStr];
    }
    contentLab.text = [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//    NSString * str_begin = @"";
//    NSString * str_end = @"";
//    if (strOld.length >= 4 || [strOld containsString:@"000"]) {
//        NSArray *temp=[strOld componentsSeparatedByString:@"-"];
//        NSLog(@"%@",[temp description]);
//        if (temp.count == 1) {
//            str_begin = [NSString stringWithFormat:@"%dk",([temp[0] intValue] / 1000)];
//            str_end = @"";
//        }else if (temp.count == 2)
//        {
//            str_begin = [NSString stringWithFormat:@"%dk",([temp[0] intValue] / 1000)];
//            str_end = [NSString stringWithFormat:@"-%dk",([temp[1] intValue] / 1000)];
//        }
//    if ([strOld containsString:@"000000"]) {
//        strOld = [strOld stringByReplacingOccurrencesOfString:@"000000" withString:@"000k"];
//    }else if ([strOld containsString:@"00000"]) {
//        strOld = [strOld stringByReplacingOccurrencesOfString:@"00000" withString:@"00k"];
//    }else if ([strOld containsString:@"0000"]) {
//        strOld = [strOld stringByReplacingOccurrencesOfString:@"0000" withString:@"0k"];
//    }else{
//        strOld = [strOld stringByReplacingOccurrencesOfString:@"000" withString:@"k"];
//        strOld = [strOld stringByReplacingOccurrencesOfString:@"999" withString:@"k"];
//    }
@end
