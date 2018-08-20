//
//  pingjiaViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol miaosuDeleat<NSObject>
@optional
- (void)miashuZiShu:(NSString *)str destring:(NSString *)des;
- (void)wanzhengFou:(NSString *)str;
- (void)bianqian:(NSString *)str;
@end

@interface pingjiaViewController : BaseViewController<UITextViewDelegate,SendRequest>
{
    UIImageView *tableViewImage;
    MBProgressHUD *loadView;
}
@property (nonatomic,retain)UITextView *textView;
@property (nonatomic,retain)NSString *trpe;
@property (nonatomic,copy) NSString *contentString;
@property (nonatomic,retain)id<miaosuDeleat>deleat;
@end
