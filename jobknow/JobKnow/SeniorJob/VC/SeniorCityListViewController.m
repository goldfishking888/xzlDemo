//
//  SeniorCityListViewController.m
//  JobKnow
//
//  Created by Suny on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "SeniorCityListViewController.h"

@interface SeniorCityListViewController ()

@end

@implementation SeniorCityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title =@"选择城市";
    
    [self addBackBtn];
    [self addTitleLabel:title];
    
    num=ios7jj;
    //创建tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    CGRect rect = _tableView.frame;
    
   
}

#pragma mark UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"city"];
    if ([[[_dataArray objectAtIndex:indexPath.row] valueForKey:@"isSelected"]isEqualToString:@"1"]) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
    }else{
        cell.accessoryView = nil;
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ((SeniorCityModel *)[_dataArray objectAtIndex:indexPath.row]).isSelected = YES;
    for (NSMutableDictionary *item in _dataArray) {
        [item setValue:@"0" forKey:@"isSelected"];
    }
    [[_dataArray objectAtIndex:indexPath.row] setValue:@"1" forKey:@"isSelected"];
    [mUserDefaults setValue:_dataArray forKey:@"SeniorCityArray"];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
     if ([_delegate respondsToSelector:@selector(finishSelectCityWithCityCode:CityName:)]) {
         [_delegate finishSelectCityWithCityCode:[dic valueForKey:@"code"] CityName:[dic valueForKey:@"city"]];
     }
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 120)];
    [view_head setBackgroundColor:[UIColor redColor]];
    
    UILabel *label_current = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 30)];
    [label_current setBackgroundColor:[UIColor colorWithHex:0xf0f0f0 alpha:1]];
    [label_current setFont:[UIFont systemFontOfSize:13]];
    [label_current setTextColor:color_lightgray];
    [label_current setText:@" 定位当前城市"];
    [view_head addSubview:label_current];
    
    UILabel *label_content = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, iPhone_width, 60)];
    [label_content setBackgroundColor:[UIColor whiteColor]];
    NSString *city_dingwei = [mUserDefaults valueForKey:@"DingweiCity"];
    [label_content setText:[NSString stringWithFormat:@"    %@",city_dingwei]];
    [label_content setFont:[UIFont boldSystemFontOfSize:15]];
    [view_head addSubview:label_content];
    label_content.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleBtnClick)];
    [label_content addGestureRecognizer:tap];

    
    UILabel *label_available = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, iPhone_width, 30)];
    [label_available setBackgroundColor:[UIColor colorWithHex:0xf0f0f0 alpha:1]];
    [label_available setFont:[UIFont systemFontOfSize:13]];
    [label_available setTextColor:color_lightgray];
    [label_available setText:@" 已开通服务的城市"];
    [view_head addSubview:label_available];
    
    return view_head;
}

- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)titleBtnClick{
    NSString *city_current = [mUserDefaults valueForKey:@"DingweiCity"];
    if ([_delegate respondsToSelector:@selector(finishSelectCityWithCityCode:CityName:)]) {
        [_delegate finishSelectCityWithCityCode:nil CityName:city_current];
    }

    for (NSMutableDictionary *item in _dataArray) {
        if ([[item valueForKey:@"city"] isEqualToString:city_current]) {
            [item setValue:@"1" forKey:@"isSelected"];
        }else{
            [item setValue:@"0" forKey:@"isSelected"];
        }
    }
    [mUserDefaults setValue:_dataArray forKey:@"SeniorCityArray"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
