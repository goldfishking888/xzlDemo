//
//  ReadView.m
//  JobKnow
//
//  Created by liuxiaowu on 13-8-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ReadView.h"
#import "RTLabel.h"
#import "AppDelegate.h"

@implementation ReadView

@synthesize dataArray,myTableView;

-(void)initData
{
    self.alpha=0;
    
    num=ios7jj;
    
    //num的作用是记录哪一个按钮被点击
    NSNumber *number=[NSNumber numberWithInt:0];
    [[NSUserDefaults standardUserDefaults]setObject: number forKey:@"selected"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    db=[UserDatabase sharedInstance];
    dataArray=[[NSMutableArray alloc]init];
    [dataArray addObjectsFromArray:[db getAllRecords:@"0"]];
    [dataArray addObjectsFromArray:[db getAllRecords:@"1"]];
    [dataArray addObjectsFromArray:[db getAllRecords:@"2"]];
    [dataArray addObjectsFromArray:[db getAllRecords:@"5"]];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        [self initData];
        
        NSInteger count=[dataArray count];
        
        if (IOS7) {
            
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-64) style:UITableViewStyleGrouped];
        }else
        {
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-65) style:UITableViewStylePlain];
        }
        myTableView.delegate=self;
        myTableView.dataSource=self;
        [self addSubview:myTableView];
        NSLog(@"ReadView 正在执行。。。。。。。。。,总共有%d个订阅器",count);
    }
    return self;
}

#pragma mark tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"dataArray count is %d",[dataArray count]);
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        NSArray *views=[cell.contentView subviews];
        for (UIView *v in views){
            
            [v removeFromSuperview];
        }
    }
    
    //青岛+职位
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15,170, 25)];
    cityLabel.backgroundColor=[UIColor clearColor];
    [cityLabel setFont:[UIFont systemFontOfSize:14]];
    cityLabel.numberOfLines = 0;
    [cell.contentView addSubview:cityLabel];
    
    
    JobModel *model = [dataArray objectAtIndex:indexPath.row];
    
    if (model.flag.integerValue==0) {
        
        NSString*titleStr=[self combineStr1:model.keyWord andStr2:model.cityStr andStr3:model.industry andStr4:model.positionName];
        
        cityLabel.text=titleStr;
        
    }else
    {
        cityLabel.text = [NSString stringWithFormat:@"%@+%@",model.cityStr,model.positionName];
    }
    
    /**今日几条,总共几条**/
    RTLabel *todayLabel = [[RTLabel alloc]initWithFrame:CGRectMake(150,8,120,50)];
    
    todayLabel.font = [UIFont systemFontOfSize:12];
    todayLabel.backgroundColor = [UIColor clearColor];
    todayLabel.textColor = [UIColor grayColor];
    todayLabel.textAlignment = RTTextAlignmentRight;
    todayLabel.text = [NSString stringWithFormat:@"今日新增<font color='#f76806'>%@</font>条\n累计<font color='#f76806'>%@</font>条",model.todayData,model.totalData];
    [cell.contentView addSubview:todayLabel];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(2,0,2.5,49)];
    
    if ([model.flag isEqualToString:@"0"]) {
        label2.backgroundColor=RGBA(230,129,141,1);
    }else if ([model.flag isEqualToString:@"1"])
    {
        label2.backgroundColor=RGBA(143,188,117,1);
    }else if ([model.flag isEqualToString:@"2"])
    {
        label2.backgroundColor=RGBA(219,159,90,1);
    }else if ([model.flag isEqualToString:@"5"])
    {
        label2.backgroundColor=RGBA(148,186,187,1);
    }
    
    [cell.contentView addSubview:label2];
    
    NSNumber *number=[[NSUserDefaults standardUserDefaults]valueForKey:@"selected"];
    
    if (number&&indexPath.row ==number.integerValue){
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
        imageView.frame=CGRectMake(iPhone_width-30,18,22,15);
        [cell.contentView addSubview:imageView];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *number=[NSNumber numberWithInt:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject: number forKey:@"selected"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [myTableView reloadData];
    
    jobModel *model=[dataArray objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(readViewChange:)]) {
        [_delegate readViewChange:model];
    }
    
    self.alpha=0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IOS7) {
        return 55;
    }else
    {
        return 0;
    }
}

-(NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3 andStr4:(NSString *)str4
{
    NSString *totalString=@"";
    
    if (![str isEqualToString:@""]) {
        totalString=[totalString stringByAppendingString:str];
        totalString=[totalString stringByAppendingFormat:@"+"];
    }
    
    totalString=[totalString stringByAppendingString:str2];
    totalString=[totalString stringByAppendingFormat:@"+"];
    
    totalString=[totalString stringByAppendingString:str3];
    totalString=[totalString stringByAppendingFormat:@"+"];
    
    totalString=[totalString stringByAppendingString:str4];
    
    if ([totalString length]>=17) {
        totalString=[totalString substringToIndex:16];
    }
    
    return totalString;
}

@end