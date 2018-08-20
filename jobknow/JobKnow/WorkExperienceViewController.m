//
//  WorkExperienceViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "WorkExperienceViewController.h"

@interface WorkExperienceViewController ()

@end

@implementation WorkExperienceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    num=ios7jj;
    
    [self addBackBtn];
    
    [self addTitleLabel:@"工作经验"];
    
     _showArray = [NSArray arrayWithObjects:@"不限",@"在读学生",@"应届毕业生",@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"11年",@"12年",@"13年",@"14年",@"15年",@"16年",@"17年",@"18年",@"19年",@"20年",@"21年",@"22年",@"23年",@"24年",@"25年",@"26年",@"27年",@"28年",@"29年",@"30年",@"31年",@"32年",@"33年",@"34年",@"35年",@"36年",@"37年",@"38年",@"39年",@"40年",@"41年",@"42年",@"43年",@"44年",@"45年",@"46年",@"47年",@"48年",@"49年",@"50年",@"51年",@"52年",@"53年",@"54年",@"55年",@"56年",@"57年",@"58年",@"59年",@"60年",nil];
    
    if (IOS7) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStyleGrouped];
    }else
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStylePlain];
    }
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

#pragma mark UITableView  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showArray count];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indenifier=@"cellIndenifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indenifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenifier];
    }
    
    cell.textLabel.text=[_showArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(changeworkExperience:)]) {
        
        [self.delegate changeworkExperience:[_showArray objectAtIndex:indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end