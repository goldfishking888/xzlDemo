//
//  GRUploadResumeWebViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/9/6.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"

@interface GRUploadResumeWebViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *urlStr;

@end
