//
//  waiyuViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "waiyuViewController.h"

#define  jianliWYDele @"api/resume_manage/language_list_delete?"
@interface waiyuViewController ()

@end

@implementation waiyuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myAry = [NSMutableArray array];
        myAry_jb = [NSMutableArray array];
        myAry_id = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"外语能力"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"外语能力"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = XZHILBJ_colour;
    int num = ios7jj;
	[self addBackBtn];
    [self addTitleLabel:@"外语能力"];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 46+num, iPhone_width-10, 40);
    [button setTitle:@"添加外语语种" forState:UIControlStateNormal];
    [button setTitleColor:RGBA(40, 100, 210, 1) forState:UIControlStateNormal]
    ;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [button addTarget:self action:@selector(tianjian:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"tianjiabg.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    myTabView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 90+num, iPhone_width, iPhone_height-90-num)style:UITableViewStyleGrouped];
    myTabView.delegate =self;
    myTabView.dataSource = self;
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTabView];
    [self configLangue];
}
//waiyu2的代理方法 用来传值
- (void)changeLangue:(NSMutableArray *)arry
{
    ResumeOperation *resume = [ResumeOperation defaultResume];
    [resume setValue:arry forKey:Language];
    if (myAry) {
        [myAry removeAllObjects];
        [myAry_jb removeAllObjects];
        [myAry_id removeAllObjects];
    }
    for (int i = 0; i<[arry count]; i++) {
        NSDictionary *dic = [arry objectAtIndex:i];
        NSString *str = [dic valueForKey:@"languageName"];
        NSString *str01 = [dic valueForKey:@"languageLevel"];
        NSString *str02 = [dic valueForKey:@"id"];
        [myAry addObject:str];
        [myAry_jb addObject:str01];
        [myAry_id addObject:str02];
    }
    [myTabView reloadData];
}
//从网络获取或者读本地数据
- (void)configLangue
{
    NSMutableArray*arry = [NSMutableArray arrayWithArray:[[[ResumeOperation defaultResume] resumeDictionary] valueForKey:Language]];
   
    if (myAry) {
        [myAry removeAllObjects];
        [myAry_jb removeAllObjects];
        [myAry_id removeAllObjects];
    }
    for (int i = 0; i<[arry count]; i++) {
        NSDictionary *dic = [arry objectAtIndex:i];
        NSString *str = [dic valueForKey:@"languageName"];
        NSString *str01 = [dic valueForKey:@"languageLevel"];
        NSString *str02 = [dic valueForKey:@"id"];
        [myAry addObject:str];
        [myAry_jb addObject:str01];
        [myAry_id addObject:str02];
    }
      [myTabView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myAry count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [myAry objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:Zhiti size:15];
    cell.textLabel.textColor = RGBA(40, 100, 210, 1);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = RGBA(40, 100, 210, 1);
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    label.text = [myAry_jb objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    waiyu2ViewController *waiyu = [[waiyu2ViewController alloc]init];
    waiyu.deleat = self;
    waiyu.myType = [NSString stringWithFormat:@"gai"];
    NSString *waiy = [myAry objectAtIndex:indexPath.row];
    NSString *jibie = [myAry_jb objectAtIndex:indexPath.row];
    waiyu.waiyu = [NSString stringWithFormat:@"%@",waiy];
    waiyu.jibie = [NSString stringWithFormat:@"%@",jibie];
    waiyu.myID = [NSString stringWithFormat:@"%@",[myAry_id objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:waiyu animated:YES];

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [myAry removeObjectAtIndex:[indexPath row]];
        [myAry_jb removeObjectAtIndex:[indexPath row]];
        NSString *myid = [myAry_id objectAtIndex:indexPath.row];
        [self resquext:myid];
         [myAry_id removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}
//网络请求
- (void)resquext:(NSString *)myId
{
//    NetWorkConnection *net = [[NetWorkConnection alloc]init];
//    net.delegate = self;
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kDeleEducation);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"user_language",@"table",myId,@"id", nil];
//    [net sendRequestURLStr:urlString ParamDic:param Method:@"GET"];
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
            for (int i = 0; i<myAry_id.count; i++) {
                NSString *str_id = [myAry_id objectAtIndex:i];
                NSString *str_wy = [myAry objectAtIndex:i];
                NSString *str_jb = [myAry_jb objectAtIndex:i];
                NSMutableDictionary*dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:str_id,@"id",str_wy,@"languageName",str_jb,@"languageLevel", nil];
                [arry addObject:dic];
            }
            ResumeOperation *st = [ResumeOperation defaultResume];
            [st setObject:arry forKey:Language];
        }else{
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}
- (void)requestTimeOut
{
}
- (void)receiveDataFail:(NSError *)error
{
}
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    NSDictionary *reslult = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSString *strr = [reslult valueForKey:@"error"];
     NSMutableArray *arry = [[NSMutableArray alloc]init];
    if ([strr integerValue]==0) {
        //此处应该删除
        for (int i = 0; i<myAry_id.count; i++) {
            NSString *str_id = [myAry_id objectAtIndex:i];
            NSString *str_wy = [myAry objectAtIndex:i];
            NSString *str_jb = [myAry_jb objectAtIndex:i];
            NSMutableDictionary*dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:str_id,@"id",str_wy,@"languageName",str_jb,@"languageLevel", nil];
            [arry addObject:dic];
        }
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:arry forKey:Language];
    }else{
    } 
}

- (void)tianjian:(id)sender
{
    waiyu2ViewController *waiyu = [[waiyu2ViewController alloc]init];
    waiyu.myType = [NSString stringWithFormat:@"jia"];
    waiyu.deleat = self;
    [self.navigationController pushViewController:waiyu animated:YES];
}
- (void)backUp:(id)sender
{
    if (myAry.count ==0) {
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"不完整"] forKey:@"leve_waiyu"];
    }else{
        ResumeOperation *st = [ResumeOperation defaultResume];
        [st setObject:[NSString stringWithFormat:@"完整"] forKey:@"leve_waiyu"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
