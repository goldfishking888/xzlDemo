//
//  HR_ResumePriceEdit.m
//  JobKnow
//
//  Created by Suny on 15/8/27.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumePriceEdit.h"

@interface HR_ResumePriceEdit ()

@end

@implementation HR_ResumePriceEdit

-(void)initData
{
    num=ios7jj;
    
    dataArray=[[NSMutableArray alloc]init];//简历数据源
    selectArray=[[NSMutableArray alloc]init];//简历数据源
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{
    if(!price){
        ghostView.message=@"请先选择简历价格";
        [ghostView show];
        return;
    }
    if (_isFromResumeList) {
        [self resumePriceRequest];
    }else{
        [_delegate passPrice:price];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    self.view.backgroundColor = XZHILBJ_colour;
    //顶部导航栏样式
    for (int i=0; i<4; i++) {
        if (i==0) {
            //图片
            UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+num)];
            titleIV.backgroundColor = RGBA(255, 115, 4, 1);
            [self.view addSubview:titleIV];
            
        }else if(i==3){
            //标题
            navTitle =[[UILabel alloc] initWithFrame:CGRectMake(50, 0+Frame_Y, 210, 44)];
            [navTitle setText:@"简历价格"];
            [navTitle setTextAlignment:NSTextAlignmentCenter];
            [navTitle setBackgroundColor:[UIColor clearColor]];
            [navTitle setFont:[UIFont systemFontOfSize:18]];
            [navTitle setNumberOfLines:0];
            [navTitle setTag:999];
            [navTitle setTextColor:[UIColor whiteColor]];
            [self.view addSubview:navTitle];
            
        }else{
            //左右按钮
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            if (i==1) {
                //左按钮
                [btn setFrame:CGRectMake(10, Frame_Y+5, 50, 30)];
                [btn setEnabled:true];
                [btn setBackgroundColor:[UIColor clearColor]];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                [btn setTitleColor:[UIColor colorWithHex:0x2c2c2c alpha:1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(leftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //右按钮
                
                if (IOS7) {
                    btn.frame = CGRectMake(iPhone_width-60,24,50,35);
                }else
                {
                    btn.frame = CGRectMake(iPhone_width-60,10,50,35);
                }
                
//                [btn setImage:[UIImage imageNamed:@"hrcircle_resume_right"] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"hrcircle_resume_right"] forState:UIControlStateHighlighted];
                [btn setTitle:@"确定" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn  addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
    }
    
    _tableView = [[UITableView alloc] init];
    if (IOS7) {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    }else
    {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
        
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
//    if ([[HR_ResumeShareTool defaultTool] haveData]) {
//        dataArray = [HR_ResumeShareTool defaultTool].array_Resume;
//        
//        [self.tableView reloadData];
//        
        [self requestData];
//    }else{
//        [self requestData];
//    }
    
}

#pragma mark 网络连接方法
-(void)requestData
{
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRResumePriceList);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSArray *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        if(!resultDic){
            
            
            return ;
        }
        if(errorStr.integerValue == 200){
            NSMutableArray *array=[resultDic valueForKey:@"price"];
            [dataArray removeAllObjects];
            dataArray = [NSMutableArray arrayWithArray:array];
            
            [self.tableView reloadData];
            
        }
        
    }];
    [request setFailedBlock:^{
        
        [loadView hide:YES];
//        ghostView.message=@"";
//        [ghostView show];
        
    }];
    [request startAsynchronous];
    
}

//请求网络修改价格
-(void)resumePriceRequest
{
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRResumeSetResumePrice);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_resumeModel.resumeUid,@"res_uid",price,@"price",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSArray *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(errorStr.integerValue == 200){
            NSLog(@"简历修改成功");
            ghostView.message=@"简历价格设定成功";
            [ghostView show];
            
            if ([_delegate respondsToSelector:@selector(afterPriceEditSucceed)]) {
                [_delegate afterPriceEditSucceed];
            }
            
            [self performSelector:@selector(jumpBack) withObject:nil afterDelay:2];
            
            
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
    
}

-(void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  UITableView代理方法
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =[indexPath row];
    static NSString *CellIdentifier = @"Cell7";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(iPhone_width-30, 10, 20, 20)];
        [btn setBackgroundImage:[UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateSelected];
        [cell addSubview:btn];
        [btn setSelected:NO];
    }
    
    UIButton *btn;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:indexPath.row]];
    
    for (UIView *item in cell.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)item;
        }
    }

    if ([selectArray containsObject:[dataArray objectAtIndex:indexPath.row]]){
        btn.selected=YES;
    }else
    {
        btn.selected = NO;
    }

//    for (int i = 0; i<[dataArray count]; i++) {
//        NSDictionary *dic = [selectArray objectAtIndex:indexPath.row];
//        [dic setValue:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
////        [ addObject:dic];
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    price = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:indexPath.row]];
    [selectArray removeAllObjects];
    [selectArray addObject:[dataArray objectAtIndex:indexPath.row]];
    [_tableView reloadData];
//    for (int i = 0; i<[dataArray count]; i++) {
//        NSDictionary *dic = [[NSDictionary alloc] init];
//        [dic setValue:@"NO" forKey:[NSString stringWithFormat:@"%d",i]];
//        [selectArray addObject:dic];
//    }
//    [[selectArray objectAtIndex:indexPath.row] setValue:@"YES" forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
