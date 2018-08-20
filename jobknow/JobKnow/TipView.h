//
//  TipView.h
//  JobKnow
//
//  Created by faxin sun on 13-4-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TipViewDelegate
@optional
- (void)recordTimeOut;
- (void)leftBtnAndRightClick;
- (void)clickPlayBtn:(BOOL)py;
- (void)rightBtnAndRightClick;
@end
@interface TipView : UIView
{
    UIView *infoView;
    
}
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *load;
@property (nonatomic, strong) UIActivityIndicatorView *actiview;//jiazai
@property (nonatomic, strong) UIButton *play;
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, assign) id <TipViewDelegate> delegate;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *leftBtn;//取消
@property (nonatomic, strong) UIButton *rightBtn;//发送
@property (nonatomic, strong) UILabel *s;//秒计时
@property (nonatomic, assign) NSInteger time;//
@property (nonatomic, assign) BOOL p;
+ (TipView *)defaultStander;
- (void)show;
- (void)hidden;
//- (void)recordTime;

- (id)initWithTitleLoad;
- (id)initFinishRecord;

- (double)widthWithString:(NSString *)str width:(double)width;
//显示
- (void)showTipView;
//消失
- (void)dismiss;
- (void)showPlay;

@end
