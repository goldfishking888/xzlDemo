//
//  ResumeFilterView.m
//  JobKnow
//
//  Created by Suny on 15/8/7.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ResumeFilterView.h"

@implementation ResumeFilterView
-(void)initData
{
    self.alpha=0;
    
    num=ios7jj;
    
    //num的作用是记录哪一个按钮被点击
    NSNumber *number=[NSNumber numberWithInt:0];
    [[NSUserDefaults standardUserDefaults]setObject: number forKey:@"resume_selected"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    

    dataArray=[[NSMutableArray alloc]init];
    
}

- (id)initWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)array
{
    self = [super initWithFrame:frame];
    if (self){
        
        [self initData];
        for (HRJobSortModel *item in array) {
            [dataArray addObject:item];
        }
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
    
    HRJobSortModel *model = [dataArray objectAtIndex:indexPath.row];
    
    //
    UILabel *label_title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,200, 25)];
    label_title.backgroundColor=[UIColor clearColor];
    label_title.font = [UIFont boldSystemFontOfSize:17];
    [label_title setText:model.name];
    [cell.contentView addSubview:label_title];
    
    UILabel *label_num = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-90, 10,80, 25)];
    label_num.backgroundColor=[UIColor clearColor];
    label_num.font = [UIFont systemFontOfSize:14];
    [label_num setText:[NSString stringWithFormat:@"%@条简历",model.num]];
    [cell.contentView addSubview:label_num];
    
    
    
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(2,0,2.5,49)];
    
    label2.backgroundColor=RGBA(148,186,187,1);

    
    [cell.contentView addSubview:label2];
    
    NSNumber *number=[[NSUserDefaults standardUserDefaults]valueForKey:@"resume_selected"];
    
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
    [[NSUserDefaults standardUserDefaults]setObject: number forKey:@"resume_selected"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [myTableView reloadData];
    
    HRJobSortModel *model=[dataArray objectAtIndex:indexPath.row];
    if ([_delegate respondsToSelector:@selector(resumeFilterViewChange:)]) {
        [_delegate resumeFilterViewChange:model];
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
