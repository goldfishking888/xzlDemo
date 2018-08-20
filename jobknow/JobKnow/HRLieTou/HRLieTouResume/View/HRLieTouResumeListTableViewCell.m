//
//  HRLieTouResumeListTableViewCell.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRLieTouResumeListTableViewCell.h"
#import "HRLieTouResumeListModel.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#define kMargLR 20

@implementation HRLieTouResumeListTableViewCell{
    
    UIView *view_back;
    UILabel *label_name;//name
    UILabel *label_binfo;//名字下方基本信息一栏
    UIView *view_line;//分割线
    
    
    UILabel *label_work;//work
    UILabel *label_status;//status
    UILabel *label_date;//date
    
    UIView *view_status_back;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    view_back = [[UIView alloc] init];
    mViewBorderRadius(view_back, 4, 1, RGB(232, 232, 232));
    [self.contentView addSubview:view_back];
    
    view_status_back = [[UIView alloc] init];
    view_status_back.backgroundColor = RGB(243, 243, 243);
    [view_back addSubview:view_status_back];
    
    label_name = [UILabel new];
    label_name.textAlignment = NSTextAlignmentLeft;
    label_name.textColor = [UIColor blackColor];
    label_name.font = [UIFont systemFontOfSize:18];
    [view_back addSubview:label_name];
    
    label_binfo = [UILabel new];
    label_binfo.textAlignment = NSTextAlignmentLeft;
    label_binfo.textColor = RGB(153, 153, 153);
    label_binfo.font = [UIFont systemFontOfSize:14];
    [view_back addSubview:label_binfo];
    
    label_work = [UILabel new];
    label_work.textAlignment = NSTextAlignmentLeft;
    label_work.textColor = RGB(74, 74, 74);
    label_work.font = [UIFont systemFontOfSize:14];
    [view_back addSubview:label_work];
    
    label_status = [UILabel new];
    label_status.textAlignment = NSTextAlignmentLeft;
    label_status.textColor = RGB(170, 170, 170);
    label_status.font = [UIFont systemFontOfSize:13];
    [view_status_back addSubview:label_status];
    
    label_date = [UILabel new];
    label_date.textAlignment = NSTextAlignmentRight;
    label_date.textColor = RGB(153, 153, 153);
    label_date.font = [UIFont systemFontOfSize:12];
    [view_back addSubview:label_date];
    
    view_back.sd_layout.widthIs(kMainScreenWidth-2*10).heightIs(148).leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 15);
    
    label_name.sd_layout.widthIs(view_back.width*2/3).heightIs(18).topSpaceToView(view_back, 20).leftSpaceToView(view_back,kMargLR);
    
    label_binfo.sd_layout.widthIs(view_back.width - kMargLR *2).heightIs(14).topSpaceToView(label_name, 16).leftSpaceToView(view_back,kMargLR);

    label_work.sd_layout.widthIs(view_back.width - kMargLR *2).heightIs(14).topSpaceToView(label_binfo, 15).leftSpaceToView(view_back,kMargLR);
    
    view_status_back.sd_layout.widthIs(view_back.width ).heightIs(36).topSpaceToView(view_back, view_back.height-36).leftSpaceToView(view_back,0);
    
    label_status.sd_layout.widthIs(view_status_back.width - kMargLR *2).heightIs(36).leftSpaceToView(view_status_back,kMargLR).topSpaceToView(view_status_back,0 );
    
    label_date.sd_layout.widthIs(view_back.width*2/3).heightIs(12).topSpaceToView(view_back, 26).rightSpaceToView(view_back, 17);
    
}


-(void)setModel:(HRLieTouResumeListModel *)model{
    _model = model;
    
//    _model.name = @"李静";
//    _model.city = @"青岛";
//    _model.salary = @"10K-12K";
//    _model.workYears = @"2年经验";
//    _model.degree = @"本科";
//    _model.work = @"后勤,人力资源,英语翻译";
//    _model.status = @"在职，有好的机会可以考虑";
//    _model.date_updated = @"2017-07-19";
    
    label_name.text = [NSString stringWithFormat:@"%@",_model.name];
    label_binfo.text = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",_model.city,_model.salary,_model.workYears,_model.degree];
    
    label_work.text = [NSString stringWithFormat:@"%@",_model.work];
    label_status.text = [NSString stringWithFormat:@"%@",_model.status];
    label_date.text = [NSString stringWithFormat:@"更新:%@",_model.date_updated];
    //***********************高度自适应cell设置步骤************************
    [self setupAutoHeightWithBottomView:view_status_back bottomMargin:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
