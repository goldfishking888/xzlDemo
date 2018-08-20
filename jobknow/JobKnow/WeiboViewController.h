//
//  WeiboViewController.h
//  JobKnow
//
//  Created by king on 13-5-2.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "WBShareKit.h"
@interface WeiboViewController : UIViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate,sharWeibo>
{
    UITextView *textView;
    NSString *str;
    UIImageView *imgView;
    OLGhostAlertView *olghostView;
    SinaWeibo *sinaweibo;
     BOOL isfasong;
}
@property (nonatomic,copy)NSString *title;
@property (nonatomic,retain)NSString *shareStr;
@property (nonatomic,retain)UIScrollView *myScro;
@end
