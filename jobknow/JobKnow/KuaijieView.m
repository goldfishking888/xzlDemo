//
//  KuaijieView.m
//  JobKnow
//
//  Created by Zuo on 13-8-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//
#import "Config.h"
#import "KuaijieView.h"
#import "jobRead.h"
#import "SaveCount.h"
#import "MyButton.h"
#import "JobModel.h"
#import "UserDatabase.h"
#import "OtherLogin.h"
@implementation KuaijieView

-(void)initData
{
    num=ios7jj;
    
    db=[UserDatabase sharedInstance];
    
    dataArray=(NSMutableArray *)[db getAllRecords:@"2"];
    
    net=[[NetWorkConnection alloc]init];
    net.delegate=self;
    
    userDefaults =[NSUserDefaults standardUserDefaults];
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.3 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    self.backgroundColor=XZhiL_colour2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        
        [self initData];
        
        NSInteger count=[dataArray count];
        
        myScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-num-40)];//添加划动视图
        
        if (count==0) {
            
            myScroView.contentSize= CGSizeMake(iPhone_width, iPhone_height-44-num-40);
            
        }else{
            
            if (IOS7){
                
                if (iPhone_5Screen) {
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+count*60-58);
                }else
                {
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+count*60+28);
                }
                
            }else
            {
                
                if (iPhone_5Screen){
                    
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+count*60-58);
                }else
                {
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+count*60+20);
                }
            }
        }
        
        myScroView.delegate = self;
        myScroView.backgroundColor = XZHILBJ_colour;
        myScroView.alwaysBounceVertical=YES;
        myScroView.alwaysBounceHorizontal=NO;
        [self addSubview:myScroView];
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"生产/加工/制造",@"汽车/摩托/修理",
                               @"家政/保洁/安保",@"司机/驾驶员/运输",@"厨师/服务员",@"技工类",@"建筑/装修/土建",@"物流/仓储/搬运工", nil];
        
        for (int i =0; i<8; i++){
            
            myButton *button = [myButton buttonWithType:UIButtonTypeCustom];
            button.tag= 101+i;
            button.frame = CGRectMake(25+145*(i%2), 10+73*(i/2),130,60);
            button.backgroundColor=[UIColor clearColor];
            
            [button setTitleColor:XZhiL_colour forState:UIControlStateNormal];
            [button setTitleColor:XZhiL_colour forState:UIControlStateHighlighted];
            
            [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg1.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg2.png"] forState:UIControlStateHighlighted];
            
            [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            [button addTarget:self action:@selector(kuaijieClick:) forControlEvents:UIControlEventTouchUpInside];
            [myScroView addSubview:button];
        }
        
        if (IOS7){
            myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,290,iPhone_width,iPhone_height) style:UITableViewStyleGrouped];
        }else
        {
            
            myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,305,iPhone_width,iPhone_height) style:UITableViewStylePlain];
            
            if (count==0) {
                myTableView.frame=CGRectMake(0,305,iPhone_width,0);
            }
            
            myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
        
        myTableView.delegate =self;
        myTableView.dataSource = self;
        myTableView.backgroundView=nil;
        if (IOS7) {
            myTableView.backgroundColor=[UIColor clearColor];
        }else
        {
            myTableView.backgroundColor=XZHILBJ_colour;
        }
        [myScroView addSubview:myTableView];
        
        //订阅器个数
        addLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 5, 220, 20)];
        [addLabel setBackgroundColor:[UIColor clearColor]];
        [addLabel setFont:[UIFont systemFontOfSize:12]];
        
        //所有订阅条数
        allLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 23, 300, 20)];
        [allLabel setBackgroundColor:[UIColor clearColor]];
        [allLabel setFont:[UIFont systemFontOfSize:12]];
        
        NSLog(@"dataArray cout is %d",[dataArray count]);
        
        //编辑订阅器的按钮
        bianjiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([dataArray count]==0) {
            bianjiBtn.alpha=0;
            bianjiBtn.frame = CGRectMake(100,102+[dataArray count]*60,110,40);
        }else
        {
            bianjiBtn.alpha=1;
            if (IOS7) {
                bianjiBtn.frame = CGRectMake(100,80+[dataArray count]*60,110,40);
            }else
            {
                bianjiBtn.frame = CGRectMake(100,47+[dataArray count]*60,110,40);
            }
        }
        
        [bianjiBtn addTarget:self action:@selector(alterFeedReader:) forControlEvents:UIControlEventTouchUpInside];
        [bianjiBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateNormal];
        [bianjiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [myTableView addSubview:bianjiBtn];
    }
    
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (IOS7) {
        
        if (section == 0) {
            return 10;
        } else {
            return 5;
        }
    }
    
    return 0;
}


//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count == 0) {
        return 0;
    }else{
        return 2;
    }
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return [dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    if (indexPath.section ==0) {
        
        NSInteger today=0;
        NSInteger total=0;
        for (int i=0;i<[dataArray count];i++) {
            JobModel *model=[dataArray objectAtIndex:i];
            today=today+model.todayData.integerValue;
            total=total+model.totalData.integerValue;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        addLabel.text = [[NSString alloc] initWithFormat:@"已设置的订阅器：   <font color='#f76806'>%d/3</font>条",dataArray.count];
        allLabel.text = [[NSString alloc] initWithFormat:@"所有订阅职位: 今日：<font color='#f76806'>%d</font>条,累计：<font color='#f76806'>%d</font>条",today,total];
        [cell.contentView addSubview:addLabel];
        [cell.contentView addSubview:allLabel];
        
        if (IOS7) {
            
        }else
        {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,43,iPhone_width,1)];
            lab.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:lab];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,1)];
            label.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:label];
        }
        
    }else
    {
        
        if (isClick){
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIButton *deleatbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleatbtn.tag=indexPath.row;
            deleatbtn.frame = CGRectMake(iPhone_width - 70, 0, 50, 55);
            [deleatbtn setImage:[UIImage imageNamed:@"deleread1.png"] forState:UIControlStateNormal];
            [deleatbtn setImageEdgeInsets:UIEdgeInsetsMake(15, -15, 15, -15)];
            [deleatbtn addTarget:self action:@selector(deleteReader:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleatbtn];
            JobModel *model = [dataArray objectAtIndex:indexPath.row];
            //青岛+职位
            UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 200, 25)];
            cityLabel.numberOfLines = 0;
            cityLabel.text = [NSString stringWithFormat:@"%@+%@",model.cityStr,model.positionName];
            [cityLabel setBackgroundColor:[UIColor clearColor]];
            [cityLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.contentView addSubview:cityLabel];
            
        }else
        {
            JobModel *model = [dataArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //青岛+职位
            UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 200, 25)];
            [cityLabel setBackgroundColor:[UIColor clearColor]];
            [cityLabel setFont:[UIFont systemFontOfSize:14]];
            cityLabel.numberOfLines = 0;
            
            [cell.contentView addSubview:cityLabel];
            cityLabel.text = [NSString stringWithFormat:@"%@+%@",model.cityStr,model.positionName];
            
            /**今日几条,总共几条**/
            RTLabel *dateLabel = [[RTLabel alloc]initWithFrame:CGRectMake(200, 13, 70, 40)];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.textColor = [UIColor grayColor];
            dateLabel.textAlignment = RTTextAlignmentRight;
            [cell.contentView addSubview:dateLabel];
            dateLabel.text = [NSString stringWithFormat:@"今日<font color='#f76806'>%@</font>条\n累计<font color='#f76806'>%@</font>条",model.todayData,model.totalData];
        }
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(5,5,10,10)];
        label2.backgroundColor=RGBA(219,159,90,1);
        [cell.contentView addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame: CGRectMake(9,16,1,40)];
        label3.backgroundColor=RGBA(219,159,90,1);
        [cell.contentView addSubview:label3];
        if (IOS7) {
            
        }else
        {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,59,iPhone_width,1)];
            lab.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:lab];
        }
    }
    
    
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section!=0) {
        
        if (!isClick) {
            JobModel *model=[dataArray objectAtIndex:indexPath.row];
            [_delegate kuaijieViewSelected:model];
        }
    }
}



/***************************点击快捷订阅按钮的时候触发当前方法***************************/
-(void)kuaijieClick:(id)sender
{
    
    Net *n=[Net standerDefault];
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    CityInfo *cityInfo=[CityInfo standerDefault];
    
    /**1.首先判断是否已经订阅3个城市**/
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
    
    /**3.判断是否订阅超过3个职位***/
    NSNumber *number=[userDefaults valueForKey:@"kuaijieNum"];
    NSInteger count=number.integerValue;
    
    if (count>=3) {
        ghostView.message=@"最多可订阅3个职位";
        [ghostView show];
        return;
    }
    
    myButton *button = (myButton *)sender;
    
    button.isClicked=!button.isClicked;
    
    for (int i=101;i<=101+8;i++) {
        myButton *btn=(myButton *)[self viewWithTag:i];
        btn.userInteractionEnabled=NO;
    }
    
    if (button.isClicked==YES) {//如果当前按钮被点击了，就显示阴影
        
        [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg2.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg2.png"] forState:UIControlStateHighlighted];
        
        titleStr =[button titleForState:UIControlStateNormal];
        
        NSArray *array=[db getAllRecords:@"2"];
        
        for (int i=0;i<[array count];i++) {
            
            JobModel *model=[array objectAtIndex:i];
            
            if ([model.positionName isEqualToString:titleStr]&&[model.cityStr isEqualToString:cityInfo.cityName]){
                [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg1.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg2.png"] forState:UIControlStateHighlighted];
                ghostView.message=@"您已订阅此职位";
                [ghostView show];
                
                button.isClicked=NO;
                
                for (int i=101;i<=101+8;i++) {
                    myButton *btn=(myButton *)[self viewWithTag:i];
                    btn.userInteractionEnabled=YES;
                }
                return;
            }
        }
        
        myTag=button.tag;
        NSString *jobSortNum = [self configBianma:button.tag];
        
        _cityStr=cityInfo.cityName;
        
        _cityCodeStr=cityInfo.cityCode;
        
        NSString *url=kCombineURL(KXZhiLiaoAPI, kBookerCreat);//开始下载
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                
                                IMEI,@"userImei",kUserTokenStr,@"userToken",
                                
                                @"2",@"flag",cityInfo.cityCode,@"searchLocation",      //订阅类型，订阅城市
                                
                                jobSortNum,@"searchPost",@"",@"searchIndustry",      //职位类别,行业类别
                                
                                @"",@"searchTreatment",@"",@"searchKeyword",      //职位待遇，职位关键词
                                
                                @"",@"searchNature",@"",@"searchWorkExperience",  //公司性质，工作经验
                                
                                @"",@"searchPublished",@"",@"searchEducational",  //发布日期，教育经历
                                
                                @"",@"searchType",@"0",@"searchBookId", nil];
        
        loadView=[MBProgressHUD showHUDAddedTo:self animated:YES];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        
        __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
        
        [request setTimeOutSeconds:30];
        
        [request setCompletionBlock:^(){
            
            [loadView hide:YES];
            
            for (int i=101;i<=101+8;i++){
                myButton *btn=(myButton *)[self viewWithTag:i];
                btn.userInteractionEnabled=YES;
            }
            
            NSLog(@"myTag in Receive is %d",myTag);
            myButton *button=(myButton *)[self viewWithTag:myTag];
            button.isClicked=NO;
            [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg1.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"kuaijieBg2.png"] forState:UIControlStateHighlighted];
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"resultDic in KuaijieView is %@",resultDic);
            
            
            NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            if([str isEqualToString:@"please login"])
            {
                OtherLogin *other = [OtherLogin standerDefault];
                [other otherAreaLogin];
                return ;
            }
            
            
            if (resultDic) {
                
            }else
            {
                ghostView.message=@"订阅失败";
                [ghostView show];
                return;
            }
            
            JobModel *model=[[JobModel alloc]init];
            model.flag=@"2";
            model.industry=@"";
            model.positionName=titleStr;
            model.cityStr=_cityStr;
            model.cityCodeStr=_cityCodeStr;
            model.bookID=[resultDic valueForKey:@"bookId"];
            model.todayData=[resultDic valueForKey:@"bookTodayData"];
            model.totalData=[resultDic valueForKey:@"bookTotalData"];
            [db addOneRecord:model];
            
            ghostView.message=@"添加成功";
            [ghostView show];
            
            dataArray=(NSMutableArray *)[db getAllRecords:@"2"];
            
            
            if (IOS7) {
                
                if (iPhone_5Screen) {
                    
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60-58);
                    
                }else
                {
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60+28);
                }
                
            }else
            {
                if (iPhone_5Screen){
                    
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60-58);
                }else
                {
                    myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60+20);
                }
                
            }
            
            [myTableView reloadData];
            
            if ([dataArray count]==0) {
                bianjiBtn.alpha=0;
                bianjiBtn.frame = CGRectMake(100,102+[dataArray count]*60,110,40);
            }else
            {
                bianjiBtn.alpha=1;
                if (IOS7) {
                    bianjiBtn.frame = CGRectMake(100,80+[dataArray count]*60,110,40);
                }else
                {
                    bianjiBtn.frame = CGRectMake(100,47+[dataArray count]*60,110,40);
                }
            }
            
            if (IOS7) {
                
                myTableView.frame=CGRectMake(0,290,iPhone_width,iPhone_height);
            }else
            {
                
                myTableView.frame= CGRectMake(0,305,iPhone_width,iPhone_height);
                
                if ([dataArray count]==0){
                    myTableView.frame=CGRectMake(0,305,iPhone_width,0);
                }
                myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
                
            }
            NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
            
            //判断当前城市是否已经订阅过
            if (![self judgeReaderOrNot:cityInfo.cityName]){
                NSMutableDictionary *dic2=[NSMutableDictionary dictionaryWithDictionary:dic];
                NSNumber *number=[NSNumber numberWithInteger:0];
                [dic2 setObject:number forKey:cityInfo.cityName];
                [userDefaults setObject:dic2 forKey:@"bookCity"];
                [userDefaults synchronize];
            }
            
            NSNumber *number=[userDefaults valueForKey:@"kuaijieNum"];
            NSInteger count=number.integerValue+1;
            NSNumber *number2=[NSNumber numberWithInteger:count];
            [userDefaults setObject:number2 forKey:@"kuaijieNum"];
            [userDefaults synchronize];
            
        }];
        
        [request setFailedBlock:^(){
            
            [loadView hide:YES];
            [request cancel];
            ghostView.message=@"下载失败";
            [ghostView show];
            
        }];
        
        [request startAsynchronous];
    }
}

-(BOOL)judgeReaderOrNot:(NSString *)cityStr
{
    NSMutableDictionary *bookCityDic=[userDefaults valueForKey:@"bookCity"];
    NSMutableArray *bookCityArray=(NSMutableArray *)[bookCityDic allKeys];
    for (NSString *bookCityStr in bookCityArray) {
        if ([bookCityStr isEqualToString:cityStr]) {
            return YES;
        }
    }
    return NO;
}

/**根据tag值来返回工作类型编码**/
- (NSString *)configBianma:(int)tag
{
    NSString *a= [[NSString alloc]init];
    switch (tag) {
        case 101:
            a = @"2200";
            break;
        case 102:
            a = @"5212,5216,2928";
            break;
        case 103:
            a = @"5400";
            break;
        case 104:
            a = @"5800";
            break;
        case 105:
            a = @"5616,5618";
            break;
        case 106:
            a = @"2900";
            break;
        case 107:
            a = @"2600";
            break;
        case 108:
            a = @"3300";
            break;
        default:
            break;
    }
    
    return a;
}
/***************************点击快捷订阅按钮的时候触发当前方法***************************/


/***************************删除快捷订阅操作***************************/

-(void)alterFeedReader:(id)sender
{
    NSLog(@"按钮被点击了");
    isClick=!isClick;
    if (!isClick) {
        [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateNormal];
        [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateHighlighted];
    }else
    {
        [bianjiBtn setTitle:@"[取消修改订阅器]" forState:UIControlStateNormal];
        [bianjiBtn setTitle:@"[取消修改订阅器]" forState:UIControlStateHighlighted];
    }
    [myTableView reloadData];
}


-(void)deleteReader:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该订阅器吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
    UIButton *btn = (UIButton *)sender;
    index = btn.tag;
    
    NSLog(@"index in deleteReader is %d",index);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0){
        
    }else{
        if(alertView.tag == 100){
            dataArray=(NSMutableArray *)[db getAllRecords:@"2"];
            JobModel *model = [dataArray objectAtIndex:index];
            [self deleatDingYu:model];
        }
    }
}
#pragma mark- 删除订阅器的请求
- (void)deleatDingYu:(JobModel*)model
{
    
    Net *n=[Net standerDefault];
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    loadView=[MBProgressHUD showHUDAddedTo:self animated:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",model.bookID,@"bookId",model.cityCodeStr,LocaCity,@"2",@"flag",nil];
    NSString *url = kCombineURL(KXZhiLiaoAPI, kCancelReadCompany);
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
    [request setTimeOutSeconds:15];
    
    [request setCompletionBlock :^{
        
        [loadView hide:YES];
        
        //请求响应结束，返回 responseString
        NSDictionary *resultDic= [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"resultDic  in KuaijieView and Delete is %@",resultDic);
        
        
        NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        if([str isEqualToString:@"please login"])
        {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return ;
        }
        
        NSString *errorStr= [resultDic valueForKey:@"error"];
        
        if (errorStr&&errorStr.integerValue==0){
            NSLog(@"删除成功");
            [db deleteRecord:model];
            ghostView.message=@"删除成功";
            [ghostView show];
            dataArray =(NSMutableArray *)[db getAllRecords:@"2"];
            [myTableView reloadData];
            
            if ([dataArray count]==0) {
                myScroView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-40-num);
                
                isClick=NO;
            }else
            {
                if (IOS7) {
                    
                    if (iPhone_5Screen) {
                        myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60-58);
                    }else{
                        myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60+28);
                    }
                    
                }else
                {
                    if (iPhone_5Screen){
                        myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60-58);
                    }else
                    {
                        myScroView.contentSize= CGSizeMake(iPhone_width,iPhone_height-44-40-num+[dataArray count]*60+20);
                    }
                }
            }
        }else
        {
            ghostView.message=@"删除失败";
            [ghostView show];
            return;
        }
        
        if ([dataArray count]==0) {
            bianjiBtn.alpha=0;
            bianjiBtn.frame = CGRectMake(100,102+[dataArray count]*60,110,40);
        }else
        {
            bianjiBtn.alpha=1;
            if (IOS7) {
                bianjiBtn.frame = CGRectMake(100,80+[dataArray count]*60,110,40);
            }else
            {
                bianjiBtn.frame = CGRectMake(100,47+[dataArray count]*60,110,40);
            }
        }
        
        if (IOS7) {
            
            myTableView.frame=CGRectMake(0,290,iPhone_width,iPhone_height);
        }else
        {
            
            myTableView.frame= CGRectMake(0,305,iPhone_width,iPhone_height);
            
            if ([dataArray count]==0) {
                myTableView.frame=CGRectMake(0,305,iPhone_width,0);
            }
            myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            
        }
        
        //每次删除一个企业订阅时，查看当前城市的详细订阅是否为0
        NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
        
        if (![self ifExist:model.cityStr]) {
            
            NSMutableDictionary *bookCityDic4=[NSMutableDictionary dictionaryWithDictionary:dic];
            [bookCityDic4 removeObjectForKey:model.cityStr];
            [userDefaults setObject:bookCityDic4 forKey:@"bookCity"];
            [userDefaults synchronize];
        }
        
        NSDictionary*bookCityDic5=[userDefaults valueForKey:@"bookCity"];
        NSLog(@"bookCityDic5 is %@",bookCityDic5);
        
        NSNumber *number=[userDefaults valueForKey:@"kuaijieNum"];
        NSInteger count=number.integerValue-1;
        NSNumber *number2=[NSNumber numberWithInteger:count];
        [userDefaults setObject:number2 forKey:@"kuaijieNum"];
        [userDefaults synchronize];
    }];
    
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息
        [loadView hide:YES];
        NSLog(@"删除失败!");
        ghostView.message=@"删除失败";
        [ghostView show];
    }];
    
    [request startAsynchronous];
}

//判断当前城市cityStr是否还有订阅器
-(BOOL)ifExist:(NSString *)cityStr
{
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
/***************************删除快捷订阅操作***************************/


@end
