//
//  MyTableCell.h
//  MyTableViewCell
//
//  Created by Ibokan on 12-10-14.
//  Copyright (c) 2012年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableCell : UITableViewCell

//******************************************************************************

//          自定义表格   直接用下面的属性就OK！    .m 设置好 他的坐标加载上cell就ok

//******************************************************************************



@property (nonatomic,retain)UIImageView * imagview;//cell左边的图片
@property (nonatomic,retain)UILabel * labname;//title




//**************************累计积分*************************************
@property (nonatomic,retain)UILabel *la_jifen;//积分
@property (nonatomic,retain)UILabel *la_laiyuan;//来源
@property (nonatomic,retain)UILabel *la_riqi;  //日期



/***************************简历自定义View**********************/
@property (nonatomic,retain)UILabel *alabel;

@end
