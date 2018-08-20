//
//  ContactView.h
//  JobKnow
//
//  Created by faxin sun on 13-3-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@protocol JobDetailViewDelegate
@optional
- (void)enterTelMapEmail:(UIButton *)btn;
@end
@interface ContactView : UIView

@property (nonatomic, strong) UILabel *contact;
@property (nonatomic, strong) UILabel *contactPerson;
@property (nonatomic, strong) UILabel *tel;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *netAddress;
@property (nonatomic, strong) UILabel *email;

@end