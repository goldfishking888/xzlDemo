//
//  allCityViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-16.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "allCityViewController.h"
#import "CityInfo.h"
#import "jobRead.h"
#import "RTLabel.h"
#import "CityModel.h"
#import "CityDetailModel.h"

@interface allCityViewController ()
{
    CityDetailModel *chooseCity;
    int selectIndexPathSection;
    int selectIndexPathRow;
    NSMutableArray *saveArray;
}
@end

@implementation allCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"城市选择"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"城市选择"];
}

//初始化数据
- (void)initData
{
    selectIndexPathSection = 0;
    
    selectIndexPathRow = 0;
    
    num=ios7jj;
    
    _change = YES;
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    formatter.dateFormat=@"yyyyMMdd";
    
    currentTime = [formatter stringFromDate:[NSDate date]];
    
    db=[UserDatabase sharedInstance];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //5个热门城市
    hotCityArray = [[NSMutableArray alloc]init];
    
    _cityDic=[[NSMutableDictionary alloc]init];
    
    _cityArray=(NSMutableArray *)[XZLUtil getCitiesWithModel:YES];
    
    //右侧索引数据
    _wordsArray = [[NSMutableArray alloc]init];
    for (CityModel *item in _cityArray) {
        [_wordsArray addObject:item.letter];
    }
    
    saveArray = [[NSMutableArray alloc]init];
    if (![NSString isNullOrEmpty:_city_selected]) {
        _city_selected = [_city_selected stringWithoutShi];
        NSArray *array_name = [_city_selected componentsSeparatedByString:@","];
        for (int i = 0; i<array_name.count; i++) {
            CityDetailModel *model = [[CityDetailModel alloc] init];
            model.city = [NSString stringWithFormat:@"%@",array_name[i]];
            model.code = [XZLUtil getCityCodeWithCityName:model.city];
            [saveArray addObject:model];
        }
    }
    NSLog(@"%@", saveArray);
    
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:2 dismissible:YES];
    
    ghostView.position= OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtnGR];
    
    [self addTitleLabelGR:@"选择城市"];
    
    if (_isMultiSelect) {
        [self addRightkBtnGR:@"保存"];
    }
    
    [self initData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, iPhone_width, iPhone_height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = RGB(74, 74, 74);//修改右边索引字体的颜色
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self sortCity:_cityArray];
}

-(void)onClickRightBtn:(UIButton *)sender{
    if (saveArray.count==0) {
        ghostView.message = @"没有选中任何城市";
        [ghostView show];
        return;
    }
    NSString *name = @"";
    NSString *code = @"";
    for (CityDetailModel *item in saveArray) {
        name = [name stringByAppendingString:[NSString stringWithFormat:@"%@,",item.city]];
        code = [code stringByAppendingString:[NSString stringWithFormat:@"%@,",item.code]];
    }
    name = [name substringToIndex:name.length-1];
    code = [code substringToIndex:code.length-1];
    
    if ([self.delegate respondsToSelector:@selector(sendChangeValue:name:)]) {
        
        [self.delegate sendChangeValue:code name:name];
    }
    
    [self.navigationController popViewControllerAnimated:YES];


}

#pragma -mark tableViewDelegate

//头部内容
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *firstwordStr = [_wordsArray objectAtIndex:section];
    
    
    return firstwordStr;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *titleStr = [_wordsArray objectAtIndex:section];
    
    if ([titleStr isEqualToString:@""])
    {
        return nil;
    }
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,20)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, view.bounds.size.width-24, view.bounds.size.height)];
    view.backgroundColor = RGBA(249, 249, 249, 1);
    label.backgroundColor = [UIColor clearColor];	//透明色
    label.textColor = RGBA(153, 153, 153, 1);
    //        label.shadowColor = [UIColor darkGrayColor];
    //        label.shadowOffset = CGSizeMake(0, 0.6);
    label.font = [UIFont systemFontOfSize:15];
    label.text = titleStr;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //判断该首字母下是否有城市，没有header高度为零
    NSString *firstword = [self.wordsArray objectAtIndex:section];
    
    if ([[self.cityDic valueForKey:firstword] count] == 0)
    {
        return 0;
        
    }
    
    return 20;
}

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_wordsArray count];
}

//每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *firstword = [_wordsArray objectAtIndex:section];
    NSArray *array=[_cityDic valueForKey:firstword];
    
    return array.count / 3 +array.count % 3;//显示足够的行数展示城市
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        for (UIView *v in [cell.contentView subviews]) {
            [v removeFromSuperview];
        }
    }
    
    NSString *first = [self.wordsArray objectAtIndex:indexPath.section];
    NSArray *arr = [self.cityDic valueForKey:first];
    
    for (int j = 0; j < 3; j++) {
        if (indexPath.row * 3 + j < arr.count)
        {
            
            NSDictionary *dicCity = arr[indexPath.row * 3 + j];
            CityDetailModel *model= [CityDetailModel ModelWithDic:dicCity];
            NSString *cityName = model.city ;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(20*(j+1) + (iPhone_width - 30 -20*3) / 3 * j, 10, (iPhone_width - 30 -20*3) / 3 , 30)];
            [btn setTitle:cityName forState:UIControlStateNormal];
            [btn setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = RGBA(216, 216, 216, 1).CGColor;
            btn.layer.cornerRadius = btn.frame.size.height / 2;
            [btn addTarget:self action:@selector(cityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = j;
            if (![NSString isNullOrEmpty:_city_selected]) {
//                _city_selected = [_city_selected stringWithoutShi];

                for (CityDetailModel *item in saveArray) {
                    if ([item.city isEqualToString:cityName]) {
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        btn.layer.borderColor = [UIColor clearColor].CGColor;
                        [btn setBackgroundColor:RGB(255, 163, 29)];
                    }
                }
                
            }
            [cell.contentView addSubview:btn];
        }else{
            break;
        }
        
        
    }
    //    cell.textLabel.text = [[arr objectAtIndex:indexPath.row] cityName];
    //    cell.textLabel.textColor = [UIColor darkGrayColor];
    //    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
    return cell;
}

#pragma mark - cityButtonClick:
-(void)cityButtonClick:(UIButton *)sender
{
    UITableViewCell* myCell = (UITableViewCell *)[[sender superview] superview]; //表示Button添加在了Cell中。
    
    NSIndexPath *cellPath = [self.tableView indexPathForCell:myCell];
    //    NSInteger i = cellPath.row; //这个就是cell的indexPath.row;
    NSString *key = [self.wordsArray objectAtIndex:cellPath.section];//取出key
    NSMutableArray *cityArray = [self.cityDic valueForKey:key];//根据key取出存放城市的数组
    
    chooseCity = [CityDetailModel ModelWithDic:[cityArray objectAtIndex:cellPath.row * 3 + sender.tag]];//取出数组中的城市
    NSLog(@"点击了选择城市---%@.....code--%@",chooseCity.city,chooseCity.code);
    [userDefaults setObject:chooseCity.code forKey:@"chooseCityCode"];
    NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
    
    NSLog(@"_fromWhereStr in allCityVC is %@",_fromWhereStr);
    
    if (_isMultiSelect) {
        if ([self existInArray:saveArray withName:chooseCity.city]) {
            //如果当前选中的cell已经被选中过
            [self array:saveArray deleteWithName:chooseCity.city];
            
        }else{
            //如果当前选中的cell没有被选中过
            if (saveArray.count==5) {
                ghostView.message = [NSString stringWithFormat:@"最多选择%ld个",(long)5];
                [ghostView show];
                return;
            }
            [saveArray addObject:chooseCity];
        }
        [_tableView reloadData];
        return;

    }
    
    
    if ([self.delegate respondsToSelector:@selector(sendChangeValue:name:)]) {
        
        [self.delegate sendChangeValue:chooseCity.code name:chooseCity.city];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    _fromWhereStr=@"";
    
}
//右侧索引栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_wordsArray];
    [array replaceObjectAtIndex:0 withObject:@"热门"];
    
    
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndexPathSection = indexPath.section;
    selectIndexPathRow = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    NSString *key = [self.wordsArray objectAtIndex:indexPath.section];//取出key
    //    NSMutableArray *cityArray = [self.cityDic valueForKey:key];//根据key取出存放城市的数组
    //
    //    City *city = [cityArray objectAtIndex:indexPath.row];//取出数组中的城市
    
    //    NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
    //
    //    NSLog(@"_fromWhereStr in allCityVC is %@",_fromWhereStr);
    //
    //    if ([_fromWhereStr isEqualToString:@"搜索界面"]||[_fromWhereStr isEqualToString:@"HomeVC"]){
    //
    //
    //    }else
    //    {
    //        if ([dic count]>=3) {
    //
    //            if (![self judgeReaderOrNot:city.cityName]) {
    //                ghostView.message=@"您最多可以订阅3个城市的职位";
    //                [ghostView show];
    //                return;
    //            }
    //        }
    //    }
    //
    //    //首先判断订阅城市是否超过三个
    //    //如果已经订阅了3个，那么应该判断当前选择的城市是否已经订阅过，如果是，返回，如果不是，警告
    //    //如果订阅的城市小于3个，那么直接返回界面就可以
    //
    //    CityInfo *cityInfo = [CityInfo standerDefault];
    //    cityInfo.cityName = city.cityName;
    //    cityInfo.cityCode = city.code;
    //    cityInfo.source=city.sourceStr;
    //    cityInfo.sourceAll=city.sourceAllStr;
    //    cityInfo.com_num=city.com_num;
    //
    //    if ([self.delegate respondsToSelector:@selector(sendChangeValue:name:)]) {
    //
    //        [self.delegate sendChangeValue:city.code name:city.cityName];
    //    }
    //
    //    [self.navigationController popViewControllerAnimated:YES];
    //
    //    _fromWhereStr=@"";
}

#pragma mark 功能函数

/**把城市进行排序**/
- (void)sortCity:(NSMutableArray *)cityArray
{
    //将城市按照首字母进行分组并放入字典
    for (int i = 0; i <_wordsArray.count; i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSString *wordStr = [_wordsArray objectAtIndex:i];
        
        CityModel *city = [cityArray objectAtIndex:i];
        if ([city.letter isEqualToString:wordStr]) {
             [_cityDic setObject:city.list forKey:wordStr];
        }
        
       
    }
    
    [_tableView reloadData];
}

-(BOOL)judgeReaderOrNot:(NSString *)cityStr
{
    NSMutableDictionary *bookCityDic=[userDefaults valueForKey:@"bookCity"];
    
    NSMutableArray *bookCityArray=(NSMutableArray *)[bookCityDic allKeys];
    
    for (NSString *bookCityStr in bookCityArray) {
        if ([bookCityStr isEqualToString:cityStr]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setHotArray
{
    hotCityArray = [NSMutableArray arrayWithArray:((CityModel *)_cityArray[0]).list];
}


//判断array里面是否包含GRReadModel
- (BOOL)existInArray:(NSMutableArray *)array withName:(NSString*)name
{
    for (CityDetailModel *item in array){
        if ([name isEqualToString:item.city])
        {
            return YES;
        }
    }
    
    return NO;
}

//遍历数组，如果数组中包含后面的job，将数组中的这个元素删除
- (void)array:(NSMutableArray *)arr deleteWithName:(NSString*)name
{
    CityDetailModel *re = nil;
    
    for (CityDetailModel *item in arr) {
        if ([item.city isEqualToString:name]) {
            re = item;
        }
    }
    
    if (re) {
        [arr removeObject:re];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
