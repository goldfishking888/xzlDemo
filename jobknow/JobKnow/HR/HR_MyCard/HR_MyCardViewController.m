//  dabendan
//  HR_MyCardViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//
#define LeftDistance 25
#import "HR_MyCardViewController.h"
#import "HR_CheckIDModelViewController.h"//查看完整的简历模板
#import "HR_MyCardCell.h"

#import "TPKeyboardAvoidingTableView.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
@interface HR_MyCardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    TPKeyboardAvoidingTableView *mainTableView;
    UIImageView *bgImageView;
    UIImageView *moreView;
    int clickNum;
    int changeData;
    int tipY;
    NSString  *LoginType;//兼职猎手或者是HR
    NSString *rightStr;
    MBProgressHUD *loadView;
    NSString *isSuccess;
    UILabel * textLabel;
    UIButton * checkBtn;
    UIImageView *rightImageView;
    UIButton *templateButton;
    
    //data
    NSString *name;
    NSString * userCompany;
    NSString * tradeName;
    NSString * occupation;
    NSString * mobile;
    NSString * telephone;
    NSString * userEmail;
    
    int mobileCorrect;
    int phoneCorrect;
    int emailCorrect;
    NSString *mobileStr;
    NSString *phoneStr;
    NSString *emailStr;
    NSString *cardURL;
    
    UITextField *mobileTf;
    UITextField *phoneTf;
    UITextField *emailTf;
    UILabel *mobileLabel;
    UILabel *phoneLabel;
    UILabel *emailLabel;
}
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation HR_MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self notifications];
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    clickNum = 0;
    changeData = 0;
    rightStr = @"更多";
    isSuccess = @"0";
    LoginType = @"";
    [self addBackBtn];
    [self addCenterTitle:@"我的名片"];
    [self addRightButtonWithTitle:rightStr];
    self.iconArray = [NSMutableArray arrayWithCapacity:0];
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    self.hrStateStr = [NSString stringWithFormat:@"%@",[AppUD objectForKey:@"hrState"]];
    cardURL = [AppUD objectForKey:@"cardUrl"];
    LoginType = [AppUD objectForKey:@"LoginType"];
    if ([self.hrStateStr isEqualToString:@"2"])
    {
        //已认证
        if ([LoginType isEqualToString:@"PTJHunter"]) {
            self.iconArray = @[@"hr_card_name.png", @"hr_card_company.png", @"hr_card_trade.png", @"hr_card_mobile.png", @"hr_card_phone.png", @"hr_card_email.png"];
            self.titleArray = @[@"姓名", @"公司", @"行业", @"电话", @"固话", @"邮箱"];
        }
        else
        {
            self.iconArray = @[@"hr_card_name.png", @"hr_card_company.png", @"hr_card_ocp.png", @"hr_card_trade.png", @"hr_card_mobile.png", @"hr_card_phone.png", @"hr_card_email.png"];
            self.titleArray = @[@"姓名", @"公司", @"职位", @"行业", @"电话", @"固话", @"邮箱"];
        }
    }
    else
    {
        if ([LoginType isEqualToString:@"PTJHunter"]) {
            self.iconArray = @[@"hr_card_trade.png", @"hr_card_mobile.png", @"hr_card_phone.png", @"hr_card_email.png"];
            self.titleArray = @[@"行业", @"电话", @"固话", @"邮箱"];
            if (cardURL.length == 0) {//未认证中未上传新名片 hrstate其实=1
                isSuccess = @"0";
            }
            else if (cardURL.length > 0)//未认证中已经上传过新名片,导致cardUrl不是空,这里的HRState还是 = 1
            {
                isSuccess = @"1";
            }
        }
        else{
            //未认证
            self.iconArray = @[@"hr_card_ocp.png", @"hr_card_trade.png", @"hr_card_mobile.png", @"hr_card_phone.png", @"hr_card_email.png"];
            self.titleArray = @[@"职位", @"行业", @"电话", @"固话", @"邮箱"];
            if (cardURL.length == 0) {//未认证中未上传新名片 hrstate其实=1
                isSuccess = @"0";
            }
            else if (cardURL.length > 0)//未认证中已经上传过新名片,导致cardUrl不是空,这里的HRState还是 = 1
            {
                isSuccess = @"1";
            }
        }
    }
    
    [self createTableView];
    [self requestDataWithPage:1];
    
    // Do any additional setup after loading the view.
}

#pragma mark textField delegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    int pageIndex1 =1;
    // 取新
    [self requestDataWithPage:pageIndex1];
    
}

- (void)requestDataWithPage:(int)page
{
    
    //http://api.xzhiliao.com/hr_api/ self_operation/getHrInfo
    NSString *url = kCombineURL(KXZhiLiaoAPI,HRMyCardInfoMation);
    
    NSLog(@"--------userImei--------%@",IMEI);
    NSLog(@"--------Hrusertoken--------%@",GRBToken);
    
    NSDictionary * paramDic = [[NSDictionary alloc]init];
    
    paramDic = @{
                 @"userToken":GRBToken,
                 @"userImei":IMEI
                 };
    NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        if(errorStr.integerValue == 0)
        {
            NSLog(@"请求成功");
            
            [self SaveMyInfo:resultDic];
            [self configNewCacheOfDic];
        }
        [mainTableView reloadData];
    }];
    [request setFailedBlock:^{
        ghostView.message=@"请求失败";
        [ghostView show];
        if([mainTableView isHeaderRefreshing] == YES){
            [mainTableView headerEndRefreshing];
        }
    }];
    
    
    [request startAsynchronous];
    
}
#pragma mark - 网络读取失败读取缓存
-(void)configNewCacheOfDic
{
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    name = [AppUD objectForKey:@"realName"];//名字
    if (name == nil)
    {
        name = @"暂无";
    }
    userCompany = [AppUD objectForKey:@"userCompany"];//公司
    if (userCompany == nil)
    {
        userCompany = @"暂无";
    }
    NSString *hrState = [NSString stringWithFormat:@"%@",[AppUD objectForKey:@"hrState"]];
    if ([hrState isEqualToString:@"2"]) {
        //已经认证HR
        //这个地方是认证了的HR.
    }else{
        //这个地方是没有认证的HR
    }
    tradeName = [AppUD objectForKey:@"tradeName"];//行业
    if (tradeName == nil)
    {
        tradeName = @"暂无";
    }
    occupation = [AppUD objectForKey:@"occupation"];//职业,
    if (occupation == nil)
    {
        occupation = @"暂无";
    }
    //手机
    mobile = [AppUD objectForKey:@"hrMobile"];
    if (mobile == nil)
    {
        mobile = @"暂无";
    }
    //固话
    telephone = [AppUD objectForKey:@"telephone"];//电话
    if (telephone == nil)
    {
        telephone = @"暂无";
    }
    //邮箱
    userEmail = [AppUD objectForKey:@"userEmail"];//邮箱
    if (userEmail == nil)
    {
        userEmail = @"暂无";
    }
    
    if ([self.hrStateStr isEqualToString:@"2"])
    {
       if ([LoginType isEqualToString:@"PTJHunter"]) {
            //
           self.contentArray = @[name, userCompany, tradeName, mobile, telephone, userEmail];
        }
        else
        {
        //已认证
        self.contentArray = @[name, userCompany, occupation, tradeName, mobile, telephone, userEmail];
        }
    }
    else
    {
        if ([LoginType isEqualToString:@"PTJHunter"]) {
            self.contentArray = @[tradeName, mobile, telephone, userEmail];
        }
        else
        {//未认证
        self.contentArray = @[occupation, tradeName, mobile, telephone, userEmail];
        }
    }
    
    [mainTableView reloadData];
}
- (NSString *)ConfigBianma:(NSString *)year
{
    NSString *workYear;
    
    if (year&&year.integerValue==-2) {
        
        workYear=@"不限";
        
    }else if(year&&year.integerValue==-1){
        
        workYear=@"在读学生";
        
    }else if (year&&year.integerValue==0)
    {
        workYear=@"应届毕业生";
    }else
    {
        workYear=[NSString stringWithFormat:@"%@年",year];
    }
    
    return workYear;
}
#pragma mark - 缓存到本地
-(void)SaveMyInfo:(NSDictionary *)infoDic
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    cardUrl = "http://api.xzhiliao.com/file_read/hr_card/92159341440136000.png?1440148541";
    
    
    NSString *hrMobile = [infoDic valueForKey:@"hrMobile"];
    NSString * hrState = [infoDic valueForKey:@"hrState"];//HRstate判断是否点亮图标
    
    NSString * UserCompany = [infoDic valueForKey:@"userCompany"];//公司
    NSString * UserEmail = [infoDic valueForKey:@"userEmail"];//公司
    NSString * Occupation = [infoDic valueForKey:@"occupation"];//职位
    NSString * Telephone = [infoDic valueForKey:@"telephone"];//固话
    
    NSString * headUrl = [infoDic valueForKey:@"headUrl"];//头像网址
    NSString *realName = [infoDic valueForKey:@"realName"];//HRname
    NSString * cityName = [infoDic valueForKey:@"cityName"];//cityName
    NSString * cityCode = [infoDic valueForKey:@"cityCode"];//cotyCode
    NSString * tradeCode = [infoDic valueForKey:@"tradeCode"];//tradeCode
    NSString * TradeName = [infoDic valueForKey:@"tradeName"];//行业
    NSString * cardUrl = [infoDic valueForKey:@"cardUrl"];//行业
    //cardUrl 改动读出来的
    [userDefaults setObject:hrState forKey:@"hrState"];//1 审核中 2 审核成功 3 审核失败
    [userDefaults setObject:UserEmail forKey:@"userEmail"];
    [userDefaults setObject:UserCompany forKey:@"UserCompany"];
    [userDefaults setObject:Occupation forKey:@"occupation"];
    [userDefaults setObject:Telephone forKey:@"telephone"];
    [userDefaults setObject:TradeName forKey:@"tradeName"];
    [userDefaults setObject:headUrl  forKey:@"headUrl"];
    
    [userDefaults setObject:realName forKey:@"realName"];
    [userDefaults setObject:cityName forKey:@"cityName"];
    [userDefaults setObject:cityCode forKey:@"cityCode"];
    [userDefaults setObject:tradeCode forKey:@"tradeCode"];
    [userDefaults setObject:TradeName forKey:@"tradeName"];
    [userDefaults setObject:cardUrl forKey:@"cardUrl"];
    
    
    [userDefaults setObject:hrMobile forKey:@"hrMobile"];
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH-mm-ss"];
    NSString *currentTime=[dateFormatter stringFromDate:[NSDate date]];
    [userDefaults setObject:currentTime forKey:@"zhangxinTime"];
    [userDefaults synchronize];
    
}
#pragma mark - createTableView
-(void)createTableView
{
    float yy;
    if ([self.hrStateStr isEqual:@"2"])
    {//已认证
        yy = 48 + 40 * self.iconArray.count + 10;
    }
    else
    {
        yy = 145 + 40 * self.iconArray.count + 10;
    }
    
    mainTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(23, 44 + (ios7jj), self.view.frame.size.width - 46, self.view.frame.size.height - (44 + (ios7jj))) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = RGBA(243, 243, 243, 1);
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    // 下拉刷新
    [mainTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    mainTableView.headerPullToRefreshText= @"下拉刷新";
    mainTableView.headerReleaseToRefreshText = @"松开马上刷新";
    mainTableView.headerRefreshingText = @"努力加载中……";
}

#pragma mark tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainTableView.frame.size.width, 20)];
        upView.backgroundColor = RGBA(243, 243, 243, 1);
        [cell.contentView addSubview:upView];
        
        UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 1, 20)];
        lineLeft.backgroundColor = RGBA(225, 225, 225, 2);
        [upView addSubview:lineLeft];
        
        UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(239, 0, 1, 20)];
        lineRight.backgroundColor = RGBA(225, 225, 225, 2);
        [upView addSubview:lineRight];
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, mainTableView.frame.size.width, 30)];
        middleView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:middleView];
        
        UIView *lineLeft1 = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 1, 10)];
        lineLeft1.backgroundColor = RGBA(225, 225, 225, 2);
        [middleView addSubview:lineLeft1];
        
        UIView *lineRight1 = [[UIView alloc] initWithFrame:CGRectMake(239, 0, 1, 10)];
        lineRight1.backgroundColor = RGBA(225, 225, 225, 2);
        [middleView addSubview:lineRight1];
        
        UIView *circleLeftView = [[UIView alloc] initWithFrame:CGRectMake(30, 10, 10, 10)];
        circleLeftView.backgroundColor = [UIColor clearColor];
        circleLeftView.layer.cornerRadius = 5;
        circleLeftView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
        circleLeftView.layer.borderWidth = 1;
        [middleView addSubview:circleLeftView];
        
        UIView *circleRightView = [[UIView alloc] initWithFrame:CGRectMake(234, 10, 10, 10)];
        circleRightView.backgroundColor = [UIColor clearColor];
        circleRightView.layer.cornerRadius = 5;
        circleRightView.layer.borderColor = RGBA(225, 225, 225, 1).CGColor;
        circleRightView.layer.borderWidth = 1;
        [middleView addSubview:circleRightView];
        
        if (![self.hrStateStr isEqualToString:@"2"])
        {
            if ([isSuccess isEqualToString:@"1"])//issuccess = 1已经上传新名片
            {
                
                [textLabel removeFromSuperview];
                textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, mainTableView.frame.size.width - 30, 45)];
                textLabel.textColor = RGBA(255, 146, 4, 1);
                textLabel.text = @"您已成功上传名片。工作时间段内我们将在1小时内完成身份审核！通过后将有私信通知或电话通知。";
                textLabel.numberOfLines = 3;
                textLabel.textAlignment = NSTextAlignmentLeft;
                textLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:textLabel];
                
                if (checkBtn) {
                    [checkBtn removeFromSuperview];
                }
                //
                if (templateButton) {
                    [templateButton removeFromSuperview];
                }
                templateButton = [MyControl createButtonFrame:CGRectMake(87, textLabel.frame.origin.y + 45, 100, 30) bgImageName:nil image:nil title:@"查看身份证明材料模板" method:@selector(templateButtonClick) target:self];
                [templateButton setTitleColor:RGBA(255, 146, 4, 1) forState:UIControlStateNormal];
                templateButton.titleLabel.font = [UIFont systemFontOfSize:9];
                [cell.contentView addSubview:templateButton];
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 20, 90, 1)];
                line.backgroundColor = RGBA(255, 146, 4, 1);
                [templateButton addSubview:line];
                
            }
            else //issuccess = 0 没有上传新名片cardurl为空
            {
                [textLabel removeFromSuperview];
                textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, mainTableView.frame.size.width - 30, 30)];
                textLabel.textColor = RGBA(255, 146, 4, 1);
                textLabel.text = @"点击上传您的名片或其他身份证明材料进行认证,\n我们将会以电话的形式对您进行回访";
                textLabel.numberOfLines = 2;
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:textLabel];
                
                [checkBtn removeFromSuperview];
                checkBtn = [MyControl createButtonFrame:CGRectMake(60, textLabel.frame.origin.y + 40, self.view.frame.size.width - 46 - 120, 30) bgImageName:@"hr_card_btn" image:nil title:@"上传名片" method:@selector(updateNewBtnClick:) target:self];
                checkBtn.titleLabel.font = [UIFont systemFontOfSize:10];
                [checkBtn setTitleColor:RGBA(92, 92, 92, 1) forState:UIControlStateNormal];
                [cell.contentView addSubview:checkBtn];
                
                rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(133, 10, 10, 10)];
                rightImageView.image = [UIImage imageNamed:@"icon_right_yellow.png"];
                [checkBtn addSubview:rightImageView];
                
                [templateButton removeFromSuperview];
                templateButton = [MyControl createButtonFrame:CGRectMake(87, checkBtn.frame.origin.y + 30, 100, 30) bgImageName:nil image:nil title:@"查看身份证明材料模板" method:@selector(templateButtonClick) target:self];
                [templateButton setTitleColor:RGBA(255, 146, 4, 1) forState:UIControlStateNormal];
                templateButton.titleLabel.font = [UIFont systemFontOfSize:9];
                [cell.contentView addSubview:templateButton];
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 20, 90, 1)];
                line.backgroundColor = RGBA(255, 146, 4, 1);
                [templateButton addSubview:line];
            }
            
            
            tipY = templateButton.frame.origin.y;
        }
        else
        {
            tipY = 20;
        }
        
        if (changeData == 1)
        {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tipY + 30, cell.contentView.frame.size.width, 30)];
            tipLabel.text = @"您可以编辑电话和邮箱信息,\n其他修改请联系客服0532-80901998";
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.numberOfLines = 2;
            tipLabel.tag = 101;
            tipLabel.textColor = RGBA(144, 144, 144, 1);
            tipLabel.font = [UIFont systemFontOfSize:9];
            [cell.contentView addSubview:tipLabel];
        }
        else
        {
            [(UILabel *)[cell.contentView viewWithTag:101] removeFromSuperview];
        }
        
        return cell;
    }
    if (indexPath.row > 0)
    {
        NSString *cellIdentifier = @"cellIdentifier";
        HR_MyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[HR_MyCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconStr = self.iconArray[indexPath.row - 1];
        cell.titleStr = self.titleArray[indexPath.row - 1];
        cell.contentStr = self.contentArray[indexPath.row - 1];
        cell.vc = self;
        
        if (changeData == 1)
        {
            [(UILabel *)[cell.contentView viewWithTag:1001] removeFromSuperview];
            [(UILabel *)[cell.contentView viewWithTag:1002] removeFromSuperview];
            [(UILabel *)[cell.contentView viewWithTag:1003] removeFromSuperview];
            
            if ([cell.titleStr isEqualToString:@"电话"])
            {
                mobileTf = [[UITextField alloc] initWithFrame:CGRectMake(70, 15, cell.frame.size.width - 85, 20)];
                mobileTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                mobileTf.tag = 101;
                mobileTf.delegate = self;
                mobileTf.font = [UIFont systemFontOfSize:11];
                mobileTf.textColor = RGBA(92, 92, 92, 1);
                mobileTf.textAlignment = NSTextAlignmentRight;
                mobileTf.text = cell.contentStr;
                mobileTf.backgroundColor = RGBA(239, 239, 239, 1);
                [cell.contentView addSubview:mobileTf];
            }
            else if ([cell.titleStr isEqualToString:@"固话"])
            {
                phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(70, 15, cell.frame.size.width - 85, 20)];
                phoneTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                phoneTf.tag = 102;
                phoneTf.delegate = self;
                phoneTf.font = [UIFont systemFontOfSize:11];
                phoneTf.textColor = RGBA(92, 92, 92, 1);
                phoneTf.textAlignment = NSTextAlignmentRight;
                phoneTf.text = cell.contentStr;
                phoneTf.backgroundColor = RGBA(239, 239, 239, 1);
                [cell.contentView addSubview:phoneTf];
            }
            else if ([cell.titleStr isEqualToString:@"邮箱"])
            {
                emailTf = [[UITextField alloc] initWithFrame:CGRectMake(70, 15, cell.frame.size.width - 85, 20)];
                emailTf.keyboardType = UIKeyboardTypeEmailAddress;
                emailTf.tag = 103;
                emailTf.delegate = self;
                emailTf.font = [UIFont systemFontOfSize:11];
                emailTf.textColor = RGBA(92, 92, 92, 1);
                emailTf.textAlignment = NSTextAlignmentRight;
                emailTf.text = cell.contentStr;
                emailTf.backgroundColor = RGBA(239, 239, 239, 1);
                [cell.contentView addSubview:emailTf];
            }
        }
        else
        {
            [(UITextField *)[cell.contentView viewWithTag:101] removeFromSuperview];
            [(UITextField *)[cell.contentView viewWithTag:102] removeFromSuperview];
            [(UITextField *)[cell.contentView viewWithTag:103] removeFromSuperview];
            
            [(UILabel *)[cell.contentView viewWithTag:1001] removeFromSuperview];
            [(UILabel *)[cell.contentView viewWithTag:1002] removeFromSuperview];
            [(UILabel *)[cell.contentView viewWithTag:1003] removeFromSuperview];
            
            if ([cell.titleStr isEqualToString:@"电话"])
            {
                mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, cell.frame.size.width - 85, 12)];
                mobileLabel.text = self.contentArray[indexPath.row - 1];
                mobileLabel.tag = 1001;
                mobileLabel.textAlignment = NSTextAlignmentRight;
                mobileLabel.textColor = RGBA(92, 92, 92, 1);
                mobileLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:mobileLabel];
            }
            else if ([cell.titleStr isEqualToString:@"固话"])
            {
                phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, cell.frame.size.width - 85, 12)];
                phoneLabel.text = self.contentArray[indexPath.row - 1];
                phoneLabel.tag = 1002;
                phoneLabel.textAlignment = NSTextAlignmentRight;
                phoneLabel.textColor = RGBA(92, 92, 92, 1);
                phoneLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:phoneLabel];
            }
            else if ([cell.titleStr isEqualToString:@"邮箱"])
            {
                emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, cell.frame.size.width - 85, 12)];
                emailLabel.text = self.contentArray[indexPath.row - 1];
                emailLabel.tag = 1003;
                emailLabel.textAlignment = NSTextAlignmentRight;
                emailLabel.textColor = RGBA(92, 92, 92, 1);
                emailLabel.font = [UIFont systemFontOfSize:11];
                [cell.contentView addSubview:emailLabel];
            }
        }
        
        if (![self.hrStateStr isEqualToString:@"2"] && indexPath.row == 1)
        {
            UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(23, 0, 235, 1)];
            upLine.backgroundColor = RGBA(247, 147, 30, 1);
            [cell.contentView addSubview:upLine];
        }
        //改动
        if ([cell.titleStr isEqualToString:@"公司"] || [cell.titleStr isEqualToString:@"行业"])
        {
            cell.isOrage = @"1";
        }
        else
        {
            cell.isOrage = @"0";
        }
        if (indexPath.row == self.iconArray.count)
        {
            cell.isLast = @"1";
        }
        else
        {
            cell.isLast = @"0";
        }
        
        if (changeData == 1)
        {
            cell.isChangeData = @"1";
        }
        else
        {
            cell.isChangeData = @"0";
        }
        
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.hrStateStr isEqualToString:@"2"])
    {
        //已认证
        return self.iconArray.count+1;
    }
    //未认证
    return self.iconArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"index === %ld", indexPath.row);
    if (indexPath.row == 0)
    {
        if (changeData == 1) {//修改资料
            if ([self.hrStateStr isEqualToString:@"2"])
            {
                //已认证头部
                return 48 + 40;
            }
            else
            {
                //未认证头部
                if ([isSuccess isEqualToString:@"0"])
                {
                    return 145 + 40;
                }
                else
                {
                    return 145 + 40 - 25;
                }
            }
        }
        else
        {
            if ([self.hrStateStr isEqualToString:@"2"])
            {
                //已认证头部
                return 48;
            }
            else
            {
                //未认证头部
                if ([isSuccess isEqualToString:@"0"])
                {
                    return 145;
                }
                else
                {
                    return 145 - 25;
                }
            }
        }
    }
    else if ([self.titleArray[indexPath.row - 1] isEqualToString:@"行业"])
    {
        //取得文字的整体宽高等值
//        if (self.contentArray.count > 0) {
            CGSize textSize = [self.contentArray[indexPath.row - 1] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
            
            //把高度返回给_textHeight,记录下来
            CGFloat height = (textSize.width /(mainTableView.frame.size.width - 85) + 1) * textSize.height;
            
            if (height > 27)
            {
                return height + 30;
            }
            
//        }
    }
    
    return 40;
}

#pragma mark buttonClick

- (void)templateButtonClick
{
    NSLog(@"查看身份证明材料模板");
    HR_CheckIDModelViewController * vc = [[HR_CheckIDModelViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickRightBtn:(id)sender
{
    NSLog(@"点击右边调到方法");//这个是右边按钮在父类的方法,在这个页面重写就行
    if ([rightStr isEqualToString:@"更多"])
    {
        if (clickNum % 2 == 0)
        {
            [self createMoreView];
        }
        else
        {
            [self removeMoreView];
        }
        clickNum++;
    }
    else
    {
        [self updataNewData];
    }
}


#pragma mark - 上传新的修改数据
-(void)updataNewData
{
    mobileCorrect = 0;
    phoneCorrect = 0;
    emailCorrect = 0;
    mobileStr = @"";
    phoneStr = @"";
    emailStr = @"";
    
    //电话
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobileTf.text];
    if (mobileTf.text.length == 11 && isMatch)
    {
        mobileCorrect = 1;
        mobileStr = mobileTf.text;
    }
    else
    {
        ghostView.message=@"请输入正确的电话格式/位数";
        [ghostView show];
    }
    
    //固话
    NSString *regex1 = @"^(\\d{3,4}\\-?)?\\d{7,8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch1 = [pred1 evaluateWithObject:phoneTf.text];
    if (phoneTf.text.length > 0 && isMatch1) {
        phoneCorrect = 1;
        phoneStr = phoneTf.text;
    }
    else
    {
        ghostView.message = @"请输入正确的固话";
        [ghostView show];
    }
    
    //邮箱
    /*String expr = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
     String expr1 = "^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";*/
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (emailTf.text.length > 0 && [emailTest evaluateWithObject:emailTf.text]) {
        emailCorrect = 1;
        emailStr = emailTf.text;
    }
    else
    {
        ghostView.message = @"请输入正确的邮箱格式";
        [ghostView show];
    }
    
    if (mobileCorrect > 0 && phoneCorrect > 0 && emailCorrect > 0) {
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *url = kCombineURL(KXZhiLiaoAPI,HRChangeMyCard);
        NSDictionary *paramDic = [[NSDictionary alloc]init];
        // 修改名片信息
        //http://api.xzhiliao.com/ hr_api/hr_operation/renewCardInfo?
        paramDic = @{
                     @"userToken":GRBToken,
                     @"userImei":IMEI,
                     @"mobile":mobileStr,
                     @"email":emailStr,
                     @"telephone":phoneStr
                     };
        
        NSURL * URL = [NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            [loadView hide:NO];
            if([mainTableView isHeaderRefreshing] == YES){
                [mainTableView headerEndRefreshing];
            }
            NSError *error;
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *errorStr =[resultDic valueForKey:@"error"];
            
            if(!resultDic)
            {
                NSLog(@"请重新登录");
                [loadView hide:YES];

            }
            if(errorStr.integerValue == 1)
            {
                changeData = @"0";
                rightStr = @"更多";
                [self setRightBtnTitle:rightStr];
                [mainTableView reloadData];
                
                NSLog(@"请求成功");
                [loadView hide:YES];
                ghostView.message=@"操作成功";
                [ghostView show];
                
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:emailStr forKey:@"userEmail"];
                [defaults setValue:mobileStr forKey:@"userMobile"];
                [defaults setValue:phoneStr forKey:@"telephone"];
                [defaults synchronize];
                
                mobile = mobileStr;
                telephone = phoneStr;
                userEmail = emailStr;
                if ([self.hrStateStr isEqualToString:@"2"])
                {
                    //已认证
                    if ([LoginType isEqualToString:@"PTJHunter"]) {
                        self.contentArray = @[name, userCompany, tradeName, mobile, telephone, userEmail];

                    }else{
                    self.contentArray = @[name, userCompany, occupation, tradeName, mobile, telephone, userEmail];
                    }
                }
                else
                {
                    //未认证
                    if ([LoginType isEqualToString:@"PTJHunter"]) {
                        self.contentArray = @[tradeName, mobile, telephone, userEmail];
                    }else{
                    self.contentArray = @[occupation, tradeName, mobile, telephone, userEmail];
                    }
                }
                [mainTableView reloadData];
            }
        }];
        
        [request setFailedBlock:^{
            [loadView hide:YES];
            ghostView.message=@"请求失败";
            [ghostView show];
            if([mainTableView isHeaderRefreshing] == YES){
                [mainTableView headerEndRefreshing];
            }
        }];
        [request startAsynchronous];//开启request的Block
    }
}
- (void)checkCorrect:(NSArray *)cellArray withIndex:(int)index withSubView:(id)subView
{
    if ([self.titleArray[cellArray.count - 2 - index] isEqualToString:@"电话"])
    {
        
    }
    else if ([self.titleArray[cellArray.count - 2 - index] isEqualToString:@"固话"])
    {
        
    }
    else if ([self.titleArray[cellArray.count - 2 - index] isEqualToString:@"邮箱"])
    {
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)createMoreView
{
    NSArray *titleArray1;
    //    if (cardURL.length == 0)
    //    {
    //        titleArray = @[@"修改资料", @"取消"];
    //    }
    //    else
    //    {
    titleArray1 = @[@"修改资料", @"上传新名片", @"取消"];
    //    }
    moreView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 57, 0, 0)];
    moreView.userInteractionEnabled = YES;
    moreView.image = [UIImage imageNamed:@"popupwindow_bgMyCard"];
    [UIView animateWithDuration:0.05 animations:^{
        moreView.frame = CGRectMake(self.view.frame.size.width - 107, 57, 107, 35 * titleArray1.count + 10);
        [self.view addSubview:moreView];
    } completion:^(BOOL finished) {
        for (int index = 0; index < titleArray1.count; index++)
        {
            UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
            moreButton.frame = CGRectMake(0, 5 + 35 * index, 107, 34);
            [moreButton setTitle:titleArray1[index] forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if ([titleArray1[index] isEqualToString:@"修改资料"])
            {
                moreButton.tag = 0;
            }
            else if ([titleArray1[index] isEqualToString:@"上传新名片"])
            {
                moreButton.tag = 1;
            }
            else
            {
                moreButton.tag = 2;
            }
            [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [moreView addSubview:moreButton];
            if (index != titleArray1.count - 1)
            {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(7, 5 + 35 * index + 34, moreView.frame.size.width, 1)];
                line.backgroundColor = RGBA(224, 106, 27, 1);
                [moreView addSubview:line];
            }
        }
    }];
}

- (void)removeMoreView
{
    [moreView removeFromSuperview];
}
#pragma mark - 更多按钮
- (void)moreButtonClick:(UIButton *)sender
{
    clickNum++;
    if (sender.tag == 0)
    {
        NSLog(@"修改名片");
        changeData = 1;
        rightStr = @"保存";
        [self setRightBtnTitle:rightStr];
        [mainTableView reloadData];
        
    }
    else if (sender.tag == 1)
    {
        NSLog(@"上传新名片");
        [self updateNewBtnClick:sender];
    }
    else
    {
        NSLog(@"取消");
    }
    [self removeMoreView];
}
//键盘弹出,隐藏通知
-(void)notifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 通知的函数
-(void)keyboardShow:(NSNotification*)sender
{
    CGFloat keyboardhight;
    NSDictionary* info = [sender userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_height:%f",kbSize.height);
    
    keyboardhight = kbSize.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardhight, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
-(void)keyboardHiden:(NSNotification*)sender
{
    CGFloat keyboardhight;
    NSDictionary* info = [sender userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_height:%f",kbSize.height);
    
    keyboardhight = kbSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y  + keyboardhight, self.view.frame.size.width, self.view.frame.size.height + keyboardhight);
    }];
    
}

-(void)updateNewBtnClick:(UIButton *)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"本地上传", nil];
    [sheet showInView:self.view];
}
#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"拍照上传");
        [self takePhotos];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"本地上传");
        [self callPhotos];
    }
    else if (buttonIndex == 2)
    {
        NSLog(@"取消");
    }
}
#pragma mark - 拍照
-(void)takePhotos
{//拍照
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:^{
        //
    }];
}

#pragma mark - 打开相册
-(void)callPhotos
{
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    //vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}
#pragma mark - Picker的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //头像保存本地
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString *str = [st valueForKey:@"UserName"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    //   NSString*finame = [NSString stringWithFormat:@"_%@.png",str];
    //    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    //    [imageCache storeData:imageData forKey:finame];
    //    [_pathCover setAvatarImage:image];
    //上传头像
    [self uploadPath2:image name:[NSString stringWithFormat:@"%@.png",str]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//上传头像
- (void)uploadPath2:(UIImage *)image name:(NSString *)Name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken", nil];
    //Filedata
    //[net send2ToServerWithImage:image imageName:name param:params];
    [net send_HRIcon_ToServerWithImage:image imageName:Name param:params withURLStr:@"http://api.xzhiliao.com/hr_api/hr_operation/uploadCard?"];
}
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shang传头像_______%@",requestDic);
    NSNumber * state = [requestDic valueForKey:@"status"];
    if ([state boolValue]) {
        ghostView.message=@"上传新名片成功";
        [ghostView show];
        self.hrStateStr = @"1";
        isSuccess = @"1";
        NSUserDefaults * APPUD = [NSUserDefaults standardUserDefaults];
        [APPUD setValue:requestDic[@"fileName"] forKey:@"cardUrl"];
        [APPUD synchronize];
        [mainTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataWhenRecommendResume" object:nil];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)receiveDataFail:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)requestTimeOut
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
