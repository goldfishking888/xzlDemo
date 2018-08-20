//
//  allCViewController.m
//  JobKnow

#import "allCViewController.h"
#import "UserDatabase.h"

@interface allCViewController ()

@end

@implementation allCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择城市（简历中心）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择城市（简历中心）"];
}

- (void)initData
{
    num = ios7jj;
 
    _cityArray = [NSMutableArray array];
    
    _cityDic = [[NSMutableDictionary alloc]init];
    
    _wordsArray = [[NSArray alloc]initWithObjects:@"$",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    
    db=[UserDatabase sharedInstance];
    
    _cityArray =(NSMutableArray *)[db getAllRecords3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self addBackBtn];
    
    [self addTitleLabel:@"城市选择"];
    
    [self initData];
    
    /*第一次进入的时候进行判断，看一下数据库中表cityInfo2是否存储了数据
     
      如果存储了数据，将直接提取出来
     
      如果没有存储，就从文件中读取数据，然后存储
     
     */
    
    NSLog(@"[_cityArray count] is %d",[_cityArray count]);
    
    if ([_cityArray count]==0) {
    
        [self stringBecomeDictionary];
        
         [db addOneRecord3:_cityArray];
    }else
    {
        [self sortCity:_cityArray];
    }
    
    if (IOS7) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
    }else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num-20) style:UITableViewStylePlain];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setBackgroundView:nil];
    
    [_tableView setBackgroundColor:XZHILBJ_colour];
    
    [self.view addSubview:_tableView];
}

#pragma -mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_wordsArray count]-2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *firstword = [_wordsArray objectAtIndex:section+1];
    
    return [[self.cityDic valueForKey:firstword] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *wordStr = [_wordsArray objectAtIndex:section+1];
    
    if ([[self.cityDic valueForKey:wordStr] count] == 0)
    {
        return 0;
    }
    
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *titleStr = [_wordsArray objectAtIndex:section+1];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,20)];
    
    view.backgroundColor = [UIColor colorWithRed:248.0/256 green:215.0/256 blue:177.0/256 alpha:1];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.bounds.size.width-24, view.bounds.size.height)];
    
    label.backgroundColor = [UIColor clearColor];	//透明色
    label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0, 0.6);
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = titleStr;
    [view addSubview:label];

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *wordStr = [_wordsArray objectAtIndex:indexPath.section+1];
    
    NSArray *arr = [self.cityDic valueForKey:wordStr];
    
    if (indexPath.section == 0) {
        if ([cell.textLabel.text isEqualToString:@"当前位置..."]) {
            cell.textLabel.text = nil;
        }
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = [[arr objectAtIndex:indexPath.row] cityName];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [_wordsArray objectAtIndex:indexPath.section+1];
    
    NSMutableArray *city = [self.cityDic valueForKey:key];
    
    City *c = [city objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(chuanCity:cityCode:)]) {
        
        [self.delegate chuanCity:c.cityName cityCode:c.code];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _wordsArray;
}

#pragma mark 将数据存放到数据库

- (void)stringBecomeDictionary
{
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"open_city" ofType:@"txt"];
    
    NSString *resultStr=[[NSString alloc]initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"resultStr in beginning is %@",resultStr);
    
    NSData *resultData=[NSData dataWithContentsOfFile:txtPath options:NSDataReadingMappedIfSafe error:nil];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *resultArray = [resultDic valueForKey:@"common"];
    
    for (NSDictionary *dic in resultArray){
        City *city = [[City alloc]init];
        city.cid=0;
        city.code = [dic valueForKey:@"code"];
        city.cityName = [dic valueForKey:@"city"];
        city.letter = [dic valueForKey:@"letter"];
        [_cityArray addObject:city];
    }
    
    [self sortCity:_cityArray];
}

//把城市进行排序
- (void)sortCity:(NSMutableArray *)cityArray
{
    //将城市按照首字母进行分组并放入字典
    for (int j = 0; j <_wordsArray.count; j++)
    {
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        NSString *s = [_wordsArray objectAtIndex:j];
        
        for (int i = 0; i < cityArray.count; i++)
        {
            City *cy = [cityArray objectAtIndex:i];
            if ([cy.letter isEqualToString:s]) {
                [a addObject:cy];
            }
        }
        
        [self.cityDic setObject:a forKey:s];
    }
    
    NSLog(@"sortCity..............");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end