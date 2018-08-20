//
//  XHPathConver.h
//  XHPathCover
//
//  Created by 曾 宪华 on 14-2-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

// user info key for Dictionary
extern NSString *const XHUserNameKey;
extern NSString *const XHQzStateKey;
extern NSString *const XHBirthdayKey;




@protocol changeHead <NSObject>
@optional
-(void)changeHeadViewf;
- (void)kaiguan;
@end

@interface XHPathCover : UIView<EGOImageViewDelegate>

// parallax background
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIImageView *bannerImageViewWithImageEffects;
@property (nonatomic,retain)id<changeHead>deleat;
// user info



@property (nonatomic, strong) UIButton *avatarButton; //头像下的按钮
@property (nonatomic,strong)  EGOImageView *headView;   //头像图片
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *birthdayLabel;
@property (nonatomic,strong)  UILabel *qzStateLab;

@property (nonatomic,strong)UIButton *statusBtn;

@property (nonatomic,assign)int num;


//scrollView call back
@property (nonatomic) BOOL touching;
@property (nonatomic) CGFloat offsetY;

// parallax background origin Y for parallaxHeight
@property (nonatomic, assign) CGFloat parallaxHeight; // default is 170， this height was not self heigth.

@property (nonatomic, assign) BOOL isZoomingEffect; // default is NO， if isZoomingEffect is YES, will be dissmiss parallax effect
@property (nonatomic, assign) BOOL isLightEffect; // default is YES
@property (nonatomic, assign) CGFloat lightEffectPadding; // default is 80
@property (nonatomic, assign) CGFloat lightEffectAlpha; // default is 1.12 (between 1 - 2)

@property (nonatomic, copy) void(^handleRefreshEvent)(void);

// stop Refresh
- (void)stopRefresh;

// background image
- (void)setBackgroundImage:(UIImage *)backgroundImage;
// custom set url for subClass， There is not work
- (void)setBackgroundImageUrlString:(NSString *)backgroundImageUrlString;

// avatar image
- (void)setAvatarImage:(UIImage *)avatarImage;
// custom set url for subClass， There is not work
- (void)setAvatarUrlString:(NSString *)avatarUrlString;

// set info, Example : NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:@"Jack", @"userName", @"1990-10-19", @"birthday", nil];
- (void)setInfo:(NSDictionary *)info;

//set 简历公开状态
- (void)setJianliState:(NSString *)state;



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
