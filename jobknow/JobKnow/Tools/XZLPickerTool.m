//
//  XZLPickerTool.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/17.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "XZLPickerTool.h"

@interface XZLPickerTool ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *toolBar;

@property (nonatomic, copy) XZLPickerDidSelectBlock didSelectBlock;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *datas;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *datasCopy;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *datasBlankMonth;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *datasCurrentMonth;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *valueString;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic) BOOL isHasTillNow;

@end

@implementation XZLPickerTool

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (UIView *)bgView
{
    if (_bgView==nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_bgView addGestureRecognizer:tap];
        
        [_bgView addSubview:self];
        [_bgView addSubview:self.toolBar];
        
        
    }
    return _bgView;
}

- (UIView *)toolBar
{
    if (_toolBar==nil) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-self.bounds.size.height-34, kMainScreenWidth, 34)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        finishBtn.frame = CGRectMake(kMainScreenWidth-60, 0, 60, _toolBar.bounds.size.height-1);
        [finishBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:finishBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, 60, _toolBar.bounds.size.height-1);
        [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:cancelBtn];
        
        UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, _toolBar.bounds.size.height-1, _toolBar.bounds.size.width, 1)];
        view_line.backgroundColor = RGB(210, 210, 210);
        [_toolBar addSubview:view_line];
    }
    return _toolBar;
}

- (void)finishClick:(UIButton *)btn
{
    if (self.didSelectBlock) {
        if (self.datas.count) {
            self.didSelectBlock(self.valueString);
        }
    }
    [self close];
}

- (void)close
{
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
    [self.toolBar removeFromSuperview];
    self.toolBar = nil;
    self.bgView = nil;
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.bgView];
}

+ (void)show:(NSArray<NSArray<NSString *> *> *)datas didSelectBlock:(XZLPickerDidSelectBlock)didSelectBlock
{
    XZLPickerTool *pickerView = [[XZLPickerTool alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-220, kMainScreenWidth, 220)];
    pickerView.didSelectBlock = didSelectBlock;
    pickerView.datas = datas;
    //    pickerView.datas =[self getDataArray:1];
    NSArray *array = @[@""];
    
    NSMutableArray *marray = [NSMutableArray arrayWithArray:datas];
    [marray replaceObjectAtIndex:1 withObject:array];
    
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = pickerView;
    pickerView.dataSource = pickerView;
    
    [pickerView show];
    
}

+ (void)showYearAndMonthWithIsEnd:(BOOL)isEnd dateStringSelected:(NSString *)dateString didSelectBlock:(XZLPickerDidSelectBlock)didSelectBlock
{
    
    
    XZLPickerTool *pickerView = [[XZLPickerTool alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-220, kMainScreenWidth, 220)];
    pickerView.didSelectBlock = didSelectBlock;
    pickerView.isHasTillNow = isEnd;
    if (!isEnd) {
        pickerView.datas =[pickerView getDataArray:1];
        pickerView.datasCopy =[pickerView getDataArray:1];
        pickerView.datasCurrentMonth = [pickerView getDataArray:0];
        pickerView.year = pickerView.datas[0][0];
        NSString *month = pickerView.datas[1][0];
        if (month.length==1) {
            month = [NSString stringWithFormat:@"0%@",month];
        }
        pickerView.month = month;
        pickerView.valueString = [NSString stringWithFormat:@"%@-%@",pickerView.year,pickerView.month];
    }else{
        pickerView.datas =[pickerView getDataArray:4];
        pickerView.datasCopy =[pickerView getDataArray:4];
        pickerView.datasCurrentMonth = [pickerView getDataArray:3];
        pickerView.datasBlankMonth = [pickerView getDataArray:2];
        pickerView.year = pickerView.datas[0][0];
        pickerView.valueString = [NSString stringWithFormat:@"%@",pickerView.year];
    }
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = pickerView;
    pickerView.dataSource = pickerView;
    [pickerView setSelectedValue:pickerView string:dateString];
    [pickerView show];
    
    
    
}

-(NSArray<NSArray<NSString *> *> *)getDataArray:(int)num{
    
    NSDate *date = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    
    NSInteger year = [d year];
    
    NSInteger month = [d month];
    NSMutableArray *array_year = [[NSMutableArray alloc] initWithCapacity:100];
    
    for (long int i = (long)year; year>=1970; i--) {
        [array_year addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        if (i == 1970) {
            break;
        }
    }
    
    NSMutableArray *array_month_current = [NSMutableArray new];
    
    for (int i = 1; i<=month; i++) {
        [array_month_current addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSMutableArray *array_month = [NSMutableArray new];
    
    for (int i = 1; i<=12; i++) {
        [array_month addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSMutableArray *array_year_Tillnow = [NSMutableArray arrayWithArray:@[@"至今"]];
    [array_year_Tillnow addObjectsFromArray:array_year];
    
    if (num == 0) {
        //正常年月
        return @[array_year,array_month];
    }else if(num == 1){
        //正常年当前月
        return @[array_year,array_month_current];
    }else if(num == 2){
        //至今年正常月
        return @[array_year_Tillnow,array_month];
    }else if(num == 3){
        //至今年当前月
        return @[array_year_Tillnow,array_month_current];
    }else if(num == 4){
        //至今年空月
        return @[array_year_Tillnow,@[@""]];
    }
    return nil;
}

-(void)setSelectedValue:(XZLPickerTool *)picker string:(NSString *)StringValue{
    if ([StringValue isNullOrEmpty]||!StringValue) {
        return;
    }
    self.valueString = StringValue;
    
    NSInteger row0 = 0;
    NSInteger row1 = 0;
    if ([StringValue isEqualToString:@"至今"]) {
        [picker selectRow:0 inComponent:0 animated:NO];
    }else{
        //
        NSArray *array = [StringValue componentsSeparatedByString:@"-"];
        NSString *year = array[0];
        NSString *month = array[1];
        if ([month hasPrefix:@"0"]) {
            month = [month substringFromIndex:1];
        }
        self.year = year;
        self.month = month;
        for (int i=0; i<self.datas[0].count; i++) {
            if ([year isEqualToString:self.datas[0][i]]) {
                row0 = i;
            }
        }
        if (self.isHasTillNow) {
            if (row0==1) {
                self.datas = [self.datasCurrentMonth copy];
            }else{
                self.datas = [self.datasBlankMonth copy];
            }
        }else{
            if (row0!=0) {
                self.datas = [self.datasCurrentMonth copy];
            }
        }
        NSArray *monthArray = picker.datas[1];
        for (int i=0; i<monthArray.count; i++) {
            if ([month isEqualToString:monthArray[i]]) {
                row1 = i;
            }
        }
        [picker selectRow:row0 inComponent:0 animated:NO];
        [picker selectRow:row1 inComponent:1 animated:NO];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.datas.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"%lu",(unsigned long)self.datas[component].count);
    return self.datas[component].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    //    if (component == 1) {
    //        return self.datas[component][0];
    //    }
    NSLog(@"%lu",(unsigned long)self.datas[component][row]);
    return self.datas[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.indexPath = [NSIndexPath indexPathForRow:row inSection:component];
    
    NSLog(@"%@",self.indexPath);
    
    if (component ==0) {
        if (self.isHasTillNow) {
            if (row==0) {
                self.datas = [self.datasCopy copy];
                
            }else if(row == 1){
                self.datas = [self.datasCurrentMonth copy];
            }else{
                self.datas = [self.datasBlankMonth copy];
            }
            [pickerView reloadComponent:1];
        }else{
            if (row==0) {
                self.datas = [self.datasCopy copy];
                
            }else if(row == 1){
                self.datas = [self.datasCurrentMonth copy];
            }
            [pickerView reloadComponent:1];
        }
        
        
    }
    
    if (component == 0) {
        self.year = [NSString stringWithFormat:@"%@",self.datas[component][row]];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.month = self.datas[1][0];
        
    }else if (component == 1){
        self.month = [NSString stringWithFormat:@"%@",self.datas[component][row]];
    }
    
    if (self.month.length!=0) {
        if (self.month.length==1) {
            self.month = [NSString stringWithFormat:@"0%@",self.month];
        }
        self.valueString = [NSString stringWithFormat:@"%@-%@",self.year,self.month];
    }else{
        self.valueString = [NSString stringWithFormat:@"%@",self.year];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
