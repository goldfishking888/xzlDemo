//
//  EnterpriseView.m
//  JobsGather
//
//  Created by faxin sun on 13-2-1.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "EnterpriseView.h"
#import "MyButton.h"
#import "SelectJob.h"
#import "SaveCount.h"
#import "UserDatabase.h"
#import "CompanyResultViewController.h"
#import "OtherLogin.h"

@implementation EnterpriseView
@synthesize imgView=_imgView;
@synthesize today,total;
-(void)initData
{
    today=0;
    total=0;
    num=ios7jj;
    _isAlter=NO;
    
    db=[UserDatabase sharedInstance];
    _readArray=(NSMutableArray*)[db getAllRecords:@"1"];
    
    NSLog(@"_readArray in initData is %@",_readArray);
    
    
    for (int i=0;i<[_readArray count];i++) {
        JobModel *model=[_readArray objectAtIndex:i];
        today=today+model.todayData.integerValue;
        total=total+model.totalData.integerValue;
    }
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.3f dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    
    self.backgroundColor=XZhiL_colour2;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        NSInteger count=[_readArray count];
        
        NSLog(@"count in EnterpriseView is %d",count);
        
        _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-num-40)];
        
        if (IOS7) {
            
            if (iPhone_5Screen) {
                
                if (count<=5) {
                    _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else
                {
                    _myScrollView.contentSize = CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-5)*60+12);
                }
            }else
            {
                
                if (count<4) {
                    _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                }else
                {
                    _myScrollView.contentSize = CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-4)*60+30);
                }
            }
            
        }else
        {
            if (count<4) {
                _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
            }else
            {
                _myScrollView.contentSize = CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-4)*60+30);
            }
        }
        
        _myScrollView.alwaysBounceHorizontal=NO;
        _myScrollView.alwaysBounceVertical=YES;
        [self addSubview:_myScrollView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 10, 235, 40);
        [button addTarget:self action:@selector(pushTextField2:) forControlEvents:UIControlEventTouchUpInside];
        
        _searchImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbackgroundView.png"]];
        _searchImage.userInteractionEnabled=YES;
        _searchImage.frame=CGRectMake(5,12,iPhone_width-10,40);
        
        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search2.png"]];
        image.frame=CGRectMake(8,9,21,21);
        [_searchImage addSubview:image];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40,5,200,30)];
        label.text=@"请输入订阅企业或者关键字";
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor colorWithWhite:0.8 alpha:1];
        [_searchImage addSubview:label];
        
        UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame=CGRectMake(285,9,21,21);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateHighlighted];
        [_searchImage addSubview:deleteBtn];
        
        if (IOS7) {
            _companyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,27,iPhone_width,iPhone_height+count*60+100) style:UITableViewStyleGrouped];
        }else
        {
            
            _companyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,60,iPhone_width,iPhone_height+count*60) style:UITableViewStylePlain];
            _companyTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            
            if (count==0){
                _companyTableView.frame=CGRectMake(0, 60,iPhone_width,0);
            }
        }
        
        _companyTableView.alwaysBounceVertical=NO;
        _companyTableView.alwaysBounceHorizontal=NO;
        _companyTableView.backgroundView=nil;
        _companyTableView.backgroundColor=XZhiL_colour2;
        _companyTableView.delegate = self;
        _companyTableView.dataSource = self;
        
        [_myScrollView addSubview:_companyTableView];
        [_myScrollView addSubview:_searchImage];
        [_myScrollView addSubview:button];
        
        //编辑订阅器的按钮
        _bianjiBtn = [myButton buttonWithType:UIButtonTypeCustom];
        
        if (count==0) {
            _bianjiBtn.alpha=0;
        }else
        {
            _bianjiBtn.alpha=1;
        }
        
        if (IOS7) {
            _bianjiBtn.frame = CGRectMake(100,102+count*60,110,40);
        }else
        {
            _bianjiBtn.frame = CGRectMake(100,52+count*60,110,40);
        }
        
        [_bianjiBtn addTarget:self action:@selector(alterFeedReader:)   forControlEvents:UIControlEventTouchUpInside];
        [_bianjiBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateNormal];
        [_bianjiBtn setTitle:@"[编辑修改订阅器]"forState:UIControlEventTouchUpInside];
        [_bianjiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_companyTableView addSubview:_bianjiBtn];
    }
    return self;
}


-(void)alterFeedReader:(id)sender
{
    myButton*bianjiBtn=(myButton *)sender;
    
    bianjiBtn.isClicked=!bianjiBtn.isClicked;
    
    if (bianjiBtn.isClicked) {
        [_bianjiBtn setTitle:@"[取消修改订阅器]" forState:UIControlStateNormal];
        [_bianjiBtn setTitle:@"[取消修改订阅器]"forState:UIControlEventTouchUpInside];
    }else
    {
        [_bianjiBtn setTitle:@"[编辑修改订阅器]" forState:UIControlStateNormal];
        [_bianjiBtn setTitle:@"[编辑修改订阅器]"forState:UIControlEventTouchUpInside];
    }
    
    _isAlter=!_isAlter;
    
    [_companyTableView reloadData];
}

/**点击最上方的输入框触发的事件**/
- (void)pushTextField2:(id)sender
{
    if ([_readArray count]<10) {
        [self.delegate pushTextField];
    }else
    {
        ghostView.message=@"您已订阅10个职位";
        [ghostView show];
    }
}

/**点击最上方的搜索进入ReaderViewController之中的pushTextField**/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_readArray count]<10) {
        [self.delegate pushTextField];
    }else
    {
        ghostView.message=@"您已订阅10个职位";
        [ghostView show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_readArray count]==0) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_readArray count]==0) {
        return 0;
    }else
    {
        if (section==0) {
            return 1;
        }else
        {
            return [_readArray count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    else
    {
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    JobModel *model = [self.readArray objectAtIndex:indexPath.row];
    
    if (indexPath.section==0) {
        
        _numberRTLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 5, 220, 20)];
        _numberRTLabel.backgroundColor=[UIColor clearColor];
        _numberRTLabel.font=[UIFont systemFontOfSize:12];
        _numberRTLabel.text =[NSString stringWithFormat:@"企业职位订阅器:今日<font color='#f76806'>%d</font>条,累计<font color='#f76806'>%d</font>条",today,total];
        
        _jobNumbersLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 23, 300, 20)];
        _jobNumbersLabel.backgroundColor =[UIColor clearColor];
        _jobNumbersLabel.font=[UIFont systemFontOfSize:12];
        _jobNumbersLabel.text=[NSString stringWithFormat:@"已订阅的企业数:<font color='#f76806'>  %d/10</font>",[_readArray count]];
        
        if (IOS7) {
            
        }else
        {
            UILabel *label4=[[UILabel alloc]initWithFrame: CGRectMake(0,44,iPhone_width,1)];
            label4.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:label4];
            
  
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,1)];
            label.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:label];
        }
        
        [cell.contentView addSubview:_numberRTLabel];
        [cell.contentView addSubview:_jobNumbersLabel];
    }else
    {
        
        if (!_isAlter){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,8,200,44)];
            nameLabel.numberOfLines = 2;
            NSString *positionNameStr=[model.cityStr stringByAppendingString:@"+"];
            positionNameStr =[positionNameStr stringByAppendingString:model.positionName];
            nameLabel.text  =positionNameStr;
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            /**今日几条,总共几条**/
            RTLabel *dateLabel = [[RTLabel alloc]initWithFrame:CGRectMake(210, 17, 70, 40)];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.textColor = [UIColor grayColor];
            dateLabel.textAlignment = RTTextAlignmentRight;
            [cell.contentView addSubview:dateLabel];
            dateLabel.text = [NSString stringWithFormat:@"今日<font color='#f76806'>%@</font>条\n累计<font color='#f76806'>%@</font>条",model.todayData,model.totalData];
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,8,200,44)];
            nameLabel.numberOfLines = 2;
            NSString *positionNameStr=[model.cityStr stringByAppendingString:@"+"];
            positionNameStr =[positionNameStr stringByAppendingString:model.positionName];
            nameLabel.text  =positionNameStr;
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            
            UIButton *deleatbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            deleatbtn.tag=indexPath.row;
            deleatbtn.frame = CGRectMake(iPhone_width - 70, 0, 50, 55);
            [deleatbtn setImage:[UIImage imageNamed:@"deleread1.png"] forState:UIControlStateNormal];
            [deleatbtn setImageEdgeInsets:UIEdgeInsetsMake(15, -15, 15, -15)];
            [deleatbtn addTarget:self action:@selector(deleteReader:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleatbtn];
        }
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(5,5,10,10)];
        
        label2.backgroundColor=RGBA(143,188,117,1);
        [cell.contentView addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame: CGRectMake(9,16,1,40)];
        label3.backgroundColor=RGBA(143,188,117,1);
        [cell.contentView addSubview:label3];
        
        if (IOS7) {
            
        }else
        {
            UILabel *label4=[[UILabel alloc]initWithFrame: CGRectMake(0,59,iPhone_width,1)];
            label4.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1];
            [cell.contentView addSubview:label4];
            
        }
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isAlter&&indexPath.section!=0) {
        JobModel*model=[_readArray objectAtIndex:indexPath.row];
        [self.delegate enterpriseViewSelected:model];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 45;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7){
        if (section!=0) {
            return 5;
        }
        return 0;
    }
    
    return 0;
}

#pragma mark textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _imgView.image = [UIImage imageNamed:@"textField_2.png"];
    _companyTableView.frame = CGRectMake(0,27,iPhone_width,iPhone_height+[_readArray count]*60);
    [textField resignFirstResponder];
    return YES;
}

-(void)deleteReader:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //删除订阅器，然后刷新界面
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该订阅器吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    [alert show];
    
    _myTag = btn.tag;
    
    NSLog(@"_myTag is %d",_myTag);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        
    }else{
        if(alertView.tag == 101){
            JobModel *model = [_readArray objectAtIndex:_myTag];
            [self deleatDingYu:model];
        }
    }
}

-(void)deleatDingYu:(JobModel *)model
{
    
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    loadView =[MBProgressHUD showHUDAddedTo:self animated:YES];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",model.bookID,@"bookId",model.cityCodeStr,LocaCity,@"1",@"flag",nil];
    NSString *url = kCombineURL(KXZhiLiaoAPI, kCancelReadCompany);
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    
    [request setTimeOutSeconds:15];
    
    [request setCompletionBlock :^{
        
        [loadView hide:YES];
        
        //请求响应结束，返回 responseString
        NSDictionary *resultDic= [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"resultDic in enterpriseView and Delete is %@",resultDic);
        
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
            
            _readArray =(NSMutableArray *)[db getAllRecords:@"1"];
            
            today=0;
            
            total=0;
            
            for (int i=0;i<[_readArray count];i++) {
                JobModel *model=[_readArray objectAtIndex:i];
                today=today+model.todayData.integerValue;
                total=total+model.totalData.integerValue;
            }
            
            [_companyTableView reloadData];
            
            NSInteger count=[_readArray count];
            
            if (count==0) {
                _bianjiBtn.alpha=0;
                _isAlter=NO;
                _companyTableView.frame=CGRectMake(0,27,iPhone_width,0);
            }else{
                
                _bianjiBtn.alpha=1;
                
                
                if (IOS7) {
                    _companyTableView.frame=CGRectMake(0,27,iPhone_width,iPhone_height+count*60);
                    _bianjiBtn.frame = CGRectMake(100,102+count*60,110,40);
                }else
                {
                    _companyTableView.frame=CGRectMake(0,60,iPhone_width,iPhone_height+count*60);
                    _bianjiBtn.frame = CGRectMake(100,52+count*60,110,40);
                }
                
                if (IOS7) {
                    
                    if (iPhone_5Screen){
                        if (count<=5) {
                            _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                        }else
                        {
                            _myScrollView.contentSize = CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-5)*60+12);
                        }
                    }else
                    {
                        if (count<4) {
                            _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                        }else
                        {
                            _myScrollView.contentSize = CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-4)*60+30);
                        }
                        
                    }
                    
                    
                }else
                {
                    if (count<4) {
                        _myScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height-44-num-40);
                    }else
                    {
                        _myScrollView.contentSize = CGSizeMake(iPhone_width,iPhone_height-44-num-40+(count-4)*60+30);
                    }
                    
                }
            }
            
            _numberRTLabel.text =[NSString stringWithFormat:@"企业职位订阅器:今日<font color='#f76806'>%d</font>条,累计<font color='#f76806'>%d</font>条",today,total];
            _jobNumbersLabel.text=[NSString stringWithFormat:@"已订阅的企业数:<font color='#f76806'>  %d/10</font>",[_readArray count]];
            
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
        }else
        {
            ghostView.message=@"删除失败";
            [ghostView show];
            return;
        }
    }];
    
    [request setFailedBlock :^{
        
        [loadView hide:YES];
        // 请求响应失败，返回错误信息
        
        ghostView.message=@"删除失败";
        [ghostView show];
        
        NSLog(@"删除失败!");
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
//动画方法
- (void)viewAnimation:(UIView *)view frame:(CGRect)frame time:(float)time alph:(float)alpha
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:time];
    view.frame = frame;
    view.alpha = alpha;
    [UIView commitAnimations];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view cache:YES];
}




@end

