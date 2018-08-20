//
//  GRResumeEditTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRResumeEditTableViewCellDelegate <NSObject>
@optional
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath;
@end

@interface GRResumeEditTableViewCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)setTitleValue:(NSString *)labelValue;
-(void)setLabelValue:(NSString *)labelValue DefaultValue:(NSString *)defaultValue;
-(void)setTextFieldValue:(NSString *)labelValue DefaultValue:(NSString *)defaultValue;
-(void)setSepLineHidden:(BOOL)hidden;

@property(nonatomic,strong) id<GRResumeEditTableViewCellDelegate>delegate;

@end
