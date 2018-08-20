//
//  GRSelectIndustryViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/9.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRSelectIndustryViewController.h"
#import "GRReadModel.h"

@interface GRSelectIndustryViewController ()

@end

@implementation GRSelectIndustryViewController{
//    UIView *view_tableFooter;
}

-(void)initData
{
    dataArray = [[NSMutableArray alloc]init];
    [dataArray addObjectsFromArray:[XZLUtil getIndustryArrayWithModel:YES]];
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
    /**存放的是GRReadModel数据,用来存储选中的行业数组,从SaveJob中得到的数据**/
    saveArray = [[NSMutableArray alloc]init];
    
    /**将saveJob中存放的saveArr存放在positionViewController中的saveArray数组中**/
    for (GRReadModel *job in saveJob.saveArr){
        [saveArray addObject:job];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"选择行业"];
    [self initTableView];
}

- (void)viewDidAppear:(BOOL)animate
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择行业"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择行业"];
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

#pragma mark 右上角保存按钮响应事件
- (void)saveBtnClick:(id)sender
{
    SaveJob *save = [SaveJob standardDefault];
    
    [save.saveArr removeAllObjects];//
    
    NSLog(@"saveArray is %@",saveArray);
    
    
    for (GRReadModel *job in saveArray){
        [save.saveArr addObject:job];//将选中的行业存储在saveArr中
    }
    
    if([self.delegate respondsToSelector:@selector(onConfrimSelectIndustry)]) {
        [self.delegate onConfrimSelectIndustry];
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
    cell.backgroundColor=[UIColor clearColor];
    cell.accessoryView.frame = CGRectMake(280, 0, 40, 30);
    
    /*
     如果textField是空的话，一个不限，另一个就不能出现不限。
     
     textField不为空，无所谓
     
     */
    
    GRReadModel *read;
    read=[dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB(74, 74, 74);
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 58;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 58)];
    vb.backgroundColor = [UIColor clearColor];
    
    UIButton *btn_confrim = [[UIButton alloc] initWithFrame:CGRectMake(58, 7, kMainScreenWidth-58*2, 44)];
    mViewBorderRadius(btn_confrim, 22, 1, [UIColor clearColor]);
    btn_confrim.backgroundColor = RGB(255, 178, 66);
    [btn_confrim setTitle:@"确定" forState:UIControlStateNormal];
    [btn_confrim setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_confrim addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [vb addSubview:btn_confrim];
    
    return vb;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GRReadModel *job=[dataArray objectAtIndex:indexPath.row];
    
    if ([self existInArray:saveArray WithObject:job]) {//如果当前选中的cell已经被选中过
        
        [self array:saveArray deleteWithObject:job];//那么应该从saveArray中删除当前GRReadModel
        
        cell.accessoryView = nil;//将右侧的选中图标去掉
        
    }else//如果当前选中的cell没有被选中过
    {
        if (saveArray.count < 5)//如果当前选择没有超过5个
        {
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cb_glossy_on.png"]];
            [saveArray addObject:job];
        }
        else
        {
            ghostView.message = @"最多只能选择5个";
            [ghostView show];
        }
    }


    [self performSelector:@selector(reloadDataTableView) withObject:self afterDelay:0.1];
    
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
    SaveJob *save = [SaveJob standardDefault];
    
    if (![saveArray isEqualToArray:save.saveArr])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有保存当前选定内容，确定返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//当点击确定时执行if内语句
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
