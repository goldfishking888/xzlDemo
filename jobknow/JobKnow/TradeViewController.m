//
//  TradeViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "TradeViewController.h"
#import "jobRead.h"
#import "EditReader.h"
#import "TipsView.h"
@interface TradeViewController ()

@end

@implementation TradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"编辑订阅器—选择行业"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"编辑订阅器-选择行业"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    _saveArray = [NSMutableArray array];
	self.view.backgroundColor = [UIColor whiteColor];
    //取出数据库中的行业数据
    _jobsArray = [jobRead findAllWith:@"workList"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, 320, iPhone_height - 88) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    UIImageView *navigationView = kNavigation;
    navigationView.frame = kNavigationFrame;
    [self.view addSubview:navigationView];
   
    
    //展开和收起已选择的行业
    UIButton *alreadyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alreadyBtn.frame = CGRectMake(0, 44, iPhone_width , 44);
    [alreadyBtn addTarget:self action:@selector(selectJobs) forControlEvents:UIControlEventTouchUpInside];
    alreadyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [alreadyBtn setTitleColor:RGBA(74, 99, 129, 1) forState:UIControlStateNormal];
    [alreadyBtn setBackgroundColor:RGBA(218, 218, 218, 1)];
    [alreadyBtn setTitle:@"  已选行业" forState:UIControlStateNormal];
    alreadyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:alreadyBtn];
    
    jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(280, 12, 17,17 )];
    jiantou.image = [UIImage imageNamed:@"dictpicker_arrow.png"];
    [alreadyBtn addSubview:jiantou];
    
    fenshu = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 30, 17)];
    fenshu.backgroundColor = [UIColor clearColor];
    fenshu.font = [UIFont systemFontOfSize:15];
    [fenshu setTextColor:RGBA(74, 99, 129, 1)];
    fenshu.text = @"0/5";
    [alreadyBtn addSubview:fenshu];
    
    
    
    
    
    
    //已选择行业
    EditReader *edit = [EditReader standerDefault];
    
    for (jobRead *job in edit.industry)
    {
        [_saveArray addObject:job];
    }
    
    _alreadyTV = [[AlreadyTableView alloc] initWithFrame:CGRectMake(0, 88, iPhone_width, 44*edit.industry.count)];
    _alreadyTV.AlreadyDelegate = self;
    _alreadyTV.selectArray = edit.industry;
    _alreadyTV.alpha = 0;
    [self.view addSubview:_alreadyTV];
    [self.view addSubview:_tableView];
    [self addBackBtn];
    [self addTitleLabel:@"选择行业"];
     [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    //保存按钮
    UIButton *faBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faBtn.frame = CGRectMake(250, 0, 70, 40);
    [faBtn addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faBtn];
    UIButton *fasongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fasongBtn addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"back1_btn@2x .png"] forState:UIControlStateNormal];
    fasongBtn.frame = CGRectMake(iPhone_width-35, 9, 25, 25);
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [self.view addSubview:fasongBtn];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_jobsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        cell.accessoryView = nil;
    }
    

    jobRead *job = [_jobsArray objectAtIndex:indexPath.row];
    if ([EditReader containTheTradeCode:job.code])
    { 
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
        cell.accessoryView = imageV;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = job.name;
    cell.selectionStyle = UITableViewCellAccessoryNone;

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    EditReader *edit = [EditReader standerDefault];
    jobRead *read = [_jobsArray objectAtIndex:indexPath.row];
    if ([EditReader containTheTradeCode:read.code])
    {
        [EditReader deleteTradeWithCode:read.code];
        cell.accessoryView = nil;
    }else
    {
        if (edit.industry.count < 5)
        {
            UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
            cell.accessoryView = imageV;
            if (indexPath.row != 0)
            {

                [EditReader deleteTradeWithCode:@"0000"];
                NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
                UITableViewCell *c = [tableView cellForRowAtIndexPath:index];
                c.accessoryView = nil;
                [edit.industry addObject:read];
            }else
            {
                BOOL l = YES;
                if (edit.jobArray.count == 1)
                {
                    jobRead *j = [edit.jobArray objectAtIndex:0];
                    if ([j.code isEqualToString:@"0000"]) {
                        alert.message = @"请至少选择一个行业类别";
                        [alert show];
                        l = NO;
                        
                    }
                }
                if (l) {
                    [edit.industry removeAllObjects];
                    [edit.industry addObject:read];
                }
                [tableView reloadData];
            }
        }else
        {
            if (indexPath.row == 0)
            {
                BOOL l = YES;
                if (edit.jobArray.count == 1)
                {
                    jobRead *j = [edit.jobArray objectAtIndex:0];
                    if ([j.code isEqualToString:@"0000"]) {
                        alert.message = @"请至少选择一个行业类别";
                        [alert show];
                        l = NO;
                    }
                }
                else
                {
                    jobRead *j = [[jobRead alloc] initWithID:0 JobCode:@"0000" JobName:@"所有行业"];
                    [edit.industry removeAllObjects];
                    [edit.industry addObject:j];
                        [tableView reloadData];
                }
            }else
            {
                alert.message = @"最多只能选择5个";
                [alert show];
            }
        }
    }if (_alreadyTV.alpha == 1)
    {
        [self selectJobs];
        [_alreadyTV reloadData];
    }

    [self fenshuCount];
}


- (void)removeSelected:(jobRead *)job
{
    EditReader *edit = [EditReader standerDefault];
    [EditReader deleteTradeWithCode:job.code];
    _alreadyTV.frame = CGRectMake(0, 88, iPhone_width, 44*edit.industry.count);
    _tableView.frame = CGRectMake(0, 88 + _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height);
    [_alreadyTV reloadData];
    [_tableView reloadData];
    if (_alreadyTV.selectArray.count ==0) {
        [self viewAnimation2];
    }

    [self fenshuCount];
    
}

- (void)selectJobs
{
    EditReader *edit = [EditReader standerDefault];
    _alreadyTV.selectArray = edit.industry;
    [UIView animateWithDuration:0.5 animations:^{_alreadyTV.frame = CGRectMake(0, 88, iPhone_width, 44*edit.industry.count);}];
    [UIView animateWithDuration:0.5 animations:^{_tableView.frame = CGRectMake(0, 88 + _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height);}];
    

    if (_alreadyTV.alpha == 0)
    {
        [self viewAnimation:_tableView frame:CGRectMake(0, 88 + _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height) time:0.5 alph:1];
        
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88, iPhone_width, 44*edit.industry.count) time:0.3 alph:1];
        //动画让他向下
        if (![fenshu.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
    }
    else
    {
        [self viewAnimation:_tableView frame:CGRectMake(0, 88, iPhone_width, iPhone_height - 88) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88, iPhone_width, 44*edit.industry.count) time:0.3 alph:0];
        //动画让他向上
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
    NSString *str = [NSString stringWithFormat:@"%d/5",[_alreadyTV.selectArray count]];
    fenshu.text =str;
}

- (void)backUp:(id)sender
{
    EditReader *edit = [EditReader standerDefault];
    if ([_saveArray isEqualToArray:edit.industry])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有保存当前选定内容，确定返回吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        EditReader *edit = [EditReader standerDefault];
        NSLog(@"---------------------%@",edit.industry);
        [edit.industry removeAllObjects];
        for (jobRead *job in _saveArray) {
            [edit.industry addObject:job];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)saveInfo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self fenshuCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
