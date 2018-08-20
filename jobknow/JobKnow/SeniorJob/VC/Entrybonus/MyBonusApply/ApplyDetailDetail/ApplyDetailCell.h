//
//  ApplyDetailCell.h
//  JobKnow
//
//  Created by WangJinyu on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyDetailCell : UITableViewCell
{
    UIImageView * circleImageV;
    UILabel * contentLabel;
    UILabel * timeLabel;
}
@property (nonatomic,strong)NSString * applyTimeStrs;
-(void)config:(NSMutableDictionary *)dic withIndexPath:(NSIndexPath *)indexpath;
@end
