//
//  HRCollectionCell.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRCollectionCell.h"
#import "HRCollectionModel.h"
#define Font1 17
#define Font3 14
#define Font2 11
@interface HRCollectionCell()
{
    int numOfcollection;
    int numOfChangeCollection;
}
@end
@implementation HRCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
//    UIView * sepaV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 8)];
//    sepaV.backgroundColor = RGBA(243, 243, 243, 1);
//    [self addSubview:sepaV];
    bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, iPhone_width, 152)];
    bgImageV.userInteractionEnabled = YES;
    [self addSubview:bgImageV];
    //20 30 400
    nameLabel = [MyControl createLableFrame:CGRectMake(15, 22, kMainScreenWidth - 149 - 15, 20) font:Font1 title:@"业务员"];
    nameLabel.numberOfLines = 1;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLabel.font = [UIFont boldSystemFontOfSize:Font1];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageV addSubview:nameLabel];
    
    salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth - 110, 25, 100, 15)];
    salaryLab.text = @"3500-4500元";
    salaryLab.textAlignment = NSTextAlignmentLeft;
    salaryLab.textColor = RGBA(252, 83, 102, 1);
    salaryLab.font = [UIFont systemFontOfSize:15];
    [bgImageV addSubview:salaryLab];
    
    label_income = [[UILabel alloc] initWithFrame:CGRectMake(salaryLab.frame.origin.x - 36, 22, 32, 18)];
    label_income.tag = 13;
    label_income.font = [UIFont systemFontOfSize:13];
    label_income.textColor = RGB(255, 255, 255);
    label_income.textAlignment = NSTextAlignmentCenter;
    label_income.backgroundColor = RGB(252, 83, 102);
    label_income.text = @"收益";
    label_income.layer.cornerRadius = 2;
    label_income.layer.masksToBounds = YES;
    [bgImageV addSubview:label_income];
    
    label_isfast = [[UILabel alloc] initWithFrame:CGRectMake(label_income.frame.origin.x - 23, 22, 18, 18)];
    label_isfast.tag = 13;
    label_isfast.font = [UIFont systemFontOfSize:13];
    label_isfast.textColor = RGB(255, 255, 255);
    label_isfast.textAlignment = NSTextAlignmentCenter;
    label_isfast.layer.cornerRadius = 2;
    label_isfast.layer.masksToBounds = YES;
    [bgImageV addSubview:label_isfast];
    
    companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 15, 260, 15)];
    companyLabel.text = @"青岛微众在线科技有限公司";
    companyLabel.textColor = RGBA(74, 74, 74, 1);
    companyLabel.font = [UIFont systemFontOfSize:13];
    [bgImageV addSubview:companyLabel];
    
    addressLabel = [MyControl createLableFrame:CGRectMake(nameLabel.frame.origin.x, companyLabel.frame.origin.y + companyLabel.frame.size.height + 15, 150, Font2) font:Font2 title:@"青岛 | 2人"];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    addressLabel.textColor = RGBA(142, 142, 142, 1);
    [bgImageV addSubview:addressLabel];
    
    timeLabel = [MyControl createLableFrame:CGRectMake(bgImageV.frame.size.width - 175, addressLabel.frame.origin.y, 160, Font2) font:Font2 title:@"刷新日期:2015-08-04"];
    timeLabel.textColor = RGBA(142, 142, 142, 1);
    timeLabel.textAlignment = NSTextAlignmentRight;
    [bgImageV addSubview:timeLabel];
    
    //底部收藏的背景
    bottomImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, bgImageV.frame.size.height - 45, bgImageV.frame.size.width, 45)];
    bottomImageV.backgroundColor = RGBA(251, 251, 251, 1);
    [bgImageV addSubview:bottomImageV];
    
    collectImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width / 3 * 0 + 20, 13.5, 18, 18)];
    collectImageV.image = [UIImage imageNamed:@"hr_fav_n"];
    [bottomImageV addSubview:collectImageV];
    
    collectCountLabel = [MyControl createLableFrame:CGRectMake(collectImageV.frame.origin.x + collectImageV.frame.size.width + 7, 15, 50, 14) font:12 title:@"收藏"];
    collectCountLabel.textColor = RGBA(142, 142, 142, 1);
    [bottomImageV addSubview:collectCountLabel];
    
    introduceImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width / 2 - 20, collectImageV.frame.origin.y, collectImageV.frame.size.width, collectImageV.frame.size.width)];
    introduceImageV.image = [UIImage imageNamed:@"hr_refer"];
    [bottomImageV addSubview:introduceImageV];
    
    introduceCountLabel = [MyControl createLableFrame:CGRectMake(introduceImageV.frame.origin.x + introduceImageV.frame.size.width + 7, collectCountLabel.frame.origin.y, 50, 14) font:12 title:@"推荐"];
    introduceCountLabel.textColor = RGBA(142, 142, 142, 1);
    [bottomImageV addSubview:introduceCountLabel];
    
    lookImageV = [[UIImageView alloc]initWithFrame:CGRectMake(bgImageV.frame.size.width - 80, collectImageV.frame.origin.y, collectImageV.frame.size.width, collectImageV.frame.size.width)];
    lookImageV.image = [UIImage imageNamed:@"hr_view"];
    [bottomImageV addSubview:lookImageV];
    
    lookCountLabel = [MyControl createLableFrame:CGRectMake(lookImageV.frame.origin.x + lookImageV.frame.size.width + 7, collectCountLabel.frame.origin.y, 50, 14) font:12 title:@"查看"];
    lookCountLabel.textColor = RGBA(142, 142, 142, 1);
    [bottomImageV addSubview:lookCountLabel];
    
    UIButton * collectBtn = [MyControl createButtonFrame:CGRectMake(0, 0, iPhone_width / 3, 45) bgImageName:nil image:nil title:nil method:@selector(collectionClick) target:self];
    [bottomImageV addSubview:collectBtn];
    
    UIButton * introduceBtn = [MyControl createButtonFrame:CGRectMake(iPhone_width / 3, 0, iPhone_width / 3, 45) bgImageName:nil image:nil title:nil method:@selector(introduceClick) target:self];
    [bottomImageV addSubview:introduceBtn];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, bgImageV.bottom-1, kMainScreenWidth, 1)];
    viewLine.backgroundColor = RGB(231, 231, 231);
    [bgImageV addSubview:viewLine];
    
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
-(void)configData:(HRCollectionModel *)model withIndexPath:(NSIndexPath *)IndexPaTH
{
//    if (IndexPaTH.row % 4 == 0)
//    {
//        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_orange"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
//    }
//    else if (IndexPaTH.row % 4 == 1)
//    {
//        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_green"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
//    }
//    else if (IndexPaTH.row % 4 == 2)
//    {
//        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_pink"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
//    }
//    else
//    {
//        [bgImageV setImage:[[UIImage imageNamed:@"hr_item_blue"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:10.0f]];
//    }
    
    nameLabel.text = @"PHP工程师(3-5年)";//model.jobName;
    companyLabel.text = @"青岛微众在线网络科技有限公司";//model.companyName;
    addressLabel.text = [NSString stringWithFormat:@"%@ | %@人",model.workArea,model.counts];
    timeLabel.text = [NSString stringWithFormat:@"刷新日期:2015-08-04"];//@"刷新日期:%@",model.stopTime];
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
