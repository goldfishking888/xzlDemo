//
//  XZLUtil.m
//  JobKnow
//
//  Created by Jiang on 15/8/22.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "XZLUtil.h"
#import "JPUSHService.h"
#import "SSKeychain.h"
#import "OpenUDID.h"
#import "sys/utsname.h"
#import "GRReadModel.h"

#import "CityModel.h"

#define SALARY @"file_salary"
#define WORKYEAR @"file_workyear"
#define COMPANYCROP @"file_companycrop"
#define COMPANYSIZE @"file_companysize"
#define MARRIAGE @"file_marriage"
#define DEGREE @"file_degree"
#define WORKCROP @"file_workcrop"
#define NOWSTATUS @"file_nowstatus"
#define COMPLAIN @"file_complain"

@implementation XZLUtil

#pragma mark IMEI

+ (NSString *)currentVersion
{
    //获取当前应用版本号
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return [appInfo objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getIMEI{
    NSString *imei = [SSKeychain passwordForService:@"xZhiLiao" account:@"IEMI"];
    if (imei && imei.length > 0) {
        return imei;
    }else{
        imei = [OpenUDID value];
        [SSKeychain setPassword:imei forService:@"xZhiLiao" account:@"IEMI"];
        return imei;
    }
}

#pragma mark 正在审核
+ (BOOL) isUnderCheck
{
    if ([[mUserDefaults valueForKey:HideForCheck] isEqualToString:HideForCheck_Value]) {
        return YES;
    }
    
    return NO;
}

#pragma mark 手机号校验
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以1开头的11位数字字符
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark 数字校验
+ (BOOL) isValidateNumber:(NSString *)number
{
    if(number.length == 0){
        return NO;
    }
    NSString *regex = @"^[0-9]*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:number];
}

#pragma mark 发送极光推送的别名
+ (void)sendAliasToJPush{
    NSString *userUid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userUid"]];
    if (userUid.length == 0) {
        return;
    }
    [JPUSHService setAlias:[NSString stringWithFormat:@"%@XZL",userUid] callbackSelector:nil object:nil];
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
//    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
//    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
//    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
//    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
//    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
//    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
//    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
//    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
//    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
//    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
//    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
//    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
//    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
//    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
//    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
//    
//    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
//    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
//    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
//    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
//    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
//    
//    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
//    
//    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
//    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
//    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
//    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
//    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
//    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
//    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
//    
//    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
//    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
//    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
//    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
//    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
//    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
//    
//    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
//    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
//    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
//    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
//    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
//    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
//    
//    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

//获得设备型号
+ (BOOL )isiPhone6
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone7,2"]) return YES;
    return NO;
    
}

//获得设备型号
+ (BOOL )isiPhone6p
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone7,1"]) return YES;
    return NO;
    
}

+ (NSString *)changeDateToStr:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStrf = [formatter stringFromDate:date];
    return dateStrf;
}

+ (NSDate *)changeStrToDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateStr];
    return destDate;
}

+ (NSString *)changeDateToString:(NSDate *)date withFormatter:(NSString *)formatter{
    
    NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
    date = [date dateByAddingTimeInterval:timeZoneOffset];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
    
}

+ (NSDate *)changeStringToDate:(NSString *)dateStr withFormatter:(NSString *)formatter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: formatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *destDate= [dateFormatter dateFromString:dateStr];
    return destDate;
    
}

+ (NSString *)stringBecomeTime:(NSString *)time
{
    return [XZLUtil stringBecomeTime:time withDateForat:@"yyyy-MM-dd"];
}
//返回时间戳
+ (NSString *)stringBecomeTime:(NSString *)time withDateForat:(NSString *)dateFormat
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];//@"MM-dd HH:mm"
    NSString *str = [formatter stringFromDate:confromTimesp];
    return str;
}

//在某日期上增加x年x月x日x时x分x秒(负值为减少)
+(NSDate *)addToStartDate:(NSDate *)startDate withYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * newDate = [calendar dateByAddingComponents:comps toDate:startDate options:0];
    return newDate;
}

+(BOOL)isShareAppInstalled{
    
    if([QQApi isQQInstalled] || [WXApi isWXAppInstalled] || [WeiboSDK isWeiboAppInstalled]){
        return YES;
    }else{
        return NO;
    }
    
}

+(NSString *)changeDateStrToTimestampStr:(NSString *)dateStr{

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *date = [formatter dateFromString:dateStr];
    NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
    date = [date dateByAddingTimeInterval:timeZoneOffset];
    NSString *timestamp = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970] -8*60*60];
//    NSString *timestamp = [NSString stringWithFormat:@"%lld",[self getMillisecondWithDate:date]];
    return timestamp;
}

+ (NSString *)changeTimestampStrToDateStr:(NSString *)timestamp{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

static long long offset = 62135596800000;
+(NSString *)getDateWithMillisecond:(long long)millisecond
{   NSString *date;
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:millisecond/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    //    dateFormatter.dateFormat = @"yyyy年MM月dd HH:mm:ss";
    return date = [dateFormatter stringFromDate:d];
}

+(long long)getMillisecondWithDate:(NSDate *)date
{
    long long msecond = (long long)[date timeIntervalSince1970] * 1000.0 + offset;
    
    return msecond;
}

+(NSDate *)getDateWithString:(NSString *)dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:dateString];
    return date;
}

//获取手机型号
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}


//判断是否已经登录
+ (BOOL)isLogin{
    
    return  [XZLUserInfoTool isLogin];
    
}

//退出程序
+ (void)exitApplication {
    
    //    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}

//URL Encode
+ (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

+(NSMutableArray *)getIndustryArrayWithModel:(BOOL)withGRReadModel{
//    NSString *jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"industry" ofType:@"json"] encoding:0 error:nil];
//    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"industry" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getSalaryArrayWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:SALARY];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getXueliWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:DEGREE];
    //    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getWorkYearsWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:WORKYEAR];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getCitiesWithModel:(BOOL)withGRReadModel{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_by_letter" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[CityModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getPositionWithModel:(BOOL)withGRReadModel{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"job" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getGenderWithModel:(BOOL)withGRReadModel{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"gender" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getNowStatusWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:NOWSTATUS];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getMarriageWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:MARRIAGE];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getCompanyNatureWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPANYCROP];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getCompanySizeWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPANYSIZE];
//    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getWorkCropWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:WORKCROP];
    //    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getLanguageLevelWithModel:(BOOL)withGRReadModel{
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"language_level" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}

+(NSMutableArray *)getComplainWithModel:(BOOL)withGRReadModel{
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPLAIN];
    //    NSLog(@"%@",jsonArray);
    if(withGRReadModel){
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *item in jsonArray) {
            [array addObject:[GRReadModel ModelWithDic:item]];
        }
        return array;
    }
    return jsonArray;
}


//根据城市code获取城市名
+(NSString *)getCityNameWithCityCode:(NSString *)cityCode{
    NSString *cityName = @"";
    cityCode = [NSString stringWithFormat:@"%@",cityCode];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_by_letter" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        for (NSDictionary *city in item[@"list"]) {
            if ([city[@"code"] isEqualToString:cityCode]) {
                return city[@"city"];
            }
        }
    }
    
    return cityName;
}

//根据城市城市名获取code
+(NSString *)getCityCodeWithCityName:(NSString *)cityName{
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    NSString *cityCode = @"";
    
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_by_letter" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        //        [array addObject:[CityModel ModelWithDic:item]];
        for (NSDictionary *city in item[@"list"]) {
            if ([city[@"city"] isEqualToString:cityName]) {
                cityCode = [NSString stringWithFormat:@"%@",city[@"code"]];
                return cityCode;
            }
        }
    }
    
    return cityCode;
}

#pragma mark - 根据degreeCode获取学历
+(NSString *)getDegreeStrWithDegreeCode:(NSString *)code
{
    NSString * DegreeStr = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:DEGREE];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return DegreeStr;
}

#pragma mark - 根据学历获取学历Code
+(NSString *)getDegreeCodeStrWithDegree:(NSString *)name
{
    NSString * DegreeStr = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:DEGREE];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:name]) {
            return item[@"name"];
        }
    }
    return DegreeStr;
}

#pragma mark - 根据workYearCode获取工作年限
+(NSString *)getWorkYearsWithWorkYearCode:(NSString *)code
{
    NSString * workyearStr = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:WORKYEAR];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        NSString *item_str = [NSString stringWithFormat:@"%@",item[@"id"]];
        NSLog(@"%@",item_str);
        if ([item_str isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return workyearStr;
}

#pragma mark - 根据工作年限获取工作年限Code
+(NSString *)getWorkYearsCodeWithWorkYear:(NSString *)name
{
    NSString * workyearStr = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:WORKYEAR];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:name]) {
            return item[@"name"];
        }
    }
    return workyearStr;
}

#pragma mark - 根据salary code获取薪资范围
+(NSString *)getSalaryRangeWithSalaryCode:(NSString *)code
{
    NSString * salaryRange = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:SALARY];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return salaryRange;
}

#pragma mark - 根据薪资范围获取薪资范围code
+(NSString *)getSalaryRangeCodeWithSalary:(NSString *)name
{
    NSString * code = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:SALARY];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:name]) {
            return item[@"name"];
        }
    }
    return code;
}


#pragma mark - 根据industryCode获取industry
+(NSString *)getIndustryNameWithCode:(NSString *)industryCode
{
    NSString * name = @"";
    industryCode = [NSString stringWithFormat:@"%@",industryCode];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"industry" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:industryCode]) {
            return item[@"name"];
        }
    }
    return name;
}

#pragma mark - 根据industryname获取薪资范围industrycode
+(NSString *)getindustryCodeWithindustry:(NSString *)industryname
{
    NSString * code = @"";
    industryname = [NSString stringWithFormat:@"%@",industryname];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:SALARY];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:industryname]) {
            return item[@"name"];
        }
    }
    return code;
}

#pragma mark - 根据企业性质code获取企业性质
+(NSString *)getCompanyCorpWithCompanyCorpCode:(NSString *)CompanyCorpCode
{
    NSString * CompanyCorp = @"";
    CompanyCorpCode = [NSString stringWithFormat:@"%@",CompanyCorpCode];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPANYCROP];
//    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] intValue] == [CompanyCorpCode intValue]) {
            return item[@"name"];
        }
    }
    return CompanyCorp;
}

#pragma mark - 根据企业性质获取企业性质code
+(NSString *)getCompanyCorpCodeWithCompanyCorp:(NSString *)CompanyCorp
{
    NSString * Company = @"";
    CompanyCorp = [NSString stringWithFormat:@"%@",CompanyCorp];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPANYCROP];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:CompanyCorp]) {
            return item[@"id"];
        }
    }
    return Company;
}

#pragma mark - 根据性别code获取性别
+(NSString *)getGenderWithGenderCode:(NSString *)GenderCode{
    NSString * CompanyCorp = @"";
    GenderCode = [NSString stringWithFormat:@"%@",GenderCode];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"gender" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:GenderCode]) {
            return item[@"name"];
        }
    }
    return CompanyCorp;
}

#pragma mark - 根据性别获取性别code
+(NSString *)getGenderCodeWithGender:(NSString *)Gender
{
    NSString * Company = @"";
    Gender = [NSString stringWithFormat:@"%@",Gender];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"gender" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:Gender]) {
            return item[@"id"];
        }
    }
    return Company;
}

#pragma mark - 根据职业code获取职业
+(NSString *)getJobWithJobCode:(NSString *)JobCode{
    NSString * CompanyCorp = @"";
    JobCode = [NSString stringWithFormat:@"%@",JobCode];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"job" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:JobCode]) {
            return item[@"name"];
        }
    }
    return CompanyCorp;
}
#pragma mark - 根据职业获取职业code
+(NSString *)getJobCodeWithJob:(NSString *)job
{
    NSString * Company = @"";
    job = [NSString stringWithFormat:@"%@",job];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"job" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:job]) {
            return item[@"id"];
        }
    }
    return Company;
}

#pragma mark - 根据婚姻code获取婚姻
+(NSString *)getMarriageWithMarriageCode:(NSString *)code{
    NSString * name = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:MARRIAGE];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return name;
}

#pragma mark - 根据婚姻获取婚姻code
+(NSString *)getMarriageCodeWithMarriage:(NSString *)name{
    NSString * code = @"";
    name = [NSString stringWithFormat:@"%@",name];
   NSMutableArray *jsonArray = [mUserDefaults valueForKey:MARRIAGE];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:name]) {
            return item[@"id"];
        }
    }
    return code;
}

#pragma mark - 根据工作性质code获取工作性质
+(NSString *)getWorkCropWithWorkCropCode:(NSString *)code{
    NSString * name = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:WORKCROP];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return name;
}

#pragma mark - 根据工作性质获取工作性质code
+(NSString *)getWorkCropCodeWithWorkCrop:(NSString *)name{
    NSString * code = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:WORKCROP];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:name]) {
            return item[@"id"];
        }
    }
    return code;
}

#pragma mark - 根据NowStatuscode获取NowStatus
+(NSString *)getNowStatusWithNowStatusCode:(NSString *)code{
    NSString * name = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:NOWSTATUS];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return name;
}

#pragma mark - 根据NowStatus获取NowStatuscode
+(NSString *)getNowStatusCodeWithNowStatus:(NSString *)name{
    NSString * code = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:NOWSTATUS];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:name]) {
            return item[@"id"];
        }
    }
    return code;
}

#pragma mark - 根据company_size code获取company_size
+(NSString *)getCompanySizeWithCompanySizeCode:(NSString *)code{
    NSString * name = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPANYSIZE];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return name;
}

#pragma mark - 根据company_size获取company_size code
+(NSString *)getCompanySizeCodeWithCompanySize:(NSString *)name{
    NSString * code = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSMutableArray *jsonArray = [mUserDefaults valueForKey:COMPANYSIZE];
    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:name]) {
            return item[@"id"];
        }
    }
    return code;
}

#pragma mark - 根据LanguageLevel code获取LanguageLevel
+(NSString *)getLanguageLevelWithLanguageLevelCode:(NSString *)code{
    NSString * name = @"";
    code = [NSString stringWithFormat:@"%@",code];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"language_level" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"id"] isEqualToString:code]) {
            return item[@"name"];
        }
    }
    return name;
}

#pragma mark - 根据LanguageLevel获取LanguageLevel code
+(NSString *)getLanguageLevelCodeWithLanguageLevel:(NSString *)name{
    NSString * code = @"";
    name = [NSString stringWithFormat:@"%@",name];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"language_level" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    //    NSLog(@"%@",jsonArray);
    for (NSDictionary *item in jsonArray) {
        if ([item[@"name"] isEqualToString:name]) {
            return item[@"id"];
        }
    }
    return code;
}



@end
