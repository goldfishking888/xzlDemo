//
//  SearchViewController.m
//  JobKnow
//
//  Created by Zuo on 14-1-23.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "SearchViewController.h"
#import "allCityViewController.h"
#import "PositionsViewController.h"
#import "WorkDetailViewController.h"
#import "SelectDetailViewController.h"
#import "ScanningViewController.h"
#import "jobRead.h"
#import "myButton.h"
#import "JobModel.h"
#import "PositionModel.h"
#import "SearchViewResultController.h"
#import "SearchModel.h"
#import "OtherLogin.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize isClick;
@synthesize _titleLabel;
@synthesize jobTextField;
@synthesize isEmpty;
-(void)initData
{
    isClick=NO;
    
    _isInsert=NO;
    
    isEmpty=NO;
    
    _btnHeight=0;
    
    _index=0;
    
    num=ios7jj;
    
    db=[UserDatabase sharedInstance];
    
    _dataArray=[[NSMutableArray alloc]init];//存放数据源
    
    _dataArray2=(NSMutableArray *)[db getAllRecords4];//得到显示tableViewCell的数据
    
    NSLog(@"_dataArray2 is %@",_dataArray2);
    
    _selectArray= [NSMutableArray arrayWithObjects:@"地区",@"行业",@"职业",@"待遇",nil];
    _selectArray2= [NSMutableArray arrayWithObjects:@"地区",@"行业",@"职业",@"待遇",@"职位类型",@"学历",@"工作经验",@"发布时间",@"公司性质",nil];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor=XZhiL_colour2;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位搜索"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位搜索"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self addBackBtn];
    [self addTitleLabel:@"职位搜索"];
    
    //高级搜索按钮
    myButton *superBtn = [myButton buttonWithType:UIButtonTypeCustom];
    superBtn.tag=100;
    superBtn.backgroundColor=[UIColor clearColor];
    superBtn.showsTouchWhenHighlighted=YES;
    if (IOS7) {
        superBtn.frame = CGRectMake(iPhone_width-45,17,45,50);
    }else
    {
        superBtn.frame = CGRectMake(iPhone_width-45,0,45,50);
    }
    
    superBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [superBtn setTitle:@"高级" forState:UIControlStateNormal];
    [superBtn setTitle:@"高级" forState:UIControlStateHighlighted];
    [superBtn addTarget:self action:@selector(superBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:superBtn];
    
    _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-num)];
    _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height);
    _myScrollView.alwaysBounceHorizontal=NO;
    _myScrollView.alwaysBounceVertical=YES;
    [self.view addSubview:_myScrollView];
    
    //输入框
    jobTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, 200, 35)];
    jobTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    jobTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    jobTextField.borderStyle = UITextBorderStyleNone;
    jobTextField.frame=CGRectMake(50,7,210,30);
    jobTextField.placeholder=@"请输入关键字";
    jobTextField.font = [UIFont systemFontOfSize:14];
    jobTextField.returnKeyType = UIReturnKeyDone;
    jobTextField.delegate = self;
    jobTextField.tag = 54321;
    
    _searchImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbackgroundView.png"]];
    _searchImage.userInteractionEnabled=YES;
    _searchImage.frame=CGRectMake(-10,33,iPhone_width+20,40);
    [_searchImage addSubview:jobTextField];
    [_myScrollView addSubview:_searchImage];
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search2.png"]];
    image.frame=CGRectMake(20,10,21,21);
    [_searchImage addSubview:image];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(295,10,21,21);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchImage addSubview:deleteBtn];
    
    UIButton *deleteBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn2.backgroundColor=[UIColor clearColor];
    deleteBtn2.frame=CGRectMake(275,0,50,40);
    [deleteBtn2 addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchImage addSubview:deleteBtn2];
    
    UIImageView *titleImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"readViewTitle.png"]];
    titleImage.frame=CGRectMake(10,10,250,18);
    [_myScrollView addSubview:titleImage];
    
    if (IOS7) {
        
        _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70,iPhone_width,iPhone_height+100) style:UITableViewStyleGrouped];
        
    }else
    {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70,iPhone_width,iPhone_height+100) style:UITableViewStylePlain];
        
        _myTableView.separatorStyle=UITableViewCellAccessoryNone;
    }
    
    _myTableView.tag=1024;
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
    _myTableView.backgroundView = nil;
    [_myTableView setBackgroundColor:[UIColor clearColor]];
    [_myScrollView addSubview:_myTableView];
    
    //搜索按钮
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.tag=101;
    searchBtn.frame=CGRectMake(10,280,300,40);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateHighlighted];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:searchBtn];
    
    //搜索完成后显示搜索项的tableView
    if (IOS7){
        _myTableView2=[[UITableView alloc]initWithFrame:CGRectMake(0,330,iPhone_width,iPhone_height+100) style:UITableViewStyleGrouped];
    }else
    {
        
        _myTableView2=[[UITableView alloc]initWithFrame:CGRectMake(0,330,iPhone_width,iPhone_height+100) style:UITableViewStylePlain];
        _myTableView2.separatorStyle=UITableViewCellAccessoryNone;
        
        UILabel *label=[[UILabel alloc]initWithFrame: CGRectMake(0,0,iPhone_width,1)];
        label.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        [_myTableView2 addSubview:label];
        
    }
    
    _myTableView2.tag=1025;
    _myTableView2.dataSource=self;
    _myTableView2.delegate=self;
    _myTableView2.backgroundView = nil;
    [_myTableView2 reloadData];
    _myTableView2.backgroundColor=[UIColor clearColor];
    
    [_myScrollView addSubview:_myTableView2];
    
    NSLog(@"_btnHeight in ViewDidLoad is %d",_btnHeight);
    
    NSInteger count=[_dataArray2 count];
    _bianjiBtn = [myButton buttonWithType:UIButtonTypeCustom];
    
    if (count==0) {
        _bianjiBtn.alpha=0;
    }else
    {
        _bianjiBtn.alpha=1;
    }
    
    if (IOS7) {
        _bianjiBtn.frame = CGRectMake(100,_btnHeight+17,110,20);
    }else
    {
        _bianjiBtn.frame = CGRectMake(100,_btnHeight+17,110,20);
    }
    
    [_bianjiBtn addTarget:self action:@selector(alterFeedReader:)forControlEvents:UIControlEventTouchUpInside];
    [_bianjiBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_bianjiBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete2.png"] forState:UIControlStateNormal];
    [_bianjiBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete2.png"] forState:UIControlStateHighlighted];
    [_myTableView2 addSubview:_bianjiBtn];
    
    _myTableView2.frame= CGRectMake(0,330,iPhone_width,_btnHeight+100);
    _myScrollView.contentSize=CGSizeMake(iPhone_width,370+_btnHeight+90);
}

-(void)deleteBtnClick:(id)sender
{
    NSLog(@"清空按钮被点击了。。。");
    
    jobTextField.text=@"";
    SaveJob *save=[SaveJob standardDefault];
    
    [save.saveArr removeAllObjects];
    [[save.positionArr objectAtIndex:1]removeAllObjects] ;
    [[save.positionArr objectAtIndex:2]removeAllObjects] ;
    [save.jobDic removeAllObjects];
    
    [_myTableView reloadData];
}

#pragma mark sendRequest代理方法的实现
-(void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic in SearchVC is %@",resultDic);
    
    
    NSString *receStr=[[NSString alloc] initWithData:receData encoding:NSUTF8StringEncoding];
    
    NSLog(@"receStr in ReceiveDataFin is %@",receStr);
    
    if ([receStr isEqualToString:@"please login"]) {
        
        OtherLogin *other = [OtherLogin standerDefault];
        [other otherAreaLogin];
        return;
    }
    
    NSArray *resultArray=[resultDic valueForKey:@"data"];
    
    NSLog(@"总共有%d项",[resultArray count]);
    
    for (int i=0;i<[resultArray count];i++) {
        
        NSDictionary *dic=[resultArray objectAtIndex:i];
        PositionModel *model=[[PositionModel alloc]init];
        model.isRead=[dic valueForKey:@"isRead"];
        model.isfavorites=[dic valueForKey:@"isfavorites"];
        model.counts=[dic valueForKey:@"counts"];
        model.favorites=[dic valueForKey:@"favorites"];
        model.postId=[dic  valueForKey:@"postId"];
        model.workAreaCode=[dic valueForKey:@"workAreaCode"];
        model.companyAddress=[dic valueForKey:@"companyAddress"];
        model.companyId=[dic valueForKey:@"companyId"];
        model.companyName=[dic valueForKey:@"companyName"];
        model.companyTel=[dic valueForKey:@"companyTel"];
        model.companyWeb=[dic  valueForKey:@"companyWeb"];
        model.age=[dic valueForKey:@"age"];
        model.degree=[dic valueForKey:@"degree"];
        model.email=[dic valueForKey:@"email"];
        model.jobName=[dic valueForKey:@"jobName"];
        model.linkMan=[dic valueForKey:@"linkMan"];
        model.pubDate=[dic valueForKey:@"pubDate"];
        model.required=[dic valueForKey:@"required"];
        model.salary=[dic valueForKey:@"salary"];
        model.workArea=[dic valueForKey:@"workArea"];
        model.workExperience=[dic valueForKey:@"workExperience"];
        model.stopTime=[dic valueForKey:@"stopTime"];
        [_dataArray addObject:model];
    }
    
    
    /*
     应该写一张表，将每次的搜索结果存放到表中，每次点击cell，就会从数据库中搜索数据
     得到相应的搜索条件进行搜索，进入scanningVC界面，点击查看按钮的时候将传过去的dataArray传入结果显示界面
     */
    
    if (!_isInsert) {
        
        [self insertIntoDataBase];
        _isInsert=!_isInsert;
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_searchModel,@"model",resultDic,@"dic",nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:dic];
        
    }else
    {
        
        _dataArray2=(NSMutableArray *)[db getAllRecords4];
        
        SearchModel *model=[_dataArray2  objectAtIndex:_index];
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:model,@"model",resultDic,@"dic",nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:dic];
        _isInsert=!_isInsert;
    }
    
    SaveJob *save=[SaveJob standardDefault];
    
    [save clearTheCache];
    
    jobTextField.text=@"";
    
    [_myTableView reloadData];
}

-(void)receiveRequestFail:(NSError *)error
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVCStop" object:self userInfo:nil];
}

#pragma mark tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView 执行了。。。。。");
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"numberOfRowsInSection 执行了。。。。。");
    
    if (tableView.tag==1024) {
        
        if (isClick) {
            return [_selectArray2 count];
        }else
        {
            return [_selectArray count];
        }
    }
    
    return [_dataArray2 count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath 执行了。。。。。");
    
    if (tableView.tag==1024) {
        
        SaveJob *save=[SaveJob standardDefault];
        
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.tag = 111;
            label.font = [UIFont fontWithName:Zhiti size:12.000];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(80, 13, 200, 20);
            [cell addSubview:label];
        }
        
        UILabel *continuousLabel2 = (UILabel *)[cell viewWithTag:111];
        
        if (!isClick) {
            
            if(indexPath.row == 0){
                CityInfo *c = [CityInfo standerDefault];
                continuousLabel2.text = c.cityName;
            }else if (indexPath.row == 1){
                continuousLabel2.text = [save industry];
            }else if (indexPath.row == 2){
                continuousLabel2.text = [save jobStr];
            }else  if(indexPath.row == 3){ //待遇
                
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                NSLog(@"read.name in 4 is %@",read.name);
                continuousLabel2.text = read.name;
                
            }else if (indexPath.row == 4)//工作类型
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                NSLog(@"read.name in 5 is %@",read.name);
                continuousLabel2.text = read.name;
            }
            
        }else
        {
            //高级搜索
            if(indexPath.row == 0){
                CityInfo *c = [CityInfo standerDefault];
                continuousLabel2.text = c.cityName;
            }else if (indexPath.row == 1){
                continuousLabel2.text = [save industry];
            }else if (indexPath.row == 2){
                continuousLabel2.text = [save jobStr];
            }else if (indexPath.row == 3)  //待遇
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                continuousLabel2.text = read.name;
            }else if (indexPath.row == 4)//职位类型
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                continuousLabel2.text = read.name;
            }else if (indexPath.row == 5)//学历
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                continuousLabel2.text = read.name;
                
            }else if (indexPath.row == 6)//工作经验
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                continuousLabel2.text = read.name;
                
            }else if (indexPath.row == 7)//发布时间
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                continuousLabel2.text = read.name;
            }else if (indexPath.row == 8)//公司性质
            {
                jobRead *read = [save.positionArr objectAtIndex:indexPath.row];
                continuousLabel2.text = read.name;
            }
        }
        
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.frame = CGRectMake(5, 25, 60, 30);
        cell.textLabel.font = [UIFont fontWithName:Zhiti size:14];
        cell.textLabel.textColor=[UIColor darkGrayColor];
        
        if (!isClick){
            cell.textLabel.text = [_selectArray objectAtIndex:indexPath.row];
        }else{
            cell.textLabel.text = [_selectArray2 objectAtIndex:indexPath.row];
        }
        
        if (IOS7) {
            
        }else
        {
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
            
            UILabel *label4=[[UILabel alloc]initWithFrame: CGRectMake(0,44,iPhone_width,1)];
            label4.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
            [cell.contentView addSubview:label4];
        }
        
        return cell;
        
    }else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }else
        {
            NSArray *views = [cell.contentView subviews];
            for (UIView *v in views) {
                [v removeFromSuperview];
            }
        }
        
        NSLog(@"indexPath.row is %d",indexPath.row);
        
        SearchModel *model=[_dataArray2 objectAtIndex:indexPath.row];
        
        
        NSString *title=[self combineStr1:model.keyWord andStr2:model.cityName andStr3:model.industry andStr4:model.position andStr5:model.salary];
        
        CGSize size = CGSizeMake(240, MAXFLOAT);
        
        CGSize size2=[title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        NSLog(@"size2 height is %f",size2.height);
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,10,240,size2.height)];
        nameLabel.numberOfLines = 0;
        nameLabel.text  =title;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(5,5,10,10)];
        label2.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        [cell.contentView addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame: CGRectMake(9,16,1,size2.height)];
        label3.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        [cell.contentView addSubview:label3];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        if (IOS7) {
            
        }else
        {
            UILabel *label4=[[UILabel alloc]initWithFrame: CGRectMake(0,size2.height+19,iPhone_width,1)];
            label4.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
            [cell.contentView addSubview:label4];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag==1024) {
        
        if (!isClick) {  //当没有点击的时候
            
            _option=[_selectArray objectAtIndex:indexPath.row];
            
            if(indexPath.row==0)//地区
            {
                allCityViewController *cityVC = [[allCityViewController alloc] init];
                cityVC.delegate = self;
                cityVC.fromWhereStr=@"搜索界面";
                [self.navigationController pushViewController:cityVC animated:YES];
            }else if (indexPath.row==1)//行业
            {
                
                NSString *textString = [jobTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([textString length]!=0) {
                    isEmpty=NO;
                }else
                {
                    isEmpty=YES;
                }
                
                PositionsViewController *positionVC = [[PositionsViewController alloc]init];
                positionVC.delegate=self;
                positionVC.isEmpty=isEmpty;
                [self.navigationController pushViewController:positionVC animated:YES];
                
            }else if (indexPath.row==2)//职业
            {
                
                NSString *textString = [jobTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if ([textString length]!=0) {
                    isEmpty=NO;
                }else
                {
                    isEmpty=YES;
                }
                
                WorkDetailViewController *workVC = [[WorkDetailViewController alloc]init];
                workVC.isEmpty=isEmpty;
                [self.navigationController pushViewController:workVC animated:YES];
                
            }else
            {
                SelectDetailViewController *selectVC = [[SelectDetailViewController alloc]init];
                selectVC.delegate = self;
                [selectVC setItemStr:_option];
                [self.navigationController pushViewController:selectVC animated:YES];
            }
        }else
        {
            
            if(indexPath.row==0)//地区
            {
                allCityViewController *cityVC = [[allCityViewController alloc] init];
                cityVC.delegate = self;
                cityVC.fromWhereStr=@"搜索界面";
                [self.navigationController pushViewController:cityVC animated:YES];
            }else if (indexPath.row==1)//行业
            {
                PositionsViewController *positionVC = [[PositionsViewController alloc]init];
                positionVC.delegate=self;
                [self.navigationController pushViewController:positionVC animated:YES];
            }else if (indexPath.row==2) //职业
            {
                WorkDetailViewController *workVC = [[WorkDetailViewController alloc]init];
                [self.navigationController pushViewController:workVC animated:YES];
                
            }else
            {
                //@"职位关键词",@"地区",@"行业",@"职业",@"待遇",@"职位类型",@"学历",@"工作经验",@"发布时间",@"公司性质"
                _option=[_selectArray2 objectAtIndex:indexPath.row];
                NSLog(@"_option in SearchVC and didSelectRow is %@",_option);
                SelectDetailViewController *selectVC = [[SelectDetailViewController alloc]init];
                selectVC.delegate = self;
                selectVC.itemStr=_option;
                [self.navigationController pushViewController:selectVC animated:YES];
                
            }
        }
    }else
    {
        NSLog(@"tableView2被点击了。。。。");
        
        _index=indexPath.row;
        
        SearchModel *model=[_dataArray2 objectAtIndex:indexPath.row];
        
        NSArray *cityArray=[db getAllRecords2:model.cityName];
        
        City *city;
        
        if ([cityArray count]!=0) {
            city=[cityArray objectAtIndex:0];
        }
        
        NSLog(@"city.sourceStr is %@",city.sourceStr);
        
        CityInfo *cityInfo=[CityInfo standerDefault];
        cityInfo.cityName=model.cityName;
        cityInfo.cityCode=model.cityCode;
        cityInfo.source =city.sourceStr;
        cityInfo.sourceAll=city.sourceAllStr;
        cityInfo.com_num=city.com_num;
        
        NSString *url=kCombineURL(KXZhiLiaoAPI, kJobSearch);
        
        //高级搜索
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",model.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  model.positionCode,@"searchPost",model.industryCode,@"searchIndustry",//职位类别，行业类别
                  model.salaryCode,@"searchTreatment",model.keyWord,@"searchKeyword",  //职位待遇，职位关键词
                  model.jobTypeCode,@"searchType",model.experienceCode,@"searchWorkExperience", //职位类型，工作经验
                  model.workYearCode,@"searchPublished",model.educationCode,@"searchEducational",     //发布日期，教育经历
                  model.natureCode,@"searchNature",@"0",@"searchBookId",@"1",@"page",nil];
        
        _isInsert=YES;
        
//        NetWorkConnection* net =[[NetWorkConnection alloc]init];
//        net.delegate=self;
//        [net requestCache:url param:paramDic];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
        [request setCompletionBlock:^{
            
            //        [loadView hide:YES];
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"resultDic in SearchVC is %@",resultDic);
            
            
            NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"receStr in ReceiveDataFin is %@",receStr);
            
            if ([receStr isEqualToString:@"please login"]) {
                
                OtherLogin *other = [OtherLogin standerDefault];
                [other otherAreaLogin];
                return;
            }
            
            NSArray *resultArray=[resultDic valueForKey:@"data"];
            
            NSLog(@"总共有%d项",[resultArray count]);
            
            for (int i=0;i<[resultArray count];i++) {
                
                NSDictionary *dic=[resultArray objectAtIndex:i];
                PositionModel *model=[[PositionModel alloc]init];
                model.isRead=[dic valueForKey:@"isRead"];
                model.isfavorites=[dic valueForKey:@"isfavorites"];
                model.counts=[dic valueForKey:@"counts"];
                model.favorites=[dic valueForKey:@"favorites"];
                model.postId=[dic  valueForKey:@"postId"];
                model.workAreaCode=[dic valueForKey:@"workAreaCode"];
                model.companyAddress=[dic valueForKey:@"companyAddress"];
                model.companyId=[dic valueForKey:@"companyId"];
                model.companyName=[dic valueForKey:@"companyName"];
                model.companyTel=[dic valueForKey:@"companyTel"];
                model.companyWeb=[dic  valueForKey:@"companyWeb"];
                model.age=[dic valueForKey:@"age"];
                model.degree=[dic valueForKey:@"degree"];
                model.email=[dic valueForKey:@"email"];
                model.jobName=[dic valueForKey:@"jobName"];
                model.linkMan=[dic valueForKey:@"linkMan"];
                model.pubDate=[dic valueForKey:@"pubDate"];
                model.required=[dic valueForKey:@"required"];
                model.salary=[dic valueForKey:@"salary"];
                model.workArea=[dic valueForKey:@"workArea"];
                model.workExperience=[dic valueForKey:@"workExperience"];
                model.stopTime=[dic valueForKey:@"stopTime"];
                [_dataArray addObject:model];
            }
            
            
            /*
             应该写一张表，将每次的搜索结果存放到表中，每次点击cell，就会从数据库中搜索数据
             得到相应的搜索条件进行搜索，进入scanningVC界面，点击查看按钮的时候将传过去的dataArray传入结果显示界面
             */
            
            if (!_isInsert) {
                
                [self insertIntoDataBase];
                _isInsert=!_isInsert;
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_searchModel,@"model",resultDic,@"dic",nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:dic];
                
            }else
            {
                
                _dataArray2=(NSMutableArray *)[db getAllRecords4];
                
                SearchModel *model=[_dataArray2  objectAtIndex:_index];
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:model,@"model",resultDic,@"dic",nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:dic];
                _isInsert=!_isInsert;
            }
            
            SaveJob *save=[SaveJob standardDefault];
            
            [save clearTheCache];
            
            jobTextField.text=@"";
            
            [_myTableView reloadData];
            
 
        }];
        [request setFailedBlock:^{
            //        [loadView hide:YES];
            //        reloading = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVCStop" object:self userInfo:nil];
            
        }];
        [request startAsynchronous];
        
        ScanningViewController *scanVC=[[ScanningViewController alloc]init];
        scanVC.fromWhereStr=@"已经搜索过";
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7) {
        return 10;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    
    NSLog(@"_dataArray2 is %@",_dataArray2);
    
    if (tableView.tag==1025){
        
        NSLog(@"......................");
        
        SearchModel *model=[_dataArray2 objectAtIndex:indexPath.row];
        
        NSString *title=[self combineStr1:model.keyWord andStr2:model.cityName andStr3:model.industry andStr4:model.position andStr5:model.salary];
        
        NSLog(@"title is %@",title);
        
        CGSize size = CGSizeMake(240, MAXFLOAT);
        
        CGSize size2=[title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        NSLog(@"size2 height is %f",size2.height);
        
        _btnHeight=_btnHeight+size2.height+20;
        
        return size2.height+20;
    }
    
    return 45;
}

#pragma mark 其他代理方法的实现
//allCityViewController代理方法的实现
- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName
{
    [_myTableView reloadData];
}

//PositionViewController代理方法的实现
- (void)positonViewChange
{
    [_myTableView reloadData];
}

//WorkDetailViewController代理方法实现
-(void)JobNameViewChange
{
    [_myTableView reloadData];
}

//SelectDetailViewController代理方法的实现
-(void)sendWithSelect:(jobRead *)select Option:(NSString *)option
{
    NSLog(@"待遇和职位类型代理方法执行。。。。。。。");
    
    NSLog(@"jobRead.name is %@ and jobRead.code is %@",select.name,select.code);
    
    //根据option判断是哪一个页面返回
    
    SaveJob *save = [SaveJob standardDefault];
    
    if ([option  isEqualToString:@"待遇"]) {
        [save.positionArr replaceObjectAtIndex:3 withObject:select];
    }else if ([option isEqualToString:@"职位类型"])
    {
        [save.positionArr replaceObjectAtIndex:4 withObject:select];
    }else if ([option isEqualToString:@"学历"])
    {
        [save.positionArr replaceObjectAtIndex:5 withObject:select];
    }else if ([option isEqualToString:@"工作经验"])
    {
        [save.positionArr replaceObjectAtIndex:6 withObject:select];
    }else if ([option isEqualToString:@"发布时间"])
    {
        [save.positionArr replaceObjectAtIndex:7 withObject:select];
    }else if ([option isEqualToString:@"公司性质"])
    {
        [save.positionArr replaceObjectAtIndex:8 withObject:select];
    }
    
    [_myTableView reloadData];
}

/*******************其他代理方法的实现********************************/

#pragma mark TextFieldDelegate Methods

//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing开始编辑。。。。。。");
}

//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing 执行到了。。。。");
}


- (BOOL)textField:(UITextField *)textField  shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SaveJob *save=[SaveJob standardDefault];
    
    NSString *industry=[save industry];
    
    NSString *jobStr;
    
    if ([[save jobStr]isEqualToString:@""]){
        jobStr=@"选择职业";
    }else
    {
        jobStr=[save jobStr];
    }
    
    NSLog(@"industry is %@",industry);
    
    NSLog(@"jobStr is %@",jobStr);
    
    if (([industry isEqualToString:@"选择行业"]&&[jobStr isEqualToString:@"选择职业"])||
        
        ([industry isEqualToString:@"不限"]&&[jobStr isEqualToString:@"不限"])) {
        
        NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        textString = [textString  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSLog(@"textString is %@",textString);
        
        //SaveJob *save=[SaveJob standardDefault];
        
        if ([textString length]>0) {
            
            jobRead *read;
            
            if ([save.saveArr count]!=0) {
                read=[save.saveArr objectAtIndex:0];
            }
            
            if (![read.name isEqualToString:@"不限"]&&![read.code isEqualToString:@"0000"])
            {
                jobRead *read=[[jobRead alloc]init];
                read.name=@"不限";
                read.code=@"0000";
                [save.saveArr addObject:read];
            }
            
            [save.jobDic removeAllObjects];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0000",@"code",@"不限",@"name",nil];
            NSMutableArray *array=[[ NSMutableArray alloc]init];
            [array addObject:dic];
            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:array,@"jobName", nil];
            [save.jobDic setObject:dic2 forKey:@"不限"];
            
        }else
        {
            [save.saveArr removeAllObjects];
            [[save.positionArr objectAtIndex:1]removeAllObjects] ;
            [[save.positionArr objectAtIndex:2]removeAllObjects] ;
            [save.jobDic removeAllObjects];
        }
        
        [_myTableView reloadData];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn 执行到了。。。。。");
    
    [textField resignFirstResponder];
    return YES;
}

- (void)backUp:(id)sender
{
    SaveJob *save=[SaveJob standardDefault];
    [save clearTheCache];
    [self.navigationController popViewControllerAnimated:YES];
}


/**连接5个字符串**/
-(NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3 andStr4:(NSString *)str4 andStr5:(NSString *)str5
{
    NSString *totalString=@"";
    
    NSLog(@"str in combineStr1 is %@",str);
    NSLog(@"str2 in combineStr1 is %@",str2);
    NSLog(@"str3 in combineStr1 is %@",str3);
    NSLog(@"str4 in combineStr1 is %@",str4);
    NSLog(@"str5 in combineStr1 is %@",str5);
    
    
    if (str&&![str isEqualToString:@""]) {
        totalString=[totalString stringByAppendingString:str];
        totalString=[totalString stringByAppendingFormat:@"+"];
    }
    
    totalString=[totalString stringByAppendingString:str2];
    totalString=[totalString stringByAppendingFormat:@"+"];
    
    totalString=[totalString stringByAppendingString:str3];
    totalString=[totalString stringByAppendingFormat:@"+"];
    
    totalString=[totalString stringByAppendingString:str4];
    totalString=[totalString stringByAppendingFormat:@"+"];
    
    totalString=[totalString stringByAppendingString:str5];
    
    return totalString;
}

#pragma mark 按钮响应事件
-(void)superBtnClick:(id)sender
{
    _btnHeight=0;
    
    myButton *btn=(myButton *)sender;
    UIButton *searchBtn=(UIButton *)[self.view viewWithTag:101];
    isClick=!isClick;
    
    [_myTableView2 reloadData];
    
    if (isClick) {
        [btn setTitle:@"快速" forState:UIControlStateNormal];
        [btn setTitle:@"快速" forState:UIControlStateHighlighted];
        searchBtn.frame=CGRectMake(20,500,280,40);
        
        _myTableView2.frame=CGRectMake(0,550,iPhone_width,_btnHeight+100);
        
        if (IOS7) {
            _myScrollView.contentSize=CGSizeMake(iPhone_width,550+_btnHeight+90);
        }else
        {
            _myScrollView.contentSize=CGSizeMake(iPhone_width,580+_btnHeight+90);
        }
        
    }else
    {
        [btn setTitle:@"高级" forState:UIControlStateNormal];
        [btn setTitle:@"高级" forState:UIControlStateHighlighted];
        searchBtn.frame=CGRectMake(20,280,280,40);
        _myTableView2.frame=CGRectMake(0,330,iPhone_width,_btnHeight+100);
        _myScrollView.contentSize=CGSizeMake(iPhone_width,370+_btnHeight+90);
    }
    [_myTableView reloadData];
}

#pragma mark 搜索按钮响应事件

-(void)searchBtnClick:(id)sender
{
    NSLog(@"搜索按钮被点击了。。。。");
    
    SaveJob *save=[SaveJob standardDefault];
    /***判断行业是否为空***/
    NSArray *tradeArray = [save.positionArr objectAtIndex:1];
    
    if (tradeArray.count==0){
        ghostView.message=@"行业不能为空哦!";
        [ghostView show];
        NSLog(@"行业不能为空哦");
        return;
    }
    
    /***判断职业是否为空***/
    NSArray *positionArray = [save.positionArr objectAtIndex:2];
    
    if (positionArray.count==0){
        ghostView.message=@"职业不能为空哦!";
        [ghostView show];
        NSLog(@"职业不能为空哦");
        return;
    }
    
    /******************判断订阅城市数量以及每个城市的订阅器数量*******************/
    
    
    [self  netConnection];
}

#pragma mark scanningVC代理
- (void)scanningVC
{
    _btnHeight=0;
    
    NSLog(@"scanningVC执行了。。。。");
    
    _dataArray2 =(NSMutableArray *)[db getAllRecords4];
    
    NSLog(@"_dataArray2 in scanningVC is %@",_dataArray2);
    
    if ([_dataArray2 count]==0) {
        _bianjiBtn.alpha=0;
    }else
    {
        _bianjiBtn.alpha=1;
    }
    
    
    [_myTableView2 reloadData];
    
    /*每次搜索成功之后,返回的时候应该会修改一下scrollview的高度*/
    if ([_dataArray2 count]==0) {
        _bianjiBtn.alpha=0;
    }else
    {
        _bianjiBtn.alpha=1;
    }
    
    if (IOS7) {
        _bianjiBtn.frame = CGRectMake(100,_btnHeight+17,110,20);
    }else
    {
        _bianjiBtn.frame = CGRectMake(100,_btnHeight+17,110,20);
    }
    
    if (isClick){ //高级搜索
        
        _myTableView2.frame= CGRectMake(0,550,iPhone_width,_btnHeight+100);
        
        if (IOS7) {
            _myScrollView.contentSize=CGSizeMake(iPhone_width,550+_btnHeight+90);
        }else
        {
            _myScrollView.contentSize=CGSizeMake(iPhone_width,580+_btnHeight+90);
        }
        
    }else  //快速搜索
    {
        _myTableView2.frame= CGRectMake(0,330,iPhone_width,_btnHeight+100);
        
        _myScrollView.contentSize=CGSizeMake(iPhone_width,370+_btnHeight+90);
    }
}

-(void)alterFeedReader:(id)sender
{
    NSLog(@"修改按钮被点击了。。。。");
    
    UIActionSheet *actionSheet02;
    actionSheet02 = [[UIActionSheet alloc]
                     initWithTitle:@"请选择需要的操作"
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@"清空"
                     otherButtonTitles:nil];
    actionSheet02.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet02 showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0){
        
        NSLog(@"被点击了");
        
        //1.清空数据库
        [db deleteSearchRecord];
        
        //2.清除数据源
        if ([_dataArray2 count]!=0) {
            [_dataArray2 removeAllObjects];
        }
        
        
        [_myTableView2 reloadData];
        
        myButton *myBtn=(myButton *)[self.view viewWithTag:100];
        
        UIButton *myBtn2=(UIButton *)[self.view viewWithTag:101];
        
        if (myBtn.isClicked) {
            
            myBtn2.frame=CGRectMake(20,500,280,40);
            _myTableView2.frame= CGRectMake(0,550,iPhone_width,0);
            _myScrollView.contentSize=CGSizeMake(iPhone_width,550);
        }else
        {
            myBtn2.frame=CGRectMake(10,280,300,40);;
            _myTableView2.frame= CGRectMake(0,370,iPhone_width,0);
            _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height);
        }
    }
}

#pragma mark 存入数据库调用的方法
-(void)insertIntoDataBase
{
    SearchModel *searchModel=[[SearchModel alloc]init];
    
    CityInfo *cityInfo=[CityInfo standerDefault];
    SaveJob *save=[SaveJob standardDefault];
    
    searchModel.cityName=cityInfo.cityName;
    searchModel.cityCode=cityInfo.cityCode;
    NSLog(@"searchModel.cityName is %@",searchModel.cityName);
    NSLog(@"searchModel.cityCode is %@",searchModel.cityCode);
    
    
    searchModel.industry=[save industry];
    searchModel.industryCode=[save industryCode];
    NSLog(@"searchModel.industry is %@",searchModel.industry);
    NSLog(@"searchModel.industryCode is %@",searchModel.industryCode);
    
    
    searchModel.position=[save jobStr];
    searchModel.positionCode=[save jobCodeStr];
    NSLog(@"searchModel.position is %@",searchModel.position);
    NSLog(@"searchModel.positionCode is %@",searchModel.positionCode);
    
    
    //薪资
    jobRead *read=[save.positionArr objectAtIndex:3];
    
    if (read.name) {
        searchModel.salary=read.name;
    }else
    {
        searchModel.salary=@"不限";
    }
    
    if (read.code) {
        searchModel.salaryCode=read.code;
    }else
    {
        searchModel.salaryCode=@"";
    }
    
    NSLog(@"searchModel.salary is %@",searchModel.salary);
    NSLog(@"searchModel.salaryCode is %@",searchModel.salaryCode);
    
    
    //职位类别
    read=[save.positionArr objectAtIndex:4];
    
    if (read.name) {
        searchModel.jobType=read.name;
    }else
    {
        searchModel.jobType=@"不限";
    }
    
    if (read.code) {
        searchModel.jobTypeCode=read.code;
    }else
    {
        searchModel.jobType=@"";
    }
    
    NSLog(@"searchModel.jobType is %@",searchModel.jobType);
    NSLog(@"searchModel.jobTypeCode is %@",searchModel.jobTypeCode);
    
    
    //学历
    read=[save.positionArr objectAtIndex:5];
    
    if (read.name){
        searchModel.education =read.name;
    }else
    {
        searchModel.education=@"不限";
    }
    
    if (read.code) {
        searchModel.educationCode=read.code;
    }else
    {
        searchModel.educationCode=@"";
    }
    
    NSLog(@"searchModel.education is %@",searchModel.education);
    NSLog(@"searchModel.educationCode is %@",searchModel.educationCode);
    
    //工作经验
    read=[save.positionArr objectAtIndex:6];
    if (read.name){
        searchModel.experience =read.name;
    }else
    {
        searchModel.experience=@"不限";
    }
    
    if (read.code) {
        searchModel.experienceCode=read.code;
    }else
    {
        searchModel.experienceCode=@"";
    }
    
    NSLog(@"searchModel.experience is %@",searchModel.experience);
    NSLog(@"searchModel.experienceCode is %@",searchModel.experienceCode);
    
    //发布时间
    read=[save.positionArr objectAtIndex:7];
    if (read.name){
        searchModel.workYear=read.name;
    }else
    {
        searchModel.workYear=@"不限";
    }
    
    if (read.code) {
        searchModel.workYearCode=read.code;
    }else
    {
        searchModel.workYearCode=@"";
    }
    
    NSLog(@"searchModel.workYear is %@",searchModel.workYear);
    NSLog(@"searchModel.workYearCode is %@",searchModel.workYearCode);
    
    //公司性质
    read=[save.positionArr objectAtIndex:8];
    if (read.name){
        searchModel.nature=read.name;
    }else
    {
        searchModel.nature=@"不限";
    }
    
    if (read.code) {
        searchModel.natureCode=read.code;
    }else
    {
        searchModel.natureCode=@"";
    }
    
    NSLog(@"searchModel.nature is %@",searchModel.nature);
    NSLog(@"searchModel.natureCode is %@",searchModel.natureCode);
    
    
    if ([jobTextField.text isEqualToString:@""]) {
        
        searchModel.keyWord=@"";
    }else
    {
        searchModel.keyWord=jobTextField.text;
    }
    
    
    NSLog(@"searchModel.keyWord in KeyWord is %@",searchModel.keyWord);
    
    _searchModel=searchModel;
    
    //每次搜索成功就将搜索路径存储到计算机中
    [db addSearchRecord:searchModel];
}

#pragma mark 网络连接方法
-(void)netConnection
{
    SaveJob *save=[SaveJob standardDefault];
    
    CityInfo *cityInfo=[CityInfo standerDefault];
    
    //职位
    NSString *postStr=[save jobStr];
    NSString *postCodeStr=[save jobCodeStr];
    NSLog(@"postStr is %@",postStr);
    NSLog(@"postCodeStr is %@",postCodeStr);
    
    //行业
    NSString *industryStr=[save industry];
    NSString *industryCodeStr=[save industryCode];
    NSLog(@"industryStr is %@",industryStr);
    NSLog(@"industryCodeStr is %@",industryCodeStr);
    
    //待遇
    jobRead*salary=[save.positionArr objectAtIndex:3];
    NSString *salaryStr=salary.code;
    
    //职位类别
    jobRead*jobType=[save.positionArr objectAtIndex:4];
    NSString *jobTypeStr=jobType.code;
    
    _dataArray2=(NSMutableArray *)[db getAllRecords4];
    
    NetWorkConnection *net=[[NetWorkConnection alloc]init];
    net.delegate=self;
    NSString *url=kCombineURL(KXZhiLiaoAPI, kJobSearch);
    
    if (!isClick) { //普通搜索
        
        NSLog(@"普通搜索 执行了。。。。。。。。");
        
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",cityInfo.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  postCodeStr,@"searchPost",industryCodeStr,@"searchIndustry",//职位类别，行业类别
                  salaryStr,@"searchTreatment",jobTextField.text,@"searchKeyword",  //职位待遇，职位关键词
                  jobTypeStr,@"searchType",@"",@"searchWorkExperience",//公司性质，工作经验
                  @"",@"searchPublished",@"",@"searchEducational",                //发布日期，教育经历
                  @"",@"searchNature",@"0",@"searchBookId",@"1",@"page",nil];                   //工作类型，BookId
        
        
        for (int i=0;i<[_dataArray2 count];i++){
            
            SearchModel *model=[_dataArray2 objectAtIndex:i];
            
            if ([model.cityCode isEqualToString:cityInfo.cityCode]&&[model.positionCode isEqualToString:postCodeStr]&&
                
                [model.industryCode isEqualToString:industryCodeStr]&&[model.salaryCode isEqualToString:salaryStr]&&
                
                [model.keyWord isEqualToString:jobTextField.text]&&[model.jobTypeCode isEqualToString:jobTypeStr])
                
            {
                
                NSLog(@"此处判断被执行到了。。。。。。");
                
                _isInsert=YES;
                
            }
        }
        
        
        
        
    }else
    {
        //1.学历
        jobRead*education=[save.positionArr objectAtIndex:5];
        
        NSString *educationalStr=education.code;
        
        NSLog(@"educationalStr is %@",education.name);
        
        //2.工作经验
        jobRead*workExperience=[save.positionArr objectAtIndex:6];
        NSString *workExperienceStr=workExperience.code;
        NSLog(@"workExperienceStr is %@",workExperience.name);
        
        //3.发布日期
        jobRead*publish=[save.positionArr objectAtIndex:7];
        NSString*publishStr=publish.code;
        NSLog(@"readPublishStr is %@",publish.name);
        
        //4.公司性质
        jobRead*nature=[save.positionArr objectAtIndex:8];
        NSString *natureStr=nature.code;
        NSLog(@"readNatureStr is %@",nature.name);
        
        //高级搜索
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",cityInfo.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  postCodeStr,@"searchPost",industryCodeStr,@"searchIndustry",//职位类别，行业类别
                  salaryStr,@"searchTreatment",jobTextField.text,@"searchKeyword",  //职位待遇，职位关键词
                  jobTypeStr,@"searchType",workExperienceStr,@"searchWorkExperience", //职位类型，工作经验
                  publishStr,@"searchPublished",educationalStr,@"searchEducational",     //发布日期，教育经历
                  natureStr,@"searchNature",@"0",@"searchBookId",@"1",@"page",nil];                   //公司性质，BookId
        
        NSLog(@"高级搜索 执行了。。。。。。。。");
        
        
        for (int i=0;i<[_dataArray2 count];i++){
            
            SearchModel *model=[_dataArray2 objectAtIndex:i];
            
            if ([model.cityCode isEqualToString:cityInfo.cityCode]&&[model.positionCode isEqualToString:postCodeStr]&&
                
                [model.industryCode isEqualToString:industryCodeStr]&&[model.salaryCode isEqualToString:salaryStr]&&
                
                [model.keyWord isEqualToString:jobTextField.text]&&[model.jobTypeCode isEqualToString:jobTypeStr]&&
                
                [model.experienceCode isEqualToString:workExperienceStr]&&[model.workYearCode isEqualToString:publishStr]&&
                [model.educationCode isEqualToString:educationalStr]&&[model.natureCode isEqualToString:natureStr]
                
                )
            {
                NSLog(@"此处判断被执行到了。。。。。。");
                _isInsert=YES;
            }
        }
    }
    
//    [net requestCache:url param:paramDic];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"resultDic in SearchVC is %@",resultDic);
        
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        NSLog(@"总共有%d项",[resultArray count]);
        
        for (int i=0;i<[resultArray count];i++) {
            
            NSDictionary *dic=[resultArray objectAtIndex:i];
            PositionModel *model=[[PositionModel alloc]init];
            model.isRead=[dic valueForKey:@"isRead"];
            model.isfavorites=[dic valueForKey:@"isfavorites"];
            model.counts=[dic valueForKey:@"counts"];
            model.favorites=[dic valueForKey:@"favorites"];
            model.postId=[dic  valueForKey:@"postId"];
            model.workAreaCode=[dic valueForKey:@"workAreaCode"];
            model.companyAddress=[dic valueForKey:@"companyAddress"];
            model.companyId=[dic valueForKey:@"companyId"];
            model.companyName=[dic valueForKey:@"companyName"];
            model.companyTel=[dic valueForKey:@"companyTel"];
            model.companyWeb=[dic  valueForKey:@"companyWeb"];
            model.age=[dic valueForKey:@"age"];
            model.degree=[dic valueForKey:@"degree"];
            model.email=[dic valueForKey:@"email"];
            model.jobName=[dic valueForKey:@"jobName"];
            model.linkMan=[dic valueForKey:@"linkMan"];
            model.pubDate=[dic valueForKey:@"pubDate"];
            model.required=[dic valueForKey:@"required"];
            model.salary=[dic valueForKey:@"salary"];
            model.workArea=[dic valueForKey:@"workArea"];
            model.workExperience=[dic valueForKey:@"workExperience"];
            model.stopTime=[dic valueForKey:@"stopTime"];
            [_dataArray addObject:model];
        }
        
        
        /*
         应该写一张表，将每次的搜索结果存放到表中，每次点击cell，就会从数据库中搜索数据
         得到相应的搜索条件进行搜索，进入scanningVC界面，点击查看按钮的时候将传过去的dataArray传入结果显示界面
         */
        
        if (!_isInsert) {
            
            [self insertIntoDataBase];
            _isInsert=!_isInsert;
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_searchModel,@"model",resultDic,@"dic",nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:dic];
            
        }else
        {
            
            _dataArray2=(NSMutableArray *)[db getAllRecords4];
            
            SearchModel *model=[_dataArray2  objectAtIndex:_index];
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:model,@"model",resultDic,@"dic",nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:dic];
            _isInsert=!_isInsert;
        }
        
        SaveJob *save=[SaveJob standardDefault];
        
        [save clearTheCache];
        
        jobTextField.text=@"";
        
        [_myTableView reloadData];
        
        
    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
        //        reloading = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVCStop" object:self userInfo:nil];
        
    }];
    [request startAsynchronous];

    
    ScanningViewController *scanVC=[[ScanningViewController alloc]init];
    scanVC.fromWhereStr=@"搜索界面";
    scanVC.delegate=self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

