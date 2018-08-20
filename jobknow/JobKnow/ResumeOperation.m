//
//  ResumeOperation.m
//  soundload
//
//  Created by liuxiaowu on 13-9-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ResumeOperation.h"

@implementation ResumeOperation
@synthesize resumeDictionary;

/************使用方法
 *ResumeOperation *resume = [ResumeOperation defaultResume];
 *[resume setObject:@"123" forKey:@"abc"];添加
 *[resume setValue:@"hrbanlv" forKey:@"xzl"];修改
 */

+ (id)defaultResume
{
    static ResumeOperation *resume = nil;
    if (resume == nil) {
        resume = [[ResumeOperation alloc] init];
        
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    name = [name stringByAppendingPathExtension:@"plist"];
    path = [path stringByAppendingPathComponent:name];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSLog(@"path-----------------------%@",path);
    [resume setResumeDictionaryPath:path];
    
    return resume;
}

- (void)setResumeDictionaryPath:(NSString *)path
{
    resumePath = path;
    resumeDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path] ;
}

- (NSMutableDictionary *)resumeDictionary
{
    resumeDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:resumePath];
    if (resumeDictionary.count == 0) {
        resumeDictionary = [NSMutableDictionary dictionary];
    }
    return resumeDictionary;
}

//修改
- (void)setValue:(id)value forKey:(NSString *)key
{
    id obj = [self.resumeDictionary valueForKey:key];
    if (obj) {
        [self.resumeDictionary setValue:value forKey:key];
        [resumeDictionary writeToFile:resumePath atomically:NO];
    }
}

//添加
- (void)setObject:(id)object forKey:(NSString *)key
{
    [self.resumeDictionary setObject:object forKey:key];
    [resumeDictionary writeToFile:resumePath atomically:NO];
}

//删除
- (void)removeObjectForKey:(id)key
{
    [self.resumeDictionary removeObjectForKey:key];
    [resumeDictionary writeToFile:resumePath atomically:NO];
}


@end
