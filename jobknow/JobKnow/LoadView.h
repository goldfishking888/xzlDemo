//
//  LoadView.h
//  JobKnow
//
//  Created by faxin sun on 13-5-22.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *activityView;


- (void)show;
- (void)hidden;
@end
