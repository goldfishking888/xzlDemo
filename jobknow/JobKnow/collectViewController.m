//
//  collectViewController.m
//  JobKnow
//
//  Created by Apple on 14-3-18.
//  Copyright (c) 2014年 lxw. All rights reserved.
//
//  职位收藏

#import "collectViewController.h"
#import "PositionModel.h"
#import "myButton.h"
#import "JobReaderDetailViewController.h"
#import "OtherLogin.h"
@interface collectViewController ()

@end

@implementation collectViewController
@synthesize dataArray=_dataArray;
@synthesize selectArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位收藏"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位收藏"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configHeadView];
    [self addBackBtn];
    
    [self addTitleLabel:@"职位收藏"];
    int num=ios7jj;
    
    _dataArray=[[NSMutableArray alloc]init];
    
    selectArray=[[NSMutableArray alloc]init];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    //_tableView是显示职位信息的view
    if (IOS7) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+num, iPhone_width, iPhone_height-44-num-45) style:UITableViewStyleGrouped];
    }else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+num, iPhone_width, iPhone_height-44-num-65) style:UITableViewStylePlain];
        
        if ([_dataArray count]==0){
            _tableView.frame=CGRectMake(0,44+num, iPhone_width,0);
        }
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView *bottomlabel=[[UIView alloc]init];
    bottomlabel.backgroundColor=[UIColor whiteColor];
    
    if (IOS7) {
        bottomlabel.frame = CGRectMake(0,iPhone_height-45, iPhone_width, 45);
    }else
    {
        bottomlabel.frame = CGRectMake(0,iPhone_height -65,iPhone_width, 45);
    }
    [self.view addSubview:bottomlabel];
    
    
    UIImage *detailImage=[UIImage imageNamed:@"mingxi.png"];
    UIImageView *detailImageView=[[UIImageView alloc]initWithImage:detailImage];
    detailImageView.frame=CGRectMake(5,-2,50,50);
    detailImageView.tag=101;
    
    myButton* detailBtn2 = [myButton buttonWithType:UIButtonTypeCustom];
    detailBtn2.frame = CGRectMake(64,2,80,45);
    detailBtn2.backgroundColor=[UIColor clearColor];
    [detailBtn2 addTarget:self action:@selector(detailVC:) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn2 addSubview:detailImageView];
    [bottomlabel addSubview:detailBtn2];
    
    detailLab = [[UILabel alloc]initWithFrame:CGRectMake(18.5+50+14,25,28, 28)];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font = [UIFont fontWithName:Zhiti size:10];
    detailLab.text = @"明细";
    [bottomlabel addSubview:detailLab];
    
    //投递按钮
    postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(200,2,iPhone_width/5, 45);
    [postBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [postBtn setTitle:@"投递" forState:UIControlStateNormal];
    [postBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [postBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"post_n.png"] forState:UIControlStateNormal];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"post_l.png"] forState:UIControlStateHighlighted];
    [postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [postBtn addTarget:self action:@selector(postBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomlabel addSubview:postBtn];
    
    //选择职位的数量
    postBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn2.alpha = 0;
    postBtn2.frame = CGRectMake(232,2,18,18);
    [postBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postBtn2 setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateNormal];
    [postBtn2 setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateHighlighted];
    [postBtn2.titleLabel setFont:[UIFont boldSystemFontOfSize:8]];
    [bottomlabel addSubview:postBtn2];
    
    /***判断是否联网***/
//    Net *n=[Net standerDefault];
//    
//    if (n.status ==NotReachable) {
//        ghostView.message=@"无网络连接,请检查您的网络!";
//        [ghostView show];
//        return;
//    }
    
//    net=[[NetWorkConnection alloc]init];
//    net.delegate=self;
    
    NSString *url = kCombineURL(KXZhiLiaoAPI,kNewFavouriteJobListShow);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    
//    [net request:url param:paramDic andTime:20];
    
    loadView =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled = NO;
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        
        NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        if ([resultStr isEqualToString:@"please login"])
        {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return ;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        if (resultArray) {
            
        }else
        {
            ghostView.message=@"亲，您暂时没有收藏任何职位~";
            [ghostView show];
            return;
        }
        
        NSLog(@"resultArray in JobSeeVC and receiveDataFinish is %@",resultArray);
        
        for (int i=0;i<[resultArray count];i++) {
            NSDictionary *dic=[resultArray objectAtIndex:i];
            PositionModel *positionmodel=[[PositionModel alloc]initWithDictionary:dic];
            [_dataArray addObject:positionmodel];
        }
        
        int num=ios7jj;
        
        if ([_dataArray count]==0){
            
            _tableView.frame=CGRectMake(0,44+num, iPhone_width,0);
            
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,60)];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.font=[UIFont systemFontOfSize:14];
            lab.backgroundColor=[UIColor clearColor];
            lab.text=@"亲，您暂时没有收藏任何职位~";
            [self.view addSubview:lab];
            
        }else
        {
            if (IOS7) {
                _tableView.frame=CGRectMake(0,44+num, iPhone_width,iPhone_height-44-num-45);
            }else
            {
                _tableView.frame=CGRectMake(0,44+num, iPhone_width,iPhone_height-44-num-65);
            }
        }
        
        [_tableView reloadData];
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
        ghostView.message=@"网络请求失败，请您稍后再试";
        [ghostView show];
        
    }];
    [request startAsynchronous];
}

-(void)receiveASIRequestFinish:(NSData *)receData
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *resultStr=[[NSString alloc]initWithData:receData encoding:NSUTF8StringEncoding];
    
    if ([resultStr isEqualToString:@"please login"])
    {
        OtherLogin *other = [OtherLogin standerDefault];
        [other otherAreaLogin];
        return ;
    }
    
    NSArray *resultArray=[resultDic valueForKey:@"data"];
    
    if (resultArray) {
        
    }else
    {
        ghostView.message=@"亲，您暂时没有收藏任何职位~";
        [ghostView show];
        return;
    }
    
    NSLog(@"resultArray in JobSeeVC and receiveDataFinish is %@",resultArray);
    
    for (int i=0;i<[resultArray count];i++) {
        NSDictionary *dic=[resultArray objectAtIndex:i];
        PositionModel *positionmodel=[[PositionModel alloc]initWithDictionary:dic];
        [_dataArray addObject:positionmodel];
    }
    
    int num=ios7jj;
    
    if ([_dataArray count]==0){
        
        _tableView.frame=CGRectMake(0,44+num, iPhone_width,0);
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,60)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14];
        lab.backgroundColor=[UIColor clearColor];
        lab.text=@"亲，您暂时没有收藏任何职位~";
        [self.view addSubview:lab];
        
    }else
    {
        if (IOS7) {
            _tableView.frame=CGRectMake(0,44+num, iPhone_width,iPhone_height-44-num-45);
        }else
        {
            _tableView.frame=CGRectMake(0,44+num, iPhone_width,iPhone_height-44-num-65);
        }
    }
    
    [_tableView reloadData];
}

-(void)receiveASIRequestFail:(NSError *)error
{
    [loadView hide:YES];
    
    ghostView.message=@"网络请求失败，请您稍后再试";
    [ghostView show];
}

#pragma mark  UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        NSArray *views = [cell.contentView subviews];
        
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    //从数据源中取出数据
    PositionModel *position = [_dataArray objectAtIndex:indexPath.row];
    
    //职位名称
    UILabel *jobNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 150,20)];
    jobNameLab.backgroundColor = [UIColor clearColor];
    jobNameLab.textColor = RGBA(40, 100, 210, 1);
    jobNameLab.font = [UIFont boldSystemFontOfSize:14];
    
    //公司名称
    UILabel *companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 25, 170,20)];
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = [UIColor darkGrayColor];
    companyNameLab.font = [UIFont systemFontOfSize:12];
    
    //地区名称
    UILabel *cityLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, 100,20)];
    cityLab.backgroundColor = [UIColor clearColor];
    cityLab.textColor = [UIColor darkGrayColor];
    cityLab.font = [UIFont systemFontOfSize:12];
    
    //职位薪水
    UILabel *salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(165, 5, 80, 20)];
    salaryLab.backgroundColor = [UIColor clearColor];
    salaryLab.font = [UIFont systemFontOfSize:12];
    salaryLab.textColor=RGBA(255, 115, 4, 1);
    salaryLab.textAlignment = NSTextAlignmentRight;
    //效果招聘图标
    UIButton *salaryImgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    salaryImgbtn.frame = CGRectMake(255, 7, 40, 16);
    [salaryImgbtn setBackgroundImage:[UIImage imageNamed:@"ic_senior"] forState:UIControlStateNormal];
    [salaryLab setHidden:NO];
    if (![[NSString stringWithFormat:@"%@",position.issenior] isEqualToString:@"1"]) {
        [salaryLab setFrame:CGRectMake(210, 5, 80, 20)];
        salaryImgbtn.hidden = YES;
    }
    
    //发布日期
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(223, 45, 70, 20)];
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.font = [UIFont systemFontOfSize:12];
    
    
    jobNameLab.text=position.jobName;
    companyNameLab.text=position.companyName;
    cityLab.text = position.workArea;
    salaryLab.text=position.salary;
    dateLab.text=position.pubDate;
    
    myButton *collectBtn = [myButton buttonWithType:UIButtonTypeCustom];
    
    collectBtn.tag = indexPath.row;
    
    collectBtn.frame = CGRectMake(0,0,100,50);
    
    UIImageView* collectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,20,30,30)];
    
    collectImageView.tag=101;
    
    [collectBtn addSubview:collectImageView];
    
    if ([selectArray containsObject:position]) {
        
        collectImageView.image=[UIImage imageNamed:@"selectedjob.png"];
        
    }else
    {
        collectImageView.image=[UIImage imageNamed:@"noselectjob.png"];
    }
    
    [collectBtn addTarget:self action:@selector(collectionJob:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:collectBtn];
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantou.frame = CGRectMake(300, 15, 15, 15);
    
    if (position.isRead.integerValue==0) {
        
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"]
                           forState:UIControlStateNormal];
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"]
                           forState:UIControlStateHighlighted];
        
    }else
    {
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                           forState:UIControlStateNormal];
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                           forState:UIControlStateHighlighted];
    }
    
    [cell.contentView addSubview:jiantou];
    [cell.contentView addSubview:jobNameLab];
    [cell.contentView addSubview:companyNameLab];
    [cell.contentView addSubview:salaryLab];
    [cell.contentView addSubview:dateLab];
    [cell.contentView addSubview:cityLab];
    [cell.contentView addSubview:salaryImgbtn];
    
    if (!detail){   //处于简单状态下时
        
    }else
    {
        //处于详细状态时
        collectBtn.frame = CGRectMake(0,0,100,100);
        UIImageView* imageView=(UIImageView *)[collectBtn viewWithTag:101];
        
        imageView.frame=CGRectMake(5,35,30,30);
        jiantou.frame = CGRectMake(300,45,15, 15);
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,65,260,10)];
        detailLabel.backgroundColor=[UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        NSString *detailStr=[NSString stringWithFormat:@"%@|%@",position.degree,position.workExperience];
        NSLog(@"detailStr in JobSeeVC is %@",detailStr);
        detailLabel.text=detailStr;
        [cell.contentView addSubview:detailLabel];
        
        UILabel *requireLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,75,260,40)];
        requireLabel.numberOfLines=0;
        requireLabel.backgroundColor=[UIColor clearColor];
        requireLabel.textColor = [UIColor darkGrayColor];
        requireLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *requireStr=[NSString stringWithFormat:@"%@",position.required];
        NSLog(@"requireStr in JobSeeVC is %@",requireStr);
        requireLabel.text=requireStr;
        [cell.contentView addSubview:requireLabel];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!detail) {
        return 70;;
    }
    
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JobReaderDetailViewController * jobDetailVC = [[JobReaderDetailViewController alloc] init];
    jobDetailVC.delegate=self;
    jobDetailVC.dataArray=_dataArray;
    jobDetailVC.index=indexPath.row;
    [self.navigationController pushViewController:jobDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    
    return 0;
}

#pragma mark 按钮响应事件

-(void)postBtnClick:(id)sender
{
    NSLog(@"postBtn被点击了。。。。。");
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    NSString *canDeliver=[userDefaults valueForKey:@"canDeliver"];
    
    NSString *isComplete=[userDefaults valueForKey:@"isComplete"];
    
    /*
     1.isComplete是否存在，不存在说明是第一次登录，此时判断canDeliver是否为0，0表示能投递，1表示不能投递
     */
    
    if (isComplete||canDeliver.integerValue==0){
        
    }else
    {
        ghostView.message=@"请先完善简历";
        [ghostView show];
        return;
    }
    
    if ([selectArray count]==0){
        ghostView.message=@"请先选择职位再投递";
        [ghostView show];
        return;
    }
    
//    if ([selectArray count]>=3) {
//        
//        NSString *titleStr=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,确认投递吗?",[selectArray count],[selectArray count]];
//        
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.tag=10000;
//        [alertView show];
//        
//    }else
    {
        
        NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
        
        net=[[NetWorkConnection alloc]init];
        net.delegate=self;
        NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewJobDeliver);
        
        NSString *companyID=[self  getCompanyID:selectArray];
        
        NSLog(@"companyID in postResumeBtn is %@",companyID);
        
        NSString *jobID=[self getJobID:selectArray];
        
        NSLog(@"jobID in postResumeBtn is %@",jobID);
        
        NSString *cityCode=[self getCityCode:selectArray];
        NSLog(@"cityCode in postResumeBtn is %@",cityCode);
        
        NSString *nameStr=[userDefaults valueForKey:@"personName"];
        NSString *telephoneStr=[userDefaults valueForKey:@"user_tel"];
        
        NSString *workYearStr=[userDefaults valueForKey:@"mWorkYear"];
        
        NSLog(@"userName is %@\nworkYear is %@\ntelphone is %@",nameStr,telephoneStr,workYearStr);
        
        NSString *contentAllStr=@"";
        
        for (int i=0;i<[selectArray count];i++) {
            
            PositionModel *model=[selectArray objectAtIndex:i];
            
            NSString *contentStr=[NSString stringWithFormat:@"简历:%@,应聘职位:%@工作经验:%@,联系电话:%@。",nameStr,model.jobName,workYearStr,telephoneStr];
            
            
            contentAllStr=[contentAllStr stringByAppendingString:contentStr];
            
            if (i!=[selectArray count]-1) {
                
                contentAllStr =[contentAllStr stringByAppendingString:@"-"];
            }
        }
        
        NSLog(@"contentAllStr is %@",contentAllStr);
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",companyID,@"companyId",jobID,@"jobId",cityCode, @"localcity",contentAllStr,@"content",nil];
        
        
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        
        __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
        
        [request setCompletionBlock:^(){
            
            [loadView hide:YES];
            
            NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            if ([resultStr isEqualToString:@"please login"])
            {
                OtherLogin *other = [OtherLogin standerDefault];
                [other otherAreaLogin];
                return ;
            }
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"resultDic in requestTypePost and ReceiveData is %@",resultDic);
            
            NSString *errorStr=[resultDic valueForKey:@"error"];
            
            if (errorStr&&errorStr.integerValue==0) {
                
                ghostView.message=@"投递成功";
                [ghostView show];
                
            }
//            else if(errorStr.integerValue==1)
//            {
//                NSString *num=[resultDic valueForKey:@"moneys"];
//                
//                NSString *title=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,您目前有%@个才币,不够支付哦,快去赚才币吧",[selectArray count],[selectArray count],num];
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.tag=101;
//                [alert show];
//                
//            }
            else
            {
                ghostView.message=@"投递失败";
                [ghostView show];
            }
            
            [self setPositionChoice];
        }];
        
        
        [request setFailedBlock:^(){
            
            [loadView hide:YES];
            ghostView.message=@"投递失败";
            [ghostView show];
            
            [self setPositionChoice];
        }];
        
        [request startAsynchronous];
    }
}

-(void)detailVC:(id)sender
{
    
    NSLog(@"明细按钮被点击了。。。。。");
    
    myButton *btn=(myButton *)sender;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    detail=!detail;
    
    if (!detail){
        detailLab.text = @"明细";
        imageView.image=[UIImage imageNamed:@"mingxi.png"];
    }else
    {
        detailLab.text = @"列表";
        imageView.image=[UIImage imageNamed:@"mingxi2.png"];
    }
    
    [_tableView reloadData];
}

-(void)collectionJob:(id)sender
{
    NSLog(@"收藏按钮被点击");
    myButton *btn=(myButton *)sender;
    btn.isClicked=!btn.isClicked;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    PositionModel *model=[_dataArray objectAtIndex:btn.tag];
    
    if ([selectArray containsObject:model]){
        [selectArray removeObject:model];
        
        imageView.image=[UIImage imageNamed:@"noselectjob.png"];
    }else
    {
        if ([selectArray count]>=10) {
            
            ghostView.message=@"一次最多可以投递10个职位";
            [ghostView show];
            return;
        }
        
        [selectArray addObject:model];
        imageView.image=[UIImage imageNamed:@"selectedjob.png"];
    }
    
    
    if ([selectArray count]!=0) {
        
        postBtn2.alpha=1;
        
    }else
    {
        postBtn2.alpha=0;
    }
    
    NSString *count=[NSString stringWithFormat:@"%d",[selectArray count]];
    
    [postBtn2 setTitle:count forState:UIControlStateNormal];
}
#pragma mark  职位投递时用的方法
//得到公司ID字符串
-(NSString *)getCompanyID:(NSMutableArray *)array
{
    
    NSString *str=[[NSString alloc]init];
    
    for (int i=0;i<[array count];i++) {
        
        PositionModel *model=[array objectAtIndex:i];
        
        if(i==[array count]-1)
        {
            str =[str stringByAppendingString:model.companyId];
            
        }else
        {
            str =[str stringByAppendingString:model.companyId];
            str=[str stringByAppendingString:@"-"];
        }
    }
    return str;
}


//得到职位ID字符串
-(NSString*)getJobID:(NSMutableArray *)array
{
    NSString *str=[[NSString alloc]init];
    
    for (int i=0;i<[array count];i++)
    {
        PositionModel *positionmodel=[array objectAtIndex:i];
        
        
        if (i!=[array count]-1) {
            NSString *subStr=[NSString stringWithFormat:@"%@",positionmodel.postId];
            
            str=[str stringByAppendingString:subStr];
            
            str=[str stringByAppendingString:@"-"];
            
            
        }else
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",positionmodel.postId];
            
            str=[str stringByAppendingString:subStr];
            
        }
    }
    
    return str;
}

//得到工作城市代码字符串
-(NSString*)getCityCode:(NSMutableArray *)array
{
    NSString *str=[[NSString alloc]init];
    
    for (int i=0;i<[array count];i++) {
        
        PositionModel *model=[array objectAtIndex:i];
        
        if(i==[array count]-1)
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",model.workAreaCode];
            str =[str stringByAppendingString:subStr];
        }else
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",model.workAreaCode];
            str =[str stringByAppendingString:subStr];
            str=[str stringByAppendingString:@"-"];
        }
    }
    return str;
}

#pragma mark UIAlertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag!=101) {
        
        if (buttonIndex==1) {
            
            NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
            
            net=[[NetWorkConnection alloc]init];
            net.delegate=self;
            NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewJobDeliver);
            
            NSString *companyID=[self  getCompanyID:selectArray];
            
            NSLog(@"companyID in postResumeBtn is %@",companyID);
            
            NSString *jobID=[self getJobID:selectArray];
            
            NSLog(@"jobID in postResumeBtn is %@",jobID);
            
            NSString *cityCode=[self getCityCode:selectArray];
            NSLog(@"cityCode in postResumeBtn is %@",cityCode);
            
            
            NSString *nameStr=[userDefaults valueForKey:@"personName"];
            NSString *telephoneStr=[userDefaults valueForKey:@"user_tel"];
            NSString *workYearStr=[userDefaults valueForKey:@"mWorkYear"];
            
            NSLog(@"userName is %@\nworkYear is %@\ntelphone is %@",nameStr,telephoneStr,workYearStr);
            
            NSString *contentAllStr=@"";
            
            for (int i=0;i<[selectArray count];i++) {
                
                PositionModel *model=[selectArray objectAtIndex:i];
                
                NSString *contentStr=[NSString stringWithFormat:@"简历:%@,应聘职位:%@工作经验:%@,联系电话:%@。",nameStr,model.jobName,workYearStr,telephoneStr];
                
                
                contentAllStr=[contentAllStr stringByAppendingString:contentStr];
                
                if (i!=[selectArray count]-1) {
                    
                    contentAllStr =[contentAllStr stringByAppendingString:@"-"];
                }
            }
            
            NSLog(@"contentAllStr is %@",contentAllStr);
            
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",companyID,@"companyId",jobID,@"jobId",cityCode, @"localcity",contentAllStr,@"content",nil];
            
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
            
            [request setCompletionBlock:^(){
                
                [loadView hide:YES];
                
                NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
                
                if ([resultStr isEqualToString:@"please login"])
                {
                    
                    OtherLogin *other = [OtherLogin standerDefault];
                    [other otherAreaLogin];
                    return ;
                }
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"resultDic in requestTypePost and ReceiveData is %@",resultDic);
                
                NSString *errorStr=[resultDic valueForKey:@"error"];
                
                if (errorStr&&errorStr.integerValue==0) {
                    
                    ghostView.message=@"投递成功";
                    [ghostView show];
                    
                }
//                else if(errorStr.integerValue==1)
//                {
//                    
//                    NSString *num=[resultDic valueForKey:@"moneys"];
//                    
//                    NSString *title=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,您目前有%@个才币,不够支付哦,快去赚才币吧",[selectArray count],[selectArray count],num];
//                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    alert.tag=101;
//                    [alert show];
//                    
//                }
                else
                {
                    ghostView.message=@"投递失败";
                    [ghostView show];
                }
                [self setPositionChoice];
            }];
            
            [request setFailedBlock:^(){
                
                [loadView hide:YES];
                ghostView.message=@"投递失败";
                [ghostView show];
                [self setPositionChoice];
            }];
            
            [request startAsynchronous];
        }
    }else
    {
        
        if (buttonIndex==1){
          
        }
        
    }
}

-(void)jobReaderDetailVC
{
    [_tableView reloadData];
}

-(void)setPositionChoice
{
    if ([selectArray count]!=0) {
        [selectArray removeAllObjects];
        [_tableView reloadData];
        [postBtn2 setTitle:@"" forState:UIControlStateNormal];
        postBtn2.alpha=0;
    }else
    {
        [_tableView reloadData];
        [postBtn2 setTitle:@"" forState:UIControlStateNormal];
        postBtn2.alpha=0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
