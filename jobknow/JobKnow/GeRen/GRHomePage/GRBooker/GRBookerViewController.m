//
//  GRBookerViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/7/26.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRBookerViewController.h"
#import "GRBookerConditionTableViewCell.h"
#import "GRReadModel.h"
#import "ScanningViewController.h"
#import "GRCityInfoNumsModel.h"

#import "GRBookPositionListViewController.h"

#import "SRAlertView.h"


@interface GRBookerViewController ()<SRAlertViewDelegate>

@end

@implementation GRBookerViewController{
    NSArray *array_title;
    NSString *btn_edit_title;
    NSInteger deleteIndex;
    GRCityInfoNumsModel *model_cityInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configHeadView];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"职位订阅"];
    [self initData];
    // 初始化tableView
    [self initTableView];
    
    // Do any additional setup after loading the view.
}

-(void)initData{
    array_title = @[@"职位名称",@"城市",@"行业",@"月薪"];
//    _dataArray = [NSMutableArray new];
    _dataArray=(NSMutableArray *)[GRBookerModel findAll];
    _dataArray = [self bubbleSort:_dataArray];
    
    _model = [GRBookerModel new];
    _model.bookLocationName = [mUserDefaults valueForKey:@"localCity"];
    _model.bookLocationCode = [XZLUtil getCityCodeWithCityName:_model.bookLocationName];
    [self getCityRelatedNumbersWithCityCode:_model.bookLocationCode GotoList:NO Index:nil];
    isEditingBooker = NO;
    btn_edit_title = @"编辑";
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
}

#pragma mark -初始化tableView

- (void)initTableView {
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight -64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.view_Booker;
}

#pragma mark -选择城市后获取城市相关信息
-(void)getCityRelatedNumbersWithCityCode:(NSString *)cityCode GotoList:(BOOL)isGoToList Index:(NSIndexPath *)indexPath{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
//    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:cityCode forKey:@"city_code"];
    
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/code/city_sources"];
    [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                if (isGoToList) {
                    GRCityInfoNumsModel *model = [GRCityInfoNumsModel yy_modelWithDictionary:dataDic];
                    model_cityInfo = model;
                    GRBookPositionListViewController *vc = [GRBookPositionListViewController new];
                    vc.model = [_dataArray objectAtIndex:indexPath.row];
                    vc.model_cityInfo= model_cityInfo;
                    vc.array_model_booker = _dataArray;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    model_cityInfo = [GRCityInfoNumsModel yy_modelWithDictionary:dataDic];
                }
                
                
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        //        ghostView.message = @"网络出现问题，请稍后重试";
        //        [ghostView show];
        
    }];
}

#pragma mark- 点击保存
-(void)onClickSaveBtn:(UIButton *)sender{
    
    [self.view endEditing:YES];
    if(_dataArray.count>=5){
        ghostView.message = @"最多设置5个订阅器";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.bookPostName]){
        ghostView.message = @"请输入职位名称";
        [ghostView show];
        return;
    }else{
        if (_model.bookPostName.length>10) {
            ghostView.message = @"职位名称最长为10个字符";
            [ghostView show];
            return;
        }
    }
    if([NSString isNullOrEmpty:_model.bookLocationName]){
        ghostView.message = @"请选择城市";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.bookIndustryName]){
        ghostView.message = @"请选择行业";
        [ghostView show];
        return;
    }
    if([NSString isNullOrEmpty:_model.bookSalaryName]){
        ghostView.message = @"请选择月薪";
        [ghostView show];
        return;
    }
    
    for (GRBookerModel *item in _dataArray) {
        NSString *title_item = [self combineStr1:item];
        NSString *title_model = [self combineStr1:_model];
        if ([title_model isEqualToString:title_item]) {
            ghostView.message = @"不能重复订阅";
            [ghostView show];
            return;
        }
    }

    [self saveingRequest];
}

#pragma mark- 保存修改网络请求
-(void)saveingRequest{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:_model.bookPostName forKey:@"position_name"];
    [paramDic setValue:_model.bookIndustryCode forKey:@"trade"];//手机企业没有
    [paramDic setValue:_model.bookLocationCode forKey:@"area"];//4表示企业
    [paramDic setValue:_model.bookSalaryCode?_model.bookSalaryCode:@"0" forKey:@"salary"];//
//    [paramDic setValue:@"PHP" forKey:@"position_name"];
//    [paramDic setValue:@"1100" forKey:@"trade"];//手机企业没有
//    [paramDic setValue:@"2012" forKey:@"area"];//4表示企业
//    [paramDic setValue:@"13" forKey:@"salary"];//
    NSLog(@"paramDic is %@",paramDic);
    //    NSDictionary *params = @{@"mobile":_phoneTF.text,@"captcha":_verifyCodeTF.text,@"version":[XZLUtil currentVersion]};
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/subscribe/create"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                GRBookerModel *model = [GRBookerModel getBookerModelWithDic:dataDic];
                [model saveOrUpdate];
                //通知GRHomeViewController刷新Booker和职位
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bookerChangeReloadData" object:@"3"];
                
                ScanningViewController *scanVC=[[ScanningViewController alloc]init];
                scanVC.model_cityInfo = model_cityInfo;
                scanVC.model_booker = model;
                [_dataArray addObject:model];
//                NSMutableArray *arrayt = [[NSMutableArray alloc] init];
//                [arrayt addObject:model];
//                [arrayt addObjectsFromArray:[NSMutableArray arrayWithArray:_dataArray]];
//                _dataArray = arrayt;
                scanVC.array_model_booker = _dataArray;
                
                _model = [GRBookerModel new];
                [self.navigationController pushViewController:scanVC animated:YES];
                [self performSelector:@selector(reloadDatas) withObject:nil afterDelay:1];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [loadView hide:YES];
        ghostView.message = @"订阅失败";
        [ghostView show];
        
    }];
}

-(void)reloadDatas{
    _dataArray =[NSMutableArray arrayWithArray:[GRBookerModel findAll]];
    _dataArray = [self bubbleSort:_dataArray];
    [_tableView reloadData];
}

#pragma mark- 点击编辑/完成
-(void)onClickEditBtn:(UIButton *)sender{
    isEditingBooker = !isEditingBooker;
    if (isEditingBooker) {
        btn_edit_title = @"完成";
    }else{
        btn_edit_title = @"编辑";
    }
    [_tableView reloadData];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return array_title.count;//测试
    }
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"mainCell";
    GRBookerConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (!cell) {
        cell = [[GRBookerConditionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell setTitleValue:array_title[indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                //职位名称
                [cell setTextFieldValue:_model.bookPostName DefaultValue:@"请输入职位名称"];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
                break;
            case 1:
            {
                //城市
                [cell setLabelValue:_model.bookLocationName DefaultValue:@"请选择"];
            }
                break;
            case 2:
            {
                //行业
                [cell setLabelValue:_model.bookIndustryName DefaultValue:@"请选择"];
            }
                break;
            case 3:
            {
                //月薪
                [cell setLabelValue:_model.bookSalaryName DefaultValue:@"请选择"];
            }
                break;
                
            default:
                break;
        }
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell1 == nil)
        {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }else
        {
            NSArray *views = [cell1.contentView subviews];
            
            for (UIView *v in views) {
                [v removeFromSuperview];
            }
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc]init];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        cell1.accessoryType = UITableViewCellAccessoryNone;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.backgroundColor = [UIColor whiteColor];
        GRBookerModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        NSString*titleStr=[self combineStr1:model];
        
        CGFloat height = 0;
        UIView *cellB = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-10*2, 59)];
        UIView *view_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, cellB.height)];
        view_left.backgroundColor = RGB(255, 178, 66);
        [cellB addSubview:view_left];
        
        mViewBorderRadius(cellB, 4, 0.5, RGB(216, 216, 216));
//        cellB.backgroundColor = [UIColor yellowColor];
        [cell1.contentView addSubview:cellB];
        
        /*当cell处在编辑状态下   当cell处在删除状态下*/
        //
        if (!isEditingBooker) {
            
            //返回的label显示今日多少条，累计多少条
            UIView *countLabel = [self labelForCell:model.bookTodayData Total:model.bookTotalData backViewFrame:cellB.frame];
//                        countLabel.backgroundColor = [UIColor blueColor];
            
            [cellB addSubview:countLabel];
            
            label.frame = CGRectMake(22,23, cellB.frame.size.width - countLabel.frame.size.width-14-22, 13);
        }else{
            [cellB setFrame:CGRectMake(10, 0, kMainScreenWidth-10-35, 59)];
            //返回的label显示今日多少条，累计多少条
            UIView *countLabel = [self labelForCell:model.bookTodayData Total:model.bookTotalData backViewFrame:cellB.frame];
//                        countLabel.backgroundColor = [UIColor blueColor];
            
            [cellB addSubview:countLabel];
            
            label.frame = CGRectMake(22,23, cellB.frame.size.width - countLabel.frame.size.width-14-22-10, 13);
            
            UIButton *btn_delete = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-29, 22, 20, 20)];
//            NSInteger row = indexPath.row?indexPath.row:0;
            btn_delete.tag = indexPath.row;
            [btn_delete setImage:[UIImage imageNamed:@"booker_delete"] forState:UIControlStateNormal];
            [btn_delete addTarget:self action:@selector(deleteFeedReader:) forControlEvents:UIControlEventTouchUpInside];
            [cell1.contentView addSubview:btn_delete];
            
            
        }
        
        label.numberOfLines = 1;
        label.text = titleStr;
        label.textColor = RGB(74, 74, 74);
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment=NSTextAlignmentLeft;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.backgroundColor = [UIColor clearColor];
        [cellB addSubview:label];
        return cell1;

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.section == 1) {
        return 70;
    }
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 61;
    }
    return 50 +6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        
        UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 61)];
        viewH.backgroundColor = [UIColor whiteColor];
        
        
        UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
        viewBack.backgroundColor = RGB(247, 247, 247);
        [viewH addSubview:viewBack];
        
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 166, 48)];
        label.text = [NSString stringWithFormat:@"已设置职位订阅器：%lu/5",(unsigned long)_dataArray.count];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGB(0, 0, 0);
        label.backgroundColor = [UIColor clearColor];
        [viewBack addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-70-22, 10, 70, 32)];
        [btn setTitleColor:RGB(255, 160, 71) forState:UIControlStateNormal];
        [btn setTitle:btn_edit_title forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        mViewBorderRadius(btn, 16, 1, RGB(216, 216, 216));
        [btn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        [viewBack addSubview:btn];
        return viewH;
    }
    
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50+6)];
    viewBack.backgroundColor = RGB(247, 247, 247);
    
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    viewH.backgroundColor = [UIColor whiteColor];
    [viewBack addSubview:viewH];
    
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    label.text = @"我们将根据您的需求每日推送最新职位";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB(74, 74, 74);
    label.backgroundColor = [UIColor clearColor];
    [viewH addSubview:label];
    
    return viewBack;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 38+44+31;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section==1) {
        return nil;
    }
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44+20)];
    viewH.backgroundColor = [UIColor whiteColor];

    UIButton *label_title = [[UIButton alloc] initWithFrame:CGRectMake(28, 38, kMainScreenWidth-28*2, 44)];
    mViewBorderRadius(label_title, 22, 1, [UIColor clearColor]);
    [label_title.titleLabel setFont:[UIFont systemFontOfSize:16]] ;
    [label_title setBackgroundColor:RGB(255, 178, 66)];
    [label_title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [label_title setTitleColor:RGB(216, 216, 216) forState:UIControlStateHighlighted];
    label_title.tag = section;
    [label_title setTitle:@"保存" forState:UIControlStateNormal];
    [label_title addTarget:self action:@selector(onClickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewH addSubview:label_title];

    return viewH;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GRReadModel *model = [[GRReadModel alloc] init];
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
                
            case 1:
            {
                [self selectCity];
            }
                break;
            case 2:
            {
                model.name = _model.bookIndustryName;
                model.code = _model.bookIndustryCode;
                [self multiSelectIndustry:indexPath Model:model];
            }
                break;
            case 3:
            {
                model.name = _model.bookSalaryName;
                model.code = _model.bookSalaryCode;
                [self selectSalary:indexPath Model:model];
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        
        GRBookerModel *model = [_dataArray objectAtIndex:indexPath.row];
        [self getCityRelatedNumbersWithCityCode:model.bookLocationCode GotoList:YES Index:indexPath];
    }
}

#pragma mark 删除订阅器

- (void)deleteFeedReader:(id)sender
{
    
    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"删除订阅"
                                                           icon:nil
                                                        message:@"您确定要删除该订阅吗？"
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"确定"
                                                 animationStyle:SRAlertViewAnimationNone
                                              selectActionBlock:^(SRAlertViewActionType actionType) {
                                                  NSLog(@"%zd", actionType);
                                                  if (actionType!=0) {
                                                      GRBookerModel *model = [_dataArray objectAtIndex:deleteIndex];
                                                      [self deleteJobReader:model];
                                                  }
                                              }];
    alertView.blurEffect = NO;
    [alertView show];
    
    UIButton *btn = (UIButton *)sender;
    deleteIndex = btn.tag?btn.tag:0;
}

#pragma mark 删除tableViewCell的方法

- (void)deleteJobReader:(GRBookerModel *)model{
    
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    myModel=model;
    
    NSLog(@"myModel.bookID is %@",myModel.bookId);
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:model.bookId forKey:@"book_id"];
    NSLog(@"paramDic is %@",paramDic);
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/subscribe/delete"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                ghostView.position=OLGhostAlertViewPositionCenter;
                ghostView.message=@"删除成功";
                [ghostView show];
                
                
                
                
                if ([_dataArray count]==0){
                    isEditingBooker=NO;
                }
                if (_dataArray.count == 1) {
                    
                    [GRBookerModel clearTable];
                    _dataArray = [NSMutableArray new];
                    NSMutableArray *array =(NSMutableArray *)[GRBookerModel findAll];
                    [_tableView reloadData];
                    //通知GRHomeViewController刷新Booker和职位
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookerChangeReloadData" object:@"1"];
                }else{
                    
                    [myModel deleteObject];
                    [_dataArray removeObject:myModel];
                    _dataArray=(NSMutableArray *)[GRBookerModel findAll];
                    _dataArray = [self bubbleSort:_dataArray];
                    [_tableView reloadData];
                    //通知GRHomeViewController刷新Booker和职位
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookerChangeReloadData" object:@"2"];
                }
                
                
                
                
        
            }else{
                ghostView.message = responseObject[@"message"];
                [ghostView show];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        [loadView hide:YES];
        ghostView.message = @"网络出现问题，请稍后重试";
        [ghostView show];
        
    }];
    
}
- (UIView *)labelForCell:(NSString *)count Total:(NSString *)total1 backViewFrame:(CGRect)backViewFrame
{
    //用来显示一条订阅器的今日更新条数和累计更新条数
    UIFont *font = [UIFont systemFontOfSize:14];
    
    
    //创建用来显示的label
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 90, 16)];
    numberLabel.numberOfLines = 0;
    //    [numberLabel setText: [[NSString alloc]initWithFormat:@"今日%@条",count]];
    numberLabel.font = font;
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.textColor=RGB(155, 155, 155);
    
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"今日%@条",count]];
    
    [strA addAttribute:NSForegroundColorAttributeName value:RGB(252, 83, 102) range:NSMakeRange(2,count.length)];
    
    numberLabel.attributedText = strA;
    
    
    //创建用来显示的label
    UILabel *numberLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0,16+4, 90, 16)];
    numberLabel2.numberOfLines = 0;
    [numberLabel2 setText: [[NSString alloc]initWithFormat:@"累计%@条",total1]];
    numberLabel2.font = font;
    numberLabel2.textAlignment = NSTextAlignmentRight;
    numberLabel2.textColor=RGB(155, 155, 155);
    
    NSMutableAttributedString *strB = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc]initWithFormat:@"累计%@条",total1]];
    
    [strB addAttribute:NSForegroundColorAttributeName value:RGB(252, 83, 102) range:NSMakeRange(2,total1.length)];
    
    numberLabel2.attributedText = strB;
    
    UIView *viewLB = [[UIView alloc] initWithFrame:CGRectMake(backViewFrame.size.width-14-90,12, 90, 36)];
    [viewLB addSubview:numberLabel];
    [viewLB addSubview:numberLabel2];
    
    
    return viewLB;
}

/**连接3个字符串**/

- (NSString *)combineStr1:(GRBookerModel *)model
{
    NSString *name = model.bookPostName;
    NSString  *city = model.bookLocationName;
    NSString *industry = model.bookIndustryName;
    NSString *salary = model.bookSalaryName;
    
    NSString *totalString=@"";
    
    if (![NSString isNullOrEmpty:name]) {
        totalString=[totalString stringByAppendingString:name];
    }
    
    if (![NSString isNullOrEmpty:city]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:city];
    }
    if (![NSString isNullOrEmpty:industry]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:industry];
    }
    
    if (![NSString isNullOrEmpty:salary]) {
        totalString=[totalString stringByAppendingFormat:@"+"];
        totalString=[totalString stringByAppendingString:salary];
    }
    
    return totalString;
}


#pragma mark- GRBookerConditionTableViewCellDelegate cell输入文字后代理
- (void)editCellWithStringValue:(NSString *)stringValue IndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _model.bookPostName = stringValue;
        [_tableView reloadData];
    }
}

#pragma mark- 选择行业
-(void)multiSelectIndustry:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRMultiSelectViewController *edu = [[GRMultiSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = MultiSelectENUMIndustry;
    edu.titleString = @"期望行业";
    [self.navigationController pushViewController:edu animated:YES];
}
#pragma mark- 选择城市
-(void)selectCity{
    allCityViewController *allCityVC=[[allCityViewController alloc]init];
    allCityVC.delegate=self;
    allCityVC.city_selected = _model.bookLocationName;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName{
    _model.bookLocationName = cityName;
    _model.bookLocationCode = cityCode;
    [_tableView reloadData];
    [self getCityRelatedNumbersWithCityCode:cityCode GotoList:NO Index:nil];
}

#pragma mark- 选择月薪
-(void)selectSalary:(NSIndexPath *)indexPath Model:(GRReadModel *)model{
    
    GRSingleSelectViewController *edu = [[GRSingleSelectViewController alloc] init];
    edu.delegate = self;
    edu.model = model;
    edu.type = SingleSelectENUMSalary;
    edu.titleString = @"期望月薪";
    [self.navigationController pushViewController:edu animated:YES];
}
#pragma mark - GRSingleSelectViewControllerDelegate单选选择VC代理

- (void)onSelectSalaryWithModel:(GRReadModel *)model_selected{
    _model.bookSalaryName = model_selected.name;
    _model.bookSalaryCode = model_selected.code;
    [_tableView reloadData];
}
-(void)onMultiSelectIndustryWithArray:(NSMutableArray *)array_selected{
    NSString *str_name = @"";
    NSString *str_code = @"";
    for (GRReadModel *model in array_selected) {
        str_name = [str_name stringByAppendingString:[NSString stringWithFormat:@"%@,",model.name]];
        str_code = [str_code stringByAppendingString:[NSString stringWithFormat:@"%@,",model.code]];
    }
    if (str_name.length>0) {
        str_name = [str_name substringToIndex:str_name.length-1];
    }if (str_code.length>0) {
        str_code = [str_code substringToIndex:str_code.length-1];
    }
    _model.bookIndustryName = str_name;
    _model.bookIndustryCode = str_code;
    [_tableView reloadData];
}

-(NSMutableArray *)bubbleSort:(NSMutableArray *)array{
    for (int i = 1; i < array.count; i++) {
        for (int j = 0; j < array.count - i; j++) {
            GRBookerModel *modelJ = array[j];
            GRBookerModel *modelJPlus = array[j+1];
            if ([modelJ.bookId compare:modelJPlus.bookId] == NSOrderedAscending) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
            
            //            printf("排序中:");
        }
    }
    return array;
    
    
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
