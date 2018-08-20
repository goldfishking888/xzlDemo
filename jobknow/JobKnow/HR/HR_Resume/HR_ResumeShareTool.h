//
//  HR_ResumeShareTool.h
//  JobKnow
//
//  Created by Suny on 15/8/12.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRReumeModel.h"

@interface HR_ResumeShareTool : NSObject

@property (atomic,strong) NSMutableArray *array_Resume;

@property (atomic,strong) NSMutableArray *array_JobSort;

@property (atomic) int resumeCount;

+(HR_ResumeShareTool *)defaultTool;

//清空
-(void)clearData;

//添加数据
-(void)addArray:(NSMutableArray *)array;

//添加jobSort数据
-(void)addJobArray:(NSMutableArray *)array;

//删除简历
-(void)deleteResumeWithModel:(HRReumeModel *)model;

-(BOOL)haveData;

@end
