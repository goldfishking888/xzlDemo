//
//  XZLJobVC.m
//  XzlEE
//
//  Created by ralbatr on 14-9-22.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import "XZLJobVC.h"
#import "XZLLocaRead.h"
#import "MBProgressHUD.h"

@interface XZLJobVC ()


@end

@implementation XZLJobVC
@synthesize jobTableView = _jobTableView;
//@synthesize alreadyTV = _alreadyTV;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
//    [self addRightkBtn:@"ic_action_ok.png"];
    [self addTitleLabel:@"选择行业"];
    self.rightBtn.frame = CGRectMake(iPhone_width - 45, 26, 31, 31);



    
    //提醒试图
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    //表格
    _jobTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, iPhone_width, self.view.frame.size.height-108) style:UITableViewStylePlain];
    _jobTableView.delegate = self;
    _jobTableView.dataSource = self;
    
    
    [self.view addSubview:_jobTableView];
    
    //数组初始化
    dataArray = [[NSMutableArray alloc] init];
    saveArray = [[NSMutableArray alloc] init];
    _alreadyTV.selectArray = [[NSMutableArray alloc] init];
    
    
    //读取plist文件（行业）
    NSString *plistpath = [[NSBundle mainBundle] pathForResource:@"hr_choosejobList" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistpath];
    dataArray = [dictionary objectForKey:@"jobList"];
    
    
    //已选行业的按钮
    UIButton *showJobsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showJobsBtn.frame = CGRectMake(0,64,self.view.frame.size.width, 44);
    showJobsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    showJobsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [showJobsBtn setTitle:@"  已选行业" forState:UIControlStateNormal];
    [showJobsBtn setTitleColor:RGBA(74, 99, 129, 1) forState:UIControlStateNormal];
    [showJobsBtn setBackgroundColor:[UIColor colorWithRed:236/255. green:236/255. blue:236/255. alpha:1]];
    [showJobsBtn addTarget:self action:@selector(showJobsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showJobsBtn];
    
    
    
//已选行业按钮上的箭头
    jiantouImage = [[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 17,17)];
    jiantouImage.image = [UIImage imageNamed:@"ic_arrow_up.png"];
    [showJobsBtn addSubview:jiantouImage];
    
//选择行业个数label
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 30, 17)];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.font = [UIFont systemFontOfSize:15];
    [scoreLabel setTextColor:RGBA(74, 99, 129, 1)];
    scoreLabel.text = @"0/5";
    
    
    XZLsaveJob *save = [XZLsaveJob standardDefault];
    if (save.saveArr.count >=1) {
        scoreLabel.text = [NSString stringWithFormat:@"%d/5",save.saveArr.count];
    }
    else{
        scoreLabel.text = [NSString stringWithFormat:@"%d/5",saveArray.count];}
    [showJobsBtn addSubview:scoreLabel];
    
    
    
    
    if (save.saveArr.count>=1) {
        
        _alreadyTV.selectArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i<save.saveArr.count; i++) {
            NSString *str = save.saveArr[i];
            [_alreadyTV.selectArray addObject:str];
        }
        
        
    }
    else{
        _alreadyTV.selectArray = saveArray;
        
    }
    
    
    
    
    _alreadyTV.alpha = 0;
    _alreadyTV = [[XZLAlreadyTableView alloc] initWithFrame:CGRectMake(0, 108, iPhone_width, saveArray.count*44)];
    
    _alreadyTV.XZLAlreadyDelegate = self;
    
    [self showJobsBtnClick];
    
    [self.view addSubview:_alreadyTV];
    
    
    // Do any additional setup after loading the view.
}

- (void)removeSelectedjob:(NSString *)jobstr
{
    
    XZLsaveJob *save = [XZLsaveJob standardDefault];
    
    
    [save.saveArr removeObject:jobstr];
    //  NSLog(@"已经执行");
    // NSLog(@"jobstr====%@",jobstr);
    
    _alreadyTV.selectArray = save.saveArr;
    
    _alreadyTV.frame = CGRectMake(0,108, iPhone_width, 44*_alreadyTV.selectArray.count);
    [_alreadyTV reloadData];
    
    _jobTableView.frame = CGRectMake(0,108+ _alreadyTV.frame.size.height, iPhone_width, iPhone_height - _alreadyTV.frame.size.height -44);
    
    if (_alreadyTV.selectArray.count ==0) {
        [self viewAnimation2];
    }
    if (save.saveArr.count >=1) {
        scoreLabel.text = [NSString stringWithFormat:@"%d/5",save.saveArr.count];
    }
    else{
        scoreLabel.text = [NSString stringWithFormat:@"%d/5",saveArray.count];
    }
    [_jobTableView reloadData];
}
//保存按钮点击事件
- (void)onClickRightBtn:(id)sender
{
    
    
}
//返回按钮点击事件
- (void)backUp:(id)sender
{
//    XZLsaveJob *save = [XZLsaveJob standardDefault];
    //NSLog(@"返回");
    XZLsaveJob *save = [XZLsaveJob standardDefault];
    
    getjoblabel = [save.saveArr componentsJoinedByString:@","];
    
    if (_delegate && [_delegate respondsToSelector:@selector(getjobstr:)]) {
        
        [self.delegate getjobstr:getjoblabel];
    }
    [save.saveArr removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}
//tableview点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // NSLog(@"str====%@",[dataArray[_ArrayCount][2] objectForKey:@"name"]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XZLsaveJob *save = [XZLsaveJob standardDefault];
    if (save.saveArr.count>=1) {
        saveArray = save.saveArr;
    }
    
    if ([saveArray containsObject:dataArray[indexPath.row]]){
        
        cell.accessoryView = nil;
        //删除职业信息
        [saveArray removeObject:dataArray[indexPath.row]];
        
    }else
    {
        
        
        
        if (saveArray.count < 5){
            
            //将当前页面第一个删除
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"job_glossy_on.png"]];
            
            //添加职业信息
            [saveArray addObject:dataArray[indexPath.row]];
            
            // NSLog(@"count====%d",saveArray.count);
            
            
        }
        
        else{
            ghostView.message = @"最多只能选择5个";
            [ghostView show];
        }
        
    }
    
    
    scoreLabel.text = [NSString stringWithFormat:@"%d/5",saveArray.count];
    
    if (saveArray.count>=1) {
        getjoblabel = [saveArray componentsJoinedByString:@","];
        
    }
    
    
    if (_alreadyTV.alpha == 1){
        
        [self showJobsBtnClick];
    }
    XZLsaveJob *savejob = [XZLsaveJob standardDefault];
    savejob.saveArr = saveArray;
    
    
}
- (void)reloadDataTableView
{
    [_jobTableView reloadData];
    
}





#pragma mark-----已选职业事件
- (void)showJobsBtnClick
{
    XZLsaveJob *save = [XZLsaveJob standardDefault];
    
    
    if (save.saveArr.count>=1) {
        _alreadyTV.selectArray = save.saveArr;
        //  NSLog(@"save=====%@",_alreadyTV.selectArray[0]);
    }
    else{
        _alreadyTV.selectArray = saveArray;
        //NSLog(@"单例还为赋值");
    }
    _alreadyTV.frame = CGRectMake(0,108 , iPhone_height,_alreadyTV.selectArray.count*44);
    
    
    if (_alreadyTV.alpha == 0)
    {
        [self viewAnimation:_jobTableView frame:CGRectMake(0,108+ _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 108 - _alreadyTV.frame.size.height) time:0.5 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0,108, iPhone_width, _alreadyTV.selectArray.count*44) time:0.3 alph:1];
        //        NSLog(@"alpha===%f",_alreadyTV.alpha);
        //动画让他向下
        if (![scoreLabel.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
    }
    
    
    else
    {
        
        [self viewAnimation:_jobTableView frame:CGRectMake(0,108, iPhone_width, iPhone_height - 108) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0,88,iPhone_width, _alreadyTV.selectArray.count*44) time:0.3 alph:0];
        
        //动画让他向下
        if (![scoreLabel.text isEqual:@"0/5"]) {
            [self viewAnimation2];
        }
    }
    
    [_alreadyTV reloadData];
}


//[_alreadyTV reloadData];
//}

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


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    else{}
#pragma mark--------在这边判断是否有对勾
    
    XZLsaveJob *save = [XZLsaveJob standardDefault];
    if (save.saveArr.count>0) {
        
        
        if ([save.saveArr containsObject:dataArray[indexPath.row]]) {
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"job_glossy_on.png"]];
            
        }
        else {cell.accessoryView = nil;}
    }
    
    //    if (save.saveArr.count>0) {
    //
    //
    //    NSLog(@"count====%@",save.saveArr[0]);
    //    }
    
    
    
    cell.textLabel.text = dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    
    
    return cell;
    
    
}

@end
