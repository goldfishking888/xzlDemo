//
//  OtherLogin.h
//  ShouXi
//
//  Created by liuxiaowu on 13-8-3.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherLogin : NSObject
{
    OLGhostAlertView *ghostView;
}
@property (nonatomic,assign)BOOL isHrBool;
@property(nonatomic,assign)BOOL login;

+ (id)standerDefault;

- (void)otherAreaLogin;

@end
