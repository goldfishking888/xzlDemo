//
//  ComViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-6-24.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ComViewController.h"
#import "CodeType.h"
#import "CompanyJobViewController.h"
@interface ComViewController ()

@end

@implementation ComViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        num = ios7jj;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"公司搜索结果"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"公司搜索结果"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _companyArray = [NSMutableArray array];
    
    tip = [[ActivetView alloc] initWithFrame:CGRectMake(120, 10, 70, 30)];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44-20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    [self addBackBtn];
    [self addTitleLabel:@"搜索结果"];
    
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, 0, iPhone_width, 44);
    [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_moreBtn addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn addSubview:tip];
    [_tableView setTableFooterView:_moreBtn];
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:@"网络连接失败，请检查网络" timeout:1 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    more = 0;
    [self requestCompanys];
}

- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreInfo:(id)sender
{
    [self requestCompanys];
}


- (void)requestCompanys
{
    more ++;
    [tip show:@"加载中..."];
    [_moreBtn setTitle:@"" forState:UIControlStateNormal];
    NSString *num2 = [[NSString alloc] initWithFormat:@"%d",more];

     CityInfo *city = [CityInfo standerDefault];
    
    
    NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:num2,@"page",self.companyName,@"keyword",city.cityCode,LocaCity, nil];
    NSString *url = kCombineURL(KXZhiLiaoAPI, @"new_api/user/company_search?");
    NSURL *urlString = [NetWorkConnection dictionaryBecomeUrl:parmDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:urlString];
    [request setCompletionBlock:^{
        NSString *result = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//        NSLog(@"================-------%@",result);
        [tip hidden];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSArray *resultArray = [resultDic valueForKey:@"data"];
        if (resultArray.count!=0) {
            [self jsonFromArray:resultArray];
        }else
        {
            [_moreBtn setTitle:@"您输入的关键字不匹配，或该企业暂无招聘信息" forState:UIControlStateNormal];
        }
    }];
    [request setFailedBlock:^{
        more --;
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [alert show];
        [tip hidden];
    }];
    [request startAsynchronous];
}


- (void)jsonFromArray:(NSArray *)arr
{
    NSLog(@"数组1=%@",arr);
    NSInteger num1 = 0;
    //NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        CodeType *ct = [[CodeType alloc] init];
        ct.isBook = [dic valueForKey:@"bookLocationName"];
        ct.cName = [dic valueForKey:@"bookPostName"];
        ct.cid = [dic valueForKey:@"bookId"];
        [_companyArray addObject:ct];
        num1++;
    }
    if (num1 >= 20) {
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    }else
    {
        [self.tableView setTableFooterView:nil];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_companyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_60.png"]];
    cell.backgroundView = img;
    cell.backgroundColor=[UIColor clearColor];

    
    CodeType *ct = [_companyArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *namel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, iPhone_width - 50, 44)];
    namel.text = ct.cName;
    [namel setBackgroundColor:[UIColor clearColor]];
    [namel setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:namel];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_60px.png"]]; 
    _tableView.separatorColor= [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CodeType *ct = [_companyArray objectAtIndex:indexPath.row];
    CompanyJobViewController *comVC = [[CompanyJobViewController alloc] init];
    comVC.codet = ct;
    [self.navigationController pushViewController:comVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
