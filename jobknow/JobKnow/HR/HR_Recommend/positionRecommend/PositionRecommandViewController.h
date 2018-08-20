//
//  PositionRecommandViewController.h
//  FreeChat
//
//  Created by WangJinyu on 7/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "BaseViewController.h"

@interface PositionRecommandViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
 OLGhostAlertView * ghostView;
}
@property (nonatomic, strong) NSString *comNameStr;
@property (nonatomic, strong) NSDictionary *dataDic;

@end
