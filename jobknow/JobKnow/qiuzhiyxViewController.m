//
//  qiuzhiyxViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "qiuzhiyxViewController.h"
#import "EditReader.h"
#import "ExpectPlaceViewController.h"

@interface qiuzhiyxViewController ()

@end

@implementation qiuzhiyxViewController
@synthesize item;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"求职意向"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"求职意向"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setExcept];
    [myTabView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    int num = ios7jj;
    item = ExpectNone;
    alertView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    alertView.position = OLGhostAlertViewPositionCenter;
	self.view.backgroundColor = XZHILBJ_colour;
    [self addBackBtn];
    [self addTitleLabel:@"求职意向"];
    
    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46+num, iPhone_width, iPhone_height-46-num) style:UITableViewStyleGrouped];
    myTabView.delegate = self;
    myTabView.dataSource = self;
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTabView];
    
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-60, 0+num, 60, 44);
    [registBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    ResumeOperation *resume = [ResumeOperation defaultResume];
    NSDictionary *applyDic = [resume.resumeDictionary valueForKey:ApplyJob];
    NSLog(@"求职意向保存的数据===%@",applyDic);
    
    xinzhi = [applyDic valueForKey:@"hope_salary"];
    leibie = [applyDic valueForKey:@"work_type"];
    local = [applyDic valueForKey:@"hope_workarea_str"];
    localCode = [applyDic valueForKey:@"hope_workarea"];
    industry = [applyDic valueForKey:@"trade_str"];
    job = [applyDic valueForKey:@"job_sort_str"];
    
    //行业code
    NSString *jobCode = [applyDic valueForKey:@"trade"];
    //职业code
    NSString *workCode = [applyDic valueForKey:@"job_sort"];
    
    NSArray *jobArray = [jobCode componentsSeparatedByString:@","];
    NSArray *workArray = [workCode componentsSeparatedByString:@","];
    NSArray *jobName = [job componentsSeparatedByString:@","];
    NSArray *workName = [industry componentsSeparatedByString:@","];
    NSArray *loaclAry = [local componentsSeparatedByString:@","];
    NSArray *loaclCodeAry = [localCode componentsSeparatedByString:@","];
    
    EditReader *edit = [EditReader standerDefault];
    [edit.jobArray removeAllObjects];
    [edit.areaArray removeAllObjects];
    if (job.length > 1) {
        if (workArray.count == jobName.count) {
        for (NSInteger i = 0; i<workArray.count; i++) {
            jobRead *j = [[jobRead alloc] init];
            j.name = [jobName objectAtIndex:i];
            j.code = [workArray objectAtIndex:i];
            [edit.jobArray addObject:j];
            }
        }
    }
    
    if (local.length > 1) {
            for (NSInteger i = 0; i<loaclAry.count; i++) {
                jobRead *j = [[jobRead alloc] init];
                j.name = [loaclAry objectAtIndex:i];
                j.code = [loaclCodeAry objectAtIndex:i];
                [edit.areaArray addObject:j];
            }
        }
    
    
    SaveJob *save = [SaveJob standardDefault];
    //NSLog(@"-----------------------%@",job);
    [save.saveArr removeAllObjects];
    
    if (industry.length > 1) {
        if (jobArray.count == workName.count) {
            for (NSInteger i = 0; i<workName.count; i++) {
                jobRead *j = [[jobRead alloc] init];
                j.name = [workName objectAtIndex:i];
                j.code = [jobArray objectAtIndex:i];
                [save.saveArr addObject:j];
            }
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:521];
        [label1 removeFromSuperview];
        cell.accessoryView = nil;
    }
    NSArray *ary = [[NSArray alloc]initWithObjects:@"期望行业",@"期望职业",@"工作类型",@"期望月薪",@"期望地点", nil];
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [ary objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    UILabel *label01 = [[UILabel alloc]initWithFrame:CGRectMake(160, 12, 60, 30)];
    label01.backgroundColor = [UIColor clearColor];
    label01.textColor = [UIColor grayColor];
    label01.font = [UIFont fontWithName:Zhiti size:14];
    label01.tag = 521;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0)
    {
        label.text = industry;
    }
    else if(indexPath.row == 1)
    {
        label.text = job;
    }else if (indexPath.row ==2){
        if (leibie.length>0) {
            label.text = [self changeCode:leibie ty:@"lx"];
        }
    }else if (indexPath.row ==3){
        if (xinzhi.length>0) {
            label.text = [self changeCode:xinzhi ty:@"yxyx"];
        }
    }else if (indexPath.row ==4){
        label.text = local;
    }
//    NSLog(@"行业=%@ 职业= %@ 类型=%@ 月薪=%@ 地点=%@",industry,job,leibie,xinzhi,local);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        item = ExpectIndustry;
        PositionsViewController *pos = [[PositionsViewController alloc]init];
        [self.navigationController pushViewController:pos animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        item = ExpectJob;
        JobItemViewController *jobVC =[[JobItemViewController alloc]init];
        jobVC.enter = NO;
        [self.navigationController pushViewController:jobVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2)
    {
        jiben2ViewController *jiben = [[jiben2ViewController alloc]init];
        jiben.myType = [NSString stringWithFormat:@"gzlx"];
        jiben.deleat =self;
        [self.navigationController pushViewController:jiben animated:YES];
      
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        jiben2ViewController *jiben = [[jiben2ViewController alloc]init];
        jiben.myType = [NSString stringWithFormat:@"yuexin"];
        jiben.deleat =self;
        [self.navigationController pushViewController:jiben animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
        item = ExpectLocal;
        ExpectPlaceViewController *epVC = [[ExpectPlaceViewController alloc] init];
        [self.navigationController pushViewController:epVC animated:YES];
    }
}

//薪资，工作类型
- (void)chuanzhi:(NSString *)str ty:(NSString *)type
{
    if ([type isEqualToString:@"yuexin"]) {
            xinzhi = [NSString stringWithFormat:@"%@",str];
        }else{
            leibie = [NSString stringWithFormat:@"%@",str];
        }
        [myTabView reloadData];
}

- (void)pressLogin:(id)sender
{
    
    
    if (![self checkInfo]) {
        alertView.message = tipString;
        [alertView show];
        return;
    }
    SaveJob *save = [SaveJob standardDefault];
    NSString *urlString = kCombineURL(KXZhiLiaoAPI, kSaveEducation);
    ResumeOperation *resume = [ResumeOperation defaultResume];
    NSString *jianliId= [resume.resumeDictionary valueForKey:@"jlId"];
     NSMutableDictionary*urlParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"resume_cn",@"table",jianliId,@"id",[save industryCode],@"trade",[EditReader jobCode],@"job_sort",xinzhi,@"hope_salary",leibie,@"work_type",[EditReader areaCode],@"hope_workarea", nil];
//    NSLog(@"地点=====%@"，[EditReader areaCode]);
    
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:urlParamter urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request setCompletionBlock:^{
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[resultDic valueForKey:@"error"] integerValue] == 0) {
            NSLog(@"求职意向保存成功");
            NSDictionary *infoDic = [resultDic valueForKey:@"info"];
            [self.deleate chuanInDic:infoDic];
            ResumeOperation *resume = [ResumeOperation defaultResume];
//            [resume setObject:infoDic forKey:ApplyJob];
            [resume setObject:@"完整" forKey:@"expect"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}


- (void)setExcept
{
    if (item == ExpectIndustry) {
        SaveJob *save = [SaveJob standardDefault];
        industry = [save industry];
    }else if (item == ExpectJob)
    {
        job = [EditReader jobStr];
    }else if (item == ExpectJobType)
    {
        
    }else if (item == ExpectSalary)
    {
        
    }else if (item == ExpectLocal)
    {
        local = [EditReader areaStr];
        NSLog(@"城市名=%@",[EditReader areaStr]);
        NSLog(@"城市代码=%@", [EditReader areaCode]);
    }
}


- (BOOL)checkInfo
{
    SaveJob *save = [SaveJob standardDefault];
    if ([[save industry] isEqualToString:@"选择行业"]) {
        tipString = @"请填写期望行业";
        return NO;
    }
    
    if ([[EditReader jobStr] isEqualToString:@"选择职业"]) {
        tipString = @"请填写期望职业";
        return NO;
    }

    if (leibie.length == 0) {
        tipString = @"请填写工作类型";
        return NO;
    }
    
    if (xinzhi.length == 0) {
        tipString = @"请填写期望薪资";
        return NO;
    }
    
    if (local.length == 0) {
        tipString = @"请填写期望地点";
        return NO;
    }
    return YES;
}

//根据编码返回字符串
-(NSString *)changeCode:(NSString *)xinziCode ty:(NSString*)type
{
    NSString *name = nil;
    if ([type isEqualToString:@"lx"]) {
        switch ([xinziCode integerValue]) {
            case 0:
                name = @"不限";
                break;
            case 1:
                name = @"全职";
                break;
            case 2:
                name = @"兼职";
                break;
            case 3:
                name = @"实习";
                break;
            case 4:
                name = @"全兼皆可";
                break;
            default:
                break;
        }
    }else if ([type isEqualToString:@"yxyx"]){
        switch ([xinziCode integerValue]) {
            case 10:
                name = @"面议";
                break;
            case 99:
                name = @"1000以下";
                break;
            case 101:
                name = @"1000-1199";
                break;
            case 121:
                name = @"1200-1499";
                break;
            case 151:
                name = @"1500-1799";
                break;
            case 181:
                name = @"1800-1999";
                break;
            case 201:
                name = @"2000-2499";
                break;
            case 251:
                name = @"2500-2999";
                break;
            case 301:
                name = @"3000-3499";
                break;
            case 351:
                name = @"3500-3999";
                break;
            case 401:
                name = @"4000-4499";
                break;
            case 451:
                name = @"4500-4999";
                break;
            case 501:
                name = @"5000-5999";
                break;
            case 601:
                name = @"6000-6999";
                break;
            case 701:
                name = @"7000-7999";
                break;
            case 801:
                name = @"8000-8999";
                break;
            case 901:
                name = @"9000-9999";
                break;
            case 1001:
                name = @"10000-11999";
                break;
            case 1201:
                name = @"12000-14999";
                break;
            case 1501:
                name = @"15000-19999";
                break;
            case 2001:
                name = @"20000-24999";
                break;
            case 2501:
                name = @"25000-29999";
                break;
            case 3001:
                name = @"30000-39999";
                break;
            case 4001:
                name = @"40000-49999";
                break;
            case 5001:
                name = @"50000-79999";
                break;
            case 8001:
                name = @"80000-99999";
                break;
            case 10001:
                name = @"100000以上";
                break;
            default:
                break;
        }
    }
    return name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
