//
//  jingliViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jingliViewController.h"
#import "jingli2ViewController.h"
@interface jingliViewController ()

@end

@implementation jingliViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作经历"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"工作经历"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, iPhone_width, iPhone_height - 88-num) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = XZHILBJ_colour;
	[self addBackBtn];
    [self addTitleLabel:@"工作经历"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 46+num, iPhone_width-10, 40);
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [button setTitleColor:RGBA(40, 100, 210, 1) forState:UIControlStateNormal]
    ;
    [button setTitle:@"添加工作经历" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tianjian:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"tianjiabg.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];

}
- (void)viewWillAppear:(BOOL)animated
{
    _workArray = [NSMutableArray arrayWithArray:[[[ResumeOperation defaultResume] resumeDictionary] valueForKey:WorkExperience]];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_workArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        UILabel *cname = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
        cname.font = [UIFont systemFontOfSize:15];
        cname.tag = 101;
        [cname setBackgroundColor:[UIColor clearColor]];
        cname.textColor = RGBA(40, 100, 210, 1);
        cname.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:cname];
        
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 20)];
        timeLable.font = [UIFont systemFontOfSize:10];
        timeLable.tag = 102;
        [timeLable setBackgroundColor:[UIColor clearColor]];
        timeLable.textColor = RGBA(40, 100, 210, 1);
        timeLable.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:timeLable];
    }
    
    UILabel *c = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *t = (UILabel *)[cell.contentView viewWithTag:102];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *university = [_workArray objectAtIndex:indexPath.row];
    c.text = [university valueForKey:@"companyName"];
    NSString *time = [university valueForKey:@"startTime"];
    time = [time stringByAppendingFormat:@"-——%@",[university valueForKey:@"endTime"]];
    t.text = time;
    return cell;
}


-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [_workArray objectAtIndex:indexPath.row];
        [_workArray removeObject:dic];
        [self deleteEducation:dic];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_workArray objectAtIndex:indexPath.row];
    jingli2ViewController *eduVC = [[jingli2ViewController alloc] init];
    eduVC.workDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:eduVC animated:YES];
}

- (void)deleteEducation:(NSDictionary *)resumeDic
{
    NSString *eduid = [resumeDic valueForKey:@"id"];
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kDeleEducation);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"user_work",@"table",eduid,@"id", nil];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:param urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"nnnnn===============%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        
        ResumeOperation *resume = [ResumeOperation defaultResume];
        if (![_workArray isKindOfClass:[NSNull class]]) {
            [resume setObject:_workArray forKey:WorkExperience];
        }else{
            _workArray = [[NSMutableArray alloc] init];
            [resume setObject:_workArray forKey:WorkExperience];
        }
        if (_workArray.count > 0) {
            [resume setObject:@"完整" forKey:@"workExperience"];
        }else
        {
            [resume setObject:@"不完整" forKey:@"workExperience"];
        }
    }];
    
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _workArray = [NSMutableArray arrayWithArray:[[[ResumeOperation defaultResume] resumeDictionary] valueForKey:EducationKey]];
        [_tableView reloadData];
    }];
    [request startAsynchronous];
}



- (void)tianjian:(id)sender
{
    jingli2ViewController *jingli = [[jingli2ViewController alloc]init];
    [self.navigationController pushViewController:jingli animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
