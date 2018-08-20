//
//  GRBookerConditionTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/18.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRBookerConditionTableViewCellDelegate <NSObject>
@optional
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath;
@end

@interface GRBookerConditionTableViewCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)setTitleValue:(NSString *)labelValue;
-(void)setLabelValue:(NSString *)labelValue DefaultValue:(NSString *)defaultValue;
-(void)setTextFieldValue:(NSString *)labelValue DefaultValue:(NSString *)defaultValue;
@property(nonatomic,strong) id<GRBookerConditionTableViewCellDelegate>delegate;
@end
