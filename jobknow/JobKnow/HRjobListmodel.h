//
//  HRjobListmodel.h
//  JobKnow
//
//  Created by Mathias on 15/7/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRjobListmodel : NSObject



@property(nonatomic,copy)NSString * allCounts;//总职位数

@property(nonatomic,copy)NSString *bouns;//总奖金

@property(nonatomic,copy)NSString *city_code;//城市代码

@property(nonatomic,assign)NSInteger  countMoney;//奖金 元

@property(nonatomic ,retain)NSArray *data;


 @property(nonatomic,copy)NSString*age;//年龄

 @property(nonatomic,copy)NSString* cid;//cid

@property(nonatomic,copy)NSString *citycode;//城市代码

@property(nonatomic,assign)int  commentsNum;//评论数

@property(nonatomic,copy)NSString *companyAddress;// 公司地址

@property(nonatomic,copy)NSString *companyId;//公司ID

@property(nonatomic,copy)NSString *companyName;//公司名字

@property(nonatomic,copy)NSString *companyTel;//公司电话

@property(nonatomic,copy)NSString *companyWeb;//公司网站

@property(nonatomic,copy)NSString *counts;//需求人数

@property(nonatomic,copy)NSString *degree;//学历要求

@property(nonatomic,copy)NSString *email;//公司email

@property(nonatomic,assign)NSInteger  favNum;//收藏人数




@property(nonatomic,assign)int  favorites;
@property(nonatomic,copy)NSString *fee;
@property(nonatomic,assign)int  isRead;
@property(nonatomic,assign)int isfavorites;
@property(nonatomic,assign)int  issenior;




@property(nonatomic,copy)NSString *jobName;//职位名称

@property(nonatomic,copy)NSString *linkMan;//联系人

@property(nonatomic,copy)NSString *newfee;//推荐奖金--------------------------------------

@property(nonatomic,assign)int  postId;

@property(nonatomic,copy)NSString *pubDate;//发布日期

@property(nonatomic,assign)NSInteger  recommendNum;//推荐人数

@property(nonatomic,copy)NSString *required;//职位要求

@property(nonatomic,copy)NSString *salary;//薪资待遇

@property(nonatomic,copy)NSString *stopTime;//截止日期

@property(nonatomic,assign)NSInteger  viewNum;//浏览次数

@property(nonatomic,copy)NSString *workArea;//工作地点

@property(nonatomic,assign)int  workAreaCode;
@property(nonatomic,copy)NSString *workExperience;//工作经验


@property(nonatomic,retain)NSDictionary *hrInfo;

@property(nonatomic,assign)int  days;
@property(nonatomic,assign)int  error;
@property(nonatomic,copy)NSString *from;



//@property(nonatomic,retain)NSNumber* recommendNum;
@property(nonatomic,assign)int  resumeNum;
@property(nonatomic,assign)int todayCounts;







 
 @property(nonatomic,assign)CGSize newfeeSize;//入职奖金字符串的长度
@property(nonatomic,assign)CGSize detailSize;//工作地点字符串长度
@property(nonatomic,assign)CGSize requestSize;//职位要求字符串长度






-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)modelWithDict:(NSDictionary *)dict;
@end