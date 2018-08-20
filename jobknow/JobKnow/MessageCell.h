//
//  MessageCell.h
//  JobKnow
//
//  Created by faxin sun on 13-4-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"
#import "EGOImageView.h"

@interface MessageCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(MessageListModel *)message;
@property (nonatomic ,strong) UILabel *jobName;
@property (nonatomic ,strong) UILabel *companyName;
@property (nonatomic ,strong) UILabel *cityName;
@property (nonatomic ,strong) UILabel *messageL;
@property (nonatomic ,strong) UILabel *date;
//@property (nonatomic ,strong) EGOImageView *head;
@property (nonatomic ,strong) UIImageView *head;
@property (nonatomic ,strong) UIButton *countBtn;

//- (void)secondDefaultInit:(MessageListModel *)message;

@end
