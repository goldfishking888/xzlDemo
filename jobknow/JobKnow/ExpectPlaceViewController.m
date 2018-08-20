//
//  ExpectPlaceViewController.m
//  JobKnow
//
//  Created by liuxiaowu on 13-9-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ExpectPlaceViewController.h"
#import "ExpectDetailViewController.h"

@interface ExpectPlaceViewController ()

@end

@implementation ExpectPlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectArray = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self selectJob:nil];
    [self setTitleForButton:edit.areaArray.count];
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择城市2（简历）"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择城市2（简历）"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    num = ios7jj;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"place" ofType:@"plist"];
    _placeArray = [NSArray arrayWithContentsOfFile:path];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self configHeadView];
    [self addTitleLabel:@"选择城市"];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0,0+num,60,44);
    [self.backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [self.backBtn setImage:[UIImage imageNamed:@"btnnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    edit = [EditReader standerDefault];
    [_selectArray removeAllObjects];
    if (edit.areaArray.count > 0) {
        for (jobRead *r in edit.areaArray) {
            jobRead *read = [[jobRead alloc] init];
            read.name = r.name;
            read.code = r.code;
            [_selectArray addObject:read];
        }
    }
    
//    [_selectArray addObjectsFromArray:edit.areaArray];
    
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    alert.position = OLGhostAlertViewPositionCenter;
    
    _alreadyTV = [[AlreadyTableView alloc] initWithFrame:CGRectMake(0, 88+num, iPhone_width, 0)];
    _alreadyTV.alpha = 0;
    _alreadyTV.AlreadyDelegate = self;
    [self.view addSubview:_alreadyTV];
    
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 44+num, iPhone_width, 44);
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [selectBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [selectBtn addTarget:self action:@selector(showOrHidden:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setBackgroundColor:XZHILBJ_colour];
    [self.view addSubview:selectBtn];
    
    [self setTitleForButton:edit.areaArray.count];
    
    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dictpicker_arrow.png"]];
    arrowView.frame = CGRectMake(iPhone_width - 40, 15, 15, 15);
    [selectBtn addSubview:arrowView];
	
    
    //保存
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(iPhone_width-60, 0+num, 60, 44);
    [saveBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [saveBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveArea:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    [self.view setBackgroundColor:XZHILBJ_colour];
}

- (void)clickBack:(id)sender
{
    
    if (![edit.areaArray  isEqualToArray:_selectArray])
    {
        UIAlertView *alertd = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有保存当前选定内容，确定返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
        [alertd show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [edit.areaArray removeAllObjects];
        if (_selectArray.count > 0) {
            for (jobRead *r in _selectArray) {
                jobRead *read = [[jobRead alloc] init];
                read.name = r.name;
                read.code = r.code;
                [edit.areaArray addObject:read];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveArea:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeSelected:(jobRead *)job
{
    [edit.areaArray removeObject:job];
    [self selectJob:nil];
    [self setTitleForButton:edit.areaArray.count];
    [_tableView reloadData];
}

- (void)setTitleForButton:(NSInteger)cityCount
{
    NSString *title = [[NSString alloc] initWithFormat:@"  已选地点                                              %d/5",cityCount];
    [selectBtn setTitle:title forState:UIControlStateNormal];
}

- (void)selectJob:(id)sender
{
    _alreadyTV.frame = CGRectMake(0, 88, iPhone_width, edit.areaArray.count*44);
    _alreadyTV.selectArray = edit.areaArray;
    if (_alreadyTV.alpha == 1)
    {
        
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num + _alreadyTV.frame.size.height, iPhone_width, iPhone_height - 88 - _alreadyTV.frame.size.height-20) time:0.5 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88+num, iPhone_width, edit.areaArray.count*44) time:0.3 alph:1];
        ////动画让他向上
        if (edit.areaArray.count == 0) {
            [self viewAnimation];
        }
        
    }else
    {
        [self viewAnimation:_tableView frame:CGRectMake(0, 88+num, iPhone_width, iPhone_height - 88-20) time:0.3 alph:1];
        [self viewAnimation:_alreadyTV frame:CGRectMake(0, 88+num, iPhone_width, edit.areaArray.count*44) time:0.3 alph:0];
    }
    
    [_alreadyTV reloadData];
    
}

- (void)showOrHidden:(id)sender
{
    if (edit.areaArray.count != 0) {
        if (_alreadyTV.alpha == 1)
        {
            _alreadyTV.alpha = 0;
        }else
        {
            _alreadyTV.alpha = 1;
        }
        [self viewAnimation];
        [self selectJob:nil];
    }
}


//动画方法
- (void)viewAnimation:(UIView *)view frame:(CGRect)frame time:(float)time alph:(float)alpha
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:time];
    view.frame = frame;
    view.alpha = alpha;
    [UIView commitAnimations];
}

- (void)viewAnimation
{
    CGAffineTransform  transform;
    //设置旋转度数
    transform = CGAffineTransformRotate(arrowView.transform,M_PI/1);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.3];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [arrowView setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_placeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = [_placeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic valueForKey:@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    if (indexPath.row < 4)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([self containTheTradeCode:[dic valueForKey:@"code"]]) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
    }else
    {
        cell.accessoryView = nil;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_placeArray objectAtIndex:indexPath.row];
    if (indexPath.row > 3) {
        ExpectDetailViewController *exdVC = [[ExpectDetailViewController alloc] init];
        exdVC.cityArray = [dic valueForKey:@"son"];
        [self.navigationController pushViewController:exdVC animated:YES];
    }else
    {
        NSDictionary *dic = [_placeArray objectAtIndex:indexPath.row];
        jobRead *read = [[jobRead alloc] init];
        read.name = [dic valueForKey:@"name"];
        read.code = [dic valueForKey:@"code"];
        NSLog(@"read.name=%@ ,read.code = %@",read.name,read.code);
        
        if ([self containTheTradeCode:read.code]) {
            [self deleteJobWithCode:read.code];
        }else
        {
            if (edit.areaArray.count>=5) {
                alert.message = @"最多选择5个城市";
                [alert show];
            }else
            {
                [edit.areaArray addObject:read];
                NSLog(@"edit.areaArray==%@",edit.areaArray);
            }
        }
        [self setTitleForButton:edit.areaArray.count];
        [tableView reloadData];
        [self selectJob:selectBtn];

    }
}


- (BOOL)containTheTradeCode:(NSString *)code
{
    if (edit.areaArray > 0)
    {
        for (jobRead *job in edit.areaArray) {
            if ([job.code integerValue]==[code integerValue]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)deleteJobWithCode:(NSString *)code
{
    for (jobRead *job in edit.areaArray) {
        if ([job.code integerValue]==[code integerValue]) {
            [edit.areaArray removeObject:job];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
