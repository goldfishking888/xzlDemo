//
//  NowAnnotation.h
//  Map-demo
//
//  Created by king on 13-3-28.
//  Copyright (c) 2013年 ZJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,  copy) NSString *title;
@property (nonatomic,  copy) NSString *subtitle;
@end
