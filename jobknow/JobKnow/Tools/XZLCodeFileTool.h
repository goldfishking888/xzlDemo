//
//  XZLCodeFileTool.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/23.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLCodeFileTool : NSObject
+(void)setSalaryCodeFileWithArray:(NSMutableArray *)array;

+(void)resetAllCode;

+ (void)checkCodeVersions;

//冒泡排序
+ (NSMutableArray *)bubbleSort:(NSMutableArray *)array;
@end
