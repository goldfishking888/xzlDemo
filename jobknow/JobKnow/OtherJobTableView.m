//
//  OtherJobTableView.m
//  JobKnow
//
//  Created by faxin sun on 13-3-8.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "OtherJobTableView.h"
#import "MyButton.h"
#import "PositionModel.h"
#import "EGORefreshTableFooterView.h"
#import "JobReaderDetailViewController.h"
@implementation OtherJobTableView
@synthesize refreshFooterView;
@synthesize myTableView;
@synthesize isJianzhi;
@synthesize detail;

- (id)initWithFrame:(CGRect)frame withModel:(PositionModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        num=ios7jj;
        
        reloading=NO;
        
        _page=1;
        
        _dataArray=[[NSMutableArray alloc]init];
        
        _selectArray=[[NSMutableArray alloc]init];
        
        _positionInfo=model;
        
        if (IOS7) {
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-44-45-num) style:UITableViewStyleGrouped];
        }else
        {
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-44-65-num) style:UITableViewStylePlain];
        }
        myTableView.backgroundColor=XZHILBJ_colour;
        myTableView.backgroundView=nil;
        myTableView.delegate=self;
        myTableView.dataSource=self;
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
        if (_otherDic!=nil) {
            NSString *countStr =[_otherDic valueForKey:@"allCounts"];
            
            NSLog(@"allCounts is %ld",(long)countStr.integerValue);
            
            NSInteger pageNumber =countStr.integerValue/20+1;
            NSLog(@"pageNumber is %ld",(long)pageNumber);
            NSString *allCountStr=[NSString stringWithFormat:@"%ld/%ld页",(long)_page,(long)pageNumber];
            [_refreshFooterView refreshLastUpdatedDate:allCountStr];
        }
        
        
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
    
    NSString *url = kCombineURL(KXZhiLiaoAPI,kNewOtherJobs);
    if (_isNewAPI) {
        url = kCombineURL(KWWWXZhiLiaoAPI,kWWWNewOtherJobs);;
    }
    NSDictionary *paramDic;
    
    if (isJianzhi) {
        
        paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_positionInfo.postId,@"pid",_positionInfo.companyId,@"cid",@"1",@"type",_cityCodeStr,@"localcity",pageStr,@"page",nil];
    }else
    {
        paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_positionInfo.postId,@"pid",_positionInfo.companyId,@"cid",@"0",@"type",_positionInfo.workAreaCode,@"localcity",pageStr,@"page",nil];
    }
    
//    [_net requestCache:url param:paramDic];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        //        NSLog(@"简历列表下载成功");
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"resultDic is %@",resultDic);
        
        NSArray *arr=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];
        if ((_isNewAPI)) {
            NSMutableDictionary * dics = [resultDic valueForKey:@"data"];
            arr=[dics valueForKey:@"data"];
            allCount = [NSString stringWithFormat:@"%@",[dics valueForKey:@"allCounts"]];
        }
        
        for (int i=0;i<[arr count];i++) {
            NSDictionary *dic=[arr objectAtIndex:i];
            
            PositionModel *model=[[PositionModel alloc]initWithDictionary:dic];
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
//        reloading = NO;
        ghostView.message=@"下载失败";
        [ghostView show];
        
    }];
    [request startAsynchronous];

    
    reloading=YES;
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
    PositionModel *position = [_dataArray objectAtIndex:indexPath.row];

    
    //职位名称
    UILabel *jobNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 145,20)];
    jobNameLab.backgroundColor = [UIColor clearColor];
    jobNameLab.textColor = RGBA(40, 100, 210, 1);
    jobNameLab.font = [UIFont boldSystemFontOfSize:14];
    
    //公司名称
    UILabel *companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 25, 170,20)];
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = [UIColor darkGrayColor];
    companyNameLab.font = [UIFont systemFontOfSize:12];
    
    if (isJianzhi) {
        jobNameLab.frame=CGRectMake(10,5,200,20);
        companyNameLab.frame=CGRectMake(10,25,190,20);
    }
    
    //地区名称
    UILabel *cityLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, 100,20)];
    cityLab.backgroundColor = [UIColor clearColor];
    cityLab.textColor = [UIColor darkGrayColor];
    cityLab.font = [UIFont systemFontOfSize:12];
    
    //职位薪水
    UILabel *salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(168, 5, 80, 20)];
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
        [salaryLab setFrame:CGRectMake(213, 5, 80, 20)];
        salaryImgbtn.hidden = YES;
    }

    
    //发布日期
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(223, 45, 70, 20)];
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
    salaryLab.text= [NSString stringWithFormat:@"%@",position.salary];//position.salary;
    dateLab.text=position.pubDate;
    
    //调整button上标题的位置
    
    if (!isJianzhi){
        
        collectBtn = [myButton buttonWithType:UIButtonTypeCustom];
        
        collectBtn.tag = indexPath.row;
        
        collectBtn.frame = CGRectMake(0,0,100,50);
        
        UIImageView* collectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,20,30,30)];
        
        collectImageView.tag=101;
        
        [collectBtn addSubview:collectImageView];
        
        if ([_selectArray containsObject:position]) {
            
            collectImageView.image=[UIImage imageNamed:@"selectedjob.png"];
            
        }else
        {
            collectImageView.image=[UIImage imageNamed:@"noselectjob.png"];
        }
        
        [collectBtn addTarget:self action:@selector(collectionJob:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:collectBtn];
    }
    
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
        
        NSLog(@"position.degree is %@",position.degree);
        
        if ([position.degree isEqualToString:@""]) {
            position.degree=@"不限";
        }
        
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
    
    PositionModel *model=[_dataArray objectAtIndex:indexPath.row];
    
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


#pragma mark
-(void)collectionJob:(id)sender
{
    myButton *btn=(myButton *)sender;
    
    btn.isClicked=!btn.isClicked;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    PositionModel *model=[_dataArray objectAtIndex:btn.tag];
    
    if ([_selectArray containsObject:model]){
        [_selectArray removeObject:model];
        
        imageView.image=[UIImage imageNamed:@"noselectjob.png"];
    }else
    {
        if ([_selectArray count]>=10) {
            
            ghostView.message=@"一次最多可以投递10个职位";
            [ghostView show];
            return;
        }
        
        [_selectArray addObject:model];
        imageView.image=[UIImage imageNamed:@"selectedjob.png"];
    }
    
    NSString *count=[NSString stringWithFormat:@"%d",[_selectArray count]];
    
    [_otherDelegate changePostBtn:count];
}

@end
