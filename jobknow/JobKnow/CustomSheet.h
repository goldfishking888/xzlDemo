//
//  CustomActionSheet.h
//  Bilin
//
//  Created by zhengfeng on 11-9-23.
//  Copyright 2011年 __Bilin__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CustomSheet : UIActionSheet {

    UIView* view;
    id toolbarDoneDelegate;
}
@property(nonatomic,retain)UIView* view;
@property(assign) id toolbarDoneDelegate;
-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title;
@end
