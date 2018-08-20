//
//  KTSelectDatePicker.h
//  KTSelectDatePicker
//
//  Created by hcl on 15/10/9.
//  Copyright (c) 2015年 hcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTSelectPickerView.h"

typedef void (^DataTimeSelect)(NSDate *selectDataTime);

@interface KTSelectDatePicker : NSObject

- (instancetype)initWithMaxDate:(NSDate *)maxDate minDate:(NSDate *)minDate currentDate:(NSDate *)currentDate datePickerMode:(UIDatePickerMode)mode;
- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime;

@end
