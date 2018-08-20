//
//  HRjobListmodel.m
//  JobKnow
//
//  Created by Mathias on 15/7/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRjobListmodel.h"

@implementation HRjobListmodel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self=[super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        
    }
    
    
    return self;
    
    
    
}

+(instancetype)modelWithDict:(NSDictionary *)dict{
    
    
    return [[self alloc]initWithDict:dict];
    
    
    
}
//重写set方法
-(void)setWorkArea:(NSString *)workArea{
    
    if (_workArea!=workArea) {
        _workArea=[workArea copy];
    }
    
      self.detailSize = [_workArea boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    
    
}
-(void)setNewfee:(NSString *)newfee{
    
    if (_newfee!=newfee) {
        _newfee=[newfee copy];
    }
    
    self.newfeeSize = [_newfee boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    
    
    
    
    
}

-(void)setRequired:(NSString *)required{
    
    if (_required!=required) {
        _required=[required copy];
    }
    
    self.requestSize = [_required boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    NSString*str=NSStringFromCGSize(self.requestSize);
    
    NSLog(@"职位要求的长度%@",str);
    
    
}





@end
