//
//  ActivetView.h
//  JobKnow
//
//  Created by faxin sun on 13-3-14.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivetView : UIView

/*UIActivityIndicatorView是活动指示器*/
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *title;
- (void)show:(NSString *)text;
- (void)hidden;
@end
