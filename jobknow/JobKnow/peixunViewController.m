//
//  peixunViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "peixunViewController.h"
#import "peixun2ViewController.h"
#import "JSONKit.h"
@interface peixunViewController ()

@end

@implementation peixunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        whereAry = [NSMutableArray array];
        idAry = [NSMutableArray array];
        contentAry =[NSMutableArray array];
        bookAry = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"培训经历"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"培训经历"];
}

//ff
- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
	self.view.backgroundColor = XZHILBJ_colour;
	[self addBackBtn];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTitleLabel:@"培训经历"];
     
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 46+num, iPhone_width-10, 40);
    [button setTitle:@"添加培训经历" forState:UIControlStateNormal];
    [button setTitleColor:RGBA(40, 100, 210, 1) forState:UIControlStateNormal]
    ;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [button addTarget:self action:@selector(tianjian:) forControlEvents:UIControlEventTouchUpInside];
     [button setBackgroundImage:[UIImage imageNamed:@"tianjiabg.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    myTabView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 90+num, iPhone_width, iPhone_height-90-num)style:UITableViewStyleGrouped];
    myTabView.backgroundView = nil;
    myTabView.delegate =self;
    myTabView.dataSource = self;
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
   [self.view addSubview:myTabView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ResumeOperation *sr = [ResumeOperation defaultResume];
    NSMutableArray *dic1 = [sr.resumeDictionary valueForKey:@"peixun"];
    if (whereAry) {
        [whereAry removeAllObjects];
        [contentAry removeAllObjects];
        [bookAry removeAllObjects];
        [idAry removeAllObjects];
    }
    NSLog(@"--------------------%@",dic1);
    //NSArray *ary = [dic objectAtIndex:0];
    for (int i = 0; i<[dic1 count]; i++) {
        NSDictionary *dic = [dic1 objectAtIndex:i];
        NSString *stt = [dic valueForKey:@"train_org"];
        NSString *str = [dic valueForKey:@"certificate"];
        NSString *str01 = [dic valueForKey:@"train_content"];
        NSString *str02 = [dic valueForKey:@"id"];
        [whereAry addObject:stt];
        [contentAry addObject:str01];
        [bookAry addObject:str];
        [idAry addObject:str02];
    }
    [myTabView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [whereAry count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        UILabel *labeil1 = (UILabel *)[cell.contentView viewWithTag:521];
        [labeil1 removeFromSuperview];
        UILabel *labeil2 = (UILabel *)[cell.contentView viewWithTag:522];
        [labeil2 removeFromSuperview];
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //培训机构
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGBA(40, 100, 210, 1);
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:15];
    label.text = [whereAry objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label];
    //培训内容
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 150, 30)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = RGBA(40, 100, 210, 1);
    label2.tag = 522;
    label2.font = [UIFont fontWithName:Zhiti size:12];
    label2.text = [contentAry objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label2];
    //获得证书
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(170, 15, 115, 30)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentRight;
    label1.textColor = RGBA(40, 100, 210, 1);
    label1.tag = 521;
    label1.font = [UIFont fontWithName:Zhiti size:14];
    label1.text = [bookAry objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    peixun2ViewController *waiyu = [[peixun2ViewController alloc]init];
    waiyu.myType = [NSString stringWithFormat:@"gai"];
    NSString *wher = [whereAry objectAtIndex:indexPath.row];
    NSString *conten = [contentAry objectAtIndex:indexPath.row];
    NSString *bok = [bookAry objectAtIndex:indexPath.row];
    waiyu.wheretr = [NSString stringWithFormat:@"%@",wher];
    waiyu.contentr = [NSString stringWithFormat:@"%@",conten];
    waiyu.booktr = [NSString stringWithFormat:@"%@",bok];
    waiyu.myId = [NSString stringWithFormat:@"%@",[idAry objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:waiyu animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [whereAry removeObjectAtIndex:[indexPath row]];
        [contentAry removeObjectAtIndex:[indexPath row]];
        [bookAry removeObjectAtIndex:[indexPath row]];
        NSString *myid = [idAry objectAtIndex:indexPath.row];
        [self resquext:myid];
        [idAry removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}
//删除简历
- (void)resquext:(NSString *)myId
{
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kDeleEducation);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,@"user_train",@"table",myId,@"id", nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *strr = [resultDic valueForKey:@"error"];
        NSMutableArray *arry = [[NSMutableArray alloc]init];
        if ([strr integerValue]==0) {
            //此处应该删除
            ResumeOperation *st = [ResumeOperation defaultResume];
            for (int i = 0; i<idAry.count; i++) {
                NSString *str_id = [idAry objectAtIndex:i];
                NSString *str_where = [whereAry objectAtIndex:i];
                NSString *str_content = [contentAry objectAtIndex:i];
                NSString *str_book = [bookAry objectAtIndex:i];
                NSMutableDictionary*dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:str_id,@"id",str_where,@"train_org",str_content,@"train_content",str_book,@"certificate", nil];
                [arry addObject:dic];
            }
            [st setObject:arry forKey:@"peixun"];
        }else{
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}

- (void)backUp:(id)sender
{
    if (whereAry.count ==0) {
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"不完整"] forKey:@"leve_peixun"];
    }else{
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve_peixun"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tianjian:(id)sender
{
    peixun2ViewController *peixun = [[peixun2ViewController alloc]init];
    peixun.myType = [NSString stringWithFormat:@"jia"];
    [self.navigationController pushViewController:peixun animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
