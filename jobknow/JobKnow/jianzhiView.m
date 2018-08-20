//
//  jianzhiView.m
//  JobKnow
//
//  Created by Zuo on 13-12-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//
#import "Config.h"
#import "jianzhiView.h"
#import "MyButton.h"
#import "RTLabel.h"
#import "JobModel.h"
#import "HeadView.h"
#import "JobDetailInfo.h"
#import "OtherLogin.h"
@implementation jianzhiView
@synthesize myScrollView;

-(void)initData
{
    num=ios7jj;
    
    status=1;
    
    db=[UserDatabase sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    dataArray=[[NSMutableArray alloc]init];
    dataArray=(NSMutableArray *)[db getAllRecords:@"5"];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.3  dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    self.backgroundColor=XZhiL_colour2;
}

- (void)loadModel{
    
    currentRow = -1;
    
    NSArray *titleArray=[NSArray arrayWithObjects:@"学生",@"热门兼职",@"教育/艺术/其他",nil];
    
    headViewArray = [[NSMutableArray alloc]init];
    
    for(int i = 0;i<3;i++){
        
        HeadView* headview = [[HeadView alloc] init];
        
        headview.delegate = self;
		headview.section = i;
        [headview.backBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [headview.backBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateHighlighted];

        
        if (i==0){
            
            headview.open=YES;
            headview.backBtn.isClicked=YES;
            
            //在按钮上添加一个arrow图片
            UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hhhh.png"]];
            image.tag=101;
            image.frame=CGRectMake(270,17.5,15,15);
            [headview.backBtn addSubview:image];
            [headview.backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-192,0,0)];
            
        }else if (i==1)
        {
            
            UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow00@2x.png"]];
            image.tag=101;
            image.frame=CGRectMake(270,17.5,15,15);
            [headview.backBtn addSubview:image];
            [headview.backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-155,0,0)];
            
        }else
        {
            UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow00@2x.png"]];
            image.tag=101;
            image.frame=CGRectMake(270,17.5,15,15);
            [headview.backBtn addSubview:image];
            [headview.backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-117,0,0)];
        }
        
        [headview.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headview.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
		[headViewArray addObject:headview];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        
        //初始化数据
        [self initData];
        //初始化headView
        [self loadModel];
        
        NSInteger count=[dataArray count];
        
        myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-num-40)];
        
        //适配界面
        [self adaptScreen];
        
        myScrollView.bounces=YES;
        myScrollView.alwaysBounceHorizontal=NO;
        myScrollView.alwaysBounceVertical=YES;
        myScrollView.showsVerticalScrollIndicator=YES;
        [self addSubview:myScrollView];
        
        //_tableView是屏幕上的3个大按钮
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,10,iPhone_width,iPhone_height+300) style:UITableViewStylePlain];
        _tableView.tag=1024;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor=XZhiL_colour2;
        _tableView.backgroundView=nil;
        _tableView.contentSize=CGSizeMake(iPhone_width,400);
        _tableView.allowsSelection=NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [myScrollView addSubview:_tableView];
        
        
        //订阅器个数
        allReaderLabel=[[RTLabel alloc]initWithFrame:CGRectMake(10,5,220,20)];
        [allReaderLabel setBackgroundColor:[UIColor clearColor]];
        [allReaderLabel setFont:[UIFont systemFontOfSize:12]];
        
        //所有订阅条数
        totalAddLabel=[[RTLabel alloc]initWithFrame:CGRectMake(10,23,300,20)];
        [totalAddLabel setBackgroundColor:[UIColor clearColor]];
        [totalAddLabel setFont:[UIFont systemFontOfSize:12]];
        
        if (IOS7 ) {
            _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,240,iPhone_width,iPhone_height) style:UITableViewStyleGrouped];
        }else
        {
            _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,240,iPhone_width, iPhone_height) style:UITableViewStylePlain];
            
            if (count==0) {
                _myTableView.frame=CGRectMake(0,240,iPhone_width,0);
            }
            
            _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
        
        _myTableView.dataSource=self;
        _myTableView.delegate=self;
        _myTableView.backgroundColor=XZhiL_colour2;
        _myTableView.backgroundView=nil;
        [_tableView addSubview:_myTableView];
        
        if (IOS7) {
            
        }else
        {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,1)];
            lab.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [_myTableView addSubview:lab];
        }
        
        
        //编辑订阅器的按钮
        bianjiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (count>0){
            bianjiBtn.alpha=1;
        }else
        {
            bianjiBtn.alpha=0;
        }
        
        if (IOS7) {
            bianjiBtn.frame = CGRectMake(100,[dataArray count]*60+70,110,40);
        }else
        {
            bianjiBtn.frame = CGRectMake(100,[dataArray count]*60+40,110,40);
        }
        
        [bianjiBtn addTarget:self action:@selector(alterFeedReader:) forControlEvents:UIControlEventTouchUpInside];
        [bianjiBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateNormal];
        [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateHighlighted];
        [bianjiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myTableView addSubview:bianjiBtn];
    }
    return self;
}


#pragma mark 职位按钮响应事件
-(void)btnClick:(id)sender
{
    Net *n=[Net standerDefault];
   
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    myButton *btn=(myButton *)sender;
    myTag=btn.tag;
    
    CityInfo *cityInfo=[CityInfo standerDefault];
    
    /***1.首先判断是否已经有3个城市***/
    NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
    NSArray *bookCityArray=[dic allKeys];
    if ([bookCityArray count]>=3) {
        //如果当前城市是订阅城市中的一个就继续执行，否则就提醒。
        if(![self judgeReaderOrNot:cityInfo.cityName]) {
            ghostView.message=@"您最多可订阅3个城市的职位";
            [ghostView show];
            return;
        }
    }
    
    /***2.判断是否订阅超过3个职位***/
    NSNumber *number=[userDefaults valueForKey:@"jianzhiNum"];
    NSInteger count=number.integerValue;
    if (count>=3) {
        ghostView.message=@"最多可订阅3个职位";
        [ghostView show];
        NSLog(@"最多可订阅3个职位");
        return;
    }
    
    
    NSString *jobPositionStr=[self configBianma:btn.tag];
    titleStr =[btn titleForState:UIControlStateNormal];
    
    NSArray *array=[db getAllRecords:@"5"];
    
    for (int i=0;i<[array count];i++) {
        
        JobModel *model=[array objectAtIndex:i];
        
        if ([model.positionName isEqualToString:titleStr]&&[model.cityStr isEqualToString:cityInfo.cityName]){
            ghostView.message=@"您已订阅此职位";
            [ghostView show];
            return;
        }
    }
    
    _cityStr=cityInfo.cityName;
    
    _cityCodeStr=cityInfo.cityCode;
    
    //职位链接
    NSString *url=kCombineURL(KXZhiLiaoAPI, kBookerCreat);//开始下载
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            
                            IMEI,@"userImei",kUserTokenStr,@"userToken",
                            
                            @"5",@"flag",cityInfo.cityCode,@"searchLocation",      //订阅类型，订阅城市
                            
                            jobPositionStr,@"searchPost",@"",@"searchIndustry",      //职位类别,行业类别
                            
                            @"",@"searchTreatment",@"",@"searchKeyword",      //职位待遇，职位关键词
                            
                            @"",@"searchNature",@"",@"searchWorkExperience",  //公司性质，工作经验
                            
                            @"",@"searchPublished",@"",@"searchEducational",  //发布日期，教育经历
                            
                            @"",@"searchType",@"0",@"searchBookId", nil];
    
    loadView=[MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
    [request setTimeOutSeconds:50];
    
    [request setCompletionBlock :^{
        
        [loadView hide:YES];
        
        CityInfo *cityInfo=[CityInfo standerDefault];
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"resultDic is %@",resultDic);
        
        NSString *str= [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        if([str isEqualToString:@"please login"])
        {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"booker"];
        
        if (resultArray) {
            
        }else
        {
            ghostView.message=@"订阅失败";
            [ghostView show];
            return;
        }
    
        NSDictionary*resultDic2=[resultArray objectAtIndex:0];
        
        JobModel *model=[[JobModel alloc]init];
        model.flag=@"5";
        model.industry=@"";
        model.positionName=titleStr;
        model.cityCodeStr=_cityCodeStr;
        model.cityStr=_cityStr;
        model.bookID=[resultDic2 valueForKey:@"bookId"];
        model.todayData=[resultDic2 valueForKey:@"bookTodayData"];
        model.totalData=[resultDic2 valueForKey:@"bookTotalData"];
        [db addOneRecord:model];
        
        ghostView.message=@"添加成功";
        [ghostView show];
        
        NSLog(@"model in jianzhiView is model.industry=%@,model.positionName=%@,model.cityStr=%@,model.bookID=%@,model.todayData=%@,model.totalData=%@",model.industry,model.positionName,model.cityStr,model.bookID,model.todayData,model.totalData);
        
        myButton *btn=(myButton *)[self viewWithTag:myTag];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg1.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg2.png"] forState:UIControlStateHighlighted];
         
        dataArray=(NSMutableArray *)[db getAllRecords:@"5"];
        
        NSLog(@"dataArray is %@",dataArray);
        
        if ([dataArray count]!=0) {
            bianjiBtn.alpha=1;
        }else
        {
            bianjiBtn.alpha=0;
        }
        
        if (IOS7) {
            
            bianjiBtn.frame = CGRectMake(100,[dataArray count]*60+70,110,40);
            
        }else
        {
            bianjiBtn.frame = CGRectMake(100,[dataArray count]*60+40,110,40);
        }
        
        [self adaptScreen2];
        //重新加载一下myTableView
        [_myTableView reloadData];
        for (int i=101;i<=101+8;i++) {
            myButton *button=(myButton *)[self viewWithTag:i];
            if (button.tag!=btn.tag) {
                btn.userInteractionEnabled=YES;
            }
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
        
        NSNumber *number=[userDefaults valueForKey:@"jianzhiNum"];
        NSInteger count2=number.integerValue+1;
        NSNumber *number2=[NSNumber numberWithInteger:count2];
        [userDefaults setObject:number2 forKey:@"jianzhiNum"];
        [userDefaults synchronize];
    }];
    
    [request setFailedBlock :^{
        
        [loadView hide:YES];
        ghostView.message=@"订阅失败";
        [ghostView show];
    }];
    
    [request startAsynchronous];
}

#pragma mark UITableView代理方法的实现
//分组的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1024) {
        return 3;
    }
    
    if (dataArray.count==0) {
        return 0;
    }
    
    return 2;
}

//每组cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1024) {
        HeadView *headView=[headViewArray objectAtIndex:section];
        return headView.open?1:0;
    }
    
    if (section ==0) {
        return 1;
    }else
    {
        return [dataArray count];
    }
}

//设置分区header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (IOS7) {
        
        if (tableView.tag==1024){
            return 60;
        }
        
        return 5;
        
    }else
    {
        if (tableView.tag==1024){
            return 60;
        }
        
        return 0;
    }
}

//设置分区footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//设置分区header的视图，可以为它添加图片或者其他控件（UIView的子类）
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag==1024) {
        return [headViewArray objectAtIndex:section];
    }
    
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    /*********************如果是大按钮的话*********************/
    if (tableView.tag==1024) {
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }else
        {
            NSArray *views=[cell.contentView subviews];
            for (UIView *v in views) {
                [v removeFromSuperview];
            }
        }
        
        //添加backView
        UIView *backView=[[UIView alloc]init];
        
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:backView];
        
        if (indexPath.section==0) {
            
            backView.frame=CGRectMake(0,0,iPhone_width,50);
            //添加3个按钮
            NSArray *textArray1=[NSArray arrayWithObjects:@"实习生",@"家教" ,@"学生兼职",nil];
            
            for (int i=0;i<[textArray1 count];i++) {//在学生按钮下面 添加3个按钮
                
                myButton *studentBtn=(myButton *)[myButton buttonWithType:UIButtonTypeCustom];
                studentBtn.backgroundColor=[UIColor clearColor];
                studentBtn.tag=101+i;
                studentBtn.frame=CGRectMake(15+100*i,0,90,50);
                [studentBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
                [studentBtn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg1.png"] forState:UIControlStateNormal];
                [studentBtn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg2.png"] forState:UIControlStateHighlighted];
                [studentBtn setTitle:[textArray1 objectAtIndex:i] forState:UIControlStateNormal];
                [studentBtn setTitle:[textArray1 objectAtIndex:i] forState:UIControlStateHighlighted];
                [studentBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [studentBtn  addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:studentBtn];
            }
            
        }else if(indexPath.section==1)
        {
            
            backView.frame=CGRectMake(0,0,iPhone_width,170);
            
            NSArray *textArray2=[NSArray arrayWithObjects:@"小时工/钟点工",@"设计制作",@"传单派发",@"服务员",@"礼仪/模特",@"促销/导航",@"手工制作",@"网站建设",@"问卷调查",nil];
            //在热门兼职下面添加9个按钮,tag值为106----114
            for (int i=0;i<[textArray2 count];i++) {
                myButton *remenBtn=(myButton *)[myButton buttonWithType:UIButtonTypeCustom];
                remenBtn.backgroundColor=[UIColor clearColor];
                remenBtn.tag=104+i;
                remenBtn.frame=CGRectMake(15+100*(i/3),60*(i%3),90,50);
                [remenBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
                [remenBtn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg1.png"] forState:UIControlStateNormal];
                [remenBtn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg2.png"] forState:UIControlStateHighlighted];
                [remenBtn setTitle:[textArray2 objectAtIndex:i] forState:UIControlStateNormal];
                [remenBtn setTitle:[textArray2 objectAtIndex:i] forState:UIControlStateHighlighted];
                [remenBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [remenBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:remenBtn];
            }
        }else
        {
            backView.frame=CGRectMake(0,0,iPhone_width,170);
            NSArray *textArray3=[NSArray arrayWithObjects:@"其他兼职",@"销售",@"摄影/摄像",@"健身教练",@"化妆师",@"艺术老师",@"律师/法务",@"会计",@"翻译",nil];
            for (int i=0;i<[textArray3 count];i++) {        //在第三个大按钮下添加9个button,tag值为115---123
                myButton *otherBtn=(myButton *)[myButton  buttonWithType:UIButtonTypeCustom];
                otherBtn.backgroundColor=[UIColor clearColor];
                otherBtn.tag=113+i;
                otherBtn.frame=CGRectMake(15+100*(i/3),60*(i%3),90,50);
                [otherBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
                [otherBtn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg1.png"] forState:UIControlStateNormal];
                [otherBtn setBackgroundImage:[UIImage imageNamed:@"jianzhiBg2.png"] forState:UIControlStateHighlighted];
                [otherBtn setTitle:[textArray3 objectAtIndex:i] forState:UIControlStateNormal];
                [otherBtn setTitle:[textArray3 objectAtIndex:i] forState:UIControlStateHighlighted];
                [otherBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:otherBtn];
            }
        }
        return cell;
    }
    
    /*********************如果是大按钮的话*********************/
    
    
    /*********************如果不是大按钮的话*********************/
    if (cell ==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views=[cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    if (indexPath.section ==0) {
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:allReaderLabel];
        [cell.contentView addSubview:totalAddLabel];
        
        NSInteger today=0;
        NSInteger total=0;
        for (int i=0;i<[dataArray count];i++) {
            JobModel *model=[dataArray objectAtIndex:i];
            today=today+model.todayData.integerValue;
            total=total+model.totalData.integerValue;
        }
        
        allReaderLabel.text=[[NSString alloc]initWithFormat:@"已设置的订阅器:<font color='#f76806'>%d/3</font>条",dataArray.count];
        
        totalAddLabel.text=[[NSString alloc]initWithFormat:@"所有订阅职位:今日<font color='#f76806'>%d</font>条，累计<font color='#f76806'>%d</font>条",today,total];
        
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(0,43,iPhone_width,1)];
        label4.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
        [cell.contentView addSubview:label4];
        
    }else{
        
        if (isClick){
            
            cell.accessoryType=UITableViewCellAccessoryNone;
            UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.tag=indexPath.row;
            deleteBtn.frame=CGRectMake(iPhone_width-70,0,50,55);
            [deleteBtn setImage:[UIImage imageNamed:@"deleread1.png"] forState:UIControlStateNormal];
            [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(15, -15,15,-15)];
            [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView  addSubview:deleteBtn];
            
            JobModel *model=[dataArray objectAtIndex:indexPath.row];
            UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(25,15,200,25)];
            cityLabel.backgroundColor=[UIColor clearColor];
            cityLabel.font=[UIFont systemFontOfSize:14];
            cityLabel.numberOfLines=0;
            [cell.contentView addSubview:cityLabel];
            cityLabel.text=[NSString stringWithFormat:@"%@+%@",model.cityStr,model.positionName];
            
        }else
        {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            JobModel *model=[dataArray objectAtIndex:indexPath.row];
            UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(25,15,200,25)];
            cityLabel.backgroundColor=[UIColor clearColor];
            cityLabel.font=[UIFont systemFontOfSize:14];
            cityLabel.numberOfLines=0;
            
            [cell.contentView addSubview:cityLabel];
            cityLabel.text=[NSString stringWithFormat:@"%@+%@",model.cityStr,model.positionName];
            RTLabel *dateLabel = [[RTLabel alloc]initWithFrame:CGRectMake(200, 13, 70, 40)];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.textColor = [UIColor grayColor];
            dateLabel.textAlignment = RTTextAlignmentRight;
            [cell.contentView addSubview:dateLabel];
            dateLabel.text = [NSString stringWithFormat:@"今日<font color='#f76806'>%@</font>条\n累计<font color='#f76806'>%@</font>条",model.todayData,model.totalData];
        }
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(5,5,10,10)];
        label2.backgroundColor=RGBA(148,186,187,1);
        [cell.contentView addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame: CGRectMake(9,16,1,40)];
        label3.backgroundColor=RGBA(148,186,187,1);
        [cell.contentView addSubview:label3];
        
        if (IOS7) {
            
        }else
        {
            
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(0,59,iPhone_width,1)];
            label4.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:label4];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    
    return cell;
}

//设置每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**设置上TableViewCell的大小**/
    if (tableView.tag==1024) {
        
        if (indexPath.section==0) {
            return 60;
        }
        return 180;
    }
    
    /**设置下TableViewCell的大小**/
    if (indexPath.section==0) {
        return 44;
    }
    
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"indexPath.section is %d",indexPath.section);
    
    if (tableView.tag!=1024&&indexPath.section!=0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        currentRow=indexPath.row;
        [_tableView reloadData];
        if (!isClick){
            JobModel *model=[dataArray objectAtIndex:indexPath.row];
            [_delegate jianzhiViewSelected:model];
        }
    }
    
}

#pragma mark 按钮点击
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
    [_myTableView reloadData];
}

-(void)delete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该订阅器吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    UIButton *btn = (UIButton *)sender;
    index = btn.tag;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        
    }else{
        if(alertView.tag == 100 ){
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
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",model.bookID,@"bookId",model.cityCodeStr,LocaCity,@"5",@"flag",nil];
    NSString *url = kCombineURL(KXZhiLiaoAPI, kCancelReadCompany);
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
    [request setTimeOutSeconds:15];
    
    [request setCompletionBlock :^{
        
        [loadView hide:YES];
        
        //请求响应结束，返回 responseString
        NSDictionary *resultDic= [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
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
            ghostView.message=@"删除成功";
            [ghostView show];
            [db deleteRecord:model];
            
            dataArray =(NSMutableArray *)[db getAllRecords:@"5"];
            
            if ([dataArray count]==0) {
                isClick=NO;
            }
            [_myTableView reloadData];
        }else
        {
            ghostView.message=@"删除失败";
            [ghostView show];
            return;
        }
        
        NSNumber *number=[userDefaults valueForKey:@"jianzhiNum"];
        NSInteger count=number.integerValue-1;
        NSNumber *number2=[NSNumber numberWithInteger:count];
        [userDefaults setObject:number2 forKey:@"jianzhiNum"];
        [userDefaults synchronize];
        
        //每次删除一个企业订阅时，查看当前城市的详细订阅是否为0
        NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
        
        if (![self ifExist:model.cityStr]) {
            NSMutableDictionary *bookCityDic4=[NSMutableDictionary dictionaryWithDictionary:dic];
            [bookCityDic4 removeObjectForKey:model.cityStr];
            [userDefaults setObject:bookCityDic4 forKey:@"bookCity"];
            [userDefaults synchronize];
        }
        
        if (IOS7){
            bianjiBtn.frame = CGRectMake(100,[dataArray count]*60+70,110,40);
        }else
        {
            bianjiBtn.frame= CGRectMake(100,[dataArray count]*60+40,110,40);
        }
        dataArray=(NSMutableArray *)[db getAllRecords:@"5"];
        
        if ([dataArray count]==0) {
            bianjiBtn.alpha=0;
            [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateNormal];
            [bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateHighlighted];
        }else
        {
            bianjiBtn.alpha=1;
        }
        
        [self adaptScreen2];
        NSDictionary*bookCityDic5=[userDefaults valueForKey:@"bookCity"];
        NSLog(@"bookCityDic5 is %@",bookCityDic5);
        
    }];
    
    [request setFailedBlock :^{
        [loadView hide:YES];
        ghostView.message=@"删除成功";
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

#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view{
    
    NSLog(@"头部按钮被点击到了。。。。。");
    
    if (view.open==YES){    //如果三个按钮都是关闭状态
        
        status=0;
        _myTableView.frame=CGRectMake(0,180,iPhone_width, iPhone_height);
        
        for (int i=0;i<[headViewArray count];i++) {
            
            HeadView *headView=[headViewArray objectAtIndex:i];
            
            UIImageView *image=(UIImageView *)[headView.backBtn viewWithTag:101];
            [image removeFromSuperview];
            UIImageView *image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow00@2x.png"]];
            image2.tag=101;
            image2.frame=CGRectMake(270,17.5,15,15);
            [headView.backBtn addSubview:image2];
            
        }
        
        [self adaptScreen2];
    }
    
    if (view.section==0&&view.open==NO){//如果第一个处于打开的状态
        status=1;
        
        [self adaptScreen2];
        
        for (int i=0;i<[headViewArray count];i++){
            
            
            HeadView *headView=[headViewArray objectAtIndex:i];
            
            UIImageView *image=(UIImageView *)[headView.backBtn viewWithTag:101];
            [image removeFromSuperview];
            UIImageView *image2;
            
            if (i==0){
                image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hhhh.png"]];
            }else
            {
                image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow00@2x.png"]];
            }
            
            image2.tag=101;
            image2.frame=CGRectMake(270,17.5,15,15);
            [headView.backBtn addSubview:image2];
            
        }
        
        
    }else if(view.section==1&&view.open==NO)//如果第二个处于打开的状态
    {
        status=2;
        [self adaptScreen2];
        
        for (int i=0;i<[headViewArray count];i++){
            
            
            HeadView *headView=[headViewArray objectAtIndex:i];
            
            UIImageView *image=(UIImageView *)[headView.backBtn viewWithTag:101];
            [image removeFromSuperview];
            UIImageView *image2;
            
            if (i==1){
                image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hhhh.png"]];
            }else
            {
                image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow00@2x.png"]];
            }
            
            image2.tag=101;
            image2.frame=CGRectMake(270,17.5,15,15);
            [headView.backBtn addSubview:image2];
            
        }
        
        
        
        
    }else if(view.section==2&&view.open==NO)//如果第三个处于打开的状态
    {
        status=3;
        [self adaptScreen2];
        
        for (int i=0;i<[headViewArray count];i++){
            
            
            HeadView *headView=[headViewArray objectAtIndex:i];
            
            UIImageView *image=(UIImageView *)[headView.backBtn viewWithTag:101];
            [image removeFromSuperview];
            UIImageView *image2;
            
            if (i==2){
                image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hhhh.png"]];
            }else
            {
                image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow00@2x.png"]];
            }
            
            image2.tag=101;
            image2.frame=CGRectMake(270,17.5,15,15);
            [headView.backBtn addSubview:image2];
        }
    }
    
    if (view.open){
        
        for(int i = 0;i<[headViewArray count];i++)
        {
            HeadView *head = [headViewArray objectAtIndex:i];
            head.open = NO;
        }
        
        [self adaptScreen3];
        
        [_tableView reloadData];
        return;
    }
    
    currentSection = view.section;
    
    [self reset];
}

#pragma mark 界面重置
-(void)reset
{
    NSLog(@"reset执行到了。。。。。");
    
    for(int i = 0;i<[headViewArray count];i++)
    {
        HeadView *head = [headViewArray objectAtIndex:i];
        
        if(head.section == currentSection)
        {
            head.open = YES;
        }else {
            head.open = NO;
        }
    }
    
    [_tableView reloadData];
}

#pragma mark 职位编码
//根据tag值来返回工作类型编码
- (NSString *)configBianma:(NSInteger)number
{
    NSString *configStr;
    switch (number) {
        case 101:
            configStr=@"7";
            break;
        case 102:
            configStr=@"2";
            break;
        case 103:
            configStr=@"1";
            break;
        case 104:
            configStr=@"3";
            break;
        case 105:
            configStr=@"10";
            break;
        case 106:
            configStr=@"6";
            break;
        case 107:
            configStr=@"19";
            break;
        case 108:
            configStr=@"5";
            break;
        case 109:
            configStr=@"4";
            break;
        case 110:
            configStr=@"18";
            break;
        case 111:
            configStr=@"9";
            break;
        case 112:
            configStr=@"8";
            break;
        case 113:
            configStr=@"21";
            break;
        case 114:
            configStr=@"20";
            break;
        case 115:
            configStr=@"17";
            break;
        case 116:
            configStr=@"15";
            break;
        case 117:
            configStr=@"16";
            break;
        case 118:
            configStr=@"13";
            break;
        case 119:
            configStr=@"14";
            break;
        case 120:
            configStr=@"11";
            break;
        case 121:
            configStr=@"12";
            break;
        default:
            break;
    }
    return configStr;
}

#pragma mark 屏幕适配方法
-(void)adaptScreen
{
    NSInteger count=[dataArray count];
    
    if (count==0) {
        _myTableView.frame=CGRectMake(0,240,0,0);
    }
    
    if (IOS7){
        
        if (iPhone_5Screen) {
            
            if (count<2) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else if(count==2)
            {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+10);
            }else
            {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-1)*60-40);
            }
            
        }else
        {
            if (count==0) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else{
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60-20);
            }
        }
    }else
    {
        
        
        if (iPhone_5Screen) {
            
            if (count<2) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else if(count<3)
            {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+10);
            }else
            {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+70);
            }
            
        }else
        {
            if (count==0) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else{
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-1)*60+20);
            }
        }
    }
}


-(void)adaptScreen2
{
    
    NSInteger count=[dataArray count];
    
    if (count==0) {
        _myTableView.frame=CGRectMake(0,240,0,0);
    }
    
    if (status==0){
        
        _myTableView.frame=CGRectMake(0,180,iPhone_width, iPhone_height);
        
        if (IOS7) {
            if (iPhone_5Screen) {
                
                if (count<2) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else{
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+20);
                }
                
            }else
            {
                if (count<=1) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else{
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-1)*60-5);
                }
            }
        }else
        {
            if (iPhone_5Screen) {
                
                if (count<2) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else{
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+20);
                }
                
            }else
            {
                if (count<=1) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else{
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-1)*60);
                }
            }
            
        }
        
        
    }else if (status==1)
    {
        
        _myTableView.frame=CGRectMake(0,240,iPhone_width, iPhone_height);
        
        if (IOS7){
            
            if (iPhone_5Screen) {
                
                if (count<2) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else if(count<3)
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+10);
                }else
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+70);
                }
                
            }else
            {
                if (count==0) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else{
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60-8);
                }
            }
        }else
        {
            
            if (iPhone_5Screen) {
                
                if (count<2) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else if(count<3)
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+10);
                }else
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+70);
                }
                
            }else
            {
                if (count==0) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else{
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-1)*60+20);
                }
            }
        }
    }else if(status==2)
    {
        _myTableView.frame=CGRectMake(0,360,iPhone_width, iPhone_height);
        
        if (IOS7) {
            
            if (count==0) {
                
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                
            }else
            {
                if (iPhone_5Screen) {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+18);
                }else
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+105);
                    
                }
            }
            
        }else
        {
            if (iPhone_5Screen) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+18);
            }else
            {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+90);
            }
        }
        
    }else
    {
        
        _myTableView.frame=CGRectMake(0,360,iPhone_width, iPhone_height);
        
        if (IOS7){
            
            if (count==0) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else
            {
                if (iPhone_5Screen){
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+18);
                }else
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+105);
                }
            }
            
        }else
        {
            if (count==0) {
                myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else
            {
                if (iPhone_5Screen){
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+18);
                }else
                {
                    myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+count*60+80);
                }
            }
        }
        
    }
}

-(void)adaptScreen3
{
    NSInteger count=[dataArray count];
    
    
    
    _myTableView.frame=CGRectMake(0,180,iPhone_width, iPhone_height);
    
    if (count==0) {
        _myTableView.frame=CGRectMake(0,240,iPhone_width,0);
    }
    
    if (iPhone_5Screen) {
        
        if (count<2) {
            myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
        }else{
            myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+20);
        }
        
    }else
    {
        
        if (count<=1) {
            myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
        }else
        {
            myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-1)*60-20);
        }
        
    }
}
@end
