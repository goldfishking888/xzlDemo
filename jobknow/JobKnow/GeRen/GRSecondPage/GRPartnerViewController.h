//
//  GRPartnerViewController.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/22.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"

@interface GRPartnerViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic) BOOL isFullHeight;

@property (strong,nonatomic) XZLNoDataView *noDateView; //没有数据，哭脸

@end
