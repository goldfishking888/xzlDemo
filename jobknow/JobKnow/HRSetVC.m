//
//  HRSetVC.m
//  JobKnow
//
//  Created by Mathias on 15/7/9.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HRSetVC.h"
#import "CustomSetCell.h"
@interface HRSetVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrays;
    NSMutableArray *arrayP;
    UIButton* switchs;
    BOOL isOn;
    
    UITableView *hrtableView;
}
@end

@implementation HRSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackBtn];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:243 green:243 blue:243 alpha:1];
    
     hrtableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width-20, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    
    hrtableView.scrollEnabled=NO;
     hrtableView.dataSource=self;
    hrtableView.delegate=self;
    hrtableView.separatorColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:1];
  
    
    hrtableView.backgroundColor=[UIColor colorWithRed:243 green:243 blue:243 alpha:1];
    //图片
    NSArray*array11=[[NSArray alloc]initWithObjects:@"hr_psd", nil];
    
    NSArray *array22=[[NSArray alloc]initWithObjects:@"hr_set_trend", nil];
    
    NSArray *array33=[[NSArray alloc]initWithObjects:@"hr_set_share", @"hr_feedback", @"hr_update", @"hr_question", nil];
    
    NSArray *array44=[[NSArray alloc]initWithObjects:@"hr_logout", nil];
    
    
    arrayP=[[NSMutableArray alloc]initWithObjects:array11,array22,array33,array44, nil];
    
    
    
    
    NSArray*array1=[[NSArray alloc]initWithObjects:@"修改密码", nil];
    
    NSArray *array2=[[NSArray alloc]initWithObjects:@"推荐动态开关", nil];
    
    NSArray *array3=[[NSArray alloc]initWithObjects:@"分享给朋友", @"反馈意见", @"检查更新", @"常见问题", nil];
    
    NSArray *array4=[[NSArray alloc]initWithObjects:@"退出登录", nil];
   
    
    arrays=[[NSMutableArray alloc]initWithObjects:array1,array2,array3,array4, nil];
    
    
    
    [self.view addSubview:hrtableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array=[arrays objectAtIndex:section];
    
    return array.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     static NSString *CellIdentifier = @"Cell";
    
     CustomSetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
     if (cell == nil) {
    
         NSLog(@"创建新的");
     cell = [[CustomSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
      
      
     }
    
        cell.labels.text=[[arrays objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
         NSString*picture= [[arrayP objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    cell.imageViews.image=[UIImage imageNamed:picture];
    
    
    cell.backgroundColor= [UIColor colorWithRed:243 green:243 blue:243 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(indexPath.section==0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section==2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.section==1){
        
        switchs=[UIButton buttonWithType:UIButtonTypeSystem];
         switchs.frame=  CGRectMake([[UIScreen mainScreen] bounds].size.width-80, 10, 40, 20);
        
        [switchs setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        
        [switchs addTarget:self action:@selector(kaiguan:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = switchs;
        
    }
  
    
    
     
    
    
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arrays.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    
    if(section==0){
        return 0;
    }else{
      return 20;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSString*str= [[arrays objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    NSLog(@"%@",str);
    
    
    
}
//开关
-(void)kaiguan:(UIButton *)sender{
    
    NSLog(@"hellow");
    if (!isOn) {
        [switchs setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        isOn=!isOn;
    }else{
        
        [switchs setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        isOn=!isOn;
    }
    
    

    
    
    
    
}
@end
