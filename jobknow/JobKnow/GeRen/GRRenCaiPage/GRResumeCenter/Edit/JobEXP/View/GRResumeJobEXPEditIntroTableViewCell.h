//
//  GRResumeJobEXPEditIntroTableViewCell.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GRResumeJobEXPEditIntroTableViewCellDelegate <NSObject>
@optional
- (void)contentDidChangeTo:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath;
@end

@interface GRResumeJobEXPEditIntroTableViewCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic,strong) id<GRResumeJobEXPEditIntroTableViewCellDelegate>delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic) NSInteger maxCount;

@property (nonatomic) BOOL hasNOCountLimit;

-(void)setTitleValue:(NSString *)labelValue;
-(void)setContent:(NSString *)content placeHolder:(NSString *)value;



@end
