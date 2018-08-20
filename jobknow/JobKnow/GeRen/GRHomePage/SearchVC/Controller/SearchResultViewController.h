//
//  SearchResultViewController.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/19.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultViewController : BaseViewController
@property (strong,nonatomic) XZLNoDataView *noDateView; //没有数据，哭脸

@property (nonatomic,strong)NSString * searchKey;
@end
