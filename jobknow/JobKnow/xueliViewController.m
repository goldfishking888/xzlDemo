//
//  xueliViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-6.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "xueliViewController.h"

@interface xueliViewController ()

@end

@implementation xueliViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择学历"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择学历"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建tableView
    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44) style:UITableViewStylePlain];
    myTabView.backgroundView = nil;
    myTabView.delegate = self;
    myTabView.dataSource = self;
    [self.view addSubview:myTabView];
 
	[self addBackBtn];
    [self addTitleLabel:@"选择学历"];
    
    showArray = [NSMutableArray arrayWithObjects:@"不限",@"初中",@"高中",@"中技",@"中专",@"大专",@"本科",@"硕士",@"博士",@"博士后",@"其他", nil];
     showArray_code= [NSMutableArray arrayWithObjects:@"0",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"99", nil];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showArray count];
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
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.textLabel.text = [showArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *name = [showArray_code objectAtIndex:indexPath.row];
    [self.selectDelegate selectValueToUp:name];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
