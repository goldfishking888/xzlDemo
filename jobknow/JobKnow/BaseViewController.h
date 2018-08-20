//
//  BaseViewController.h
//  JobKnow
//
//  Created by Zuo on 13-8-9.
//  Copyright (c) 2013年 zuojia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    BOOL isRead;
    UILabel *titleLabel;
    UILabel *titleLabel1;
    UILabel *titleLabel2;
    UILabel *titleLabel3;
}
@property (strong, nonatomic, readonly) UIButton *rightBtn;
@property (nonatomic,assign) int num;

@property (nonatomic,strong) UIButton *backBtn;

//这个是一般的返回按钮
- (void)addRightkBtn:(NSString*)imageName;

- (void)addRightkBtnGR:(NSString*)name;
//右边title可变
- (void)setRightBtnTitle:(NSString *)title;
#pragma mark - 增加仅为图标的leftBarBtnItem
- (void)addBarButtonItemWithLeftImageName:(NSString *)imageNameLeftStr WithX:(float)X WithWidth:(float)Width WithHeight:(float)Height;
#pragma mark - 增加仅为图标的rightBarBtnItem
- (void)addRightBarBtnItem:(NSString*)imageNameRightStr WithXtoRight:(float)X WithWidth:(float)Width WithHeight:(float)Height;

- (void)addBackBtn;  //添加返回按钮
- (void)addBackBtnGR;//个人版返回（灰色）

- (void)addBackBtnGROnly;  //添加返回按钮;
- (void)addBackBtnGRWithText;//个人版返回带“返回”文字
- (void)configHeadView;//添加headView

- (void)configHeadViewGR;//个人导航栏白色

- (void)configHeadView:(UIColor *)color;

- (void)changeTExt:(NSString *)str secText:(NSString *)str2;

-(void)addTitleLabelGR:(NSString*)title;

- (void)addTitleLabel:(NSString*)title;
-(void)addTitleLabel:(NSString*)title color:(UIColor *)color;
- (void)addHomeTitleLabel:(NSString*)title secTitle:(NSString *)str;
- (void)addQuanchengTitleLabel:(NSString*)title secTitle:(NSString *)str;

- (UILabel *)addTitleLabel3:(NSString*)title;

- (void)addCenterTitle:(NSString *)titleString;//添加居中的标题（最多9个字）
- (void)addRightButtonWithTitle:(NSString *)title;//添加文字形式的右按钮

- (void)addRightButtonWithTitle:(NSString *)title Color:(UIColor *)color;
- (void)addRightButtonWithTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font;


@end
