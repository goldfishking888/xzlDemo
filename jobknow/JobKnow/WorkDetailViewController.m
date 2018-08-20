//
//  WorkDetailViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-1-28.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "WorkDetailViewController.h"
#import "JobNameViewController.h"
@interface WorkDetailViewController ()

@end

@implementation WorkDetailViewController

@synthesize isEmpty;

- (void)initData
{
    SaveJob *save = [SaveJob standardDefault];
    
    //标记数据,是一个NSMutableDictionary
    self.recordDic = [[NSMutableDictionary alloc]init];
    
    NSArray *keys = [save.jobDic allKeys];
    
    for (NSString *key in keys){
        /**jobNameArr数组中存放的是字典,每个字典中存放着两个键值对,code和name**/
        NSMutableArray *jobNameArr = [[NSMutableArray alloc]initWithArray:[save dicKeyName:key jobKeyName:@"jobName"]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:jobNameArr,@"jobName", nil];
        [self.recordDic setObject:dic forKey:key];
    }
    
    NSLog(@"self.recordDic is %@",self.recordDic);
    
    NSString *jobListPath = [[NSBundle mainBundle] pathForResource:@"jobList" ofType:@"plist"];
    NSString *jobPath = [[NSBundle mainBundle] pathForResource:@"job" ofType:@"plist"];
    
    /**根据工程路径中存放的数据创建两个字典**/
    NSMutableDictionary *jobListDic = [NSMutableDictionary dictionaryWithContentsOfFile:jobListPath];
    NSMutableDictionary *jobDic = [NSMutableDictionary dictionaryWithContentsOfFile:jobPath];
    
    NSArray *jobListArray = [jobListDic valueForKey:@"jobList"];
    
    //NSLog(@"jobListArray is %@",jobListArray);
    
    NSArray *jobArray =  [jobDic valueForKey:@"job"];
    
    //NSLog(@"jobArray is %@",jobArray);
    
    /**jobListArray中存放的是所有的职位类别,用来进行职位界面的职位显示**/
    firstLiveArray = [NSMutableArray arrayWithArray:jobListArray];
    /**jobArray中存放的是每一个职位类别下的职位分类，数组由多个数组组成，每个数组中都存放的是字典**/
    /**其中的字典有code和name两个键值对构成**/
    
    dataArray = [NSMutableArray arrayWithArray:jobArray];//dataArray数据量很大
    
    //NSLog(@"dataArray is %@",dataArray);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setScore];
    
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self addBackBtn];
    [self addTitleLabel:@"选择职业"];
    
    num=ios7jj;
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,88+num,iPhone_width, iPhone_height-88-num) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    /*已选择的职业*/
    UIButton *showJobsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showJobsBtn.frame = CGRectMake(0,44+num,iPhone_width, 44);
    showJobsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    showJobsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [showJobsBtn setTitle:@"  已选职业" forState:UIControlStateNormal];
    [showJobsBtn addTarget:self action:@selector(showJobsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [showJobsBtn setBackgroundColor:[UIColor colorWithRed:236/255. green:236/255. blue:236/255. alpha:1]];
    [showJobsBtn setTitleColor:RGBA(74, 99, 129, 1) forState:UIControlStateNormal];
    [self.view addSubview:showJobsBtn];
    
    jiantouImage = [[UIImageView alloc]initWithFrame:CGRectMake(280,12, 17,17 )];
    jiantouImage.image = [UIImage imageNamed:@"dictpicker_arrow.png"];
    [showJobsBtn addSubview:jiantouImage];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 30, 17)];
    scoreLabel.text = @"0/5";
    scoreLabel.font = [UIFont systemFontOfSize:15];
    scoreLabel.backgroundColor = [UIColor clearColor];
    [scoreLabel setTextColor:RGBA(74, 99, 129, 1)];
    [showJobsBtn addSubview:scoreLabel];
    
    //保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(250,num,70,40);
    [saveBtn addTarget:self action:@selector(saveBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *saveBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn2.frame = CGRectMake(iPhone_width-35,10+num, 25, 25);
    [saveBtn2 addTarget:self action:@selector(saveBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn2 setBackgroundImage:[UIImage imageNamed:@"back1_btn@2x .png"] forState:UIControlStateNormal];
    [saveBtn2 setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [saveBtn2 setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn2];
    
    
    SaveJob *save = [SaveJob standardDefault];
    
    _alreadyTV = [[AlreadyTableView alloc] initWithFrame:CGRectMake(0, 88+num,iPhone_width, 44)];
    _alreadyTV.readJob = YES;
    _alreadyTV.AlreadyDelegate = self;
    _alreadyTV.selectArray = [save allSelectJobInfo];
    _alreadyTV.alpha = 0;
    [self.view addSubview:_alreadyTV];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(_alreadyTV.alpha == 1){
        SaveJob *save = [SaveJob standardDefault];
        _alreadyTV.selectArray = [save allSelectJobInfo];
        _alreadyTV.frame = CGRectMake(0, 88+num, iPhone_width, 44*_alreadyTV.selectArray.count);
        if (_alreadyTV.selectArray.count > 0) {
            NSIndexPath *p = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:p];
            cell.accessoryView = nil;
        }
        _tableView.frame = CGRectMake(0, 88 +num+ _alreadyTV.frame.size.height,iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height);
        [_alreadyTV reloadData];
    }
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择职位（一）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择职业（一）"];
}

#pragma -mark tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL isBuxian=[self isBuxian];
    
    if (isEmpty==YES&&isBuxian==YES) {
        return [firstLiveArray count]-1;
    }else
    {
        return [firstLiveArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }else
    {
        cell.accessoryView = nil;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BOOL isBuxian=[self isBuxian];
    
    if (isEmpty==YES&&isBuxian==YES){
        
        cell.textLabel.text = [firstLiveArray objectAtIndex:indexPath.row+1];
        
    }else
    {
        cell.textLabel.text = [firstLiveArray objectAtIndex:indexPath.row];
        
        SaveJob *save=[SaveJob standardDefault];
        
        //NSLog(@"此处执行了。。。。。。1111111");
        
        NSDictionary *dic;
        NSMutableArray *array=[save dicKeyName:@"不限" jobKeyName:@"jobName"];
        //NSLog(@"此处执行了。。。。。。22222222");
        
        NSLog(@"array is %@",array);
        
        if (array){
            
            if ([array count]!=0) {
                dic=[array objectAtIndex:0];
            }else
            {
                dic=NULL;
            }
        }else
        {
            dic=NULL;
        }
        
        //NSLog(@"此处执行了。。。。。。3333333333");
        
        if (indexPath.row==0){
            
            cell.textLabel.textColor= RGBA(40, 100, 210, 1);
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (dic) {
                cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
                
            }else
            {
                cell.accessoryView=nil;
            }
        }else
        { 
            cell.textLabel.textColor=[UIColor blackColor];
        }
    }
    
    if (IOS7) {
        
    }else
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isBuxian=[self isBuxian];
    
    if (isBuxian==YES&&isEmpty==YES) {
        
        firstLiveStr = [firstLiveArray objectAtIndex:indexPath.row+1];//得到的是一个总的职位名。
        
        detailJobArray = [dataArray objectAtIndex:indexPath.row+1];//每个职位名下对应的数组
        
        JobNameViewController *jobNameVC = [[JobNameViewController alloc]init];
        NSArray *arr = [self.navigationController viewControllers];
        
        NSLog(@"arr in  WorkDetailVC and didSelectRowAtIndexPath %@",arr);
        
        jobNameVC.delegate=[arr objectAtIndex:arr.count-2];
        jobNameVC.jobItem=firstLiveStr;
        jobNameVC.dataArray=detailJobArray;
        [self.navigationController pushViewController:jobNameVC animated:YES];
        
        
    }else
    {
        if (indexPath.row>0) {
            
            firstLiveStr = [firstLiveArray objectAtIndex:indexPath.row];//得到的是一个总的职位名。
            
            detailJobArray = [dataArray objectAtIndex:indexPath.row];//每个职位名下对应的数组
            
            JobNameViewController *jobNameVC = [[JobNameViewController alloc]init];
            NSArray *arr = [self.navigationController viewControllers];
            
            NSLog(@"arr in  WorkDetailVC and didSelectRowAtIndexPath %@",arr);
            
            jobNameVC.delegate=[arr objectAtIndex:arr.count-2];
            jobNameVC.jobItem=firstLiveStr;
            jobNameVC.dataArray=detailJobArray;
            [self.navigationController pushViewController:jobNameVC animated:YES];
            
        }else if(indexPath.row==0)
        {
            
            NSLog(@"当indexPath.row==0的时候执行到了。。。。。。");
            
            //判断不限是否已经存放在
            
            SaveJob *save=[SaveJob standardDefault];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            NSDictionary *dic=[[dataArray objectAtIndex:indexPath.row]objectAtIndex:0];
            
            NSLog(@"dic in indexPath.row==0 is %@",dic);
            
            if ([[save dicKeyName:@"不限" jobKeyName:@"jobName"]containsObject:dic]) {
                
                NSLog(@"不限在saveJob中。。。。。。。。");
                
                cell.accessoryView = nil;
                //删除职业信息
                [[save dicKeyName:@"不限" jobKeyName:@"jobName"] removeObject:dic];
                
                [save.jobDic removeObjectForKey:@"不限"];
                
                
            }else
            {
                NSLog(@"不限不在saveJob中。。。。。。。。");
                
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
                
                [save.jobDic removeAllObjects];
                
                [save exsitNameKey:@"不限"];
                
                
                [[save dicKeyName:@"不限" jobKeyName:@"jobName"] addObject:dic];
            }
        }
    }
    
    if (_alreadyTV.alpha==1) {
        
        [self showJobsBtnClick];
    }
    
    [self setScore];
}

- (void)backUp:(id)sender
{
    SaveJob *save = [SaveJob standardDefault];
    //返回时，判断职业数据是否发生改变
    if ([self compare:save.jobDic otherDic:self.recordDic])
    {
        
        if ([_delegate respondsToSelector:@selector(workDetailChange)]){
            [_delegate workDetailChange];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有保存当前选定内容，确定返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert1 show];
    }
}

//比较两个字典
- (BOOL)compare:(NSMutableDictionary *)dic otherDic:(NSMutableDictionary *)otherDic
{
    
    
    NSArray *keys = [dic allKeys];
    //比较两个字典的key是否相同
    if ([[dic allKeys] isEqualToArray:[otherDic allKeys]]) {
        for (int i = 0; i < keys.count; i++)
        {
            NSString *key = [keys objectAtIndex:i];
            NSArray *arr1 = [[dic valueForKey:key] valueForKey:@"imageName"];
            NSArray *arr2 = [[otherDic valueForKey:key] valueForKey:@"imageName"];
            //比较字典内的数组是否相同
            if (arr1.count == arr2.count)
            {
                for (int j = 0; j<arr2.count; j++) {
                    jobRead *j1 = [arr2 objectAtIndex:j];
                    jobRead *j2 = [arr1 objectAtIndex:j];
                    if (![j2.name isEqualToString:j1.name]) {
                        return NO;
                    }
                }
                
            }else
            {
                return NO;
            }
        }
        //相同返回yes
        return YES;
    }
    
    return NO;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SaveJob *save = [SaveJob standardDefault];
    //确定不保存返回
    if (buttonIndex == 1) {
        save.jobDic = nil;
        //初始化jobDic
        save.jobDic = [[NSMutableDictionary alloc]init];
        
        NSArray *keys = [self.recordDic allKeys];
        //遍历上次选择的职位，并将职位添加进jobDic
        for (NSString *key in keys)
        {
            [save.jobDic setObject:[self.recordDic valueForKey:key] forKey:key];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showJobsBtnClick
{
    SaveJob *save = [SaveJob standardDefault];
    
    _alreadyTV.frame = CGRectMake(0, 88+num, iPhone_width, [[save allSelectJob] count]*44);
    _alreadyTV.selectArray = [save allSelectJobInfo];
    if (_alreadyTV.alpha == 0)
    {
        
        [self viewAnimation:_tableView frame:CGRectMake(0, 88 +num+ _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88+num, iPhone_width, [[save allSelectJob] count]*44) time:0.3 alph:1];
        //动画让他向下
        if (![scoreLabel.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
        
    }else
    {
        //_tableView.frame = CGRectMake(0, 88, iPhone_width, iPhone_height - 88);
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-num) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88+num, iPhone_width, [[save allSelectJob] count]*44) time:0.3 alph:0];
        //动画让他向下
        if (![scoreLabel.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
        
    }
    [_alreadyTV reloadData];
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

- (void)viewAnimation2
{
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(jiantouImage.transform,M_PI/1);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.3];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [jiantouImage setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}

- (void)setScore
{
    SaveJob *save = [SaveJob standardDefault];
    NSString *str = [NSString stringWithFormat:@"%d/5",[[save allSelectJob] count]];
    scoreLabel.text =str;
}

- (void)removeSelectedJob:(NSDictionary *)dic
{
    SaveJob *save = [SaveJob standardDefault];
    [save deleteSelectJob:dic];
    _alreadyTV.selectArray = [save allSelectJobInfo];
    _alreadyTV.frame = CGRectMake(0, 88+num, iPhone_width, 44*_alreadyTV.selectArray.count);
    _tableView.frame = CGRectMake(0, 88 +num+ _alreadyTV.frame.size.height, iPhone_width, iPhone_height - _alreadyTV.frame.size.height - 88-num);
    if (_alreadyTV.selectArray.count ==0) {
        [self viewAnimation2];
    }
    [self setScore];
    
    [_alreadyTV reloadData];
    [_tableView reloadData];
}

- (void)saveBtnclick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(workDetailChange)]) {
        
        [_delegate workDetailChange];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)isBuxian
{
    SaveJob *save=[SaveJob standardDefault];
    
    for (int i=0;i<[save.saveArr count];i++) {
        
        jobRead *read=[save.saveArr objectAtIndex:i];
        
        if ([read.name isEqualToString:@"不限"]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end