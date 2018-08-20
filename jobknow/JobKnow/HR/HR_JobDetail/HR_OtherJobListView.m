
//
//  HR_OtherJobListView.m
//  JobKnow
//
//  Created by Suny on 15/8/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_OtherJobListView.h"
#import "HRHomeIntroduceModel.h"
#import "EGORefreshTableFooterView.h"
#import "JobReaderDetailViewController.h"

#define cell_index_space 14

#define cell_inner_space 20

@implementation HR_OtherJobListView
@synthesize refreshFooterView;
@synthesize myTableView;
@synthesize isJianzhi;
@synthesize detail;

- (id)initWithFrame:(CGRect)frame withModel:(HRHomeIntroduceModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        num=ios7jj;
        
        reloading=NO;
        
        _page=1;
        
        _dataArray=[[NSMutableArray alloc]init];
        
        _selectArray=[[NSMutableArray alloc]init];
        
        _positionInfo=model;
        
        if (ISIOS7) {
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-44-45-num) style:UITableViewStylePlain];
        }else
        {
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-44-65-num) style:UITableViewStylePlain];
        }
        myTableView.backgroundColor=XZHILBJ_colour;
        myTableView.backgroundView=nil;
        myTableView.delegate=self;
        myTableView.dataSource=self;
        
//        UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myTableView.frame.size.width, 30)];
//        [viewHead setBackgroundColor:[UIColor clearColor]];
//        RTLabel *label_rec =  [[RTLabel alloc] initWithFrame:CGRectMake(cell_index_space,5,iPhone_width - 150,20)];
//        [label_rec setBackgroundColor:[UIColor clearColor]];
//        label_rec.font = [UIFont systemFontOfSize:14];
//        label_rec.backgroundColor = [UIColor clearColor];
//        NSString *salaryStr=[NSString stringWithFormat:@"%@：<font color='#f76806'>%@</font> 条",@"其他职位:",[_otherDic valueForKey:@"allCounts"]];
//        label_rec.text=salaryStr;
//        [viewHead addSubview:label_rec];
//        myTableView.tableHeaderView = viewHead;
        [self addSubview:myTableView];
        
        [self setFooterView];
        
        ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1.5 dismissible:YES];
        ghostView.position=OLGhostAlertViewPositionCenter;
    }
    return self;
}

-(void)setFooterView
{
    NSLog(@"setFooterView执行到了");
    
    CGFloat height=MAX(myTableView.contentSize.height,myTableView.bounds.size.height);
    
    if (_refreshFooterView &&[_refreshFooterView superview]) {
        
        _refreshFooterView.frame=CGRectMake(0.0f,height,myTableView.frame.size.width,myTableView.bounds.size.height);
    }else
    {
        
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         myTableView.frame.size.width,myTableView.frame.size.height)];
        _refreshFooterView.delegate = self;
        [myTableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        
        NSString *countStr =[_otherDic valueForKey:@"allCounts"];
        
        NSLog(@"allCounts is %@",countStr);
        
        NSInteger pageNumber =countStr.integerValue/20+1;
        NSLog(@"pageNumber is %d",pageNumber);
        NSString *allCountStr=[NSString stringWithFormat:@"%d/%d页",_page,pageNumber];
        [_refreshFooterView refreshLastUpdatedDate:allCountStr];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView &&[_refreshFooterView superview]) {
        
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView =nil;
}

#pragma mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark EGORefresh代理方法实现

#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    return reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    return [NSDate date];
}

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    if(aRefreshPos == EGORefreshFooter){
        [self performSelector:@selector(getNextPageView) withObject:self afterDelay:2];
    }
}

-(void)getNextPageView
{
    _page++;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",_page];
    
    NSLog(@"下拉刷新方法实现了。。。");
    
    _net=[[NetWorkConnection alloc]init];
    
    _net.delegate=self;
    //http://www.xzhiliao.com/api/company_job?page=1&localcity=2012&pid=3358582&cid=46973132012&type=0&version=3.2.1&userToken=71c517f9c9735244281335a7ad7bdcd9&userImei=868433027181654

    NSString *url = kCombineURL(KWWWXZhiLiaoAPI,kWWWNewOtherJobs);
    
    NSDictionary *paramDic;
    
    if (isJianzhi) {
        
//        paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",_positionInfo.postId,@"cid",@"1",@"type",_cityCodeStr,@"localcity",pageStr,@"page",kUserTokenStr,@"userToken",nil];
        paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"3",@"role",_positionInfo.postId,@"cid",_positionInfo.postId,@"pid",_cityCodeStr,@"localcity",IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    }else
    {
         paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"3",@"role",_positionInfo.postId,@"cid",_positionInfo.postId,@"pid",_cityCodeStr,@"localcity",IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    }
    
//    [_net requestCache:url param:paramDic];
//    [_net sendRequestURLStr:url ParamDic:paramDic Method:@"GET"];
     NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
//        [loadView hide:YES];
        NSError *error;
        
        //        NSLog(@"简历列表下载成功");
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        
        NSArray *arr=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];
        
        for (int i=0;i<[arr count];i++) {
            NSDictionary *dic=[arr objectAtIndex:i];
            
            HRHomeIntroduceModel *model=[[HRHomeIntroduceModel alloc]initWithDictionary:dic];
            
            [_dataArray addObject:model];
        }
        
        reloading=NO;
        
        [myTableView reloadData];
        
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
        
        if ([arr count]!=20) {
            [self removeFooterView];
            ghostView.message=@"主人，已为您加载所有职位!";
            [ghostView show];
        }else
        {
            [self setFooterView];
        }

        
        
    }];
    [request setFailedBlock:^{
//        [loadView hide:YES];
        reloading = NO;
        ghostView.message=@"网络请求失败";
        [ghostView show];
        
    }];
    [request startAsynchronous];
}




#pragma mark UITableView代理方法的实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    HRHomeIntroduceModel *position = [_dataArray objectAtIndex:indexPath.row];
    
    //职位名称
    UILabel *jobNameLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 5, 180,20)];
    jobNameLab.backgroundColor = [UIColor clearColor];
    jobNameLab.textColor = RGBA(40, 100, 210, 1);
    jobNameLab.font = [UIFont boldSystemFontOfSize:14];
    
    //公司名称
    UILabel *companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 25, 170,20)];
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = [UIColor darkGrayColor];
    companyNameLab.font = [UIFont systemFontOfSize:12];
    
    //地区名称
    UILabel *cityLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 45, 100,20)];
    cityLab.backgroundColor = [UIColor clearColor];
    cityLab.textColor = [UIColor darkGrayColor];
    cityLab.font = [UIFont systemFontOfSize:12];
    
    if (isJianzhi) {
        jobNameLab.frame=CGRectMake(10,5,200,20);
        companyNameLab.frame=CGRectMake(10,25,190,20);
    }
    
    //职位薪水
    UILabel *salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width-35-70-10-45, 5, 80, 20)];
    salaryLab.backgroundColor = [UIColor clearColor];
    salaryLab.font = [UIFont systemFontOfSize:12];
    salaryLab.textColor=RGBA(255, 115, 4, 1);
    salaryLab.textAlignment = NSTextAlignmentRight;
    //效果招聘图标
    UIButton *salaryImgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    salaryImgbtn.frame = CGRectMake(iPhone_width-70, 5, 40, 16);
    [salaryImgbtn setBackgroundImage:[UIImage imageNamed:@"ic_senior"] forState:UIControlStateNormal];
    [salaryLab setHidden:NO];

//    if ([position.senior_type isEqualToString:@"1"]) {
//        [salaryImgbtn setBackgroundImage:[UIImage imageNamed:@"icon_pay_resume"] forState:UIControlStateNormal];
//        [salaryLab setHidden:YES];
//    }else{
//        [salaryImgbtn setBackgroundImage:[UIImage imageNamed:@"ic_senior"] forState:UIControlStateNormal];
//        [salaryLab setHidden:NO];
//    }
    
    //发布日期
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width-35-70-10, 45, 70, 20)];
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.font = [UIFont systemFontOfSize:12];
    
    
    if (isJianzhi) {
        salaryLab.frame=CGRectMake(208, 25, 80, 20);
        dateLab.frame=CGRectMake(218, 5, 70, 20);
    }
    
    jobNameLab.text=position.jobName;
    companyNameLab.text=position.companyName;
    cityLab.text = position.workArea;
    salaryLab.text=[NSString stringWithFormat:@"%@",position.newfee];
    dateLab.text=position.pubDate;
    
    //调整button上标题的位置
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantou.frame = CGRectMake(iPhone_width-20-15, 27, 15, 15);
    
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
    [cell.contentView addSubview:cityLab];
    [cell.contentView addSubview:salaryLab];
    [cell.contentView addSubview:dateLab];
    [cell.contentView addSubview:salaryImgbtn];
    
    if (!detail){   //处于简单状态下时
        
    }else
    {
        //处于详细状态时
        
        jiantou.frame = CGRectMake(300,48,15, 15);
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell_index_space,65,260,10)];
        detailLabel.backgroundColor=[UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        
        NSLog(@"position.degree is %@",position.degree);
        
        if ([position.degree isEqualToString:@""]) {
            position.degree=@"不限";
        }
        
        NSString *detailStr=[NSString stringWithFormat:@"%@|%@",position.degree,position.workExperience];
        NSLog(@"detailStr in JobSeeVC is %@",detailStr);
        detailLabel.text=detailStr;
        [cell.contentView addSubview:detailLabel];
        
        UILabel *requireLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell_index_space,72,260,40)];
        requireLabel.numberOfLines=0;
        requireLabel.backgroundColor=[UIColor clearColor];
        requireLabel.textColor = [UIColor darkGrayColor];
        requireLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *requireStr=[NSString stringWithFormat:@"%@",position.required];
        NSLog(@"requireStr in JobSeeVC is %@",requireStr);
        requireLabel.text=requireStr;
        [cell.contentView addSubview:requireLabel];
        
        if (isJianzhi) {
            detailLabel.frame=CGRectMake(10,45,260,10);
            requireLabel.frame=CGRectMake(10,52,260,40);
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HRHomeIntroduceModel *model=[_dataArray objectAtIndex:indexPath.row];
    
    if (model.isRead&&model.isRead.integerValue==0) {
        model.isRead=@"1";
    }
    
    NSLog(@"isJianzhi in OtherJobView is %d",isJianzhi);
    
    [_otherDelegate  checkOtherJob:_dataArray otherIndex:indexPath.row AndJianzhi:isJianzhi];
    
    [myTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!detail) {
        return 70;
    }
    
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    
    return 0;
}

#pragma mark SendRequest代理方法实现
-(void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"resultDic is %@",resultDic);
    
    NSArray *arr=[resultDic valueForKey:@"data"];
    
    allCount=[resultDic valueForKey:@"allCounts"];
    
    for (int i=0;i<[arr count];i++) {
        NSDictionary *dic=[arr objectAtIndex:i];
        
        HRHomeIntroduceModel *model=[[HRHomeIntroduceModel alloc]initWithDictionary:dic];
        
        [_dataArray addObject:model];
    }
    
    reloading=NO;
    
    [myTableView reloadData];
    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
    
    if ([arr count]!=20) {
        [self removeFooterView];
        ghostView.message=@"主人，已为您加载所有职位!";
        [ghostView show];
    }else
    {
        [self setFooterView];
    }
}

- (void)receiveRequestFail:(NSError *)error
{
    ghostView.message=@"下载失败";
    [ghostView show];
}

//#pragma mark-
//-(void)collectionJob:(id)sender
//{
//    myButton *btn=(myButton *)sender;
//    
//    btn.isClicked=!btn.isClicked;
//    
//    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
//    
//    HRHomeIntroduceModel *model=[_dataArray objectAtIndex:btn.tag];
//    
//    if ([_selectArray containsObject:model]){
//        [_selectArray removeObject:model];
//        
//        imageView.image=[UIImage imageNamed:@"noselectjob.png"];
//    }else
//    {
//        if ([_selectArray count]>=10) {
//            
//            ghostView.message=@"一次最多可以投递10个职位";
//            [ghostView show];
//            return;
//        }
//        
//        [_selectArray addObject:model];
//        imageView.image=[UIImage imageNamed:@"selectedjob.png"];
//    }
//    
//    NSString *count=[NSString stringWithFormat:@"%d",[_selectArray count]];
//    
//    [_otherDelegate changePostBtn:count];
//}

@end
