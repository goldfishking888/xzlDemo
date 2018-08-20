//
//  CompanyJobViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-6-24.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "CompanyJobViewController.h"
#import "JobInfo.h"
@interface CompanyJobViewController ()

@end

@implementation CompanyJobViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位结果"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位结果"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *EntryBackground = [UIImage imageNamed:@"app_background.png"];
    UIImage *entryBackgrounds = [EntryBackground stretchableImageWithLeftCapWidth:10 topCapHeight:10];

    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44-20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:entryBackgrounds]];
    [self.view addSubview:_tableView];
    [self addBackBtn];
    [self addTitleLabel:@"搜索结果"];
    
    tip = [[ActivetView alloc] initWithFrame:CGRectMake(120, 10, 70, 30)];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, 0, iPhone_width, 44);
    [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_moreBtn addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn addSubview:tip];
    [_tableView setTableFooterView:_moreBtn];
    
    
    more = 0;
    _companyArray = [NSMutableArray array];
    [self requestCompanys];
}

- (void)requestCompanys
{
    more ++;
    
    [tip show:@"加载中..."];
    [_moreBtn setTitle:@"" forState:UIControlStateNormal];
   
    NSString *num = [[NSString alloc] initWithFormat:@"%d",more];
    NSDictionary *parmDic = [[NSDictionary alloc]initWithObjectsAndKeys:num,@"page",self.codet.cid,@"cid", nil];
    NSString *url = kCombineURL(KXZhiLiaoAPI, @"new_api/get/get_job_bycid?");
    NSURL *urlString = [NetWorkConnection dictionaryBecomeUrl:parmDic urlString:url];

    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:urlString];
    [request setCompletionBlock:^{
        
        [tip hidden];
//        NSString *result = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//        
//        result = [SaveJob string2Json2:result];
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];

        NSArray *resultArray = [resultDic valueForKey:@"job"];
        if (resultArray.count!=0) {
            [self jsonFromArray:resultArray];
        }else
        {
            _moreBtn.userInteractionEnabled = NO;
            [_moreBtn setTitle:@"该企业暂无招聘信息哦～" forState:UIControlStateNormal];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}


- (void)jsonFromArray:(NSArray *)arr
{
    NSInteger num = 0;
    for (NSDictionary *dic in arr) {
        JobInfo *info = [[JobInfo alloc] init];
        info.cid = [dic valueForKey:@"bookId"];
        info.companyName = [dic valueForKey:@"companyName"];
        info.salary = [dic valueForKey:@"salary"];
        info.jobName = [dic valueForKey:@"jobName"];
//         info.publishDate = [JobInfo stringBecomeTime:[dic valueForKey:@"pubdate"]];
        info.publishDate = [dic valueForKey:@"pubDate"];
        [_companyArray addObject:info];
        num ++;
    }
    if (num >= 20) {
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    }else
    {
        [self.tableView setTableFooterView:nil];
    }
    
    NSLog(@"========================%@",_companyArray);
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }

    }
    
    JobInfo *job = [_companyArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_60px.png"]];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_60.png"]];
    cell.backgroundView = img;
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel *namel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, iPhone_width - 100, 22)];
    namel.text = job.jobName;
    [namel setTextColor:RGBA(40, 100, 210, 1)];
    [namel setFont:[UIFont boldSystemFontOfSize:13]];
    [namel setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:namel];
    
    
    UILabel *companyn = [[UILabel alloc] initWithFrame:CGRectMake(10, 39, iPhone_width - 100, 22)];
    companyn.text = job.companyName;
    NSLog(@"companyName==%@",job.companyName);
    [companyn setTextColor:[UIColor darkGrayColor]];
    [companyn setFont:[UIFont systemFontOfSize:12]];
    [companyn setBackgroundColor:[UIColor clearColor]];

    [cell.contentView addSubview:companyn];
    
    
    UILabel *pubdate = [[UILabel alloc] initWithFrame:CGRectMake(220, 39, 90, 22)];
    pubdate.textAlignment = NSTextAlignmentRight;
    pubdate.text = job.publishDate;
    NSLog(@"publishDate==%@",job.publishDate);
    [pubdate setBackgroundColor:[UIColor clearColor]];

    [pubdate setTextColor:[UIColor darkGrayColor]];
    [pubdate setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:pubdate];
    
    
    UILabel *salary = [[UILabel alloc] initWithFrame:CGRectMake(220, 8, 90, 22)];
    salary.textAlignment = NSTextAlignmentRight;
    salary.text = job.salary;
    [salary setBackgroundColor:[UIColor clearColor]];

    [salary setTextColor:RGBA(223, 90, 0, 1)];
    [salary setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:salary];
    _tableView.separatorColor= [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OLGhostAlertView *olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    olalterView.position = OLGhostAlertViewPositionCenter;
    olalterView.message =@"亲，请通过职位订阅或搜索通道查看职位详情";
    [olalterView show];

    
}
- (void)moreInfo:(id)sender
{
    [self requestCompanys];
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
