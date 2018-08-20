//
//  DetailView.m
//  JobKnow
//
//  Created by Zuo on 14-2-11.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "DetailView.h"
#import "jobRead.h"
#import "ReadTableView.h"
#import "allCityViewController.h"
#import "PositionsViewController.h"
#import "WorkDetailViewController.h"
#import "ScanningViewController.h"
#import "SelectDetailViewController.h"
#import "OtherLogin.h"

#import "GRReadModel.h"

#define kHeaderHeight 369


@implementation DetailView

@synthesize isEmpty;

@synthesize tableView=_tableView;

@synthesize scrollView=_scrollView;

- (void)initData
{
    num=ios7jj;
    
    isEmpty=NO;
    
    db=[UserDatabase sharedInstance];
    
    _dataArray=(NSMutableArray *)[GRBookerModel findAll];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    selectListArray = [NSArray arrayWithObjects:@"职位名称",@"地区",@"行业",@"待遇",nil];
    
    if(![userDefaults valueForKey:@"bookCity"]){
    
        NSDictionary *bookCityDic=[[NSDictionary alloc]init];
        [userDefaults setObject:bookCityDic forKey:@"bookCity"];
    }
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    self.backgroundColor=XZhiL_colour2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        
        [self initData];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,kMainScreenWidth, self.frame.size.height)];
        _scrollView.bounces=YES ;
        _scrollView.pagingEnabled=NO;
        _scrollView.backgroundColor = RGB(247, 247, 247);
        [self addSubview:_scrollView];
        
        _readTV=[[ReadTableView alloc]initWithFrame:CGRectMake(0,120,iPhone_width,200)];
        _readTV.isAlter = NO;
        _readTV.readDelegate=self;
        [_readTV reloadData];
        
        if ([_readTV.dataArray count]==0) {
            _readTV.alpha=0;
        }else
        {
            _readTV.alpha=1;
        }
        
        NSInteger tableViewHeight=_dataArray>0?_dataArray.count*70+71:0;

            
        _readTV.frame=CGRectMake(0,371,kMainScreenWidth,tableViewHeight);
            
            
        _scrollView.contentSize=CGSizeMake(kMainScreenWidth,371+tableViewHeight);
        
        [_scrollView addSubview:_readTV];
        
        
        //detailView的标题
        
        UILabel *labelHead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
        
        labelHead.text = @"我们将根据您的需求每日推送最新职位";
        labelHead.textColor = RGB(74, 74, 74);
        labelHead.textAlignment = NSTextAlignmentCenter;
        labelHead.font = [UIFont systemFontOfSize:14];
        labelHead.backgroundColor = [UIColor whiteColor];
        
        

        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0,56,kMainScreenWidth,200)];

        
        _tableView.bounces=NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView=nil;
        _tableView.backgroundColor=XZhiL_colour2;
        [_scrollView addSubview: _tableView];

        [_scrollView addSubview:labelHead];
        
        UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 256, kMainScreenWidth, 113)];
        viewFooter.backgroundColor = [UIColor whiteColor];
        
        //订阅按钮
        UIButton *readBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        CGRect r = CGRectMake(kMainScreenWidth*(1-319.0f/375.0f)/2,38,319.0f/375.0f*kMainScreenWidth,44);
        readBtn.frame=r;
        readBtn.backgroundColor=[UIColor clearColor];
        [readBtn setTitle:@"确定" forState:UIControlStateNormal];
        [readBtn setTitle:@"确定" forState:UIControlStateHighlighted];
        [readBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
        [readBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
        [readBtn addTarget:self action:@selector(readBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:viewFooter];
        [viewFooter addSubview:readBtn];

    }
    
    return self;
}


#pragma mark- 职位名称TF
-(UITextField *)jobTextField{
    if (_jobTextField == nil) {
        //输入框
        _jobTextField = [[UITextField alloc]init];
        _jobTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _jobTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _jobTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        mViewBorderRadius(_jobTextField, 16, 1, [UIColor clearColor]);
        _jobTextField.backgroundColor = RGB(239, 239, 239);
        UIView *view_tf_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
        view_tf_left.backgroundColor = [UIColor clearColor];
        _jobTextField.leftView = view_tf_left;
        _jobTextField.leftViewMode = UITextFieldViewModeAlways;
        _jobTextField.borderStyle = UITextBorderStyleNone;
        _jobTextField.placeholder=@"请输入关键字";
        _jobTextField.frame=CGRectMake(116,8,kMainScreenWidth-116-25,32);
        _jobTextField.font = [UIFont systemFontOfSize:14];
        _jobTextField.returnKeyType = UIReturnKeyDone;
        _jobTextField.delegate = self;
        _jobTextField.text = @"";
        _jobTextField.tag = 54321;
    }
    return  _jobTextField;
}

#pragma mark 清空关键字按钮

- (void)deleteBtnClick:(id)sender
{
    NSLog(@"清空按钮被点击了。。。");
    
    _jobTextField.text=@"";
    
    SaveJob *save=[SaveJob standardDefault];
    
    [save.saveArr removeAllObjects];
    
    [[save.positionArr objectAtIndex:1]removeAllObjects] ;
    
    [[save.positionArr objectAtIndex:2]removeAllObjects] ;
    
    [save.jobDic removeAllObjects];
    
    [_tableView reloadData];
}

#pragma mark 订阅按钮响应事件

- (void)readBtnClick2:(id)sender{
    
    SaveJob *save=[SaveJob standardDefault];
    NSString *industryStr=[save industry];
    NSString *industryCodeStr=[save industryCode];
    CityInfo *cityInfo=[CityInfo standerDefault];
    //待遇
    jobRead*salary=[save.positionArr objectAtIndex:3];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjEzOTAzZjVmN2M2NTU1ZjI4NDg3Yjc2YzQ4YTNkY2NiY2FmYzg4MmI0MTgyMDYzMGE5YjcyYTMyMzdlMTkyMmM3ZDc3MWNkM2ZhNzBhYjA2In0.eyJhdWQiOiIyIiwianRpIjoiMTM5MDNmNWY3YzY1NTVmMjg0ODdiNzZjNDhhM2RjY2JjYWZjODgyYjQxODIwNjMwYTliNzJhMzIzN2UxOTIyYzdkNzcxY2QzZmE3MGFiMDYiLCJpYXQiOjE1MDIyNDQ5OTIsIm5iZiI6MTUwMjI0NDk5MiwiZXhwIjoxODE3Nzc3NzkyLCJzdWIiOiIxMCIsInNjb3BlcyI6W119.EHmVbD2Zn1VifZDYbSz1Sn79ljPz8NaJ5MKUuZavPS5ZI_5Mqglar0p9zuY-1_kKjKPt44sUXHxo-G3XjzP6jP2YXOP-vguuA6X9MdUnZJvL3vVAQ8Rl-DNgiFEU8I0oAvop-r9tIUHP3rLtkxkSs5wGnys4JYJETQzSDBA3UbpboGQIQT_rgJiowaxzof3gzitudAhUtuGfnsdFbXBb9zMOq1Jz9DffJbA5FaEvD-V4A43hNRYlK6LgYd8bH-ui4EmjNqICA8aiR0YIGl21hDERk-SWEXvSQFG755NcBfF1sY6OrMO3Q6LkOS2Wzg4FOI7Hk5LGZnVGSWBYNkg__feRrvyRpNDfoCHrOv_m3rQFw1ZIiv1JGtLj8n849gTFQnbuHKcbKGEeXwlb7TPeIs0eF59Mx9jOWqCu7fjFExe6YnosL9ci_AtCXxyDXfD29wg7vEllP74PRxiI2fmR6n8hF9WHvzmfsCC8iQi_pwsj0wypopClfB8BhTIBPS2VZJFxau-WmCSaUn3ux0nQAI5J66x6VAbMqdN3tHi6C2n5sdq5HRO1nlfNVp9lZiutQnNs91C5CSb7ElfXWWwqiWpcScH7bRllf_-EInjh4HDjI2GmZju-2P0qqQu3zau7Ft32aXDs8jHqlEnHVkRukawEeYpxIlK_OaBh46wXxig";
    [paramDic setValue:tokenStr forKey:@"token"];
//    [paramDic setValue:self.jobTextField.text forKey:@"position_name"];
//    [paramDic setValue:industryCodeStr forKey:@"trade"];//手机企业没有
//    [paramDic setValue:cityInfo.cityCode forKey:@"area"];//4表示企业
//    [paramDic setValue:salary.code forKey:@"salary"];//
    [paramDic setValue:@"PHP" forKey:@"position_name"];
    [paramDic setValue:@"1100" forKey:@"trade"];//手机企业没有
    [paramDic setValue:@"2012" forKey:@"area"];//4表示企业
    [paramDic setValue:@"13" forKey:@"salary"];//
    NSLog(@"paramDic is %@",paramDic);
    //    NSDictionary *params = @{@"mobile":_phoneTF.text,@"captcha":_verifyCodeTF.text,@"version":[XZLUtil currentVersion]};
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/subscribe/create"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                GRBookerModel *model = [GRBookerModel getBookerModelWithDic:dataDic];
                [model saveOrUpdate];
                [self setScreen];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];

}

//- (void)readBtnClick:(id)sender
//{
//    /*
//     1.判断是否联网
//     2.判断行业和职业是否为空
//     3.判断城市：(1)订阅的城市个数是否已经超过3个。(3)每个城市的订阅器个数是否已经超过3个
//     4.以上3条都符合的时候发送订阅请求
//     */
//    
//    NSLog(@"订阅按钮被点击了");
//    
//    SaveJob *save=[SaveJob standardDefault];
//    
//    /***判断是否联网***/
//    Net *n=[Net standerDefault];
//    
//    if (n.status ==NotReachable) {
//        ghostView.message=@"无网络连接,请检查您的网络!";
//        [ghostView show];
//        [self removeAllObjectsData];
//        [_tableView reloadData];
//        return;
//    }
//    
//    /***判断行业是否为空***/
//    
//    NSArray *tradeArray = [save.positionArr objectAtIndex:1];
//    
//    NSLog(@"tradeArray is %@",tradeArray);
//    
//    NSLog(@"[tradeArray count] is %d",[tradeArray count]);
//    
//    if ([tradeArray count]==0){
//        ghostView.message=@"行业不能为空哦!";
//        [ghostView show];
//        return;
//    }
//    
//    /***判断职业是否为空***/
//    
//    NSArray *positionArray = [save.positionArr objectAtIndex:2];
//    
//    if ([positionArray count]==0) {
//
//        ghostView.message=@"职业不能为空哦!";
//        [ghostView show];
//        return;
//    }
//    
//    /**
//     (1)每次订阅之前都应该看一下已经订阅了几个城市。
//     (2)
//     如果已经订阅了超过3个城市,那么应该提示用户不能再订阅新的城市。
//     (3)如果没有超过3个城市，判断当前选择的城市是否已经订阅，如果订阅，就在当前城市订阅数上加1。
//     (4)如果当前选择的城市之前没有被订阅，添加到已经订阅的城市数组中去，并且在该城市的订阅数上加1。
//     **/
//    
//    CityInfo *cityInfo=[CityInfo standerDefault];
//    
//    /******************判断订阅城市数量以及每个城市的订阅器数量*******************/
//    NSDictionary *bookCityDic=[userDefaults valueForKey:@"bookCity"];
//    
//    NSLog(@"bookCityDic in readBtnClick is %@",bookCityDic);
//    
//    /*
//     1.之前没有订阅过城市的话，是可以订阅的
//     2.已经订阅过城市的情况下，当前订阅城市超过3个不能再次订阅
//     */
//    
//    if ([bookCityDic count]!=0){       //已经订阅过城市
//    
//        NSInteger count=[bookCityDic count];
//        
//        NSLog(@"count in readBtnClick is %d",count);
//        
//        if (count>=3) {         //订阅城市超过3个
//        
//            if ([self judgeReaderOrNot:cityInfo.cityName]){//判断当前城市是否已经订阅过
//            
//                NSLog(@"cityName is %@",cityInfo.cityName);
//                NSMutableDictionary *bookCityDic1=[NSMutableDictionary dictionaryWithDictionary:bookCityDic];
//                NSNumber *bookCount=[bookCityDic1 valueForKey:cityInfo.cityName];
//                NSInteger number=[bookCount integerValue];
//                
//                if (number>=3) {
//                    ghostView.message=@"每个城市最多只能订阅3个职位";
//                    [ghostView show];
//                    NSLog(@"每个城市最多只能订阅3个职位");
//                    return;
//                }
//            
//            }else         //当前已经订阅了3个城市
//            {
//                ghostView.message=@"您最多可订阅3个城市";
//                [ghostView show];
//                NSLog(@"您最多可订阅3个城市");
//                [self removeAllObjectsData];
//                [_tableView reloadData];
//                return;
//            }
//            
//        }else  //订阅的城市数量小于3个，第二种情况
//        {
//            if ([self judgeReaderOrNot:cityInfo.cityName]){//判断当前城市是否已经订阅过
//                
//                NSLog(@"cityName is %@",cityInfo.cityName);
//                NSMutableDictionary *bookCityDic1=[NSMutableDictionary dictionaryWithDictionary:bookCityDic];
//                NSNumber *bookCount=[bookCityDic1 valueForKey:cityInfo.cityName];
//                NSInteger number=[bookCount integerValue];
//                
//                if (number>=3) {
//                    ghostView.message=@"每个城市最多只能订阅3个职位";
//                    [ghostView show];
//                    NSLog(@"每个城市最多只能订阅3个职位");
//                    return;
//                }
//            }
//            
//        }
//    }
//    
//    /******************判断订阅城市数量以及每个城市的订阅器数量*******************/
//    
//    //职位
//    
//    NSString *postStr=[save jobStr];
//    NSString *postCodeStr=[save jobCodeStr];
//    NSLog(@"postStr is %@",postStr);
//    NSLog(@"postCodeStr is %@",postCodeStr);
//    
//    //行业
//    NSString *industryStr=[save industry];
//    NSString *industryCodeStr=[save industryCode];
//    NSLog(@"industryStr is %@",industryStr);
//    NSLog(@"industryCodeStr is %@",industryCodeStr);
//    
//    //待遇
//    jobRead*salary=[save.positionArr objectAtIndex:3];
//    
//    NSString *salaryStr=salary.code;
//    
//    NSLog(@"。。。。。。。。。。。。。salaryStr is %@",salaryStr);
//    
//    NSString *url=kCombineURL(KXZhiLiaoAPI, kBookerCreat);
//    
//    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
//                            IMEI,@"userImei",kUserTokenStr,@"userToken",
//                            @"0",@"flag",cityInfo.cityCode,@"searchLocation",                   //订阅类型，订阅城市
//                            postCodeStr,@"searchPost",industryCodeStr,@"searchIndustry",//职位类别，行业类别
//                            salaryStr,@"searchTreatment",_jobTextField.text,@"searchKeyword",  //职位待遇，职位关键词
//                            @"",@"searchType",@"",@"searchWorkExperience",  //职位类型，工作经验
//                            @"",@"searchPublished",@"",@"searchEducational",                //发布日期，教育经历
//                            @"",@"searchNature",@"0",@"searchBookId", nil];                 //公司性质，BookId
//    
//    textFieldStr=_jobTextField.text;
//    
//    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
//    
//    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:URL];
//    
//    [request setTimeOutSeconds:30];
//    
//    [request setCompletionBlock:^(){
//        
//        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:nil];
//        
//        NSLog(@"resultDic in DetailView and receiveDataFinish is %@",resultDic);
//        
//        NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"resultStr is %@",resultStr);
//        
//        NSString *errorStr=[resultDic valueForKey:@"error"];
//        
//        //如果此时异地登录，进入重新登录界面
//        
//        if ([resultStr isEqualToString:@"please login"])
//        {
//            OtherLogin *other = [OtherLogin standerDefault];
//            [other otherAreaLogin];
//            return;
//        }
//        
//        //只要有返回数据，就判断是否订阅成功
//        
//        if (resultDic&&errorStr.integerValue==0){
//            
//            CityInfo *city=[CityInfo standerDefault];
//            SaveJob *save=[SaveJob standardDefault];
//            
//            /*在此处进行城市数据操作*/
//            [self setCityNumber];
//            
//            //每一次订阅成功都将该数据添加到数据库中
//            JobModel *model=[[JobModel alloc]init];
//            model.flag=@"0";
//            model.bookID=[resultDic valueForKey:@"bookId"];
//            model.industry=[save industry];
//            model.positionName=[save jobStr];
//            model.cityStr=city.cityName;
//            model.cityCodeStr=city.cityCode;
//            model.todayData=[resultDic valueForKey:@"bookTodayData"];
//            model.totalData=[resultDic valueForKey:@"bookTotalData"];
//            model.keyWord= textFieldStr;
//            
//            NSLog(@"textFieldStr in receiveDataFinish is %@",textFieldStr);
//            
//            [db addOneRecord:model];
//            
//            //发送给ScanningVC的通知，通知ScanningVC显示今日新增等信息
//            
//            NSDictionary *resultDic2=[NSDictionary dictionaryWithObjectsAndKeys:resultDic,@"dic",model,@"model",nil];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC" object:self userInfo:resultDic2];
//            
//        }else
//        {
//            ghostView.message=@"订阅失败";
//            [ghostView show];
//            return;
//        }
//        
//        [self setScreen];
//    }];
//    
//    [request setFailedBlock:^(){
//        ghostView.message=@"订阅失败";
//        [ghostView show];
//    }];
//    
//    [request startAsynchronous];
//    
//    if ([self.delegate respondsToSelector:@selector(detailViewChange: andBOOL:)]){
//        [self.delegate detailViewChange:@"0" andBOOL:YES];
//    }
//}


//下载完成之后重新修改屏幕

- (void)setScreen
{
    [_readTV.dataArray removeAllObjects];
    
    _readTV.dataArray=(NSMutableArray *)[GRBookerModel findAll];
    
    NSLog(@"_readTV.dataArray is %@",_readTV.dataArray);
    
    [_readTV reloadData];
    
    if ([_readTV.dataArray count]==0) {
        _readTV.alpha=0;
    }else
    {
        _readTV.alpha=1;
    }
    
    [self removeAllObjectsData];
    
    [_tableView reloadData];
    
    _readTV.tableViewHeight = _readTV.dataArray.count*70+71;
    NSNumber *height=[NSNumber numberWithInteger:_readTV.tableViewHeight];
    NSLog(@"_readTV.tableViewHeight  in 订阅成功 is %d",_readTV.tableViewHeight);
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:height,@"height",nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toReaderView2" object:self userInfo:dic2];
}

#pragma mark Table Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [selectListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SaveJob *save = [SaveJob standardDefault];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 111;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB(74, 74, 74);
        label.backgroundColor = [UIColor clearColor];
        label.frame = CGRectMake(kMainScreenWidth-30-200, 16, 200, 20);
        [cell addSubview:label];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    UILabel *continuousLabel2 = (UILabel *)[cell viewWithTag:111];
    
    if (indexPath.row == 2) {
        
        if ([[save industry]isEqualToString:@""]){
            continuousLabel2.text =@"选择行业";
        }else
        {
            continuousLabel2.text = [save industry];
        }
        
    }else if(indexPath.row ==0)
    {
        //职位名称
        [cell addSubview:self.jobTextField];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row ==1)
    {
        CityInfo *c = [CityInfo standerDefault];
        continuousLabel2.text = c.cityName;
    }
    else
    {
        
        GRReadModel *read = [save.positionArr objectAtIndex:indexPath.row];
        
        if (read.name&&![read.name isEqualToString:@""]){
            continuousLabel2.text=read.name;
        }else
        {
            continuousLabel2.text=@"不限";
        }
    }
    
    cell.textLabel.frame = CGRectMake(28, 25, 60, 30);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [selectListArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _optionString = [selectListArray objectAtIndex:indexPath.row];
    
    if (indexPath.row ==1)//进入城市选择界面
    {
        if ([self.delegate respondsToSelector:@selector(detailViewChange: andBOOL:)]) {
            [self.delegate detailViewChange:@"1" andBOOL:YES];
        }
    
    }else if(indexPath.row ==2)//进入行业界面
    {
        
        NSString *textString = [_jobTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([textString length]!=0) {
            isEmpty=NO;
        }else
        {
            isEmpty=YES;
        }
        
        if ([self.delegate respondsToSelector:@selector(detailViewChange:andBOOL:)]) {
            [self.delegate detailViewChange:@"2" andBOOL:isEmpty];
        }
        
    }else if(indexPath.row ==3){//进入薪资
        
        NSLog(@"_optionString in DetailView is %@",_optionString);
        if ([self.delegate respondsToSelector:@selector(detailViewChange:andBOOL:)]){
            [self.delegate detailViewChange:_optionString andBOOL:YES];
        }
    }
}


#pragma mark TextFieldDelegate Methods

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
}

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
    
//    if (([industry isEqualToString:@"选择行业"]&&[jobStr isEqualToString:@"选择职业"])||
//        
//        ([industry isEqualToString:@"不限"]&&[jobStr isEqualToString:@"不限"])) {
//        
//        NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        textString = [textString  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        
//        NSLog(@"textString is %@",textString);
//        
//        //SaveJob *save=[SaveJob standardDefault];
//        
//        if ([textString length]>0) {
//            
//            jobRead *read;
//            
//            if ([save.saveArr count]!=0) {
//                read=[save.saveArr objectAtIndex:0];
//            }
//            
//            if (![read.name isEqualToString:@"不限"]&&![read.code isEqualToString:@"0000"])
//            {
//                jobRead *read=[[jobRead alloc]init];
//                read.name=@"不限";
//                read.code=@"0000";
//                [save.saveArr addObject:read];
//            }
//            
//            [save.jobDic removeAllObjects];
//            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"0000",@"code",@"不限",@"name",nil];
//            NSMutableArray *array=[[ NSMutableArray alloc]init];
//            [array addObject:dic];
//            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:array,@"jobName", nil];
//            [save.jobDic setObject:dic2 forKey:@"不限"];
//            
//        }else
//        {
//            [save.saveArr removeAllObjects];
//            [[save.positionArr objectAtIndex:1]removeAllObjects] ;
//            [[save.positionArr objectAtIndex:2]removeAllObjects] ;
//            [save.jobDic removeAllObjects];
//        }
//        
//        [_tableView reloadData];
//    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn 执行到了。。。。。");
    
    [textField resignFirstResponder];
    return YES;
}

- (void)removeAllObjectsData//清空
{
    _jobTextField.text = @"";
    
    SaveJob *save = [SaveJob standardDefault];

    [save clearTheCache];//清空职位订阅中的数据
    
    [_tableView reloadData];
}

#pragma mark ReadTableView代理方法
-(void)readTableViewChange:(JobModel *)model
{
    NSLog(@"readTableView的代理方法实现了。。");
    
    if ([self.delegate respondsToSelector:@selector(detailViewChange2:)]) {
        
        [self.delegate detailViewChange2:model];
    }
}



-(void)readTableBeginDownload
{
    loadView=[MBProgressHUD showHUDAddedTo:self animated:YES];
}

-(void)readTableEndDownload
{
    [loadView hide:YES];
}


@end
