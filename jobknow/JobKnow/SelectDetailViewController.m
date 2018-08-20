//
//  SelectDetailViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-1-30.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "SelectDetailViewController.h"

@interface SelectDetailViewController ()

@end

@implementation SelectDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    
    if ([_itemStr isEqualToString:@"职位类型"])//判断是什么选项
    {
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择职位类型"];
        
    }else if ([_itemStr isEqualToString:@"待遇"])
    {
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择待遇"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([_itemStr isEqualToString:@"职位类型"])
    {
        [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择职位类型"];
        
    }else if ([_itemStr isEqualToString:@"待遇"])
    {
        [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择待遇"];
    }
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addBackBtn];
    
    num=ios7jj;
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width, iPhone_height - 44-num) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview: _myTableView];
    
    if ([_itemStr isEqualToString:@"职位类型"])  //判断是什么选项
    {
        _showArray = [NSArray arrayWithObjects:@"不限",@"全职",@"兼职",@"实习",@"全兼皆可",nil];
        _codeArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4", nil];
        
        [self addTitleLabel:@"选择工作性质"];
        
    }else if ([self.itemStr isEqualToString:@"待遇"])
    {
    
        _showArray = [NSArray arrayWithObjects:@"不限",@"4000 以下",@"4000-6000",@"6000-8000",@"8000-10000",@"10000-15000",@"15000-20000",@"20000-30000",@"30000-50000",@"50000以上",nil];
        
        _codeArray= [[NSArray alloc]initWithObjects:@"",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",nil];
        
        [self addTitleLabel:@"选择薪资"];
         
    }else if ([self.itemStr isEqualToString:@"学历"])
    {
        _showArray = [NSArray arrayWithObjects:@"不限",@"初中",@"高中",@"中技",@"中专",@"大专",@"本科",@"硕士",@"博士",@"博士后",@"其他",nil];
        _codeArray= [[NSArray alloc]initWithObjects:@"0",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"99",nil];
        [self addTitleLabel:@"选择学历"];
    }else if ([self.itemStr isEqualToString:@"工作经验"])
    {
        _showArray = [NSArray arrayWithObjects:@"不限",@"在读学生",@"应届毕业生",@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"11年",@"12年",@"13年",@"14年",@"15年",@"16年",@"17年",@"18年",@"19年",@"20年",@"21年",@"22年",@"23年",@"24年",@"25年",@"26年",@"27年",@"28年",@"29年",@"30年",@"31年",@"32年",@"33年",@"34年",@"35年",@"36年",@"37年",@"38年",@"39年",@"40年",@"41年",@"42年",@"43年",@"44年",@"45年",@"46年",@"47年",@"48年",@"49年",@"50年",@"51年",@"52年",@"53年",@"54年",@"55年",@"56年",@"57年",@"58年",@"59年",@"60年",nil];
        
        _codeArray= [[NSArray alloc]initWithObjects:@"-2",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",nil];
        [self addTitleLabel:@"工作经验"];
        
    }else if ([self.itemStr isEqualToString:@"发布时间"])
    {
        _showArray = [NSArray arrayWithObjects:@"不限",@"近一天",@"近二天",@"近三天",@"近一周",@"近二周",@"近一月",@"近六周",@"近俩月",nil];
        _codeArray= [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"7",@"14",@"30",@"42",@"60",nil];
        [self addTitleLabel:@"发布时间"];
        
    }else if ([self.itemStr isEqualToString:@"公司性质"])
    {
        _showArray = [NSArray arrayWithObjects:@"不限",@"行政机关/事业单位",@"国有企业",@"合资企业",@"外商独资",@"民企/私企",@"股份制企业",@"上市公司",@"其它",nil];
        _codeArray= [[NSArray alloc]initWithObjects:@"",@"01",@"04",@"05",@"06",@"09",@"10",@"11",@"00",nil];
        [self addTitleLabel:@"公司性质"];
    }
    
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark tableView代理方法的实现
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
    static NSString *identify = @"Cellidentify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [_showArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"indexPath is %d",indexPath.row);
    
    jobRead *selectRead = [[jobRead alloc]init];
    selectRead.code = [_codeArray objectAtIndex:indexPath.row];
    selectRead.name = [_showArray objectAtIndex:indexPath.row];
    [self.delegate sendWithSelect:selectRead Option:_itemStr];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)backUp:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
