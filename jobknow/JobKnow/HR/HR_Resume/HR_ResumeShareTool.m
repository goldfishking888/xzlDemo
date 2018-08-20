//
//  HR_ResumeShareTool.m
//  JobKnow
//
//  Created by Suny on 15/8/12.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeShareTool.h"
#import "HRReumeModel.h"
#import "HRJobSortModel.h"

static HR_ResumeShareTool *defaultTool;

@implementation HR_ResumeShareTool


+(HR_ResumeShareTool *)defaultTool{
    if (!defaultTool) {
        defaultTool = [[HR_ResumeShareTool alloc] init];
        defaultTool.array_Resume = [[NSMutableArray alloc] init];
        defaultTool.array_JobSort = [[NSMutableArray alloc] init];
    }
    return defaultTool;
}

-(BOOL)haveData{
    if (defaultTool.array_Resume) {
        if ([defaultTool.array_Resume count]>0) {
            return YES;
        }
    }
    
    return NO;
}

-(void)clearData{
    if (defaultTool.array_Resume) {
        [defaultTool.array_Resume removeAllObjects];
    }
    if (defaultTool.array_JobSort) {
        [defaultTool.array_JobSort removeAllObjects];
    }
}

-(void)addArray:(NSMutableArray *)array{
    if (defaultTool.array_Resume) {
//        for (HRReumeModel *item in array) {
//            [defaultTool.array_Resume addObject:item];
//        }
        
        defaultTool.array_Resume = [NSMutableArray arrayWithArray:[array copy]];
    }
}

-(void)deleteResumeWithModel:(HRReumeModel *)model{
    if (defaultTool.array_Resume) {
        //        for (HRReumeModel *item in array) {
        //            [defaultTool.array_Resume addObject:item];
        //        }
        for (HRReumeModel *item in defaultTool.array_Resume) {
            if ([[NSString stringWithFormat:@"%@",model.Id] isEqualToString:[NSString stringWithFormat:@"%@",item.Id]]) {
                [defaultTool.array_Resume removeObject:item];
                defaultTool.resumeCount -= 1;
                return;
            }
        }
    }
}

-(void)addJobArray:(NSMutableArray *)array{
    if (defaultTool.array_JobSort) {
//        for (HRJobSortModel *item in array) {
//            [defaultTool.array_JobSort addObject:item];
//        }
        defaultTool.array_JobSort = [NSMutableArray arrayWithArray:[array copy]];
    }
}

@end
