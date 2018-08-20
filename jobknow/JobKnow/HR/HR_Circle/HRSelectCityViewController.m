//
//  HRSelectCityViewController.m
//  JobKnow
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRSelectCityViewController.h"
#import "City.h"

@interface HRSelectCityViewController ()

@end

@implementation HRSelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"选择城市"];
    
    [self initData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+ios7jj, iPhone_width, iPhone_height - 44-ios7jj) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self sortCity:_cityArray];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

//初始化数据
- (void)initData
{
    
    UserDatabase *db = [UserDatabase sharedInstance];
    
    _cityDic=[[NSMutableDictionary alloc]init];
    
    _cityArray=(NSMutableArray *)[db getAllRecords2];
    
    //右侧索引数据
    _wordsArray = [[NSArray alloc]initWithObjects:@"热门",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *firstwordStr = [_wordsArray objectAtIndex:section];
    
    if ([firstwordStr isEqualToString:@"热门"]) {
        return @"热门城市";
    }
    
    return firstwordStr;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *titleStr = [_wordsArray objectAtIndex:section];
    
    if ([titleStr isEqualToString:@""])
    {
        return nil;
    }
    else if ([titleStr isEqualToString:@"热门"])
    {
        UIView *cview = [[UIView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,50)];
        cview.backgroundColor = [UIColor whiteColor];
        RTLabel* cnlabel3  = [[RTLabel alloc]initWithFrame:CGRectMake(10, 5, cview.bounds.size.width-24, cview.bounds.size.height-20)];
        NSString *string = [NSString stringWithFormat:@"已开通<font color='#f76806'>%d</font>个城市。",_cityArray.count-5];
        cnlabel3.text =string;
        cnlabel3.backgroundColor = [UIColor clearColor];
        [cnlabel3 setFont:[UIFont systemFontOfSize:14]];
        [cview addSubview:cnlabel3];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,30, tableView.bounds.size.width,20)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.bounds.size.width-24, view.bounds.size.height)];
        view.backgroundColor = [UIColor colorWithRed:248.0/256 green:215.0/256 blue:177.0/256 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.shadowColor = [UIColor darkGrayColor];
        label.shadowOffset = CGSizeMake(0, 0.6);
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = titleStr;
        [view addSubview:label];
        [cview addSubview:view];
        
        return cview;
        
    }else{//A~Z
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,20)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.bounds.size.width-24, view.bounds.size.height)];
        view.backgroundColor = [UIColor colorWithRed:248.0/256 green:215.0/256 blue:177.0/256 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.shadowColor = [UIColor darkGrayColor];
        label.shadowOffset = CGSizeMake(0, 0.6);
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = titleStr;
        [view addSubview:label];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //判断该首字母下是否有城市，没有header高度为零
    NSString *firstword = [self.wordsArray objectAtIndex:section];
    
    if ([[self.cityDic valueForKey:firstword] count] == 0)
    {
        return 0;
        
    }else if ([firstword isEqualToString:@"热门"]){
        return 50;
    }
    
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_wordsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *firstword = [_wordsArray objectAtIndex:section];
    NSArray *array=[_cityDic valueForKey:firstword];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *first = [self.wordsArray objectAtIndex:indexPath.section];
    NSArray *arr = [self.cityDic valueForKey:first];
    cell.textLabel.text = [[arr objectAtIndex:indexPath.row] cityName];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _wordsArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [self.wordsArray objectAtIndex:indexPath.section];//取出key
    NSMutableArray *cityArray = [self.cityDic valueForKey:key];//根据key取出存放城市的数组
    
    City *city = [cityArray objectAtIndex:indexPath.row];//取出数组中的城市
    
    if ([self.delegate respondsToSelector:@selector(didSelectWithCityCode:cityName:)]) {
        
        [self.delegate didSelectWithCityCode:city.code cityName:city.cityName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 功能函数

/**把城市进行排序**/
- (void)sortCity:(NSMutableArray *)cityArray
{
    //将城市按照首字母进行分组并放入字典
    for (int i = 0; i <_wordsArray.count; i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSString *wordStr = [_wordsArray objectAtIndex:i];
        
        for (int m = 0; m <[cityArray count]; m++)
        {
            City *city = [cityArray objectAtIndex:m];
            if ([city.letter isEqualToString:wordStr]) {
                [array addObject:city];
            }
        }
        
        [_cityDic setObject:array forKey:wordStr];
    }
    
    [_tableView reloadData];
}
@end
