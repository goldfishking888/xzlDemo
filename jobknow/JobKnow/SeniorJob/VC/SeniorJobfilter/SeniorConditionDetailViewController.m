//
//  SeniorConditionDetailViewController.m
//  JobKnow
//
//  Created by Suny on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "SeniorConditionDetailViewController.h"

@interface SeniorConditionDetailViewController ()

@end

@implementation SeniorConditionDetailViewController
@synthesize codeArray=_codeArray;
@synthesize showArray=_showArray;
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
    
    iosHeight=ios7jj;
    
    NSLog(@"iosHeight is %d",iosHeight);
    
    //创建tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44,iPhone_width,iPhone_height-44) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    NSString *title =@"";
    
    //判断是什么选项
    if (_selectOption == SeniorSelectPaiLieFangshi)
    {
        title = @"排列方式";
        
        self.showArray = [NSArray arrayWithObjects:@"最新发布",@"奖金最高",@"薪资最高",nil];
        
        self.codeArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",nil];
        
    }else if (_selectOption == SeniorSelectWorkExp)
    {
        title = @"工作经验";
        self.showArray = [NSArray arrayWithObjects:@"不限",@"在读学生",@"应届毕业生",@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"11年",@"12年",@"13年",@"14年",@"15年",@"16年",@"17年",@"18年",@"19年",@"20年",@"21年",@"22年",@"23年",@"24年",@"25年",@"26年",@"27年",@"28年",@"29年",@"30年",@"31年",@"32年",@"33年",@"34年",@"35年",@"36年",@"37年",@"38年",@"39年",@"40年",@"41年",@"42年",@"43年",@"44年",@"45年",@"46年",@"47年",@"48年",@"49年",@"50年",@"51年",@"52年",@"53年",@"54年",@"55年",@"56年",@"57年",@"58年",@"59年",@"60年",nil];
        
        self.codeArray = [[NSArray alloc]initWithObjects:@"",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",nil];
        
    }else if (_selectOption == SeniorSelectEduExp)
    {
        title = @"学历";
        self.showArray =  [NSArray arrayWithObjects:@"不限",@"初中以上",@"高中以上",@"中技以上",@"中专以上",@"大专以上",@"本科以上",@"硕士以上",@"博士以上",@"其他",nil];
        self.codeArray = [[NSArray alloc]initWithObjects:@"0",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"99",nil];
    }else if(_selectOption == SeniorSelectCompanyType)
    {
        
        title = @"公司性质";
        self.showArray = [NSArray arrayWithObjects:@"不限",@"行政机关/事业单位",@"国有企业",@"合资企业",@"外商独资",@"民营/私企",@"股份制企业",@"上市公司",@"其它",nil];
        self.codeArray = [NSArray arrayWithObjects:@"",@"01",@"04",@"05",@"06",@"09",@"10",@"11",@"99", nil];
    }
    
    [self addBackBtn];
    [self addTitleLabel:title];
}

#pragma mark UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showArray count];
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
    cell.textLabel.text = [_showArray objectAtIndex:indexPath.row];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    jobRead *read=[[jobRead alloc]init];
    
    read.name=[_showArray objectAtIndex:indexPath.row];
    read.code=[_codeArray objectAtIndex:indexPath.row];
    
    [self.delegate selectValueToUp:read];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
