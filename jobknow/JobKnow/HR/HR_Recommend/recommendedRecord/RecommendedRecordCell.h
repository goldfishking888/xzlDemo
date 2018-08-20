//
//  RecommendedRecordCellTableViewCell.h
//  FreeChat
//
//  Created by WangJinyu on 7/08/2015.
//  Copyright (c) 2015 Feng WangJinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendedRecordViewController.h"

@interface RecommendedRecordCell : UITableViewCell

@property (nonatomic, assign) RecommendedRecordViewController *vc;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSString *isLine;
@property (nonatomic) NSInteger viewTag;

@end
