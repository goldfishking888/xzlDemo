//
//  XZLNoDataView.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/29.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZLNoDataView : UIView
{
    UILabel *label;
}

- (instancetype)initWithLabelString:(NSString *)string;
- (void)modifyLabelText:(NSString *)string;


@end
