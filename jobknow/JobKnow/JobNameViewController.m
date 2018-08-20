//
//  JobNameViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-1-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "JobNameViewController.h"
#import "TipsView.h"

@interface JobNameViewController ()

@end

@implementation JobNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear执行到了。。。");
    
    SaveJob *save = [SaveJob standardDefault];
    //如果当前选择的职位类别下之前没有选择其中任何一项
    if ([[save dicKeyName:_jobItem jobKeyName:@"jobName"] count] == 0) {
        //删除save中保存的jobDic中key为_jobItem的那一项
        [save.jobDic removeObjectForKey:_jobItem];
    }
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择职业（二）"];
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"viewDidAppear执行到了。。。");
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择职业（二）"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"viewWillAppear执行到了。。。");
    
    [self setScore];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"选择职业"];
    
    NSLog(@"viewDidLoad执行到了。。。");
    
    num=ios7jj;
    
    SaveJob *save = [SaveJob standardDefault];
    
    //将当前_jobItem作为键存放到saveJob的jobDic中
    [save exsitNameKey:_jobItem];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    //已经选择的职业
    UIButton *showJobsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    showJobsBtn.frame = CGRectMake(0, 44+num, iPhone_width, 44);
    showJobsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    showJobsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [showJobsBtn setTitle:@"  已选职业" forState:UIControlStateNormal];
    [showJobsBtn addTarget:self action:@selector(showJobsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [showJobsBtn setTitleColor:RGBA(74, 99, 129, 1) forState:UIControlStateNormal];
    [showJobsBtn setBackgroundColor:[UIColor colorWithRed:236/255. green:236/255. blue:236/255. alpha:1]];
    [self.view addSubview:showJobsBtn];
    
    //已选择的职业按钮上的箭头
    jiantouImage = [[UIImageView alloc]initWithFrame:CGRectMake(280, 12, 17,17 )];
    jiantouImage.image = [UIImage imageNamed:@"dictpicker_arrow.png"];
    [showJobsBtn addSubview:jiantouImage];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 30, 17)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont systemFontOfSize:15];
    [scoreLabel setTextColor:RGBA(74, 99, 129, 1)];
    scoreLabel.text = @"0/5";
    [showJobsBtn addSubview:scoreLabel];
    
    //保存按钮,保存选中的职业。
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(250, 0, 70, 40);
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    UIButton *saveBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn2 addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn2 setBackgroundImage:[UIImage imageNamed:@"back1_btn@2x .png"] forState:UIControlStateNormal];
    saveBtn2.frame = CGRectMake(iPhone_width-35, 9, 25, 25);
    [saveBtn2 setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [saveBtn2 setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn2];
    
    _myTableView = [[UITableView alloc]init];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    
    //[save allSelectJobInfo]得到一个数组。里面存放的是字典
    
    _alreadyTV = [[AlreadyTableView alloc] init];
    _alreadyTV.readJob = YES;
    _alreadyTV.AlreadyDelegate = self;
    _alreadyTV.selectArray = [save allSelectJobInfo];
    _alreadyTV.alpha = 0;
    [self.view addSubview:_alreadyTV];
    [self.view addSubview:_myTableView];
    
    if (IOS7){
        saveBtn.frame = CGRectMake(250,20,70, 40);
        saveBtn2.frame = CGRectMake(iPhone_width-35,29, 25, 25);
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,108,iPhone_width, iPhone_height - 88) ];
        _alreadyTV = [[AlreadyTableView alloc] initWithFrame:CGRectMake(0,108,iPhone_width,44)];
    }else
    {
        saveBtn.frame = CGRectMake(250,5,70, 40);
        saveBtn2.frame = CGRectMake(iPhone_width-35,10, 25, 25);
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,88,iPhone_width, iPhone_height - 88) ];
        _alreadyTV = [[AlreadyTableView alloc] initWithFrame:CGRectMake(0,88,iPhone_width,44)];
    }
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _alreadyTV.readJob = YES;
    _alreadyTV.AlreadyDelegate = self;
    _alreadyTV.selectArray = [save allSelectJobInfo];
    _alreadyTV.alpha = 0;
    [self.view addSubview:_alreadyTV];
    [self.view addSubview:_myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdent = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }else
    {
        // cell.accessoryView = nil;
    }
    
    SaveJob *save = [SaveJob standardDefault];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    
    //从saveJob中得到表示职业的数组
    NSArray *jobsarray = [save dicKeyName:_jobItem jobKeyName:@"jobName"];
    
    if ([jobsarray containsObject:dic]) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
    }else
    {
        cell.accessoryView=nil;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.row == 0) {
        cell.textLabel.textColor = RGBA(40, 100, 210, 1);
    }else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if (IOS7) {
        
    }else
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    
    return cell;
}

//tableview点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    SaveJob *save = [SaveJob standardDefault];
    
    if ([[save dicKeyName:self.jobItem jobKeyName:@"jobName"]containsObject:[_dataArray objectAtIndex:indexPath.row]]){
        
        cell.accessoryView = nil;
        //删除职业信息
        [[save dicKeyName:self.jobItem jobKeyName:@"jobName"] removeObject:[_dataArray objectAtIndex:indexPath.row]];
        
    }else
    {
        //如果之前没有选中当前选项
        
        if (indexPath.row == 0)
        {
            [[save dicKeyName:_jobItem jobKeyName:@"jobName"] removeAllObjects];
            [self performSelector:@selector(reloadDataTableView:) withObject:self afterDelay:0.3];
        }
        
        if ([save allNumber] < 5){
            
            //将当前页面第一个删除
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell0 = [tableView cellForRowAtIndexPath:index];
            cell0.accessoryView = nil;
            [[save dicKeyName:self.jobItem jobKeyName:@"jobName"] removeObject:[_dataArray objectAtIndex:0]];
            
            //删除不限
            NSMutableArray *jobArr = [[save.jobDic valueForKey:@"不限"]valueForKey:@"jobName"];
            NSDictionary *subJob = [NSDictionary dictionaryWithObjectsAndKeys:@"0000",@"code",@"不限",@"name", nil];
            [jobArr removeObject:subJob];
            
            //添加职业信息
            [[save dicKeyName:_jobItem jobKeyName:@"jobName"] addObject:[_dataArray objectAtIndex:indexPath.row]];
            
        }else{
            ghostView.message = @"最多只能选择5个";
            [ghostView show];
        }
    }
    
    if (_alreadyTV.alpha == 1){
        
        [self showJobsBtnClick];
    }
    
    [self setScore];
}

- (void)reloadDataTableView:(id)sender
{
    [_myTableView reloadData];
}

- (void)showJobsBtnClick
{
    SaveJob *save = [SaveJob standardDefault];
    
    _alreadyTV.frame = CGRectMake(0,88+num , iPhone_width,[[save allSelectJob] count]*44);
    
    _alreadyTV.selectArray = [save allSelectJobInfo];
    
    if (_alreadyTV.alpha == 0)
    {
        [self viewAnimation:_myTableView frame:CGRectMake(0,88+num+ _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height-num) time:0.5 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0,88+num, iPhone_width, [[save allSelectJob] count]*44) time:0.3 alph:1];
        
        //动画让他向下
        if (![scoreLabel.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
        
    }else
    {
        
        [self viewAnimation:_myTableView frame:CGRectMake(0,88+num, iPhone_width, iPhone_height - 88-num) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0,88+num,iPhone_width, [[save allSelectJob] count]*44) time:0.3 alph:0];
        
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
    NSString *str = [NSString stringWithFormat:@"%d/5",[save allNumber]];
    scoreLabel.text =str;
}

- (void)removeSelectedJob:(NSDictionary *)dic
{
    SaveJob *save = [SaveJob standardDefault];
    [save deleteSelectJob:dic];
    _alreadyTV.selectArray = [save allSelectJobInfo];
    
    _alreadyTV.frame = CGRectMake(0,88+num, iPhone_width, 44*_alreadyTV.selectArray.count);
    _myTableView.frame = CGRectMake(0,88+num+ _alreadyTV.frame.size.height, iPhone_width, iPhone_height - _alreadyTV.frame.size.height -88-num);
    
    if (_alreadyTV.selectArray.count ==0) {
        [self viewAnimation2];
    }
    [self setScore];
    [_alreadyTV reloadData];
    [_myTableView reloadData];
}

- (void)saveBtnClick:(id)sender
{
    
    //保存成功之后，实现ReadViewController的代理方法
    if ([self.delegate respondsToSelector:@selector(JobNameViewChange)]){
        [self.delegate JobNameViewChange];
    }
    
    NSArray *arr = [self.navigationController viewControllers];
    
    //进入ReadViewController界面
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:arr.count - 3] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end