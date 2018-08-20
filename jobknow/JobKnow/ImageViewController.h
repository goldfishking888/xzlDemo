//
//  ImageViewController.h
//  JobKnow
//
//  Created by liuxiaowu on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : BaseViewController<ASIProgressDelegate>
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *imageView;
@end
