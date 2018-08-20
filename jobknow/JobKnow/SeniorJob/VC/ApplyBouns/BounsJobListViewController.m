//
//  BounsJobListViewController.m
//  JobKnow
//
//  Created by Jiang on 15/9/15.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BounsJobListViewController.h"

@interface BounsJobListViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UITableView *_tableView;

}
@end

@implementation BounsJobListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"奖金职位"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ios7jj+44, iPhone_width, iPhone_height-ios7jj-44)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = XZHILBJ_colour;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_jobList count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = _jobList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"jobName"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _jobList[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectBounsJob:)]) {
        [_delegate didSelectBounsJob:dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
