//
//  ConditionDetailViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//
#import "ConditionDetailViewController.h"

@interface ConditionDetailViewController ()

@end

@implementation ConditionDetailViewController
@synthesize codeArray=_codeArray;
@synthesize showArray=_showArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择筛选条件"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择筛选条件"];
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
    if (_selectOption == SelectPublishDate)
    {
        title = @"发布时间";
        
        self.showArray = [NSArray arrayWithObjects:@"不限",@"近一天",@"近二天",@"近三天",@"近一周",@"近二周",@"近一月",@"近六周",@"近俩月",nil];
        
        self.codeArray = [[NSArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"7",@"14",@"30",@"42",@"60",nil];
        
    }else if (_selectOption == SelectJobYear)
    {
        title = @"工作经验";
        self.showArray = [NSArray arrayWithObjects:@"不限",@"在读学生",@"应届毕业生",@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"11年",@"12年",@"13年",@"14年",@"15年",@"16年",@"17年",@"18年",@"19年",@"20年",@"21年",@"22年",@"23年",@"24年",@"25年",@"26年",@"27年",@"28年",@"29年",@"30年",@"31年",@"32年",@"33年",@"34年",@"35年",@"36年",@"37年",@"38年",@"39年",@"40年",@"41年",@"42年",@"43年",@"44年",@"45年",@"46年",@"47年",@"48年",@"49年",@"50年",@"51年",@"52年",@"53年",@"54年",@"55年",@"56年",@"57年",@"58年",@"59年",@"60年",nil];
        
        self.codeArray = [[NSArray alloc]initWithObjects:@"",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",nil];
        
    }else if (_selectOption == SelectEducation)
    {
        title = @"学历";
        self.showArray =  [NSArray arrayWithObjects:@"不限",@"初中以上",@"高中以上",@"中技以上",@"中专以上",@"大专以上",@"本科以上",@"硕士以上",@"博士以上",@"其他",nil];
        self.codeArray = [[NSArray alloc]initWithObjects:@"0",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"99",nil];
    }else if (_selectOption == SelectMonthSalary)
    {
        title = @"薪资待遇分类";
        
        _showArray = [NSArray arrayWithObjects:@"不限",@"面议",@"1000以下",@"1000-1199",@"1200-1499",@"1500-1799",@"1800-1999",@"2000-2499",@"2500-2999",@"3000-3499",@"3500-3999",@"4000-4499",@"4500-4999",@"5000-5999",@"6000-6999",@"7000-7999",@"8000-8999",@"9000-9999",@"10000-11999",@"12000-14999",@"15000-19999",@"20000-24999",@"25000-29999",@"30000-39999",@"40000-49999",@"50000-79999",@"80000-99999",@"100000以上",nil];
        
        _codeArray= [[NSArray alloc]initWithObjects:@"",@"10",@"99",@"101",@"121",@"151",@"181",@"201",@"251",@"301",@"351",@"401",@"451",@"501",@"601",@"701",@"801",@"901",@"1001",@"1201",@"1501",@"2001",@"2501",@"3001",@"4001",@"5001",@"8001",@"10001",nil];
        
    }else if (_selectOption == SelectJobType)
    {
        title = @"职位类型";
        _showArray = [NSArray arrayWithObjects:@"不限",@"全职",@"兼职",@"实习",@"全兼皆可",nil];
        _codeArray = [NSArray arrayWithObjects:@"",@"1",@"2",@"3",@"4", nil];
    }else
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
