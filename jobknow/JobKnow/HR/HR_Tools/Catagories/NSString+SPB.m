//
//  NSString+SPB.m
//  M_Music
//
//  Created by bianchx on 14-7-9.
//

#import "NSString+SPB.h"

@implementation NSString (SPB)

+(BOOL)isNullOrEmpty:(NSString *)str{
    return str == NULL || str == Nil || str == nil || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str isEqualToString:@"(null)"]||str.length == 0||!str;
}

-(BOOL)isNullOrEmpty{
    return [NSString isNullOrEmpty:self];
}

+(NSString *)urlEncoded:(NSString *)str
{
    NSString *result = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                          (CFStringRef)str, nil,
                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return result;
}

-(NSString *)urlEncoded
{
    return [NSString urlEncoded:self];
}

+(int)lenghtBySPBCount:(NSString *)str
{
    if([NSString isNullOrEmpty:str])
        return 0;
    
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength + 1)/2;
}

-(int)lenghtBySPBCount
{
    return [NSString lenghtBySPBCount:self];
}


+(NSString *)stringWithjoin:(NSString *)ctor strings:(NSArray *)strings
{
    if (strings == NULL || strings.count == 0) {
        return NULL;
    }
    
    if (strings.count == 1) {
        return [strings objectAtIndex:0];
    }
    
    NSString *str = [strings objectAtIndex:0];
    for (int i = 1; i < strings.count; i++) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@",ctor,[strings objectAtIndex:i]]];
    }
    
    return str;
}

@end
