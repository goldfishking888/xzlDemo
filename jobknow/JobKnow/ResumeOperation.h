//
//  ResumeOperation.h
//  soundload
//
//  Created by liuxiaowu on 13-9-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumeOperation : NSObject

{
    NSString *resumePath;//文件路径
}

@property (nonatomic, strong) NSMutableDictionary *resumeDictionary;
+ (id)defaultResume;

- (NSMutableDictionary *)resumeDictionary;
//修改
- (void)setValue:(id)value forKey:(NSString *)key;
//添加
- (void)setObject:(id)object forKey:(NSString *)key;
//删除
- (void)removeObjectForKey:(id)key;

@end
