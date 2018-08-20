//
//  jiaoyuxxViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jiaoyuxxViewController.h"
#import "jiaoyu2ViewController.h"

@interface jiaoyuxxViewController ()

@end

@implementation jiaoyuxxViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"教育经历"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"教育经历"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
	[self addBackBtn];
    [self addTitleLabel:@"教育经历"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 46+num, iPhone_width-10, 40);
    [button setTitle:@"添加教育经历" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [button setTitleColor:RGBA(40, 100, 210, 1) forState:UIControlStateNormal]
    ;
    [button addTarget:self action:@selector(tianjian:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"tianjiabg.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-num) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor clearColor];
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _educationArray = [NSMutableArray arrayWithArray:[[[ResumeOperation defaultResume] resumeDictionary] valueForKey:EducationKey]];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_educationArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *university = [_educationArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:10];
    [cell.textLabel setTextColor:RGBA(40, 100, 210, 1)];
    NSString *school = [university valueForKey:@"school"];
    if (school.length == 0) {
        school = [university valueForKey:@"self_sw"];
    }
    cell.textLabel.frame = CGRectMake(20, 15, 200, 25);
    cell.textLabel.text = school;
    cell.detailTextLabel.text = [university valueForKey:@"graduate_time"];
    cell.detailTextLabel.frame = CGRectMake(200, 25, 200, 15);
    return cell;
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [_educationArray objectAtIndex:indexPath.row];
        [_educationArray removeObjectAtIndex:indexPath.row];
        [self deleteEducation:dic];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_educationArray objectAtIndex:indexPath.row];
    jiaoyu2ViewController *eduVC = [[jiaoyu2ViewController alloc] init];
    eduVC.eduDic = dic;
    [self.navigationController pushViewController:eduVC animated:YES];
}
- (void)deleteEducation:(NSDictionary *)resumeDic
{
    
    NSString *eduid = [resumeDic valueForKey:@"id"];
    NSLog(@"要删除的字典的id=%@",eduid);
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kDeleEducation);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"user_education",@"table",eduid,@"id", nil];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:param urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"删除的结果===============%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        
        ResumeOperation *resume = [ResumeOperation defaultResume];
        [resume setObject:_educationArray forKey:EducationKey];
        if (_educationArray.count > 0) {
            [resume setObject:@"完整" forKey:@"education"];
        }else
        {
            [resume setObject:@"不完整" forKey:@"education"];
        }
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _educationArray = [NSMutableArray arrayWithArray:[[[ResumeOperation defaultResume] resumeDictionary] valueForKey:EducationKey]];
        [_tableView reloadData];
    }];
    [request startAsynchronous];
}
- (void)tianjian:(id)sender
{
    jiaoyu2ViewController *jiaoui = [[jiaoyu2ViewController alloc]init];
    [self.navigationController pushViewController:jiaoui animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
