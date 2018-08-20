//
//  XZLPickerTool.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/17.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XZLPickerDidSelectBlock)(NSString *strValue);

@interface XZLPickerTool : UIPickerView

+ (void)show:(NSArray<NSArray<NSString *> *> *)datas didSelectBlock:(XZLPickerDidSelectBlock)didSelectBlock;

+ (void)showYearAndMonthWithIsEnd:(BOOL)isEnd dateStringSelected:(NSString *)dateString didSelectBlock:(XZLPickerDidSelectBlock)didSelectBlock;


@end
