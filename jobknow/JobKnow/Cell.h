//
//  Cell.h
//  Cell-Demo
//
//  Created by king on 13-4-10.
//  Copyright (c) 2013年 jiazuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell

@property(nonatomic,retain)UIImageView *arrowImageView;
@property(nonatomic,retain)UIImageView *myImg;
@property (nonatomic,retain)UILabel *titleLabel;
- (void)changeArrowWithUp:(BOOL)up;
@end
