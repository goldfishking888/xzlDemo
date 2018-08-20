//
//  NSObject+ModelHelper.h
//  Wawa
//
//  Created by Alik on 14-8-12.
//  Copyright (c) 2014年 Alik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ModelHelper)

-(id)initWithDictionary:(NSDictionary *)dic;

- (NSArray*)propertyKeys;

- (BOOL)reflectDataFromOtherObject:(NSDictionary *)dic;

-(NSDictionary *)convertModelToDictionary;

//-(NSString *)reflectNSObjectToNSString:(NSObject *)obj;

- (id) createInstanceByClassName: (NSString *)className;
@end
