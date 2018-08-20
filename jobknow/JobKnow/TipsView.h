//
//  TipsView.h
//  TestStatic
//
//  Created by faxin sun on 13-5-3.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsView : UIView

@property (nonatomic, strong) UILabel *label;
+ (TipsView *)standerDefault;

- (void)showTipString:(NSString *)string;
- (void)bounceOutAnimationStoped;
@end
