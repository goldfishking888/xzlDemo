//
//  Net.h
//  JobKnow
//
//  Created by faxin sun on 13-5-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface Net : NSObject
@property (nonatomic, assign) NetworkStatus status;
+ (Net *)standerDefault;
@end
