//
//  JobItemViewController.m
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "JobItemViewController.h"
#import "EditReader.h"
@interface JobItemViewController ()

@end

@implementation JobItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _enter = YES;
        // Custom initialization
        num = ios7jj;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_alTableView.alpha == 1) {
        EditReader *edit = [EditReader standerDefault];
        _alTableView.frame = CGRectMake(0, 88+num, iPhone_width, _alTableView.selectArray.count*44);
        _alTableView.selectArray = edit.jobArray;
        [_alTableView reloadData];
    }
    
    [_tableView reloadData];
    [self fenshuCount];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"编辑订阅器-选择职业（一）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"编辑订阅器-选择职业（一）"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    EditReader *edit = [EditReader standerDefault];
    [edit.jobOtherArray removeAllObjects];
    for (jobRead *read in edit.jobArray) {
        [edit.jobOtherArray addObject:read];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-num) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"jobList" ofType:@"plist"];
    
    NSString *p = [[NSBundle mainBundle] pathForResource:@"job" ofType:@"plist"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:p];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithContentsOfFile:srcPath];
    
    NSArray *job = [dic valueForKey:@"job"];
    NSArray *list = [result valueForKey:@"jobList"];
    
    _dataArray = [NSMutableArray arrayWithArray:list];

    
    //取出职业数据
    _detailJob = [NSMutableArray arrayWithArray:job];
    if (!_enter) {
        [EditReader deleteJobWithCode:@"0000"];
        [_detailJob removeObjectAtIndex:0];
        [_dataArray removeObjectAtIndex:0];
    }
    
    
    //已选择的职业
    UIButton *showJobs = [UIButton buttonWithType:UIButtonTypeCustom];
    showJobs.frame = CGRectMake(0, 44+num, iPhone_width, 44);
    showJobs.titleLabel.font = [UIFont systemFontOfSize:15];
    showJobs.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [showJobs setTitle:@"   已选职业" forState:UIControlStateNormal];
    [showJobs addTarget:self action:@selector(selectJobs) forControlEvents:UIControlEventTouchUpInside];
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
    
    
    
    //已选职业
    _alTableView = [[AlreadyTableView alloc]initWithFrame:CGRectMake(0, 88+num, iPhone_width,  edit.jobArray.count*44)];
    _alTableView.AlreadyDelegate = self;
    _alTableView.selectArray = edit.jobArray;
    _alTableView.alpha = 0;
    [self.view addSubview:_alTableView];
    [self.view addSubview:_tableView];
    //NSLog(@"---------------------%@",edit.jobArray);
    [self addBackBtn];
    [self addTitleLabel:@"选择职业"];
    [self.backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];

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
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        cell.accessoryView = nil;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (_enter) {
        if (indexPath.row == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([EditReader containTheCode:@"0000"])
            {
                UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
                cell.accessoryView = imageV;
            }
        }
    }

    cell.selectionStyle = UITableViewCellAccessoryNone;

    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_enter) {
        JobNameDetailViewController *jobDetailVC = [[JobNameDetailViewController alloc] init];
        //得到当前点击的职位信息，并传递到下一界面
        NSArray *array = [_detailJob objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:jobDetailVC animated:YES];
        [jobDetailVC setTableArray:array];
    }else{
    //判断当前点击是否为第一个
    if (indexPath.row !=0) {
        //不是，则进入下一个界面
        JobNameDetailViewController *jobDetailVC = [[JobNameDetailViewController alloc] init];
        //得到当前点击的职位信息，并传递到下一界面
        NSArray *array = [_detailJob objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:jobDetailVC animated:YES];
        [jobDetailVC setTableArray:array];
    }else
    {
            EditReader *edit = [EditReader standerDefault];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (edit.industry.count == 1) {
                jobRead *j = [edit.industry objectAtIndex:0];
                if ([j.code isEqualToString:@"0000"]) {
                    alert.message = @"请至少选择一个职业类别";
                    [alert show];
                }
            }
            else
            {
                if ([EditReader containTheCode:@"0000"])
                {
                    [EditReader deleteJobWithCode:@"0000"];
                    cell.accessoryView = nil;
                }
                else
                {
                    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
                    [edit.jobArray removeAllObjects];
                    cell.accessoryView = imageV;
                    jobRead *read = [[jobRead alloc] initWithID:0 JobCode:@"0000" JobName:@"所有职业"];
                    [edit.jobArray addObject:read];
                }
                if (_alTableView.alpha == 1) {
                    [self selectJobs];
                    [_alTableView reloadData];
         
                }
            }
        }
    }
    [self fenshuCount];
}

#pragma -mark AlreadTableView的代理方法
- (void)removeSelected:(jobRead *)job
{
    EditReader *edit = [EditReader standerDefault];
    
    //删除职业job
    [EditReader deleteJobWithCode:job.code];
    _alTableView.selectArray = edit.jobArray;
    //改变_alTableView的大小
    _alTableView.frame = CGRectMake(0, 88+num, iPhone_width, _alTableView.selectArray.count*44);
    _tableView.frame = CGRectMake(0, 88 +num+ _alTableView.frame.size.height, iPhone_width, iPhone_height - 88 - _alTableView.frame.size.height);
    
    [_alTableView reloadData];
    [self.tableView reloadData];
    if (_alTableView.selectArray.count ==0) {
        [self viewAnimation2];
    }

    [self fenshuCount];
}


- (void)selectJobs
{
    EditReader *edit = [EditReader standerDefault];
    
    [UIView animateWithDuration:0.5 animations:^{_alTableView.frame = CGRectMake(0, 88+num, iPhone_width, _alTableView.selectArray.count*44);}];
    _alTableView.selectArray = edit.jobArray;
    if (_alTableView.alpha == 0)
    {
        _alTableView.alpha = 1;
      //  _tableView.frame = CGRectMake(0, 88 + _alTableView.frame.size.height, iPhone_width, iPhone_height - 88 - _alTableView.frame.size.height);
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num + _alTableView.frame.size.height, iPhone_width, iPhone_height - 88 - _alTableView.frame.size.height-num) time:0.5 alph:1];
        [self viewAnimation:_alTableView frame:CGRectMake(0, 88+num, iPhone_width, _alTableView.selectArray.count*44) time:0.5 alph:1];
        //动画让他向下
        if (![fenshu.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
    }else
    {
       
       // _tableView.frame = CGRectMake(0, 88, iPhone_width, iPhone_height - 88);
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-num) time:0.5 alph:1];
        [self viewAnimation:_alTableView frame:CGRectMake(0, 88+num, iPhone_width, _alTableView.selectArray.count*44) time:0.5 alph:0];
        //动画让他向下
        if (![fenshu.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
    }
    [_alTableView reloadData];
    
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
    NSString *str = [NSString stringWithFormat:@"%d/5",_alTableView.selectArray.count];
    fenshu.text =str;
}

- (void)saveInfo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)backUp:(id)sender
{
    EditReader *edit = [EditReader standerDefault];
    if ([edit.jobArray isEqualToArray:edit.jobOtherArray])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有保存当前选定内容，确定返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    EditReader *edit = [EditReader standerDefault];
    if (buttonIndex == 1)
    {
        [edit.jobArray removeAllObjects];
        for (jobRead *read in edit.jobOtherArray)
        {
            [edit.jobArray addObject:read];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
