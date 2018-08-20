//
//  ReadTableView.m
//  JobsGather
//
//  Created by faxin sun on 13-2-16.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "ReadTableView.h"
#import "AppDelegate.h"
#import "GRBookerModel.h"
#import "UserDatabase.h"
#import "JobSeeViewController.h"
#import "OtherLogin.h"

@implementation ReadTableView

- (void)initData
{
    today = 0;
    
    total = 0;
    
    myModel=[[GRBookerModel alloc]init];
    
    db=[UserDatabase sharedInstance];
    
    _dataArray=(NSMutableArray *)[GRBookerModel findAll];
    if (_dataArray.count>0) {
        _tableViewHeight = _dataArray.count*70+71;//tableViewHeight高度
    }else{
        _tableViewHeight = 0;
    }

    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.3 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
}

- (id)initWithFrame:(CGRect)frame
{

        
    _readTV = [super initWithFrame:frame];
    _readTV.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    if (_readTV){
        
        [self initData];

        _readTV.scrollEnabled = NO;
        
        _readTV.delegate = self;
        
        _readTV.dataSource = self;
        
        UIView *tvBg = [[UIView alloc] initWithFrame:_readTV.frame];
        tvBg.backgroundColor=XZhiL_colour2;
        [_readTV setBackgroundView:tvBg];
     
        addLabel = [[RTLabel alloc] initWithFrame:CGRectMake(22, 17, 200, 20)];
        [addLabel setBackgroundColor:[UIColor greenColor]];
        [addLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14]];
        addLabel.textColor = [UIColor blackColor];
        
        btn_edit = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-22-70, 10, 70, 32)];
        btn_edit.backgroundColor = [UIColor whiteColor];
        mViewBorderRadius(btn_edit, 16, 0.5, RGB(216, 216, 216));
        [btn_edit setTitleColor:RGB(255, 160, 71) forState:UIControlStateNormal];
        [btn_edit setTitle:@"编辑" forState:UIControlStateNormal];
        [btn_edit.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn_edit addTarget:self action:@selector(alterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _isAlter = NO;
        
        _alterBtn=[myButton buttonWithType:UIButtonTypeCustom];
        
        if ([_dataArray count]!=0){
            _alterBtn.alpha=1;
        }else{
            _alterBtn.alpha=0;
        }
    
    }
    
    return _readTV;
}

#pragma mark alterBtn响应事件

- (void)alterBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    _isAlter=!_isAlter;
    
    if (_isAlter){
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else
    {
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    
    
    [self reloadData];
}

#pragma mark UITableViewDelegate代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (_dataArray.count == 0) {
    
        return 0;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count!=0) {
     
        if (section==0) {
            
            return 1;
        }
    
        return [_dataArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views = [cell.contentView subviews];
        
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    UILabel *label = [[UILabel alloc]init];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section ==0) {
        
        
        
        UIView *tempV = [[UIView alloc] initWithFrame:CGRectMake(0,0 , kMainScreenWidth, 48)];
        tempV.backgroundColor = RGB(247, 247, 247);
        [tempV addSubview:addLabel];
        
        [tempV addSubview:btn_edit];
        
        [cell.contentView addSubview:tempV];
        
        addLabel.text = [[NSString alloc] initWithFormat:@"已设置的订阅器：%lu/5",(unsigned long)[_dataArray count]];
        [self setTodayAndAllNum];
        
    }else{
        
        GRBookerModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        NSString*titleStr=[self combineStr1:model.bookPostName andStr2:model.bookLocationName andStr3:model.bookIndustryName];
        
        CGFloat height = 0;
        UIView *cellB = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-10*2, 59)];
        mViewBorderRadius(cellB, 4, 1, RGB(216, 216, 216));
        cellB.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:cellB];
        /*当cell处在编辑状态下   当cell处在删除状态下*/
//        
        if (!_isAlter) {
            
            //返回的label显示今日多少条，累计多少条
            UIView *countLabel = [self labelForCell:model.bookTodayData Total:model.bookTotalData backViewFrame:cellB.frame];
//            countLabel.backgroundColor = [UIColor blueColor];
            
            [cellB addSubview:countLabel];
            
            label.frame = CGRectMake(22,23, cellB.frame.size.width - countLabel.frame.size.width-14-22-10, 13);
        }else{
            [cellB setFrame:CGRectMake(10, 0, kMainScreenWidth-10-35, 59)];
            //返回的label显示今日多少条，累计多少条
            UIView *countLabel = [self labelForCell:model.bookTodayData Total:model.bookTotalData backViewFrame:cellB.frame];
//            countLabel.backgroundColor = [UIColor blueColor];
            
            [cellB addSubview:countLabel];
            
            label.frame = CGRectMake(22,23, cellB.frame.size.width - countLabel.frame.size.width-14-22-10, 13);
            
            UIButton *btn_delete = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-29, 22, 20, 20)];
            btn_delete.tag = indexPath.row;
            [btn_delete setImage:[UIImage imageNamed:@"booker_delete"] forState:UIControlStateNormal];
            [btn_delete addTarget:self action:@selector(deleteFeedReader:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_delete];


        }
    
        label.numberOfLines = 1;
        label.text = titleStr;
        label.textColor = RGB(74, 74, 74);
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment=NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.backgroundColor = [UIColor clearColor];
        [cellB addSubview:label];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        
        return 67;
        
    }else
    {
        return 70;
    }
}

//判断是否编辑状态
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"indexPath.section is %d",indexPath.section);
    if(_isAlter){
        return;
    }
    
    if (indexPath.section!=0) {
        
//
        
        if (!_isAlter) {
            
            GRBookerModel *model=[_dataArray objectAtIndex:indexPath.row];
            
            if ([_readDelegate respondsToSelector:@selector(readTableViewChange:)]){
                [_readDelegate readTableViewChange:model];
            }
        }
    }
}

#pragma mark 删除订阅器

- (void)deleteFeedReader:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该订阅器吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    UIButton *btn = (UIButton *)sender;
    index = btn.tag;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) {
        
        if(alertView.tag == 100 ){//点击进行删除
            GRBookerModel *model = [_dataArray objectAtIndex:index];
            [self deleteJobReader:model];
        }
    }
}

#pragma mark 删除tableViewCell的方法

- (void)deleteJobReader:(GRBookerModel *)model{
    
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    myModel=model;
    
    NSLog(@"myModel.bookID is %@",myModel.bookId);
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjEzOTAzZjVmN2M2NTU1ZjI4NDg3Yjc2YzQ4YTNkY2NiY2FmYzg4MmI0MTgyMDYzMGE5YjcyYTMyMzdlMTkyMmM3ZDc3MWNkM2ZhNzBhYjA2In0.eyJhdWQiOiIyIiwianRpIjoiMTM5MDNmNWY3YzY1NTVmMjg0ODdiNzZjNDhhM2RjY2JjYWZjODgyYjQxODIwNjMwYTliNzJhMzIzN2UxOTIyYzdkNzcxY2QzZmE3MGFiMDYiLCJpYXQiOjE1MDIyNDQ5OTIsIm5iZiI6MTUwMjI0NDk5MiwiZXhwIjoxODE3Nzc3NzkyLCJzdWIiOiIxMCIsInNjb3BlcyI6W119.EHmVbD2Zn1VifZDYbSz1Sn79ljPz8NaJ5MKUuZavPS5ZI_5Mqglar0p9zuY-1_kKjKPt44sUXHxo-G3XjzP6jP2YXOP-vguuA6X9MdUnZJvL3vVAQ8Rl-DNgiFEU8I0oAvop-r9tIUHP3rLtkxkSs5wGnys4JYJETQzSDBA3UbpboGQIQT_rgJiowaxzof3gzitudAhUtuGfnsdFbXBb9zMOq1Jz9DffJbA5FaEvD-V4A43hNRYlK6LgYd8bH-ui4EmjNqICA8aiR0YIGl21hDERk-SWEXvSQFG755NcBfF1sY6OrMO3Q6LkOS2Wzg4FOI7Hk5LGZnVGSWBYNkg__feRrvyRpNDfoCHrOv_m3rQFw1ZIiv1JGtLj8n849gTFQnbuHKcbKGEeXwlb7TPeIs0eF59Mx9jOWqCu7fjFExe6YnosL9ci_AtCXxyDXfD29wg7vEllP74PRxiI2fmR6n8hF9WHvzmfsCC8iQi_pwsj0wypopClfB8BhTIBPS2VZJFxau-WmCSaUn3ux0nQAI5J66x6VAbMqdN3tHi6C2n5sdq5HRO1nlfNVp9lZiutQnNs91C5CSb7ElfXWWwqiWpcScH7bRllf_-EInjh4HDjI2GmZju-2P0qqQu3zau7Ft32aXDs8jHqlEnHVkRukawEeYpxIlK_OaBh46wXxig";
    [paramDic setValue:tokenStr forKey:@"token"];
    //    [paramDic setValue:self.jobTextField.text forKey:@"position_name"];
    //    [paramDic setValue:industryCodeStr forKey:@"trade"];//手机企业没有
    //    [paramDic setValue:cityInfo.cityCode forKey:@"area"];//4表示企业
    //    [paramDic setValue:salary.code forKey:@"salary"];//
    [paramDic setValue:model.bookId forKey:@"book_id"];
    NSLog(@"paramDic is %@",paramDic);
    //    NSDictionary *params = @{@"mobile":_phoneTF.text,@"captcha":_verifyCodeTF.text,@"version":[XZLUtil currentVersion]};
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/subscribe/delete"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                ghostView.position=OLGhostAlertViewPositionCenter;
                ghostView.message=@"删除成功";
                [ghostView show];
                
                [_dataArray removeObject:myModel];
                [myModel deleteObject];
                
                if ([_dataArray count]==0){
                    _isAlter=NO;
                    self.frame=CGRectMake(0,0,0,0);
                }
                
                [self reloadData];
                _tableViewHeight = _tableViewHeight-70;
                NSLog(@"删除成功后的_tableViewHeight is %d",_tableViewHeight);
                //将得到的tableViewHeight传给ReadViewController
                NSNumber *number3=[NSNumber numberWithInteger:_tableViewHeight];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:number3,@"height",nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"toReaderView" object:self userInfo:dic];
            }else{
                ghostView.message = responseObject[@"message"];
                [ghostView show];
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


//根据positionid删除职位订阅器的请求

- (void)deleteJobReader2:(GRBookerModel *)model
{
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    if ([self.readDelegate respondsToSelector:@selector(readTableBeginDownload)]) {
        
        [self.readDelegate readTableBeginDownload];
    }
    
    myModel=model;
    
    NSLog(@"myModel.bookID is %@",myModel.bookId);
    
    NetWorkConnection *net=[[NetWorkConnection alloc]init];
    
    net.delegate=self;
    
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",model.bookId,@"book_id", nil];
    
    NSString*urlStr= kCombineURL(KXZhiLiaoAPI, kCancelReadCompany);
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    
    __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
    
    [request setTimeOutSeconds:20];
    
    [request setCompletionBlock:^(){
        
        //关闭提示
        if ([self.readDelegate respondsToSelector:@selector(readTableEndDownload)]) {
            [self.readDelegate readTableEndDownload];
        }
        
        NSDictionary *resultDic =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"resultDic is %@",resultDic);
        
        NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        if ([resultStr isEqualToString:@"please login"])
        {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSString *errorStr=[resultDic valueForKey:@"error"];
        
        if (resultDic&&errorStr.integerValue==0){
            
            NSLog(@"服务器端删除成功");
            ghostView.position=OLGhostAlertViewPositionCenter;
            ghostView.message=@"删除成功";
            [ghostView show];
            
            [_dataArray removeObject:myModel];
            [myModel deleteObject];
            
            if ([_dataArray count]==0){
                _isAlter=NO;
                self.frame=CGRectMake(0,0,0,0);
            }
            
            [self reloadData];
            
            NSLog(@"删除成功后的_tableViewHeight is %d",_tableViewHeight);
            //将得到的tableViewHeight传给ReadViewController
            NSNumber *number3=[NSNumber numberWithInteger:_tableViewHeight];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:number3,@"height",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toReaderView" object:self userInfo:dic];
        }
    }];
    
    [request setFailedBlock:^(){
        
        ghostView.message=@"删除失败";
        
        [ghostView show];
        
        //关闭提示
        if ([self.readDelegate respondsToSelector:@selector(readTableEndDownload)]) {
            [self.readDelegate readTableEndDownload];
        }
        
    }];
    
    [request startAsynchronous];
}

#pragma mark 功能函数

//判断当前城市cityStr是否是应经订阅过职位的城市

- (BOOL)judgeReaderOrNot:(NSString *)cityStr
{
    NSMutableDictionary *bookCityDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"bookCity"];
   
    NSMutableArray *bookCityArray=(NSMutableArray *)[bookCityDic allKeys];
    
    for (NSString *bookCityStr in bookCityArray) {
        if ([bookCityStr isEqualToString:cityStr]) {
            return YES;
        }
    }
    
    return NO;
}

//判断当前城市cityStr是否还有订阅器
- (BOOL)ifExist:(NSString *)cityStr
{
    if(cityStr == nil || cityStr.length == 0 ){
        return NO;
    }
    NSArray *cityArray=[db getAllCityRecords];
    
    NSMutableArray *cityArray2=[[NSMutableArray alloc]init];

    for (GRBookerModel *model in cityArray) {
        [cityArray2 addObject:model.bookLocationName];
    }
    
    for (NSString *modelCity in cityArray2) {
        if ([cityStr isEqualToString:modelCity]) {
            return YES;
        }
    }
    
    return NO;
}

- (CGPoint)setLabelCenterX:(CGFloat)x Y:(CGFloat)y
{
    CGPoint point;
    
    point.x = x;
    
    if (y < 20) {
        y = 40;
    }
    
    point.y = y/2;
    
    return point;
}

- (UIView *)labelForCell:(NSString *)count Total:(NSString *)total1 backViewFrame:(CGRect)backViewFrame
{
    //用来显示一条订阅器的今日更新条数和累计更新条数
    UIFont *font = [UIFont systemFontOfSize:14];

    
    //创建用来显示的label
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 90, 16)];
    numberLabel.numberOfLines = 0;
//    [numberLabel setText: [[NSString alloc]initWithFormat:@"今日%@条",count]];
    numberLabel.font = font;
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.textColor=RGB(155, 155, 155);
    
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"今日%@条",count]];
    
    [strA addAttribute:NSForegroundColorAttributeName value:RGB(252, 83, 102) range:NSMakeRange(2,total1.length)];
    
    numberLabel.attributedText = strA;
    
    
    //创建用来显示的label
    UILabel *numberLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0,16+4, 90, 16)];
    numberLabel2.numberOfLines = 0;
    [numberLabel2 setText: [[NSString alloc]initWithFormat:@"累计%@条",total1]];
    numberLabel2.font = font;
    numberLabel2.textAlignment = NSTextAlignmentRight;
    numberLabel2.textColor=RGB(155, 155, 155);
    
    NSMutableAttributedString *strB = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"累计%@条",total1]];
    
    [strB addAttribute:NSForegroundColorAttributeName value:RGB(252, 83, 102) range:NSMakeRange(2,total1.length)];
    
    numberLabel2.attributedText = strB;
    
    UIView *viewLB = [[UIView alloc] initWithFrame:CGRectMake(backViewFrame.size.width-14-90,12, 90, 36)];
    [viewLB addSubview:numberLabel];
    [viewLB addSubview:numberLabel2];
    
    
    return viewLB;
}

//根据宽度和字符串，返回所需要的高度
- (CGFloat)textLableHeightWithString:(NSString *)str Width:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:14];
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    CGSize expectedLabelSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingMiddle];
    
    return expectedLabelSize.height;
}

//计算今日职位数量

- (void)setTodayAndAllNum
{
    today = 0;
    total = 0;
    for (GRBookerModel *model in _dataArray) {
        today = today + [model.bookTodayData integerValue];
        total = total + [model.bookTotalData integerValue];
    }
}


/**连接3个字符串**/

- (NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3
{
    NSString *totalString=@"";
    
    if (![NSString isNullOrEmpty:str]) {
        totalString=[totalString stringByAppendingString:str];
    }
    
    if (![NSString isNullOrEmpty:str2]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:str2];
    }
    if (![NSString isNullOrEmpty:str3]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:str3];
    }
    
    
    if ([totalString length]>=17) {
        totalString=[totalString substringToIndex:16];
    }
    
    return totalString;
}

@end
