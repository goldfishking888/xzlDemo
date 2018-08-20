//
//  GRSingleSelectViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/10.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRSingleSelectViewController.h"

@interface GRSingleSelectViewController ()

@end

@implementation GRSingleSelectViewController

-(void)initData
{
    dataArray = [[NSMutableArray alloc]init];
    NSArray *array;
    if (_type == SingleSelectENUMSalary) {
        array = [XZLUtil getSalaryArrayWithModel:YES];
    }else if (_type == SingleSelectENUMEduQualification){
        array = [XZLUtil getXueliWithModel:YES];
    }else if (_type == SingleSelectENUMWorkYears){
        array = [XZLUtil getWorkYearsWithModel:YES];
    }else if (_type == SingleSelectENUMPosition){
        array = [XZLUtil getPositionWithModel:YES];
    }else if (_type == SingleSelectENUMNowStatus){
        array = [XZLUtil getNowStatusWithModel:YES];
    }else if (_type == SingleSelectENUMMarriage){
        array = [XZLUtil getMarriageWithModel:YES];
    }else if (_type == SingleSelectENUMCorpNature){
        array = [XZLUtil getCompanyNatureWithModel:YES];
    }else if (_type == SingleSelectENUMCorpScale){
        array = [XZLUtil getCompanySizeWithModel:YES];
    }else if (_type == SingleSelectENUMWorkCrop){
        array = [XZLUtil getWorkCropWithModel:YES];
    }else if (_type == SingleSelectENUMGender){
        array = [XZLUtil getGenderWithModel:YES];
    }else if (_type == SingleSelectENUMLanguageLevel){
        array = [XZLUtil getLanguageLevelWithModel:YES];
    }else if (_type == SingleSelectENUMIndustry){
        array = [XZLUtil getIndustryArrayWithModel:YES];
    }
    [dataArray addObjectsFromArray:array];
    
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

- (void)viewWillAppear:(BOOL)animated{
    
    /**主要是为了第二次进入该界面时显示已经保存过的信息**/
    /**存放的是GRReadModel数据,用来存储选中的salary数组,从SaveJob中得到的数据**/
    saveArray = [[NSMutableArray alloc]init];
    
    if (![NSString isNullOrEmpty:_model.name]) {
        [saveArray addObject:_model];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self addBackBtnGR];
    [self addTitleLabelGR:_titleString];
    
    //NSLog(@"dataArray is %@",dataArray);
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kMainScreenWidth,iPhone_height-64) style:UITableViewStyleGrouped];
    
    _myTableView.backgroundView = nil;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.bounces = NO;
    _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_myTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_myTableView];
    
}

- (void)viewDidAppear:(BOOL)animate
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:_titleString];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:_titleString];
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

#pragma mark 响应事件
- (void)saveBtnClick
{
    GRReadModel *model = saveArray[0];
    
    if(_type == SingleSelectENUMEduQualification) {
        if([self.delegate respondsToSelector:@selector(onSelectEduQualificationWithModel:)]) {
            [self.delegate onSelectEduQualificationWithModel:model];
        }
    }else if (_type == SingleSelectENUMSalary) {
        if([self.delegate respondsToSelector:@selector(onSelectSalaryWithModel:)]) {
            [self.delegate onSelectSalaryWithModel:model];
        }
    }else if (_type == SingleSelectENUMWorkYears) {
        if([self.delegate respondsToSelector:@selector(onSelectWorkYearsWithModel:)]) {
            [self.delegate onSelectWorkYearsWithModel:model];
        }
    }else if (_type == SingleSelectENUMPosition) {
        if([self.delegate respondsToSelector:@selector(onSelectPositionWithModel:)]) {
            [self.delegate onSelectPositionWithModel:model];
        }
    }else if (_type == SingleSelectENUMNowStatus) {
        if([self.delegate respondsToSelector:@selector(onSelectNowStatusWithModel:)]) {
            [self.delegate onSelectNowStatusWithModel:model];
        }
    }else if (_type == SingleSelectENUMMarriage) {
        if([self.delegate respondsToSelector:@selector(onSelectMarriageWithModel:)]) {
            [self.delegate onSelectMarriageWithModel:model];
        }
    }else if (_type == SingleSelectENUMCorpNature) {
        if([self.delegate respondsToSelector:@selector(onSelectCorpNatureWithModel:)]) {
            [self.delegate onSelectCorpNatureWithModel:model];
        }
    }else if (_type == SingleSelectENUMCorpScale) {
        if([self.delegate respondsToSelector:@selector(onSelectCorpScaleWithModel:)]) {
            [self.delegate onSelectCorpScaleWithModel:model];
        }
    }else if (_type == SingleSelectENUMWorkCrop) {
        if([self.delegate respondsToSelector:@selector(onSelectWorkCropWithModel:)]) {
            [self.delegate onSelectWorkCropWithModel:model];
        }
    }else if (_type == SingleSelectENUMGender) {
        if([self.delegate respondsToSelector:@selector(onSelectGenderWithModel:)]) {
            [self.delegate onSelectGenderWithModel:model];
        }
    }else if (_type == SingleSelectENUMLanguageLevel) {
        if([self.delegate respondsToSelector:@selector(onSelectLanguageLevelWithModel:)]) {
            [self.delegate onSelectLanguageLevelWithModel:model];
        }
    }else if (_type == SingleSelectENUMIndustry) {
        if([self.delegate respondsToSelector:@selector(onSelectIndustryWithModel:)]) {
            [self.delegate onSelectIndustryWithModel:model];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
