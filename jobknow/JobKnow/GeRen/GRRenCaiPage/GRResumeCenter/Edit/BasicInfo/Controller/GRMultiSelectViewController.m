//
//  GRMultiSelectViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRMultiSelectViewController.h"

@interface GRMultiSelectViewController ()

@end

@implementation GRMultiSelectViewController

-(void)initData
{
    if (self.maxNum==0) {
        self.maxNum = 5;
    }
    dataArray = [[NSMutableArray alloc]init];
    NSArray *array;
    if (_type == MultiSelectENUMPosition) {
        array = [XZLUtil getPositionWithModel:YES];
    }else if (_type == MultiSelectENUMIndustry){
        array = [XZLUtil getIndustryArrayWithModel:YES];
    }
    [dataArray addObjectsFromArray:array];
    //NSLog(@"dataArray is %@",dataArray);
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    /**主要是为了第二次进入该界面时显示已经保存过的信息**/
    /**存放的是GRReadModel数据,用来存储选中的salary数组,从SaveJob中得到的数据**/
    saveArray = [[NSMutableArray alloc]init];
    if (![NSString isNullOrEmpty:_model.name]) {
        NSArray *array_name = [_model.name componentsSeparatedByString:@","];
        NSArray *array_code = [_model.code componentsSeparatedByString:@","];
        for (int i = 0; i<array_name.count; i++) {
            GRReadModel *model = [GRReadModel new];
            model.name = array_name[i];
            model.code = array_code[i];
            [saveArray addObject:model];
        }
    }
    NSLog(@"%@", saveArray);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self addBackBtnGR];
    [self addTitleLabelGR:_titleString];
    [self initTableView];
    [self initBottomView];
    
}

- (void)viewDidAppear:(BOOL)animate
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:_titleString];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:_titleString];
}

-(void)initTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kMainScreenWidth,kMainScreenHeight-64-58) style:UITableViewStyleGrouped];
    
    _myTableView.backgroundView = nil;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.bounces = NO;
    _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_myTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_myTableView];
}

-(void)initBottomView{
    UIView *vb = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-58, kMainScreenWidth, 58)];
    vb.backgroundColor = [UIColor whiteColor];
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    view_line.backgroundColor = RGB(231, 231, 231);
    [vb addSubview:view_line];
    
    UIButton *btn_confrim = [[UIButton alloc] initWithFrame:CGRectMake(58, 7, kMainScreenWidth-58*2, 44)];
    mViewBorderRadius(btn_confrim, 22, 1, [UIColor clearColor]);
    btn_confrim.backgroundColor = RGB(255, 178, 66);
    [btn_confrim setTitle:@"确定" forState:UIControlStateNormal];
    [btn_confrim setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_confrim addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [vb addSubview:btn_confrim];
    
    [self.view addSubview:vb];
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
    
    
    GRReadModel *job=[dataArray objectAtIndex:indexPath.row];
    
    if ([self existInArray:saveArray WithObject:job]) {
        //如果当前选中的cell已经被选中过
        [self array:saveArray deleteWithObject:job];
        
    }else{
        //如果当前选中的cell没有被选中过
        if (saveArray.count==_maxNum) {
            ghostView.message = [NSString stringWithFormat:@"最多选择%ld个",(long)_maxNum];
            [ghostView show];
            return;
        }
        [saveArray addObject:job];
    }
    
    
    [self performSelector:@selector(reloadDataTableView) withObject:self afterDelay:0.1];
}

-(void)reloadDataTableView
{
    [_myTableView reloadData];
}

#pragma mark 响应事件
- (void)saveBtnClick
{
   //saveArray;
    
    if(_type == MultiSelectENUMPosition) {
        if([self.delegate respondsToSelector:@selector(onMultiSelectPositionWithArray:)]) {
            [self.delegate onMultiSelectPositionWithArray:saveArray];
        }
    }else if (_type == MultiSelectENUMIndustry) {
        if([self.delegate respondsToSelector:@selector(onMultiSelectIndustryWithArray:)]) {
            [self.delegate onMultiSelectIndustryWithArray:saveArray];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//判断array里面是否包含GRReadModel
- (BOOL)existInArray:(NSMutableArray *)array WithObject:(GRReadModel*)job
{
//    if (_type == MultiSelectENUMPosition) {
//        for (GRReadModel *read in array){
//            if ([[read.code substringToIndex:2] isEqualToString:[job.code substringToIndex:2]])
//            {
//                return YES;
//            }
//        }
//    }else{
//        for (GRReadModel *read in array){
//            if ([read.code intValue]==[job.code intValue])
//            {
//                return YES;
//            }
//        }
//    }
    for (GRReadModel *read in array){
        if ([[read.code substringToIndex:2] isEqualToString:[job.code substringToIndex:2]])
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
    NSMutableArray *array_delete = [NSMutableArray new];
    
    for (GRReadModel *read in arr) {
        if ([[read.code substringToIndex:2] isEqualToString:[job.code substringToIndex:2]]) {
            re = read;
            [array_delete addObject:read];
            
        }
    }
    for (GRReadModel *item in array_delete) {
        [arr removeObject:item];
    }
}

//返回按钮
- (void)backUp:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
