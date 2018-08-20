//
//  ResumePrivacySettingTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GRResumePrivacyModel;

@class LanguageLevelModel;

@protocol ResumePrivacySettingTableViewCellDelegate <NSObject>
@optional
- (void)confirmTimeTFWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath;

@optional
- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface ResumePrivacySettingTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *label_title;

@property (nonatomic,strong) UIImageView *imageView_icon;

@property (nonatomic,strong) UITextField *tf_title;

@property (nonatomic,strong) UIView *view_line;

@property (nonatomic,strong) GRResumePrivacyModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)setModel:(GRResumePrivacyModel *)model indexPath:(NSIndexPath *)indexPath;

-(void)setModelLanEdit:(LanguageLevelModel *)model indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,strong) id<ResumePrivacySettingTableViewCellDelegate>delegate;

@end
