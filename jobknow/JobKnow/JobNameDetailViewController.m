//
//  JobNameDetailViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-2-26.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "JobNameDetailViewController.h"
#import "jobRead.h"
#import "EditReader.h"
#import "TipsView.h"
@interface JobNameDetailViewController ()

@end

@implementation JobNameDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        num = ios7jj;
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"编辑订阅器-选择职业（二）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"编辑订阅器-选择职业（二）"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88+num, 320, iPhone_height-88-num)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _jobSelectArray = [[NSMutableArray alloc]init];
    
    UIImageView *navigationView = kNavigation;
    navigationView.frame = kNavigationFrame;
    [self.view addSubview:navigationView];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    
    //已选择的职业
    UIButton *showJobs = [UIButton buttonWithType:UIButtonTypeCustom];
    showJobs.frame = CGRectMake(0, 44+num, iPhone_width, 44);
    showJobs.titleLabel.font = [UIFont systemFontOfSize:15];
    showJobs.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [showJobs setTitle:@"  已选职业" forState:UIControlStateNormal];
    [showJobs addTarget:self action:@selector(alreadySelectJobs:) forControlEvents:UIControlEventTouchUpInside];
    [showJobs setTitleColor:RGBA(74, 99, 129, 1) forState:UIControlStateNormal];
    [showJobs setBackgroundColor:RGBA(218, 218, 218, 1)];
    [self.view addSubview:showJobs];
    
    jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(280, 12, 17,17 )];
    jiantou.image = [UIImage imageNamed:@"dictpicker_arrow.png"];
    [showJobs addSubview:jiantou];
    
    fenshu = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 30, 17)];
    fenshu.backgroundColor = [UIColor clearColor];
    fenshu.font = [UIFont systemFontOfSize:15];
    [fenshu setTextColor:RGBA(74, 99, 129, 1)];
    fenshu.text = @"0/5";
    [showJobs addSubview:fenshu];
    
    _alreadyTV = [[AlreadyTableView alloc] initWithFrame:CGRectMake(0, 88+num, iPhone_width, 0)];
    EditReader *edit = [EditReader standerDefault];
    _alreadyTV.AlreadyDelegate = self;
    _alreadyTV.selectArray = edit.jobArray;
    _alreadyTV.alpha = 0;
    [self.view addSubview:_alreadyTV];
    [self.view addSubview:_tableView];
    
    [self addBackBtn];
    [self addTitleLabel:@"选择职业"];
    //保存按钮
    UIButton *faBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faBtn.frame = CGRectMake(250, 0+num, 70, 40);
    [faBtn addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faBtn];
    UIButton *fasongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fasongBtn addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"back1_btn@2x .png"] forState:UIControlStateNormal];
    fasongBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [self.view addSubview:fasongBtn];
    
}


- (void)alreadySelectJobs:(id)sender
{
    [self selectJobs];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        cell.accessoryView = nil;
    }
    NSDictionary *dic =  [_tableArray objectAtIndex:indexPath.row];
    NSString *code = [dic valueForKey:@"code"];
    
    if ([EditReader containTheCode:code]) {
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
        cell.accessoryView  = imageV;
    }
    if (indexPath.row == 0) {
        cell.textLabel.textColor = RGBA(40, 100, 210, 1);
    }else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.textLabel.text = [dic valueForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditReader *edit = [EditReader standerDefault];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic =  [_tableArray objectAtIndex:indexPath.row];
    NSString *code = [dic valueForKey:@"code"];
    //判断当前点击的选项是否已选
    if ([EditReader containTheCode:code])
    {
        //已选则删除
        [EditReader deleteJobWithCode:code];
        cell.accessoryView = nil;
    }else
    {
        if (indexPath.row == 0) {
            jobRead *j = [[jobRead alloc] initWithID:0 JobCode:@"0000" JobName:@"所有行业"];
            //[edit.jobArray removeAllObjects];
            
            for (NSInteger i = 1; i< self.tableArray.count; i++) {
                NSDictionary *dic = [_tableArray objectAtIndex:i];
                NSString *code = [dic valueForKey:@"code"];
                [EditReader deleteJobWithCode:code];
            }
            if (edit.jobArray.count<5) {
                [edit.jobArray addObject:j];
            }else
            {
                alert.message = @"最多只能选择5个";
                [alert show];
            }
            
            [tableView reloadData];
        }//未选并且已选择的职业小于五个则添加
        if (edit.jobArray.count < 5)
        {
            jobRead *job = [[jobRead alloc]init];
            job.code = code;
            job.name = [dic valueForKey:@"name"];
            [edit.jobArray addObject:job];
            UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
            cell.accessoryView  = imageV;
            [EditReader deleteJobWithCode:@"0000"];
            if (indexPath.row == 0)
            {
                for (NSDictionary *dic in _tableArray)
                {
                    NSString *code = [dic valueForKey:@"code"];
                    [EditReader deleteJobWithCode:code];
                }
                [edit.jobArray addObject:job];
                [self performSelector:@selector(tableViewReload:) withObject:self afterDelay:0.2];
            }
            else
            {
                NSIndexPath *ind = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *c = [tableView cellForRowAtIndexPath:ind];
                c.accessoryView = nil;
                NSDictionary *dic =  [_tableArray objectAtIndex:0];
                NSString *code = [dic valueForKey:@"code"];
                [EditReader deleteJobWithCode:code];
            }
        }
        else{
            alert.message = @"最多只能选择5个";
            [alert show];
            
        }
        
    }
    if (_alreadyTV.alpha == 1)
    {
        [self selectJobs];
    }
    [self fenshuCount];
}

- (void)tableViewReload:(id)sender
{
    [self.tableView reloadData];
}


- (void)selectJobs
{
    EditReader *edit = [EditReader standerDefault];
    _alreadyTV.frame = CGRectMake(0, 88+num, iPhone_width, _alreadyTV.selectArray.count*44);
    _alreadyTV.selectArray = edit.jobArray;
    if (_alreadyTV.alpha == 0)
    {
        
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num + _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height-num) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88+num, iPhone_width, _alreadyTV.selectArray.count*44) time:0.5 alph:1];
        //动画让他向下
        if (![fenshu.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
        
    }else
    {
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-num) time:0.3 alph:1];
        // _tableView.frame = CGRectMake(0, 88, iPhone_width, iPhone_height - 88);
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88+num, iPhone_width, _alreadyTV.selectArray.count*44) time:0.5 alph:0];
        //动画让他向下
        if (![fenshu.text isEqual:@"0/5"]) {
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
    transform = CGAffineTransformRotate(jiantou.transform,M_PI/1);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.3];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [jiantou setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}
- (void)fenshuCount
{
    NSString *str = [NSString stringWithFormat:@"%d/5",_alreadyTV.selectArray.count];
    fenshu.text =str;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self fenshuCount];
}

#pragma -mark AlreadTableView的代理方法
- (void)removeSelected:(jobRead *)job
{
    EditReader *edit = [EditReader standerDefault];
    //删除职业job
    [EditReader deleteJobWithCode:job.code];
    _alreadyTV.selectArray = edit.jobArray;
    //改变_alTableView的大小
    _alreadyTV.frame = CGRectMake(0, 88+num, iPhone_width, _alreadyTV.selectArray.count*44);
    _tableView.frame = CGRectMake(0, 88+num + _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height);
    [_alreadyTV reloadData];
    [_tableView reloadData];
    if (_alreadyTV.selectArray.count ==0) {
        [self viewAnimation2];
    }
    
    [self fenshuCount];
}


- (void)saveInfo:(id)sender
{
    
    NSArray *arr = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:arr.count - 3] animated:YES];
}

- (void)backUpPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
