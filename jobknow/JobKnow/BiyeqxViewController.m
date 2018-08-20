//
//  BiyeqxViewController.m
//  JobKnow
//
//  Created by Zuo on 14-3-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BiyeqxViewController.h"
#import "MyTableCell.h"
@interface BiyeqxViewController ()

@end

@implementation BiyeqxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        num = ios7jj;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"毕业去向"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"毕业去向"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"毕业去向"];
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource =self;
    mytableView.backgroundView = nil;
    [self.view addSubview:mytableView];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    titleArray1 = [NSArray arrayWithObjects:@"签约工作",@"出国",@"国内升学",@"其他",nil];
    static NSString *identifier = @"Cell";
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labname.frame =CGRectMake(15, 10, 290, 20);
    cell.labname.text = [titleArray1 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        
    }else if (indexPath.section==0&&indexPath.row==1){
        
    }
    
    NSString *name = [titleArray1 objectAtIndex:indexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"byqx", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jyfx_byqx" object:self userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
