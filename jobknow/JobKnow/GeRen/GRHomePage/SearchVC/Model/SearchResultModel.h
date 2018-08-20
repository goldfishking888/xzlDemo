//
//  SearchResultModel.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/19.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject
@property (nonatomic, copy) NSNumber * company_city;
@property (nonatomic, copy) NSNumber * company_corpprop;
@property (nonatomic, copy) NSString * company_financing_type;
@property (nonatomic, copy) NSNumber * company_id;
@property (nonatomic, copy) NSString * company_listing_status;
@property (nonatomic, copy) NSString * company_name;
@property (nonatomic, copy) NSArray * company_trade;
@property (nonatomic, copy) NSNumber * degree;
@property (nonatomic, copy) NSString * earnings_total;//收益
@property (nonatomic, copy) NSString * enddate;
@property (nonatomic, copy) NSNumber * Id;
@property (nonatomic, copy) NSNumber * is_fast;
@property (nonatomic, copy) NSString * position_area;
@property (nonatomic, copy) NSString * position_name;
@property (nonatomic, copy) NSArray * position_sort;
@property (nonatomic, copy) NSNumber * position_type;
@property (nonatomic, copy) NSNumber * salary;
@property (nonatomic, copy) NSNumber * status;
@property (nonatomic, copy) NSNumber * type;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSNumber * work_years;

/*
 {
 "company_city" = 2012;
 "company_corpprop" = "";
 "company_financing_type" = "-1";
 "company_id" = 4559;
 "company_listing_status" = "-1";
 "company_name" = "\U9752\U5c9b\U7f8e\U90a6\U533b\U836f\U6709\U9650\U516c\U53f8";
 "company_trade" =                 (
 1811,
 1800,
 1812,
 1813
 );
 degree = 15;
 "earnings_total" = "27000-35999";
 enddate = "2017-02-06";
 id = 620;
 "is_fast" = 1;
 "position_area" = "\U9752\U5c9b";
 "position_name" = "\U526f\U603b\U7ecf\U7406";
 "position_sort" =                 (
 1123
 );
 "position_type" = 0;
 salary = 1501;
 status = 1;
 type = 1;
 "updated_at" = "2017-05-12";
 "work_years" = 5;
 }
 */
@end
