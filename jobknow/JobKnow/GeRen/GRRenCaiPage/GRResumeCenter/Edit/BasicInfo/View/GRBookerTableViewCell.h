//
//  GRBookerTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRBookerModel.h"

@interface GRBookerTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic) BOOL isEditting;

-(void)setModel:(GRBookerModel *)model;

@end
