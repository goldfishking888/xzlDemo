//
//  SelectCompanyViewController.m
//  JobKnow
//
//  Created by Jiang on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "SelectCompanyViewController.h"


@interface SelectCompanyViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{

    UITableView *_tableView;
    NSMutableArray *_companyArray;// dic (id,cname,pid)
    OLGhostAlertView *_ghost;
    UISearchBar *_searchBar;
}

@end

@implementation SelectCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"公司名称"];
    
    _companyArray  = [[NSMutableArray alloc] init];
    
    //搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44+ios7jj, iPhone_width, 50)];
    _searchBar.placeholder = @"请输入公司名称";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_searchBar];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 44+ios7jj+50, iPhone_width - 20, iPhone_height - 44-ios7jj-50) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _ghost = [[OLGhostAlertView alloc] initWithTitle:nil message:@"" timeout:3 dismissible:YES];
    [_ghost setPosition:OLGhostAlertViewPositionCenter];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 注册键盘通知

- (void)registerForKeyboardNotifications
{

    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardDidShow:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardDidShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat tableHeight = iPhone_height - 44-ios7jj-50 - kbSize.height;
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, tableHeight)];
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    CGFloat tableHeight = iPhone_height - 44-ios7jj-50;
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, tableHeight)];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *searchStr = _searchBar.text;
    [self requestSearchBar:searchStr];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - 请求搜索数据

- (void)requestSearchBar:(NSString *)search
{
    if (search.length == 0) {
        [_companyArray removeAllObjects];
        [self reloadDataOfTableView];
        return;
    }
    
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_cityCode,@"localcity",search,@"cname",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/senior/company_list?"];
    NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        if ([request.responseString isEqualToString:@"please login"] == NO) {
            
            NSArray *resultArray=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            if ([resultArray isKindOfClass:[NSArray class]] == YES) {

                [_companyArray removeAllObjects];
                _companyArray = [NSMutableArray arrayWithArray:resultArray];
                [self reloadDataOfTableView];

            }
        }
    }];
    [request setFailedBlock:^(void){
        _ghost.message = @"网络连接失败，请稍后重试";
        [_ghost show];
    }];
    [request startAsynchronous];

}

#pragma mark - UITableView相关

- (void)reloadDataOfTableView{
    
    if (_companyArray.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }else{
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = YES;
    }
    [_tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_companyArray.count == 0) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        return 0;
    }else{
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = YES;
        return _companyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_companyArray.count == 0) {
        return 0;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_companyArray.count == 0) {
        
        return nil;
        
    }else{
        
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary *dic = _companyArray[indexPath.row];
        cell.textLabel.text = dic[@"cname"];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_companyArray.count == 0) {
        
        
    }else{
        
        NSDictionary *dic = _companyArray[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(selectCompanyWithPid:companyName:)]) {
            [_delegate selectCompanyWithPid:[NSString stringWithFormat:@"%@",dic[@"pid"]] companyName:[NSString stringWithFormat:@"%@",dic[@"cname"]]];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

@end
