//
//  NewReadView.m
//  JobKnow
//
//  Created by Apple on 14-4-1.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "NewReadView.h"
#import "AppDelegate.h"
#import "jobModel.h"
#import "JobSeeViewController.h"
#import "CityInfo.h"
@implementation NewReadView

- (void)initData
{
    UserDatabase *db=[UserDatabase sharedInstance];
    
    _dataArray=[[NSMutableArray alloc]init];
    
    [_dataArray addObjectsFromArray:[db getAllRecords:@"0"]];
    [_dataArray addObjectsFromArray:[db getAllRecords:@"1"]];
    [_dataArray addObjectsFromArray:[db getAllRecords:@"2"]];
    [_dataArray addObjectsFromArray:[db getAllRecords:@"5"]];
    
    NSLog(@"_dataArray in NewReadView is %@",_dataArray);
 
    _realArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<[_dataArray count];i++) {
        
        JobModel *model=[_dataArray objectAtIndex:i];
        
        if (model.todayData.integerValue!=0) {
            
            [_realArray addObject:model];
        }
    }
    
    NSLog(@"_dataArray2 in NewReadView is %@",_realArray);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tuisong.png"]];
        
        imageView.frame=CGRectMake(10,70,iPhone_width-20,50);
        
        [self addSubview:imageView];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(100,10,200,30)];
        label.font=[UIFont systemFontOfSize:17];
        label.text=@"查看职位数据";
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        [imageView addSubview:label];
        
        [self initData];//初始化数据
        
        if ([_realArray count]==0) {
            return NULL;
        }
        
        if (IOS7) {
            _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10,120,iPhone_width-20,270) style:UITableViewStyleGrouped];
        }else
        {
            _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10,120,iPhone_width-20,270) style:UITableViewStylePlain];
        }
        
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:_tableView];
        
        UIImageView *imageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tuisong2.png"]];
        imageView2.userInteractionEnabled=YES;
        imageView2.frame=CGRectMake(10,390,iPhone_width-20,60);
        [self addSubview:imageView2];
        
        UIButton *readBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        readBtn.frame=CGRectMake(10,10,280,40);
        readBtn.backgroundColor=[UIColor clearColor];
        [readBtn setTitle:@"查看" forState:UIControlStateNormal];
        [readBtn setTitle:@"查看" forState:UIControlStateHighlighted];
        [readBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
        [readBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
        [readBtn addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView2 addSubview:readBtn];
        
        if ([_realArray count]==1){
            
            if (iPhone_5Screen) {
                
                imageView.frame=CGRectMake(10,200,iPhone_width-20,50);
                _tableView.frame=CGRectMake(10,250,iPhone_width-20,45);
                imageView2.frame=CGRectMake(10,295,iPhone_width-20,60);
                
            }else
            {
                imageView.frame=CGRectMake(10,120,iPhone_width-20,50);
                _tableView.frame=CGRectMake(10,170,iPhone_width-20,45);
                imageView2.frame=CGRectMake(10,215,iPhone_width-20,60);
            }
            
        }else if ([_realArray count]==2||[_realArray count]==3)
        {
            if (iPhone_5Screen) {
                imageView.frame=CGRectMake(10,180,iPhone_width-20,50);
                _tableView.frame=CGRectMake(10,230,iPhone_width-20,[_realArray count]*45);
                imageView2.frame=CGRectMake(10,230+[_realArray count]*45,iPhone_width-20,60);
            }else
            {
                
                imageView.frame=CGRectMake(10,120,iPhone_width-20,50);
                _tableView.frame=CGRectMake(10,170,iPhone_width-20,[_realArray count]*45);
                imageView2.frame=CGRectMake(10,170+[_realArray count]*45,iPhone_width-20,60);
            }
            
        }else if ([_realArray count]==4||[_realArray count]==5)
        {
            if (iPhone_5Screen) {
                
                imageView.frame=CGRectMake(10,150,iPhone_width-20,50);
                _tableView.frame=CGRectMake(10,200,iPhone_width-20,[_realArray count]*45);
                imageView2.frame=CGRectMake(10,200+[_realArray count]*45,iPhone_width-20,60);
                
            }else
            {
                imageView.frame=CGRectMake(10,80,iPhone_width-20,50);
                _tableView.frame=CGRectMake(10,130,iPhone_width-20,[_realArray count]*45);
                imageView2.frame=CGRectMake(10,130+[_realArray count]*45,iPhone_width-20,60);
            }
        }
    }
    
    return self;
}

//点击查看按钮
-(void)readBtnClick:(id)sender
{
    JobModel *model=[_dataArray objectAtIndex:0];
    
    if ([_dataArray count]!=0) {
        model=[_dataArray objectAtIndex:0];
    }else
    {
        [self removeFromSuperview];
    }
    
    if ([self.delegate respondsToSelector:@selector(readView:)]){
        [self.delegate readView:model];
    }
    
    [self removeFromSuperview];
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_realArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views=[cell.contentView subviews];
        
        for (UIView *v in views) {
            if (v.tag==100) {
                [v removeFromSuperview];
            }
            //[v removeFromSuperview];
        }
        
    }
    
    JobModel *model=[_realArray objectAtIndex:indexPath.row];
    NSLog(@"model.flag is %@",model.flag);
    NSLog(@"model.bookID is %@",model.bookID);
    NSLog(@"model.positionName is %@",model.positionName);
    NSLog(@"model.industry is %@",model.industry);
    
    NSString *combineString=@"";
    
    if (model.flag.integerValue==0) {
        
        combineString=[self combineStr1:model.keyWord andStr2:model.cityStr andStr3:model.industry andStr4:model.positionName];
    }else
    {
        
        combineString=[self combineStr1:@"" andStr2:model.cityStr andStr3:@"" andStr4:model.positionName];
    }
    
    NSLog(@"combineString is %@",combineString);
    
    cell.textLabel.text=combineString;
    
    RTLabel *dateLabel = [[RTLabel alloc]initWithFrame:CGRectMake(220,5,70,40)];
    dateLabel.tag=100;
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = RTTextAlignmentRight;
    dateLabel.text = [NSString stringWithFormat:@"今日<font color='#f76806'>%@</font>条\n累计<font color='#f76806'>%@</font>条",model.todayData,model.totalData];
    [cell.contentView addSubview:dateLabel];
    
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobModel *model=[_realArray objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(readView:)]){
        [self.delegate readView:model];
    }
    
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IOS7){
        return 0.1;
    }
    
    return 0;
}



-(NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3 andStr4:(NSString *)str4
{
    NSString *totalString=@"";
    
    //NSLog(@"str in combineStr1 is %@",str);
    
    if (![str isEqualToString:@""]) {
        totalString=[totalString stringByAppendingString:str];
        totalString=[totalString stringByAppendingFormat:@"+"];
    }
    
    if (![str2 isEqualToString:@""]) {
        totalString=[totalString stringByAppendingString:str2];
        totalString=[totalString stringByAppendingFormat:@"+"];
    }
    
    if (![str3 isEqualToString:@""]) {
        totalString=[totalString stringByAppendingString:str3];
        totalString=[totalString stringByAppendingFormat:@"+"];
    }
    
    totalString=[totalString stringByAppendingString:str4];
    
    
    if ([totalString length]>=18) {
        
        totalString=[totalString substringToIndex:17];
    }
    
    return totalString;
}

@end
