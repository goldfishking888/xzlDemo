//
//  GRComplaintViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/25.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRComplaintViewController.h"

@interface GRComplaintViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    BOOL everSelect;
    NSString * submitID;
    NSIndexPath * LastIndexPath;
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * selectArray;
@end

@implementation GRComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"举报"];
    [self addRightButtonWithTitle:@"完成" Color:RGBA(255, 163, 29, 1) Font:[UIFont systemFontOfSize:18]];
    submitID = @"";
    everSelect = NO;
    LastIndexPath = 0;
    [self initTableView];
    [self requestData];
    // Do any additional setup after loading the view.
}

-(void)requestData{
    
    NSString *urlstr = kCombineURL(kTestAPPAPIGR, @"/api/code/position/complain");
    //http://appapi.xzhiliao.com/api/code/position/complain;
    //    NSString * tokenStr =  [XZLUserInfoTool getToken];
    self.dataArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    //    [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
    //    [paramDic setValue:self.positionID forKey:@"position_id"];//self.searchKey
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
//                NSMutableArray * tempArray = [[NSMutableArray alloc]init];
//                for (NSString * key in [data allKeys]) {
//                    NSMutableDictionary * dicItem = [[NSMutableDictionary alloc] init];
//                    [dicItem setValue:key forKey:@"key"];
//                    [dicItem setValue:[data valueForKey:key] forKey:@"value"];
//                    [tempArray addObject:dicItem];
//                }
                NSMutableArray *arrayKeys = [XZLCodeFileTool bubbleSort:[NSMutableArray arrayWithArray:[dataDic allKeys]]];
                NSMutableArray *tempArray = [NSMutableArray new];
                                for (NSString *key in arrayKeys) {
                                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"key",[dataDic valueForKey:key],@"value", nil];
                                    [tempArray addObject:dic];
                                }
                self.dataArray = tempArray;
                [_tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        mGhostView(nil, @"失败，请检查网络");
        NSLog(@"failed block%@",error);
    }];
    
    
}

-(void)initTableView
{
    //高度减去tabbar高度50
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + self.num, iPhone_width, iPhone_height - 44 - self.num) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBA(245, 245, 245, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"personCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else
    {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
   UIButton * imgbgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgbgBtn.frame = CGRectMake(iPhone_width - 44, 17, 20, 20);
    imgbgBtn.userInteractionEnabled = NO;
    imgbgBtn.tag = 200;
    [imgbgBtn setImage:[UIImage imageNamed:@"weiwancheng"] forState:UIControlStateNormal];
    [cell addSubview:imgbgBtn];
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(20, imgbgBtn.frame.origin.y, 240, 18)];
    lab.text = @"";
    lab.textColor = RGB(74, 74, 74);
    lab.textAlignment =NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:15];
    [cell addSubview:lab];
    
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(lab.frame.origin.x, 54, iPhone_width - lab.frame.origin.x, 1)];
    lineV.backgroundColor  =RGBA(245, 245, 245, 1);
    [cell addSubview:lineV];
    if (self.dataArray.count > 0) {
        if (indexPath.row == 0 && everSelect == NO) {
            [imgbgBtn setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
            submitID = self.dataArray[0][@"value"];
        }else{
            if (indexPath == LastIndexPath) {
                [imgbgBtn setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
            }else{
                [imgbgBtn setImage:[UIImage imageNamed:@"weiwancheng"] forState:UIControlStateNormal];
            }
        }
        lab.text = self.dataArray[indexPath.row][@"value"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LastIndexPath = indexPath;
    //先把所有的背景文字设置为默认值 再把对应的点击button改了.
    everSelect = YES;
    [_tableView reloadData];
    if (self.dataArray.count > 0) {
        //        [self.dataArray[indexPath.row] setValue:@"1" forKey:@"isSelect"];
        submitID = self.dataArray[indexPath.row][@"key"];
    }
}

-(void)onClickRightBtn:(UIButton *)sender
{
    NSString *urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/complain");
     NSLog(@"要举报的positionID is %@,reason is %@,key is %@",self.positionID,self.dataArray[LastIndexPath.row][@"value"],self.dataArray[LastIndexPath.row][@"key"]);
    //http://appapi.xzhiliao.com/api/position/complain
    NSString * tokenStr =  [XZLUserInfoTool getToken];
    self.dataArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setValue:tokenStr forKey:@"token"];//待确定是否添加
        [paramDic setValue:self.positionID forKey:@"position_id"];//self.searchKey
    if (self.dataArray.count > 0) {
        [paramDic setValue:self.dataArray[LastIndexPath.row][@"key"] forKey:@"position_type"];
    }
    [paramDic setValue:@"" forKey:@"complain_reason"];
    [paramDic setValue:@"" forKey:@"remark"];
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
//                NSDictionary *dataDic = responseObject[@"data"];
                mGhostView(nil, @"感谢您的反馈,我们会尽快处理");
                [self.navigationController popViewControllerAnimated:YES];
                [_tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        mGhostView(nil, @"失败，请检查网络");
        NSLog(@"failed block%@",error);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
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
