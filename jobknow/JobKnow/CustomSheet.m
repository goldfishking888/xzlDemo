//
//  CustomActionSheet.m
//  Bilin
//
//  Created by zhengfeng on 11-9-23.
//  Copyright 2011年 __Bilin__. All rights reserved.
//

#import "CustomSheet.h"
@implementation CustomSheet
@synthesize view,toolbarDoneDelegate;
-(id)initWithHeight:(float)height WithSheetTitle:(NSString*)title
{
    self = [super init];
    if (self) 
    {
        self.title = @"\n\n\n\n\n\n\n\n\n\n\n\n";

        UIToolbar * _toolbar     = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *cancel   = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
        UIBarButtonItem *spaceFix = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        UIBarButtonItem *done     = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(done)] autorelease];
        
        
        _toolbar.items = [NSArray arrayWithObjects:cancel, spaceFix, done, nil];
        
        [self addSubview:_toolbar];
        [_toolbar release];
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
    }
    return self;
}



-(void)cancel
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)done
{
    [self.toolbarDoneDelegate performSelector:@selector(selectFilter)];
}
@end