//
//  ZPDetailViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-1-21.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "ZPDetailViewController.h"
#import "City.h"
#import "CityInfo.h"
#define kInfoFont [UIFont systemFontOfSize:14]
@interface ZPDetailViewController ()

@end

@implementation ZPDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arry04 = [NSArray arrayWithObjects:@"日期:",@"城市:",@"学校:",@"场地:", nil];
        arry03 = [NSArray arrayWithObjects:@"日期:",@"城市:",@"场地:", nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"招聘会详细界面"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"招聘会详细界面"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =XZHILBJ_colour;
    myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, iPhone_height-44)];
    myScroll.contentSize = CGSizeMake(320, iPhone_height-43);
    myScroll.backgroundColor = XZHILBJ_colour;

    //标题
    _zpTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, iPhone_width - 40, 80)];
    _zpTitle.textAlignment = NSTextAlignmentLeft;
    _zpTitle.text = _zpInfo.z_title;
    _zpTitle.lineBreakMode = NSLineBreakByWordWrapping;
    _zpTitle.numberOfLines = 0;
    [_zpTitle setFont:[UIFont boldSystemFontOfSize:14]];
    _zpTitle.textColor = RGBA(40, 100, 210, 1);
    NSInteger height;
    if (_zpInfo.schoolName.length > 0){
        
    height = [ZPDetailViewController buttonWidthWithTitle:_zpInfo.companyName width:iPhone_width-40 font:14];
        
    }else{
    height = [ZPDetailViewController buttonWidthWithTitle:_zpInfo.z_title width:iPhone_width-40 font:14];
    }
     
    myImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, height+50, iPhone_width-40, 150)];
    myImg.backgroundColor = [UIColor clearColor];
    myImg.image = [UIImage imageNamed:@"bg01.png"];
    //[myScroll addSubview:myImg];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, height+50, iPhone_width-10, 320) style:UITableViewStyleGrouped];
    myTableView.delegate =self;
    myTableView.dataSource =self;
    myTableView.backgroundView = nil;
    myTableView.userInteractionEnabled = NO;
    myTableView.backgroundColor = [UIColor clearColor];
    [myScroll addSubview:myTableView];

    //日期
    _zpDate = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, iPhone_width - 40, 40)];
    _zpDate.font = kInfoFont;
    self.zpDate.text = [NSString stringWithFormat:@"日期： %@",_zpInfo.date];
    [myImg addSubview:_zpDate];
   
    //城市
//    _zpCity = [[UILabel alloc]initWithFrame:CGRectMake(5, 45, iPhone_width - 40, 40)];
//    _zpCity.numberOfLines = 0;
//    _zpCity.font = kInfoFont;
//    NSArray *citys = [City findAllWith:@"cityList"];
//    for (City *c in citys) {
//        if ([c.code isEqualToString:_zpInfo.area]) {
//            _zpInfo.area = c.cityName;
//            break;
//        }
//    }
//     CityInfo *info = [CityInfo standerDefault];
//    self.zpCity.text = [NSString stringWithFormat:@"城市： %@",info.cityName];
//    [myImg addSubview:_zpCity];
    
    //场地
    _zpLocation = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, 60, 60)];
    _zpLocation.backgroundColor = [UIColor clearColor];
    _zpLocation.font = kInfoFont;
    _zpLocation.text = @"场地：";
    [_zpLocation setTextColor: RGBA(40, 100, 210, 1)];
    _location = [[UILabel alloc]initWithFrame:CGRectMake(50, 75, iPhone_width - 100, 60)];
    _location.backgroundColor = [UIColor clearColor];
    _location.font = kInfoFont;
    _location.numberOfLines = 0;
    _location.text = _zpInfo.address;
    [myImg addSubview:_zpLocation];
    [myImg addSubview:_location];
    
    
    //学校啊 另外判断 
    if (_zpInfo.schoolName.length > 0)
    {
        self.zpTitle.text = self.zpInfo.companyName;
        UILabel *schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 85, 280, 40)];
        schoolLabel.font = kInfoFont;
        schoolLabel.numberOfLines = 0;
        schoolLabel.backgroundColor = [UIColor clearColor];
        schoolLabel.text = [NSString stringWithFormat:@"学校： %@",_zpInfo.schoolName];
        [myImg addSubview:schoolLabel];
        _zpLocation.frame = CGRectMake(5, 125, 240, 40);
        _location.frame = CGRectMake(50, 125, 230, 40);
        myImg.frame = CGRectMake(20, height+50, iPhone_width-40, 190);
        myImg.image = [UIImage imageNamed:@"bg01.png"];
    }
    else
    {
//        self.zpTitle.text = self.zpInfo.z_title;
//        self.zpSchool.alpha = 0;
    }
    [myImg addSubview:self.zpSchool];
    
    _zpCity.backgroundColor = [UIColor clearColor];
    _zpDate.backgroundColor = [UIColor clearColor];
    _zpLocation.backgroundColor = [UIColor clearColor];
    _zpTitle.backgroundColor = [UIColor clearColor];

    [myScroll addSubview:_zpTitle];
    [self.view addSubview:myScroll];
    [self addBackBtn];
    [self addTitleLabel:@"招聘会"];
    CityInfo *info3 = [CityInfo standerDefault];
    ary033 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",_zpInfo.date],[NSString stringWithFormat:@"%@",info3.cityName],[NSString stringWithFormat:@"%@",_zpInfo.address], nil];
    ary044 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",_zpInfo.date],[NSString stringWithFormat:@"%@",info3.cityName],[NSString stringWithFormat:@"%@",_zpInfo.schoolName],[NSString stringWithFormat:@"%@",_zpInfo.address], nil];
}
#pragma mark - tabView 的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_zpInfo.schoolName.length > 2) {
        return 4;
    }else{
        return 3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//返回行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    UILabel *label01 = [[UILabel alloc]initWithFrame:CGRectMake(60, 4, 225, 40)];
    label01.backgroundColor =[UIColor clearColor];
    label01.font = [UIFont systemFontOfSize:13];
    label01.numberOfLines = 0;
    [cell addSubview:label01];
    if (_zpInfo.schoolName.length > 2) {
        cell.textLabel.text = [arry04 objectAtIndex:indexPath.row];
        label01.text = [ary044 objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [arry03 objectAtIndex:indexPath.row];
        label01.text = [ary033 objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = RGBA(40, 100, 210, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


//根据字符串来得到高度
+ (NSInteger)buttonWidthWithTitle:(NSString *)title width:(NSInteger)width font:(NSInteger)fontNum
{
    
    CGSize sizeToFit = [title sizeWithFont:[UIFont systemFontOfSize:fontNum] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)backZP:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
