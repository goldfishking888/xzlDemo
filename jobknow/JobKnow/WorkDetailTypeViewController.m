//
//  WorkDetailTypeViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "WorkDetailTypeViewController.h"
#import "PurchaseViewController.h"

@interface WorkDetailTypeViewController ()

@end

@implementation WorkDetailTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    num=ios7jj;
    
    [self addBackBtn];
    
    [self addTitleLabel:@"职业类别"];
    
    NSLog(@"jobItem is %@",_jobItem);

    NSLog(@"dataArray is %@",_dataArray);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(changeworkDetail:)]) {
        
        [self.delegate changeworkDetail:[[_dataArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
    }

    NSArray *view=self.navigationController.viewControllers;
    
    NSInteger count=[view count];
    
    [self.navigationController popToViewController:[view objectAtIndex:count-3] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end