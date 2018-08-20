//
//  HRHomeCell.m
//  JobKnow
//
//  Created by WangJinyu on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//
#define Font1 17
#define Font3 14
#define Font2 11

#import "HRHomeCell.h"
@interface HRHomeCell()
{
    int numOfcollection;
    int numOfChangeCollection;
}
@end
@implementation HRHomeCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(6.0f, 0, iPhone_width - 12.0f, 125.0f)];
    bgImageV.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImageV];
    //20 30 400
    nameLabel = [MyControl createLableFrame:CGRectMake(10.0f, 15.0f, 160.0f, Font1 + 2) font:Font1 title:@"业务员"];
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLabel.font = [UIFont boldSystemFontOfSize:Font1];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:nameLabel];
    
    hrRecCountLabel = [MyControl createLableFrame:CGRectMake(10.0f, 15.0f, 160.0f, Font2 + 2) font:Font2 title:@""];
    hrRecCountLabel.numberOfLines = 1;
    hrRecCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    hrRecCountLabel.font = [UIFont boldSystemFontOfSize:Font2];
    hrRecCountLabel.textColor = [UIColor orangeColor];
    hrRecCountLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:hrRecCountLabel];
    
    NSString *money = @"0元";
    CGSize moneySize = [money sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Font3]}];
    
    //@"bonus_job_list"
    moneyBtn = [MyControl createButtonFrame:CGRectMake(bgImageV.frame.size.width - moneySize.width-40 - 20, nameLabel.frame.origin.y, 20 + moneySize.width, 20) bgImageName:nil image:nil title:nil method:nil target:self];
    moneyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    moneyBtn.titleLabel.font = [UIFont systemFontOfSize:Font3];
    [bgImageV addSubview:moneyBtn];
    
    companyLabel = [MyControl createLableFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, 220, Font2) font:Font2 title:@"青岛英网资讯股份有限公司"];
    companyLabel.textColor = RGBA(142, 142, 142, 1);
    [companyLabel setBackgroundColor:[UIColor clearColor]];
    companyLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:companyLabel];
    
    addressLabel = [MyControl createLableFrame:CGRectMake(nameLabel.frame.origin.x, companyLabel.frame.origin.y + companyLabel.frame.size.height + 7, 150, Font2) font:Font2 title:@"青岛  2人"];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    addressLabel.textColor = RGBA(142, 142, 142, 1);
    [bgImageV addSubview:addressLabel];
    
    timeLabel = [MyControl createLableFrame:CGRectMake(bgImageV.frame.size.width - 170, addressLabel.frame.origin.y, 160, Font2) font:Font2 title:@"2015-08-04"];
    timeLabel.textColor = RGBA(142, 142, 142, 1);
    timeLabel.textAlignment = NSTextAlignmentRight;
    [bgImageV addSubview:timeLabel];
    
    lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, bgImageV.frame.size.height - 40, bgImageV.frame.size.width - 20, 0.5)];
    lineImageV.backgroundColor = RGBA(237, 237, 237, 1);
    [bgImageV addSubview:lineImageV];
    
    collectImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width / 3 * 0 + 10, bgImageV.frame.size.height - 30, 17, 17)];
    collectImageV.image = [UIImage imageNamed:@"hr_fav_n"];
    [bgImageV addSubview:collectImageV];
    
    collectCountLabel = [MyControl createLableFrame:CGRectMake(collectImageV.frame.origin.x + collectImageV.frame.size.width + 7, bgImageV.frame.size.height - 27, 50, Font2) font:Font2 title:@"收藏"];
    collectCountLabel.textColor = RGBA(142, 142, 142, 1);
    [bgImageV addSubview:collectCountLabel];
    
    introduceImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width / 2 - 20, collectImageV.frame.origin.y, collectImageV.frame.size.width, collectImageV.frame.size.width)];
    introduceImageV.image = [UIImage imageNamed:@"hr_refer"];
    [bgImageV addSubview:introduceImageV];
    
    introduceCountLabel = [MyControl createLableFrame:CGRectMake(introduceImageV.frame.origin.x + introduceImageV.frame.size.width + 7, bgImageV.frame.size.height - 27, 50, Font2) font:Font2 title:@"推荐"];
    introduceCountLabel.textColor = RGBA(142, 142, 142, 1);
    [bgImageV addSubview:introduceCountLabel];
    
    lookImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width - 60, collectImageV.frame.origin.y, collectImageV.frame.size.width, collectImageV.frame.size.width)];
    lookImageV.image = [UIImage imageNamed:@"hr_view"];
    [bgImageV addSubview:lookImageV];
    
    lookCountLabel = [MyControl createLableFrame:CGRectMake(lookImageV.frame.origin.x + lookImageV.frame.size.width + 7, bgImageV.frame.size.height - 27, 50, Font2) font:Font2 title:@"查看"];
    lookCountLabel.textColor = RGBA(142, 142, 142, 1);
    [bgImageV addSubview:lookCountLabel];
    
    UIButton * collectBtn = [MyControl createButtonFrame:CGRectMake(0, bgImageV.frame.size.height - 40, iPhone_width / 3, 40) bgImageName:nil image:nil title:nil method:@selector(collectionClick) target:self];
    [bgImageV addSubview:collectBtn];
    
    UIButton * introduceBtn = [MyControl createButtonFrame:CGRectMake(iPhone_width / 3, bgImageV.frame.size.height - 40, iPhone_width / 3, 40) bgImageName:nil image:nil title:nil method:@selector(introduceClick) target:self];
    [bgImageV addSubview:introduceBtn];
    
}
-(void)collectionClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(CollectionClick:)]) {
        [_delegate CollectionClick:self.IndexPath];
        //withIfCollectBool:self.BoolOfCollected
    }
}
-(void)introduceClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(introduceClick:)]) {
        [_delegate introduceClick:self.IndexPath];
    }
}

#pragma mark - 收藏改变图标,label数的加减.
-(void)changeCollectionImagewithNumber:(int)number
{
    
    if (number == 1) {//如果已收藏,则改成未收藏
        
        collectImageV.image = [UIImage imageNamed:@"hr_fav_n"];
        collectCountLabel.text = [NSString stringWithFormat:@"%d",numOfcollection];
    }
    else
    {
        collectImageV.image = [UIImage imageNamed:@"hr_fav_y"];
        collectCountLabel.text = [NSString stringWithFormat:@"%d",numOfcollection + 1];
    }
}
-(void)configData:(HRHomeIntroduceModel *)model withIndexPath:(NSIndexPath *)IndexPaTH
{
//    NSString *count = [NSString stringWithFormat:@"%@",model.hrRecommendTotal];
//    if([count isEqualToString:@"0"]||!count||[count isEqualToString:@""]){
//        bgImageV.frame = CGRectMake(6.0f, 0, iPhone_width - 12.0f, 125.0f);
//        hrRecCountLabel.text = @"";
//    }else{
//        bgImageV.frame = CGRectMake(6.0f, 0, iPhone_width - 12.0f, 145.0f);
//        hrRecCountLabel.frame = CGRectMake(10, bgImageV.frame.size.height-25, iPhone_width - 12.0f, Font2+2);
//        hrRecCountLabel.text =[NSString stringWithFormat:@"该企业HR累计推荐简历数:%@",count];
//    }
    
    if (IndexPaTH.row % 4 == 0)
    {
        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_orange"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
    }
    else if (IndexPaTH.row % 4 == 1)
    {
        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_green"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
    }
    else if (IndexPaTH.row % 4 == 2)
    {
        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_pink"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
    }
    else
    {
        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_blue"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
    }
    
    [feeImageV removeFromSuperview];
    [moneyBtn removeFromSuperview];
    nameLabel.text = model.jobName;
    
    feeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width - 12-40, 16, 40, 16)];
    [bgImageV addSubview:feeImageV];
    feeImageV.image = [UIImage imageNamed:@"ic_senior"];
    [moneyBtn setHidden:YES];
//    if ([model.senior_type isEqualToString:@"1"]) {
//        feeImageV.image = [UIImage imageNamed:@"icon_pay_resume"];
//        [moneyBtn setHidden:YES];
//    }else{
//        feeImageV.image = [UIImage imageNamed:@"ic_senior"];
//        [moneyBtn setHidden:NO];
//    }
    
    
    
    NSString * MoneyStr = [NSString stringWithFormat:@"%@元",model.newfee];
    CGSize moneySize = [MoneyStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:Font3]}];
    //@"bonus_job_list"
    moneyBtn.frame = CGRectMake(bgImageV.frame.size.width - moneySize.width -feeImageV.frame.size.width - 30, nameLabel.frame.origin.y, 20 + moneySize.width, 20);
    [moneyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    if ([[NSString stringWithFormat:@"%@",model.newfee] hasSuffix:@"以上"]) {
        [moneyBtn setTitle:[NSString stringWithFormat:@"%@元以上",[[NSString stringWithFormat:@"%@",model.newfee] substringToIndex:[model.newfee length]-2]] forState:UIControlStateNormal];
    }else{
        [moneyBtn setTitle:[NSString stringWithFormat:@"%@元",model.newfee] forState:UIControlStateNormal];
    }
    
    [bgImageV addSubview:moneyBtn];
    
    
    
    companyLabel.text = model.companyName;
    addressLabel.text = [NSString stringWithFormat:@"%@  %@人",model.workArea,model.counts];
    timeLabel.text = [NSString stringWithFormat:@"截止日期:%@",model.stopTime];
    //recommendNum = 7; viewNum = 17; favorites = 0; favNum = 0;
    if ([model.isfavorites intValue] == 0) {//未收藏过
        collectImageV.image = [UIImage imageNamed:@"hr_fav_n"];
    }
    else
    {
        collectImageV.image = [UIImage imageNamed:@"hr_fav_y"];
    }
    
    if ([model.favNum intValue] == 0)
    {
        collectCountLabel.text = @"收藏";
    }
    else
    {
        collectCountLabel.text = [NSString stringWithFormat:@"%@",model.favNum];
    }
    numOfcollection = [model.favNum intValue];
    if ([model.recommendNum intValue] == 0) {
        introduceCountLabel.text = @"推荐";
    }
    else
    {
    introduceCountLabel.text = [NSString stringWithFormat:@"%@",model.recommendNum];
    }
    if ([model.viewNum intValue] == 0) {
        lookCountLabel.text = @"查看";
    }
    else
    {
    lookCountLabel.text = [NSString stringWithFormat:@"%@",model.viewNum];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
