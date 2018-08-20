//
//  WebConsole.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/1.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "WebConsole.h"

//WebConsole.m
@implementation WebConsole
+ (void) enable {
    [NSURLProtocol registerClass:[WebConsole class]];
}

+ (BOOL) canInitWithRequest:(NSURLRequest *)request {
    if ([[[request URL] host] isEqualToString:@"debugger"]){
        NSLog(@"%@", [[[request URL] path] substringFromIndex: 1]);
    }
    
    return FALSE;
}
@end
