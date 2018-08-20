//
//  GRSelectSalaryViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRSelectSalaryViewController.h"
#import "GRReadModel.h"

@interface GRSelectSalaryViewController ()

@end

@implementation GRSelectSalaryViewController

-(void)initData
{
    dataArray = [[NSMutableArray alloc]init];
    [dataArray addObjectsFromArray:[XZLUtil getSalaryArrayWithModel:YES]];
    //NSLog(@"dataArray is %@",dataArray);
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;

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
    SaveJob *saveJob = [SaveJob standardDefault];
    
    /**主要是为了第二次进入该界面时显示已经保存过的信息**/
    /**存放的是GRReadModel数据,用来存储选中的salary数组,从SaveJob中得到的数据**/
    saveArray = [[NSMutableArray alloc]init];
    
    /**将saveJob中存放的saveArrSalary存放在GRSelectSalaryViewController中的saveArray数组中**/
    for (GRReadModel *job in saveJob.saveArrSalary){
        [saveArray addObject:job];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"选择薪资"];
    [self initTableView];
}

-(void)initTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,iPhone_width,iPhone_height-64) style:UITableViewStyleGrouped];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _myTableView.bounces = NO;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_myTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.myTableView];
}

- (void)viewDidAppear:(BOOL)animate
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择薪资"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择薪资"];
}

#pragma mark 右上角保存按钮响应事件
- (void)saveBtnClick
{
    SaveJob *save = [SaveJob standardDefault];
    
    [save.saveArrSalary removeAllObjects];//
    
    NSLog(@"saveArray is %@",saveArray);
    
    
    for (GRReadModel *job in saveArray){
        [save.saveArrSalary addObject:job];//将选中的行业存储在saveArr中
        [save.positionArr replaceObjectAtIndex:3 withObject:job];
    }
    
    if([self.delegate respondsToSelector:@selector(onSelectSalary)]) {
        [self.delegate onSelectSalary];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return [dataArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else{
        cell.accessoryView = nil;
    }
    
    cell.accessoryView.frame = CGRectMake(280, 0, 40, 30);
    
    /*
     如果textField是空的话，一个不限，另一个就不能出现不限。
     
     textField不为空，无所谓
     
     */
    
    GRReadModel *read;
    
    read=[dataArray objectAtIndex:indexPath.row];
        
    cell.textLabel.textColor = RGB(74, 74, 74);
    //ylh
    if ([self existInArray:saveArray WithObject:read]){//判断saveArray中是否有当前的cell
        
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
    }
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = read.name;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath//返回cell的高度
{
    return 46.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //这是WorkVC里面的不限没有被点击的时候，positionVC里面有不限的时候。
    
    GRReadModel *job=[dataArray objectAtIndex:indexPath.row];
    
    if ([self existInArray:saveArray WithObject:job]) {//如果当前选中的cell已经被选中过
        
        
    }else//如果当前选中的cell没有被选中过
    {
        [saveArray removeAllObjects];
        [saveArray addObject:job];
    }

    
    [self performSelector:@selector(reloadDataTableView) withObject:self afterDelay:0.1];
    
    [self performSelector:@selector(saveBtnClick) withObject:self afterDelay:0.5];

}

-(void)reloadDataTableView
{
    [_myTableView reloadData];
}

//判断array里面是否包含GRReadModel
- (BOOL)existInArray:(NSMutableArray *)array WithObject:(GRReadModel*)job
{
    for (GRReadModel *read in array){
        if ([read.code intValue]==[job.code intValue])
        {
            return YES;
        }
    }
    return NO;
}

//遍历数组，如果数组中包含后面的job，将数组中的这个元素删除
- (void)array:(NSMutableArray *)arr deleteWithObject:(GRReadModel *)job
{
    GRReadModel *re = nil;
    
    for (GRReadModel *read in arr) {
        if ([read .code intValue] == [job.code intValue]) {
            re = read;
        }
    }
    
    if (re) {
        [arr removeObject:re];
    }
}


//返回按钮
- (void)backUp:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//当点击确定时执行if内语句
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(BOOL)isBuxian
{
    
    SaveJob *save=[SaveJob standardDefault];
    
    NSDictionary *dic=[save.jobDic valueForKey:@"不限"];
    
    if (dic) {
        NSMutableArray *array=[dic valueForKey:@"jobName"];
        
        if ([array count]!=0){
            
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
