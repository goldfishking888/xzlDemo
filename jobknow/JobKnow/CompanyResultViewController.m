//
//  CompanyResultViewController.m
//  JobKnow
//
//  Created by Apple on 14-3-19.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "Company.h"
#import "CompanyResultViewController.h"
#import "allCityViewController.h"
#import "OtherLogin.h"

@interface CompanyResultViewController ()

@end

@implementation CompanyResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"企业订阅搜索结果"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"企业订阅搜索结果"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configHeadView];
    [self addBackBtn];
    [self addTitleLabel:@"搜索结果"];
    
    num=ios7jj;
    page=0;
    
    dataArray=[[NSMutableArray alloc]init];
    CityInfo *cityInfo=[CityInfo standerDefault];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    db=[UserDatabase sharedInstance];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    //屏幕右上方的city按钮
    _cityBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.tag=100;
    _cityBtn.backgroundColor=[UIColor clearColor];
    _cityBtn.frame = CGRectMake(iPhone_width-45,-2+num,45,50);
    _cityBtn.showsTouchWhenHighlighted=YES;
    _cityBtn.titleLabel.font=[UIFont systemFontOfSize: 17];
    [_cityBtn setTitle:cityInfo.cityName forState:UIControlStateNormal];
    [_cityBtn setTitle:cityInfo.cityName forState:UIControlStateHighlighted];
    [_cityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cityBtn];
    
    _searchImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbackgroundView.png"]];
    _searchImage.userInteractionEnabled=YES;
    _searchImage.frame=CGRectMake(5,44+num+12,iPhone_width-10,40);
    [self.view addSubview:_searchImage];
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search2.png"]];
    image.frame=CGRectMake(8,9,21,21);
    [_searchImage addSubview:image];
    
    //新的收索框
    newTextfield =[[UITextField alloc]initWithFrame:CGRectMake(35,-5,200,50)];
    newTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newTextfield.returnKeyType = UIReturnKeySearch;
    newTextfield.borderStyle = UITextBorderStyleNone;
    newTextfield.font = [UIFont systemFontOfSize:14];
    newTextfield.delegate = self;
    newTextfield.placeholder = @"请输入订阅企业或关键字";
    [_searchImage addSubview:newTextfield];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(285,10,21,21);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchImage addSubview:deleteBtn];
    
    UIButton *deleteBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn2.backgroundColor=[UIColor clearColor];
    deleteBtn2.frame=CGRectMake(275,0,50,40);
    [deleteBtn2 addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchImage addSubview:deleteBtn2];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(0,54+num+40+18,iPhone_width,2)];
    _label.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:_label];
    
    if ([dataArray count]!=0) {
        
        _label.alpha=1;
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,54+num+40+20,iPhone_width, iPhone_height-44-num-50-20) style:UITableViewStylePlain];
    }else
    {
        _label.alpha=0;
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,54+num+40+20,iPhone_width,0)];
    }
    
    _resultTableView.backgroundColor=[UIColor clearColor];
    _resultTableView.allowsSelection =NO;
    _resultTableView.delegate = self;
    _resultTableView.dataSource =self;
    _resultTableView.backgroundView = nil;
    [self.view addSubview:_resultTableView];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.alpha=0;
    _moreBtn.frame = CGRectMake(0, 0, iPhone_width, 44);
    _moreBtn.tag = 11;
    [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_resultTableView setTableFooterView:_moreBtn];
}

-(void)deleteBtnClick:(id)sender
{
    newTextfield.text=@"";
}

#pragma mark  更多按钮响应事件
-(void)moreInfo:(id)sender
{
    /*
     1.判断网络是否连接
     2.page加1，然后下载.
     3.
     */
    //NSLog(@"更多按钮执行到了。。。。。。");
    Net *n=[Net standerDefault];
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        newTextfield.text=@"";
        return;
    }
    
    if ([textFieldStr length]>0) {
        
        page++;
        NSString *pageStr=[NSString stringWithFormat:@"%d",page];
//        net=[[NetWorkConnection alloc]init]; //创建并发送请求
//        net.delegate = self;
        NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",textFieldStr,@"keyword",kAreaCode,LocaCity, nil];
        NSString *url = kCombineURL(KXZhiLiaoAPI, kEnterpriseShow);
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _moreBtn.alpha=0;
//        [net request:url param:paramDic andTime:20];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSArray *resultArray=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            
            NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            if([str isEqualToString:@"please login"])
            {
                OtherLogin *other = [OtherLogin standerDefault];
                [other otherAreaLogin];
                return ;
            }
        
            
            if (resultArray) {
                
            }else
            {
                ghostView.message=@"请求失败";
                [ghostView show];
                return;
            }
            
            if (resultArray&&[resultArray count]==0) {
                
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                lab.text=@"抱歉,暂无相关数据,请换个条件试试吧";
                
                [self.view addSubview:lab];
            }
            
            
            for (int i=0;i<[resultArray count];i++) {
                Company *company=[[Company alloc]init];
                NSDictionary *dic=[resultArray objectAtIndex:i];
                company.cid=[dic  valueForKey:@"bookId"];
                company.cName=[dic valueForKey:@"bookPostName"];
                company.isBook=[dic valueForKey:@"isBook"];
                company.cityName=[dic valueForKey:@"bookLocationName"];
                company.cityCode=[dic valueForKey:@"bookLocation"];
                [dataArray addObject:company];
            }
            
            if ([resultArray count]<20) {
                [self.resultTableView setTableFooterView:nil];
            }
            
            if ([dataArray count]!=0) {
                
                _label.alpha=1;
                _resultTableView.frame= CGRectMake(0,54+num+40+20,iPhone_width, iPhone_height-44-num-50-20);
                _moreBtn.alpha=1;
            }else
            {
                _label.alpha=0;
                _resultTableView.frame=CGRectMake(0,54+num+40+20,iPhone_width,0);
            }
            
            [_resultTableView reloadData];
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            ghostView.message=@"请求失败";
            [ghostView show];
            
        }];
        [request startAsynchronous];
        
    }
}

#pragma mark 城市界面
-(void)cityBtnClick:(id)sender
{
    NSLog(@"cityBtn is Clicked!");
    allCityViewController *allCityVC=[[allCityViewController  alloc]init];
    allCityVC.delegate=self;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

#pragma mark SendRequest代理方法


-(void)receiveASIRequestFinish:(NSData *)receData
{
    [loadView hide:YES];
    
    NSString *str= [[NSString alloc]initWithData:receData encoding:NSUTF8StringEncoding];
    
    if([str isEqualToString:@"please login"])
    {
        OtherLogin *other = [OtherLogin standerDefault];
        [other otherAreaLogin];
        return ;
    }
    
    NSArray*resultArray = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    
    if (resultArray) {
        
    }else
    {
        ghostView.message=@"请求失败";
        [ghostView show];
        return;
    }
    
    if (resultArray&&[resultArray count]==0) {
        
        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
        
        image.tag=10000;
        
        image.frame=CGRectMake(110,230,100,100);
        
        [self.view addSubview:image];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
        
        lab.tag=10001;
        
        lab.backgroundColor=[UIColor clearColor];
        
        lab.font=[UIFont systemFontOfSize:14];
        
        lab.textColor=[UIColor orangeColor];
        
        lab.text=@"抱歉,暂无相关数据,请换个条件试试吧";
        
        [self.view addSubview:lab];
    }
    
    
    for (int i=0;i<[resultArray count];i++) {
        Company *company=[[Company alloc]init];
        NSDictionary *dic=[resultArray objectAtIndex:i];
        company.cid=[dic  valueForKey:@"bookId"];
        company.cName=[dic valueForKey:@"bookPostName"];
        company.isBook=[dic valueForKey:@"isBook"];
        company.cityName=[dic valueForKey:@"bookLocationName"];
        company.cityCode=[dic valueForKey:@"bookLocation"];
        [dataArray addObject:company];
    }
    
    if ([resultArray count]<20) {
        [self.resultTableView setTableFooterView:nil];
    }
    
    if ([dataArray count]!=0) {
        
        _label.alpha=1;
        _resultTableView.frame= CGRectMake(0,54+num+40+20,iPhone_width, iPhone_height-44-num-50-20);
        _moreBtn.alpha=1;
    }else
    {
        _label.alpha=0;
        _resultTableView.frame=CGRectMake(0,54+num+40+20,iPhone_width,0);
    }
    
    [_resultTableView reloadData];
}

-(void)receiveASIRequestFail:(NSError *)error
{
    [loadView hide:YES];
    ghostView.message=@"请求失败";
    [ghostView show];
}

#pragma mark UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else
    {
        for (UIView *v in [cell.contentView subviews]) {
            [v removeFromSuperview];
        }
    }
    
    Company *company = [dataArray objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 240, 44)];//显示公司名字
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 2;
    label.text = company.cName;
    [label setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:label];
    
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom]; //订阅按钮
    readBtn.tag = indexPath.row;
    readBtn.frame = CGRectMake(iPhone_width -70,7.5,60,30);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [readBtn setTitle:@"订阅" forState:UIControlStateNormal];
    [readBtn setTitle:@"订阅" forState:UIControlStateHighlighted];
    
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [readBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_radio_on.png"] forState:UIControlStateNormal];
    [readBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_radio_on.png"] forState:UIControlStateHighlighted];
    
    [readBtn addTarget:self action:@selector(readCompany:) forControlEvents:UIControlEventTouchUpInside];
    
    //如果当前公司没有被点击
    if ([company.isBook intValue] == 0){
        
        [readBtn setTitle:@"订阅" forState:UIControlStateNormal];
        [readBtn setTitle:@"订阅" forState:UIControlStateHighlighted];
        
    }else
    {
        [readBtn setTitle:@"取消订阅" forState:UIControlStateNormal];
        [readBtn setTitle:@"取消订阅" forState:UIControlStateHighlighted];
    }
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_60.png"]];
    cell.backgroundView = img;
    cell.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:readBtn];
    self.resultTableView.separatorColor= [UIColor clearColor];
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

#pragma mark 城市界面详解
-(void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName
{
    NSLog(@"城市代理方法实现。。");
    CityInfo*cityInfo=[CityInfo standerDefault];
    [_cityBtn setTitle:cityInfo.cityName forState:UIControlStateNormal];
    [_cityBtn setTitle:cityInfo.cityName forState:UIControlStateHighlighted];
}

#pragma mark  textField代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"开始编辑的时候响应");
    
    [newTextfield becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [newTextfield resignFirstResponder];
    
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:10000];
    
    [imageView removeFromSuperview];
    
    UILabel *lab=(UILabel *)[self.view viewWithTag:10001];
    [lab removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        _resultTableView.frame=CGRectMake(0,54+num+40,iPhone_width, iPhone_height-44-num-50);
    }];
    
    /***判断是否联网***/
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        newTextfield.text=@"";
        return YES;
    }
    
    textFieldStr=newTextfield.text;
    
    if ([textFieldStr length]!=0){
        
        page=1;
        NSString *pageStr = [[NSString alloc] initWithFormat:@"%d",page];
//        net=[[NetWorkConnection alloc]init]; //创建并发送请求
//        net.delegate = self;
        NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",textFieldStr,@"keyword",kAreaCode,LocaCity, nil];
        NSString *url = kCombineURL(KXZhiLiaoAPI, kEnterpriseShow);
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _moreBtn.alpha=0;
        
//        [net request:url param:paramDic andTime:20];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSArray *resultArray=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            
            NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            if([str isEqualToString:@"please login"])
            {
                OtherLogin *other = [OtherLogin standerDefault];
                [other otherAreaLogin];
                return ;
            }
            
            
            if (resultArray) {
                
            }else
            {
                ghostView.message=@"请求失败";
                [ghostView show];
                return;
            }
            
            if (resultArray&&[resultArray count]==0) {
                
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                lab.text=@"抱歉,暂无相关数据,请换个条件试试吧";
                
                [self.view addSubview:lab];
            }
            
            
            for (int i=0;i<[resultArray count];i++) {
                Company *company=[[Company alloc]init];
                NSDictionary *dic=[resultArray objectAtIndex:i];
                company.cid=[dic  valueForKey:@"bookId"];
                company.cName=[dic valueForKey:@"bookPostName"];
                company.isBook=[dic valueForKey:@"isBook"];
                company.cityName=[dic valueForKey:@"bookLocationName"];
                company.cityCode=[dic valueForKey:@"bookLocation"];
                [dataArray addObject:company];
            }
            
            if ([resultArray count]<20) {
                [self.resultTableView setTableFooterView:nil];
            }
            
            if ([dataArray count]!=0) {
                
                _label.alpha=1;
                _resultTableView.frame= CGRectMake(0,54+num+40+20,iPhone_width, iPhone_height-44-num-50-20);
                _moreBtn.alpha=1;
            }else
            {
                _label.alpha=0;
                _resultTableView.frame=CGRectMake(0,54+num+40+20,iPhone_width,0);
            }
            
            [_resultTableView reloadData];
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            ghostView.message=@"请求失败";
            [ghostView show];
            
        }];
        [request startAsynchronous];
        
    }else
    {
        ghostView.message=@"请先输入企业关键字";
        [ghostView show];
    }
    
    if ([dataArray count]!=0) {
        [dataArray removeAllObjects];
        [_resultTableView reloadData];
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕的时候执行到了。。。。");
    [newTextfield resignFirstResponder];
}

//订阅按钮响应
- (void)readCompany:(id)sender
{
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    UIButton *btn = (UIButton *)sender;
    
    btn.userInteractionEnabled=NO;
    
    CityInfo *cityInfo=[CityInfo standerDefault];
    
    
    //首先判断是否已经有3个城市
    NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
    NSArray *bookCityArray=[dic allKeys];
    
    if ([bookCityArray count]>=3) {
        
        //如果当前城市是订阅城市中的一个就继续执行，否则就提醒。
        if(![self judgeReaderOrNot:cityInfo.cityName]) {
            ghostView.message=@"您最多订阅3个城市";
            [ghostView show];
            return;
        }
    }
    
    Company *company = [dataArray objectAtIndex:btn.tag];
    
    NSString *url = nil;
    
    /**如果当前公司没有订阅**/
    
    if ([company.isBook integerValue] == 0){
        
        count=[[db getAllRecords:@"1"] count];
        
        if (count <10){

            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            count++;
            
            url=kCombineURL(KXZhiLiaoAPI, kBookerCreat);
            
            company.isBook = @"1";
            
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                    
                                    IMEI,@"userImei",kUserTokenStr,@"userToken",
                                    
                                    @"1",@"flag",cityInfo.cityCode,@"searchLocation",     //订阅类型，订阅城市
                                    
                                    @"",@"searchPost",@"",@"searchIndustry",          //职位类别,行业类别
                                    
                                    @"",@"searchTreatment",@"",@"searchKeyword",      //职位待遇，职位关键词
                                    
                                    @"",@"searchNature",@"",@"searchWorkExperience",  //公司性质，工作经验
                                    
                                    @"",@"searchPublished",@"",@"searchEducational",  //发布日期，教育经历
                                    
                                    @"",@"searchType",company.cid,@"searchBookId", nil];      //工作类型，BookId
            
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
            
            __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
            
            [request setTimeOutSeconds:10];
            
            [request setCompletionBlock:^(){
                
                [loadView hide:YES];
                
                btn.userInteractionEnabled=YES;
                [btn setTitle:@"取消订阅" forState:UIControlStateNormal];
                [btn setTitle:@"取消订阅" forState:UIControlStateHighlighted];
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
                
                
                NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
                
                if([str isEqualToString:@"please login"])
                {
                    OtherLogin *other = [OtherLogin standerDefault];
                    [other otherAreaLogin];
                    return ;
                }
                
                NSLog(@"resultDic  in  Company is %@",resultDic);
                
                if (resultDic) {
                    
                }else
                {
                   ghostView.message=@"订阅失败";
                   [ghostView show];
                   return;
                }
                
                JobModel *model=[[JobModel alloc]init];
                model.flag=@"1";
                model.industry=@"";
                model.positionName=company.cName;
                model.cityStr=cityInfo.cityName;
                model.cityCodeStr=cityInfo.cityCode;
                model.bookID=[resultDic valueForKey:@"bookId"];
                model.todayData=[resultDic valueForKey:@"bookTodayData"];
                model.totalData=[resultDic valueForKey:@"bookTotalData"];
                [db addOneRecord:model];
                
                //判断当前城市是否已经订阅过
                if (![self judgeReaderOrNot:cityInfo.cityName]){
                    NSMutableDictionary *dic2=[NSMutableDictionary dictionaryWithDictionary:dic];
                    NSNumber *number=[NSNumber numberWithInteger:0];
                    [dic2 setObject:number forKey:cityInfo.cityName];
                    [userDefaults setObject:dic2 forKey:@"bookCity"];
                    [userDefaults synchronize];
                }
            }];
            
            [request setFailedBlock:^(){
                [loadView hide:YES];
                ghostView.message=@"订阅失败";
                [ghostView show];
            }];
            
            [request startAsynchronous];
            
        }else{
            
            btn.userInteractionEnabled=YES;
            ghostView.message = @"最多订阅10条";
            [ghostView show];
        }
        
    }else{
        
        
        count=[[db getAllRecords:@"1"] count];
        
        if (count>=1) {
            
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            company.isBook = @"0";
            
            url = kCombineURL(KXZhiLiaoAPI, kCancelReadCompany);
            
            count--;
            
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                    IMEI,@"userImei",kUserTokenStr,@"userToken",
                                    @"1",@"flag",cityInfo.cityCode,@"localcity",company.cid,@"bookId",nil];      //订阅类型，订阅城市
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
            
            __weak  ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
            
            [request setCompletionBlock:^(){
                
                [loadView hide:YES];
                
                btn.userInteractionEnabled=YES;
                
                [btn setTitle:@"订阅" forState:UIControlStateNormal];
                [btn setTitle:@"订阅" forState:UIControlStateHighlighted];
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"resultDicInCancel is %@",resultDic);
                
                NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
                
                if([str isEqualToString:@"please login"])
                {
                    OtherLogin *other = [OtherLogin standerDefault];
                    [other otherAreaLogin];
                    return ;
                }
                
                NSString *errorStr=[resultDic valueForKey:@"error"];
                
                if (errorStr&&errorStr.integerValue==0) {
                    
                    JobModel *model=[[JobModel alloc]init];
                    model.flag=@"1";
                    model.industry=@"";
                    model.positionName=company.cName;
                    model.bookID=company.cid;
                    model.todayData=@"";
                    model.totalData=@"";
                    model.cityStr=company.cityName;
                    model.cityCodeStr=company.cityCode;
                    [db deleteRecord:model];
                    
                    //每次删除一个企业订阅时，查看当前城市的详细订阅是否为0
                    NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
                    
                    NSLog(@"model.cityStr is %@",model.cityStr);
                    
                    if (![self ifExist:model.cityStr]){
                        NSLog(@"这里执行到了。。1");
                        NSMutableDictionary *bookCityDic4=[NSMutableDictionary dictionaryWithDictionary:dic];
                        [bookCityDic4 removeObjectForKey:model.cityStr];
                        [userDefaults setObject:bookCityDic4 forKey:@"bookCity"];
                        [userDefaults synchronize];
                        NSLog(@"这里执行到了。。2");
                    }
                    
                    NSDictionary*bookCityDic5=[userDefaults valueForKey:@"bookCity"];
                    NSLog(@"bookCityDic5 is %@",bookCityDic5);
                    
                }else
                {
                    ghostView.message=@"删除失败";
                    [ghostView show];
                    return;
                }
            }];
            
            [request setFailedBlock:^(){
                
                [loadView hide:YES];
                ghostView.message=@"删除失败";
                [ghostView show];
                
            }];
            
            [request startAsynchronous];
            
        }else
        {
            ghostView.message=@"请先订阅职位";
            [ghostView show];
        }
        
    }
}

//查看数据库中还有没有城市名为cityStr的城市订阅的职位
-(BOOL)ifExist:(NSString *)cityStr
{
    //从数据库中找出订阅的城市
    NSArray *cityArray=[db getAllCityRecords];
    
    NSMutableArray *cityArray2=[[NSMutableArray alloc]init];
    
    for (JobModel *model in cityArray) {
        [cityArray2 addObject:model.cityStr];
    }
    
    for (NSString *modelCity in cityArray2) {
        
        if ([cityStr isEqualToString:modelCity]) {
            return YES;
        }
        
    }
    return NO;
}

//判断当前城市是否已经订阅过。
-(BOOL)judgeReaderOrNot:(NSString *)cityStr
{
    NSMutableDictionary *bookCityDic=[userDefaults valueForKey:@"bookCity"];
    
    NSMutableArray *bookCityArray=(NSMutableArray *)[bookCityDic allKeys];
    
    NSLog(@"bookCityArray is %@",bookCityArray);
    
    for (NSString *bookCityStr in bookCityArray) {
        
        if ([bookCityStr isEqualToString:cityStr]) {
            return YES;
        }
        
    }
    return NO;
}

//点击左上角的退后按钮时触发的事件
- (void)backUp:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(comResultChange)]) {
        
        [self.delegate comResultChange];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
